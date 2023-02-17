local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=200, y=80}, bg={alpha=0, red=0, green=0, blue=0, visible=false}, flags={draggable=true, bold=true}, text={size=15, font='Calibri', alpha=255, red=245, green=200, blue=20, stroke={width=2, alpha=255, red=0, green=0, blue=0}}, padding=5}
    local settings  = bp.libs.__settings.new('assist')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __assist = false
        local __engage = false
        local __update = 0

        do -- Private Settings.
            settings.visible    = settings.visible ~= nil and settings.visible or true
            settings.layout     = settings.layout or layout
            settings.display    = settings:getDisplay()

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.render = function()

            if settings.visible then

                bp.__ui.renderUI(settings.display, function()

                    if bp and bp.player and settings.visible and settings.display:text() == "" then
                        pvt.updateDisplay()
                    end
                
                end)

            end
        
        end

        pvt.updateDisplay = function()
            local target = bp.__target.get(__assist)

            if target then
                settings.display:text(string.format("ASSISTING: \\cs(%s)%s%s\\cr", __engage and bp.colors.on or bp.colors.setting, target.name:upper(), __engage and "*" or ""))

            else
                settings.display:text(string.format("ASSISTING: \\cs(%s). . .\\cr", bp.colors.setting))

            end

        end

        pvt.handle = function()

            if __assist then
                local ally = bp.__target.get(__assist)
    
                if ally and ally.target_index > 0 and ally.status == 1 and bp.__distance.get(ally) <= 25 then
    
                    if bp.player.status == 0 then
                        local target = bp.__target.get(ally.target_index)
                            
                        if target and bp.__target.canEngage(target) then
                            bp.target.set(target)
    
                            if __engage then
                                bp.__actions.stop()
                                bp.__actions.engage(target)
                            end
    
                        end
    
                    elseif bp.player.status == 1 and bp.__target.get('t') and bp.__target.get('t').index ~= ally.target_index then
                        bp.__actions.switchTarget(ally.target_index)
    
                    end
    
                elseif ally and ally.status == 0 and bp.player.status == 1 and bp.__distance.get(ally) < 50 then
                    bp.__actions.disengage()
    
                end
    
            end

        end

        -- Public Methods.
        new.get = function() return __assist end
        
        new.clear = function()
            __assist = false
            pvt.updateDisplay()

        end

        new.set = function(target, engage)
            __assist = bp.__target.get(target) and bp.__target.get(target).index or false

            if engage then
                __engage = engage and true or false
                            
            end
            pvt.updateDisplay()
        
        end

        new.send = function(target)
            local target = bp.__target.get(target)

            if target and target.id ~= bp.player.id and bp.__party.isMember(target) then
                new.set(target.index)

                if (os.clock()-__update) < 0.35 then
                    bp.__orders.deliver('p*', string.format('bp assist set %s', target.index))
                end

            elseif not target or (target and (not bp.__party.isMember(target) or target.id == bp.player.id)) then
                new.clear()

                if (os.clock()-__update) < 0.35 then
                    bp.__orders.deliver('p*', 'bp assist clear')
                end

            end
            __update = os.clock()

        end

        -- Private Events.
        helper('prerender', pvt.render)
        helper('time change', pvt.handle)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'assist' then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then

                    if ('engage'):startswith(command) then

                        if T{'!','#'}:contains(commands[1]) then
                            __engage = (commands[1] == '!')
    
                        else
                            __engage = (__engage ~= true) and true or false
                            bp.popchat.pop(string.format("AUTO-ENGAGE: \\cs(%s)%s\\cr", bp.colors.setting, tostring(__engage):upper()))
    
                        end
                        pvt.updateDisplay()

                    elseif ('clear'):startswith(command) then
                        new.clear()

                    elseif ('set'):startswith(command) and commands[1] then
                        new.set(tonumber(commands[1]))

                    elseif ("visible"):startswith(command) then
                        settings.visible = (settings.visible ~= true) and true or false
                        bp.popchat.pop(string.format("ASSIST DISPLAY: \\cs(%s)%s\\cr", bp.colors.setting, tostring(settings.visible):upper()))

                    elseif ("position"):startswith(command) and #commands > 0 then
                        settings.display:pos(tonumber(commands[1]) or settings.display:pos_x(), tonumber(commands[2]) or settings.display:pos_y())

                    elseif bp.__target.get(command) then
                        new.send(bp.__target.get(command).index)

                    end

                elseif bp.__target.get('t') then
                    new.send(bp.__target.get('t').index)

                end    
    
            end        
    
        end)

        return new

    end

    return helper

end
return buildHelper