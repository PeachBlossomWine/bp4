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

    return self

end
return library