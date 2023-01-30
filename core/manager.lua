local manager = {}
function manager:new(bp)
    local bp = bp
    local mt = {}

    -- Private Variables.
    local classes   = {}
    local status    = {

        [0x01] = 'LOADING',
        [0x02] = 'READY',
        [0x03] = 'RELOADING',

    }

    -- Private Methods.
    local getHelper = function(name) return classes and classes[name] and classes[name].helper or false end
    local getClass = function(name) return classes and classes[name] and classes[name].class or false end
    local clearEvents = function(class)
        
        if class and class.events then

            for id in T(class.events):it() do
                windower.unregister_event(id)
            end
            class.events = {}

        end

    end

    -- Public Methods.
    function self:add(helper, name)
        
        if bp and helper and name then
            local class = helper(bp, bp.files.new('core/metas.lua'):exists() and dofile(string.format('%score/metas.lua', windower.addon_path)) or {})

            if class then
                classes[name] = {class=class, helper=class.new()}
            end

        end

    end

    function self:reload(name)
        local class = getClass(name)

        if bp and class then
            clearEvents(class)

            do -- Reload the class.
                class.helper = class.new()

            end
            bp.popchat.pop(string.format("RELOADING HELPER: \\cs(%s)%s\\cr", bp.colors.setting, name:upper()))

        end

    end

    self.getStatus = function(name)
        local class = getClass(name)

        if class and class.status then
            return class.status
        end
        return false

    end

    self.isReady = function(name)
        local class = getClass(name)

        if class and class.status and class.status == 0x02 then
            return true
        end
        return false

    end

    self.active = function()
        return T(classes):keyset()
    end

    -- Metatables.
    mt.__index = function(t, key)

        if rawget(classes, key) and rawget(classes, key).helper then
            return rawget(classes, key).helper
        end

    end

    return setmetatable(self, mt)

end
return manager