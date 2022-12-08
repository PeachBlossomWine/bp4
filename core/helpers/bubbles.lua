local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=200, y=80}, bg={alpha=125, red=0, green=0, blue=0, visible=true}, flags={draggable=true, bold=false}, text={size=10, font='Lucida Console', alpha=255, red=245, green=200, blue=20, stroke={width=1, alpha=255, red=0, green=0, blue=0}}, padding=5}
    local settings  = bp.libs.__settings.new('bubbles')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __entrust     = ""
        local __geocolure   = ""
        local __shortcuts   = bp.__bubbles.shortcuts
        local __indirecast  = false
        local __georecast   = false

        do -- Private Settings.
            settings.bubbles    = settings.bubbles or {"Indi-Fury","Geo-Frailty","Indi-Haste"}
            settings.visible    = settings.visible ~= nil and settings.visible or true
            settings.placement  = settings.placement ~= nil and settings.placement or true
            settings.messages   = settings.messages ~= nil and settings.messages or true
            settings.position   = settings.position or 1
            settings.layout     = settings.layout or layout
            settings.display    = settings:getDisplay()

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.render = function()

            if settings.visible then

                bp.__ui.renderUI(settings.display, function()

                    if bp and bp.player and settings.visible and bp.player.main_job == 'GEO' then
                        pvt.updateDisplay()

                    elseif settings.display:visible() and bp.player.main_job ~= 'GEO' then
                        settings.display:hide()

                    end
                
                end)

            end
        
        end

        pvt.updateDisplay = function()
            local itoggle = bp.core.get('indicolure')
            local gtoggle = bp.core.get('geocolure')
            local etoggle = bp.core.get('entrust')
            local updated = {}

            do -- Build display table.
                updated[1] = string.format("Current Luopan Position: \\cs(%s)%s\\cr\n", bp.colors.setting, bp.__bubbles.getPosition(settings.position))
                updated[2] = string.format("[I]: \\cs(%s)%s\\cr", itoggle and bp.colors.on or bp.colors.off, new.getIndicolure():upper())
                updated[3] = string.format("[G]: \\cs(%s)%s\\cr → \\cs(%s)%s\\cr", gtoggle and bp.colors.on or bp.colors.off, new.getGeocolure():upper(), bp.colors.setting, __geocolure)
                updated[4] = string.format("[E]: \\cs(%s)%s\\cr → \\cs(%s)%s\\cr", etoggle and bp.colors.on or bp.colors.off, new.getEntrust():upper(), bp.colors.setting, __entrust)

            end
            settings.display:text(table.concat(updated, '\n'))

        end

        pvt.cast = function(id, original)

            if bp and id and id == 0x01a and settings.placement then
                local parsed = bp.packets.parse('outgoing', original)

                if parsed and parsed['Category'] == 3 and bp.res.spells[parsed['Param']] and bp.__bubbles.isGeocolure(bp.res.spells[parsed['Param']].en) then
                    return bp.packets.build(bp.__bubbles.buildAction(parsed['Target'], parsed['Param'], parsed['Category'], settings.position))
                end

            end

        end

        pvt.placement = function(commands)

            if commands[1] and S{"!","#"}:contains(commands[1]) then
                settings.placement = (commands[1] == '!') and true or false

            else
                settings.placement = (settings.placement ~= true) and true or false

            end
            bp.popchat.pop(string.format("ADJUST BUBBLE PLACEMENT: \\cs(%s)%s\\cr", bp.colors.setting, tostring(settings.placement):upper()))

        end

        pvt.handleRecast = function(id, original)

            if bp and id and id == 0x028 then
                local parsed    = bp.packets.parse('incoming', original)
                local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
                
                if bp.player and actor and bp.player.id == actor.id and parsed['Category'] == 4 then
                    local spell = bp.res.spells[parsed['Param']]

                    if spell and spell.skill == 44 then

                        if spell.en:startswith('Indi-') then
                            __indirecast = false

                        elseif spell.en:startswith('Geo-') then
                            __georecast = false

                        end

                    end

                end

            end

        end
        
        -- Public Methods.
        new.active = function(id) return bp.__buffs.hasAura(id) end
        new.indiRecast = function() return __indirecast end
        new.geoRecast = function() return __georecast end
        new.getIndicolure = function() return settings.bubbles[1] end
        new.getGeocolure = function() return settings.bubbles[2] end
        new.getEntrust = function() return settings.bubbles[3] end
        new.setBubbles = function(...)
            local i, g, e = ...

            if i and __shortcuts.indicolure[i] or bp.MA[i] then
                settings.bubbles[1] = __shortcuts.indicolure[i] and __shortcuts.indicolure[i] or bp.MA[i].en
                __indirecast = true
            end

            if g and __shortcuts.geocolure[g] or bp.MA[g] then
                settings.bubbles[2] = __shortcuts.geocolure[g] and __shortcuts.geocolure[g] or bp.MA[g].en
                __georecast = true
            end

            if e and __shortcuts.indicolure[e] or bp.MA[e] then
                settings.bubbles[3] = __shortcuts.indicolure[e] and __shortcuts.indicolure[e] or bp.MA[e].en
            end
            windower.send_command(string.format("input /p Bubbles: %s, %s [ %s ]!", settings.bubbles[1], settings.bubbles[2], settings.bubbles[3]))

        end

        new.entrustTarget = function(target)
            local target = bp.__party.findMember(target)

            if target and bp.player.name ~= target.name then
                bp.popchat.pop(string.format("%s SET TO ENTRUST TARGET", target.name:upper()))
                __entrust = target.name
                return __entrust

            elseif not target then
                return __entrust

            end

        end

        new.geocolureTarget = function(target)
            local target = bp.__party.findMember(target)

            if target then
                bp.popchat.pop(string.format("%s SET TO GEOCOLURE TARGET", target.name:upper()))
                __geocolure = target.name
                return __geocolure

            elseif not target then
                return __geocolure

            end

        end
        
        -- Private Events.
        helper('incoming chunk', pvt.handleRecast)
        helper('outgoing chunk', pvt.cast)
        helper('prerender', pvt.render)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)

            if command == "?" then
                pvt.updateDisplay()
            end
            
            if bp and command and command:lower() == 'bubbles' and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then

                    if ("position"):startswith(command) then
                        settings.position = (settings.position == 1) and 2 or 1
                        bp.popchat.pop(string.format("BUBBLE POSITION: \\cs(%s)%s\\cr", bp.colors.setting, bp.__bubbles.getPosition(settings.position)))

                    elseif ("placement"):startswith(command) then
                        pvt.placement(commands)

                    elseif ("etarget"):startswith(command) and commands[1] then
                        new.entrustTarget(commands[1])

                    elseif ("gtarget"):startswith(command) and commands[1] then
                        new.geocolureTarget(commands[1])

                    elseif ("visible"):startswith(command) then
                        settings.visible = (settings.visible ~= true) and true or false

                    else
                        new.setBubbles(command, commands[1], commands[2])

                    end
                    pvt.updateDisplay()

                end
                settings:save()

            end

        end)

        return new

    end

    return helper

end
return buildHelper