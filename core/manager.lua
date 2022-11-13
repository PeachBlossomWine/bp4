local buildManager = function(bp)
    local manager, meta = {}, {}
        
    -- Private Variables.
    local bp        = bp
    local hmt       = dofile(string.format("%score/metas.lua", windower.addon_path))
    local classes   = {}

    -- Public Variables.
    manager.helpers = {}

    -- Private Methods.
    local addClass = function(helper)
        local helper = helper(bp, hmt)

        if helper and helper.new then
            return helper, helper.new()
        end
        
    end

    local clearEvents = function(class)
        
        if class and class.events then

            for id in T(class.events):it() do
                windower.unregister_event(id)
            end
            class.events = {}

        end

    end

    -- Public Methods.    
    function manager:add(helper, name)
        
        if bp and helper and name then
            classes[name], self.helpers[name] = addClass(helper)
        end

    end

    function manager:reload(name)

        if bp and name and classes[name] then
            clearEvents(classes[name])

            do -- Reload the class.
                self.helpers[name] = classes[name].new()

            end

        end

    end

    -- Manager Metas.
    meta.__index = function(t, index)

        if t.helpers and t.helpers[index] then
            return t.helpers[index]

        else
            return false

        end

    end

    meta.__call = function(t, ...)
        local options = T{...}

        if #options > 0 then
            -- Future needs.

        else
            return T(t.helpers):keyset()

        end

    end

    return setmetatable(manager, meta)

end
return buildManager