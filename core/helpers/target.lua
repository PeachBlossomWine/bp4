local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=200, y=80}, bg={alpha=0, red=0, green=0, blue=0, visible=true}, flags={draggable=true, bold=false}, text={size=10, font='Lucida Console', alpha=255, red=245, green=200, blue=20, stroke={width=1, alpha=255, red=0, green=0, blue=0}}, padding=5}
    local settings  = bp.libs.__settings.new('target')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local modes = {'PLAYER ONLY','PARTY SHARE'}
        local reset = 0

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
        pvt.reset = function() return (os.clock()-reset) < 0.5 end
        pvt.updateTargets = function()

            if bp and bp.player then
                local target = windower.ffxi.get_mob_by_target('t') or false
    
                if target and bp.player.status == 1 and not new.targets.player then
                    new.targets.player = target                    
                end
    
                if new.targets.player and (not bp.libs.__target.valid(new.targets.player) or bp.libs.__distance.get(new.targets.player) > 45) then
                    new.set(false)                    
                end
    
                if new.targets.entrust and (not bp.libs.__target.valid(new.targets.entrust) or bp.libs.__distance.get(new.targets.entrust) > 45) then
                    new.setEntrust(false)
                end
    
                if new.targets.luopan and (not bp.libs.__target.valid(new.targets.luopan) or bp.libs.__distance.get(new.targets.luopan) > 45) then
                    new.setLuopan(false)
                end
    
            end

        end

        pvt.updateDisplay = function()

            if new.targets.player and new.targets.player.name then
                settings.display:text(string.format('{  \\cs(%s)%s\\cr  } Target → [ \\cs(%s)%s%s (%s)\\cr ]', bp.colors.important, string.format('%05.2f', bp.libs.__distance.get(windower.ffxi.get_mob_by_target('t'))), bp.colors.important, new.targets.player.name:sub(1, 8), #new.targets.player.name > 8 and '...' or '', new.targets.player.index))
                settings.display:update()

            else
                settings.display:text(string.format('{  \\cs(%s)%s\\cr  } Target → [ \\cs(%s)%s (%s)\\cr ]', bp.colors.important, string.format('%05.2f', bp.libs.__distance.get(windower.ffxi.get_mob_by_target('t'))), bp.colors.important, '........', 0))
                settings.display:update()

            end
            pvt.updateTargets()

        end

        pvt.render = function()

            bp.libs.__ui.renderUI(settings.display, function()

                if bp and bp.player and (T{2,3}:contains(bp.player.status) or bp.player['vitals'].hp <= 0) then
                    new.clear()
                end
            
            end)
            pvt.updateDisplay()
        
        end

        -- Public Methods.
        new.setMode = function(value)
            if tonumber(value) == nil then return end
            settings.mode = value
            return value

        end

        new.clear = function()
            new.targets = {player=false, luopan=false, entrust=false}
        end
        
        new.get = function()
            return bp.libs.__target.get(new.targets.player)
        end

        new.set = function(target, share)
            local target = bp.libs.__target.get(target) or windower.ffxi.get_mob_by_target('t')

            if target then
                new.targets.player = bp.libs.__target.valid(target) and bp.libs.__target.canEngage(target) and target or false

                if share and new.targets.player and settings.mode == 2 then
                    --windower.send_command(string.format('ord r* bp target share %s', new.targets.player.id))
                end

                if pvt.reset() then

                    if share then
                        windower.send_command('ord r bp target clear')

                    else
                        new.clear()

                    end

                end
                reset = os.clock()

            end

        end

        -- Private Events.
        helper('prerender', pvt.render)
        helper('mouse', function(param, x, y, delta, blocked) settings:saveDisplay(x, y, param) end)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'target' then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then
    
                    if command == 'pos' and commands[1] then
                        bp.libs.__displays.position(settings, commands[1], commands[2])

                    elseif command == 't' then
                        new.set(commands[1], true)

                    elseif command == 'p' then
                        new.set(commands[1], true)

                    elseif command == 'e' then
                        new.set(commands[1], true)
        
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