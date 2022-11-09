function library()
    local internal = {}

    -- Create a new class object.
    function internal:new(bp)
        local bp = bp

        -- Class Variables.
        self.events = {

        }

        -- Class Functions.
        

        return setmetatable({}, {__index = self})

    end

    return internal

end
return library()