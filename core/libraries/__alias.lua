local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Public Methods.
    self.register = function(list)

        if list and type(list) == 'table' then

            for _,v in ipairs(list) do
                windower.send_command(string.format('alias %s %s', v[1], v[2]))
            end

        end

    end

    self.unregister = function(list)

        if list and type(list) == 'table' then

            for _,v in ipairs(list) do
                windower.send_command(string.format('unalias %s', v[1]))
            end

        end

    end

    return self

end
return library