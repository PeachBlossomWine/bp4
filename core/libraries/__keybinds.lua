local library = {}
function library:new(bp)
    local bp = bp

    -- Public Methods.
    self.register = function(list)

        if list and type(list) == 'table' then

            for _,v in ipairs(list) do
                windower.send_command(string.format('bind %s', v))

            end

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