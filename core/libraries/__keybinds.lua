local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Public Methods.
    self.register = function(keybinds)
        
        for bind in T(keybinds):it() do
            windower.send_command(string.format('bind %s', bind))
        end

    end

    -- Private Events.
    windower.register_event('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)

        if bp and bp.player and command and command:lower() == 'keybinds' then
            local command = commands[1] and table.remove(commands, 1):lower() or false
            
            if command then
                windower.send_command(string.format('bind %s', command))
            end

        end

    end)

    return self

end
return library