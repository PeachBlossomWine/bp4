local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=200, y=80}, bg={alpha=0, red=0, green=0, blue=0, visible=false}, flags={draggable=true, bold=true}, text={size=15, font='Segoe UI', alpha=255, red=245, green=200, blue=20, stroke={width=2, alpha=255, red=0, green=0, blue=0}}, padding=5}
    local settings  = bp.libs.__settings.new('bubbles')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __entrust     = ""
        local __geocolure   = ""

        do -- Private Settings.
            settings.visible    = settings.visible ~= nil and settings.visible or true
            settings.layout     = settings.layout or layout
            settings.display    = settings:getDisplay()

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.render = function()

            if settings.visible and bp.player.main_job == 'GEO' then

                bp.__ui.renderUI(settings.display, function()

                    if bp and bp.player and settings.visible and settings.display:text() == "" then
                        pvt.updateDisplay()
                    end
                
                end)

            end
        
        end

        pvt.updateDisplay = function()

            if bp and bp.core and bp.core.get('indicolure') ~= nil and bp.core.get('geocolure') ~= nil and bp.core.get('entrust') ~= nil then
                local itoggle, i = bp.core.get('indicolure'), new.getIndicolure():upper()
                local gtoggle, g = bp.core.get('geocolure'), new.getGeocolure():upper()
                local etoggle, e = bp.core.get('entrust'), new.getEntrust():upper()
                local updated = {}

                do
                    updated[1] = string.format(" \\cs(%s)%s\\cr", itoggle and bp.colors.on or bp.colors.off, i)
                    updated[3] = string.format(" \\cs(%s)%s → %s\\cr", gtoggle and bp.colors.on or bp.colors.off, g, __geocolure)
                    updated[4] = string.format(" \\cs(%s)%s → %s\\cr", etoggle and bp.colors.on or bp.colors.off, e, __entrust)

                end
                settings.display:text(table.concat(updated, '\n'))

            end

        end
        
        -- Public Methods.
        new.getIndicolure = function() return bp.core.get('bubbles') and bp.core.get('bubbles').list[1] end
        new.getGeocolure = function() return bp.core.get('bubbles') and bp.core.get('bubbles').list[2] end
        new.getEntrust = function() return bp.core.get('bubbles') and bp.core.get('bubbles').list[3] end
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
        helper('prerender', pvt.render)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)

            if command == "?" then
                coroutine.schedule(function()
                    pvt.updateDisplay()
                end, 0.15)
            end
            
            if bp and command and command:lower() == 'bubbles' and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then

                    if ("etarget"):startswith(command) and commands[1] then
                        new.entrustTarget(commands[1])

                    elseif ("gtarget"):startswith(command) and commands[1] then
                        new.geocolureTarget(commands[1])

                    elseif ("visible"):startswith(command) then
                        settings.visible = (settings.visible ~= true) and true or false
                        bp.popchat.pop(string.format("BUBBLES DISPLAY: \\cs(%s)%s\\cr", bp.colors.setting, tostring(settings.visible):upper()))

                    elseif ("position"):startswith(command) and #commands > 0 then
                        settings.display:pos(tonumber(commands[1]) or settings.display:pos_x(), tonumber(commands[2]) or settings.display:pos_y())

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