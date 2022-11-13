local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=200, y=80}, bg={alpha=0, red=0, green=0, blue=0, visible=true}, flags={draggable=true, bold=false}, text={size=9, font='Lucida Console', alpha=255, red=245, green=200, blue=20, stroke={width=1, alpha=255, red=0, green=0, blue=0}}, padding=5}
    local settings  = bp.libs.__settings.new('target')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)

        -- Private Variables.
        local modes = {'PLAYER ONLY','PARTY SHARE'}

        do
            settings.mode       = settings.mode or 1
            settings.layout     = settings.layout or layout
            settings.display    = bp and not settings.display and bp.libs.__displays.new(settings.layout)

        end

        -- Public Variables.
        new.targets = {player=false, luopan=false, entrust=false}

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        local render = function()

            bp.libs.__ui.renderUI(settings.display, function()
                
                if bp and bp.player and (T{2,3}:contains(bp.player.status) or bp.player['vitals'].hp <= 0) then
                    new.clear()
                end
            
            end)
        
        end

        local updateDisplay = function()

            if new.targets.player and new.targets.player.name then
                settings.display:text(string.format('Target → [ \\cs(%s)%s%s (%s)\\cr ]', bp.colors.important, new.targets.player.name:sub(1, 8), #new.targets.player.name > 8 and '...' or '', new.targets.player.index))
                settings.display:update()

            else
                settings.display:text(string.format('Target → [ \\cs(%s)%s (%s)\\cr ]', bp.colors.important, '........', 0))
                settings.display:update()

            end

        end
        updateDisplay()

        local updateTargets = function()

        end

        -- Public Methods.
        new.clear = function()
            new.targets = {player=false, luopan=false, entrust=false}
        end
        
        new.get = function()
            return bp.libs.__target.get(new.targets.player)
        end

        new.set = function(target, sharing)
            local target = bp.libs.__target.get(target)

            if target then
                new.targets.player = bp.libs.__target.valid(target) and bp.libs.__target.canEngage(target) and target or false

                if new.targets.player and settings.mode == 2 then
                    windower.send_command(string.format('ord r* bp target share %s', self.targets.player.id)) -- ##ORDERS!
                end

            end

        end

        -- Private Events.
        helper('prerender', render)
        helper('mouse', function(param, x, y, delta, blocked) settings:saveDisplay(x, y, param) end)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'speed' then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then
    
                    if command == 'pos' and commands[1] then
                        bp.libs.__displays.position(settings, commands[1], commands[2])

                    elseif tonumber(command) ~= nil then
                        new.set(tonumber(command))
        
                    end
    
                elseif not command then                    
    
                end
                settings:save()
    
            end        
    
        end)

        return new

    end

    function helper:reload()
        bp.clearEvents(self.events)

        do -- Create a new helper object.
            return self.new()

        end

    end

    return helper

end
return buildHelper