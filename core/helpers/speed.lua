
local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=200, y=80}, bg={alpha=0, red=0, green=0, blue=0, visible=false}, flags={draggable=true, bold=false}, text={size=15, font='Impact', alpha=255, red=245, green=200, blue=20, stroke={width=2, alpha=255, red=0, green=0, blue=0}}, padding=5}
    local settings  = bp.libs.__settings.new('speed')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)

        -- Private Variables.
        settings.layout     = settings.layout or layout
        settings.speed      = settings.speed or 70
        settings.zones      = settings.zones or {}
        settings.display    = settings:getDisplay()

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        local render = function()

            bp.libs.__ui.renderUI(settings.display, function()

                if settings.speed then
                    settings.display:text(string.format("{  %d%%  }", settings.speed*2))
                end
            
            end)

        end

        -- Public Methods.
        new.get = function() return settings.speed end
        new.set = function(value) settings.speed = value and tonumber(value) ~= nil and value or settings.speed end

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

                    elseif command == 'test' then
                        print(settings.mode)

                    elseif tonumber(command) ~= nil then
                        new.set(tonumber(command))
        
                    end
    
                elseif not command then                    
    
                end
                settings:save()
    
            end        
    
        end)

        helper('incoming', function(id, original)

            if bp and bp.player and enabled then
    
                if id == 0x037 then
                    local parsed = bp.packets.parse('incoming', original)

                    if parsed and parsed['Player'] == bp.player.id then
                        parsed['Movement Speed/2'] = parsed['Movement Speed/2'] >= settings.speed and parsed['Movement Speed/2'] or settings.speed
                    end
                    return bp.packets.build(parsed)
            
                elseif id == 0x00d then
                    local parsed = bp.packets.parse('incoming', original)

                    if parsed and parsed['Player'] == bp.player.id then
                        parsed['Movement Speed'] = parsed['Movement Speed'] >= settings.speed and parsed['Movement Speed'] or settings.speed
                    end
                    return bp.packets.build(parsed)
            
                end

            end
        
        end)

        return new

    end

    return helper

end
return buildHelper