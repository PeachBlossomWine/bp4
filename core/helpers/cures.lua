local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = {events={}}

    -- Set Metamethods to helper.
    setmetatable(helper, hmt)

    helper.new = function()
        local t = {}

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