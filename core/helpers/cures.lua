local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({}, hmt)

    -- Class Variables.
    helper.display  = bp.libs.__displays.new()

    -- Class Methods.
    helper.new = function()
        local t = setmetatable({}, hmt)

        -- Private Variables.
        
        -- Public Variables.

        -- Private Methods.

        -- Public Methods.

        -- Private Events.

        return t

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