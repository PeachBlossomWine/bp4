local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=200, y=80}, bg={alpha=180, red=0, green=0, blue=0, visible=true}, flags={draggable=true, bold=false}, text={size=9, font='Lucida Console', alpha=255, red=245, green=200, blue=20, stroke={width=1, alpha=255, red=0, green=0, blue=0}}, padding=5}
    local settings  = bp.libs.__settings.new('rolls')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __rolls = {}

        do -- Private Settings.
            settings.stop       = settings.stop or 7
            settings.visible    = settings.visible ~= nil and settings.visible or true
            settings.layout     = settings.layout or layout
            settings.display    = settings:getDisplay()

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Disable rolls on load.
        coroutine.schedule(function()
            pvt.disable()
            pvt.updateDisplay()
        
        end, 1.75)

        -- Private Methods.
        pvt.render = function()

            if settings.visible then

                bp.__ui.renderUI(settings.display, function()

                    if bp and bp.player and settings.visible and settings.display:text() == "" and (bp.player.main_job == 'COR' or bp.player.sub_job == 'COR') then
                        pvt.updateDisplay()
                    end
                
                end)

            end
        
        end

        pvt.updateDisplay = function(id)
            local update = {}

            if id and id ~= 309 and bp.res.buffs[id] and bp.__rolls.list:contains(bp.res.buffs[id].en) then

                if bp.core.get('rolls').list[1] == bp.res.buffs[id].en then
                    __rolls[1] = 0

                elseif bp.core.get('rolls').list[2] == bp.res.buffs[id].en then
                    __rolls[2] = 0

                end

            end

            if bp.core.get('rolls') and bp.core.get('rolls').list[1] then
                table.insert(update, string.format("CORSAIR ROLLS: \\cs(%s)%s\\cr\n", (bp.core.get('rolls').enabled) and string.format('%s,%s,%s', 60, 180, 5) or string.format('%s,%s,%s', 220, 30, 45), tostring(bp.core.get('rolls').enabled):upper()))
                table.insert(update, string.format("\\cs(%s)STOP ROLLS:\\cr \\cs(%s)%s\\cr\n\n", string.format('%s,%s,%s', 30, 120, 220), bp.colors.setting, settings.stop))
                table.insert(update, string.format("ROLL #1: \\cs(%s)%s\\cr\n", pvt.getColor(bp.core.get('rolls').list[1], __rolls[1]), bp.core.get('rolls').list[1]:upper()))
                table.insert(update, string.format("ROLL #2: \\cs(%s)%s\\cr\n", pvt.getColor(bp.core.get('rolls').list[2], __rolls[2]), bp.core.get('rolls').list[2]:upper()))
            
            end
            settings.display:text(table.concat(update, ""))

        end

        pvt.getColor = function(roll, n)

            if roll and n then

                if bp.__rolls.isLucky(roll, n) then
                    return string.format('%s,%s,%s', 60, 180, 5)

                elseif bp.__rolls.isUnlucky(roll, n) then
                    return string.format('%s,%s,%s', 220, 30, 45)

                elseif n > 11 then
                    return string.format('%s,%s,%s', 50, 50, 50)

                end

            end
            return bp.colors.setting

        end

        pvt.disable = function()

            if bp.core.get('rolls') then
                bp.core.get('rolls').enabled = false
            end
        
        end
        
        -- Public Methods.
        new.getStop = function() return settings.stop end
        
        -- Private Events.
        helper('prerender', pvt.render)
        helper('zone change', pvt.disable)
        helper('lose buff', pvt.updateDisplay)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)

            if command == "?" then
                coroutine.schedule(function()
                    pvt.updateDisplay()
                end, 0.15)
            end
            
            if bp and command and command:lower() == 'rolls' and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then

                    if ("visible"):startswith(command) then
                        settings.visible = (settings.visible ~= true) and true or false
                        bp.popchat.pop(string.format("ROLLS DISPLAY: \\cs(%s)%s\\cr", bp.colors.setting, tostring(settings.visible)))

                    elseif ("stop"):startswith(command) then
                        settings.stop = (tonumber(commands[1]) and tonumber(commands[1]) >= 1 and tonumber(commands[1]) <= 11) and tonumber(commands[1]) or settings.stop
                        bp.popchat.pop(string.format("STOP ROLLS: @\\cs(%s)%s\\cr", bp.colors.setting, tostring(settings.stop)))

                    elseif ("position"):startswith(command) and #commands > 0 then
                        settings.display:pos(tonumber(commands[1]) or settings.display:pos_x(), tonumber(commands[2]) or settings.display:pos_y())

                    end
                    pvt.updateDisplay()

                end
                settings:save()

            end

        end)

        helper('incoming chunk', function(id, original)
        
            if bp and id == 0x028 then
                local parsed    = bp.packets.parse('incoming', original)
                local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
                local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
                
                if parsed and bp.player and actor and target and bp.player.id == actor.id and bp.player.id == target.id and parsed['Category'] == 6 then
    
                    if parsed['Target 1 Action 1 Param'] and bp.res.job_abilities[parsed['Param']] and bp.__rolls.list:contains(bp.res.job_abilities[parsed['Param']].en) then

                        if bp.res.job_abilities[parsed['Param']].en == bp.core.get('rolls').list[1] then
                            __rolls[1] = parsed['Target 1 Action 1 Param']
                            pvt.updateDisplay()

                        elseif bp.res.job_abilities[parsed['Param']].en == bp.core.get('rolls').list[2] then
                            __rolls[2] = parsed['Target 1 Action 1 Param']
                            pvt.updateDisplay()

                        end
                        
                    end
    
                end
    
            end
    
        end)

        return new

    end

    return helper

end
return buildHelper