local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=200, y=80}, bg={alpha=0, red=0, green=0, blue=0, visible=false}, flags={draggable=true, bold=true}, text={size=15, font='Calibri', alpha=255, red=245, green=200, blue=20, stroke={width=2, alpha=255, red=0, green=0, blue=0}}, padding=5}
    local settings  = bp.__settings.new('target')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __modes = {'PLAYER ONLY','PARTY SHARE'}
        local __reset = 0

        do
            settings.mode       = settings.mode or 1
            settings.layout     = settings.layout or layout
            settings.display    = settings:getDisplay()

        end

        -- Public Variables.
        new.targets = {player=false, luopan=false, entrust=false}

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.__reset = function() return (os.clock()-__reset) < 0.5 end
        pvt.updateTargets = function()

            if bp and bp.player then
                local target = windower.ffxi.get_mob_by_target('t') or false
    
                if target and bp.player.status == 1 and not new.targets.player then
                    new.targets.player = target                    
                end
    
                if new.targets.player and (not bp.__target.valid(new.targets.player) or bp.__distance.get(new.targets.player) > 45) then
                    new.set(false)                    
                end
    
                if new.targets.entrust and (not bp.__target.valid(new.targets.entrust) or bp.__distance.get(new.targets.entrust) > 45) then
                    new.setEntrust(false)
                end
    
                if new.targets.luopan and (not bp.__target.valid(new.targets.luopan) or bp.__distance.get(new.targets.luopan) > 45) then
                    new.setLuopan(false)
                end
    
            end

        end

        pvt.updateDisplay = function()

            if new.targets.player and new.targets.player.name then
                settings.display:text(string.format('{  \\cs(%s)%s\\cr  } Target → [ \\cs(%s)%s%s ( %s )\\cr ]', bp.colors.setting, string.format('%05.2f', bp.__distance.get(windower.ffxi.get_mob_by_target('t'))), bp.colors.setting, new.targets.player.name:sub(1, 10), #new.targets.player.name > 10 and '...' or '', new.targets.player.index))
                settings.display:update()

            else
                settings.display:text(string.format('{  \\cs(%s)%s\\cr  } Target → [ \\cs(%s)%s ( %s )\\cr ]', bp.colors.setting, string.format('%05.2f', bp.__distance.get(windower.ffxi.get_mob_by_target('t'))), bp.colors.setting, '........', 0))
                settings.display:update()

            end
            pvt.updateTargets()

        end

        pvt.render = function()

            bp.__ui.renderUI(settings.display, function()

                if bp and bp.player and (T{2,3}:contains(bp.player.status) or bp.player['vitals'].hp <= 0) then
                    new.clear()
                end
            
            end)
            pvt.updateDisplay()
        
        end

        pvt.statusClear = function(n, o)

            if n == 0 and o == 1 then
                new.clear()
            end

        end

        -- Public Methods.
        new.setMode = function(value)
            local value = tonumber(value)

            if value and value >= 1 and value <= 2 then
                settings.mode = value
            end
            bp.popchat.pop(string.format("TARGET MODE: \\cs(%s)%s\\cr.", bp.colors.setting, __modes[settings.mode]))
            return settings.mode

        end

        new.clear = function()
            new.targets = {player=false, luopan=false, entrust=false}
        end
        
        new.get = function()
            return bp.__target.get(new.targets.player)
        end

        new.set = function(target, share)
            local target = bp.__target.get(target) or windower.ffxi.get_mob_by_target('t')

            if target then
                new.targets.player = bp.__target.valid(target) and bp.__target.canEngage(target) and target or false

                if share and new.targets.player and settings.mode == 2 then
                    windower.send_command(string.format('ord r* bp target share %s', new.targets.player.id))
                end

                if pvt.__reset() then

                    if share then
                        windower.send_command('ord r bp target clear')

                    else
                        new.clear()

                    end

                end
                __reset = os.clock()

            end

        end

        -- Private Events.
        helper('prerender', pvt.render)
        helper('zone change', new.clear)
        helper('status change', pvt.statusClear)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'target' then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then
    
                    if command == 'pos' and commands[1] then
                        bp.__displays.position(settings, commands[1], commands[2])

                    elseif command == 't' then
                        new.set(commands[1], true)

                    elseif command == 'p' then
                        new.set(commands[1], true)

                    elseif command == 'e' then
                        new.set(commands[1], true)

                    elseif command == 'mode' and commands[1] then
                        new.setMode(commands[1])
        
                    end                   
    
                end
                settings:save()
    
            end        
    
        end)

        return new

    end

    return helper

end
return buildHelper