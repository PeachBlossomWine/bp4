function library()
    local internal = {}

    -- Create a new class object.
    function internal:new(bp)
        local bp = bp

        -- Class Functions.
        function self:get(target)
            local m = windower.ffxi.get_mob_by_target('me') or false
            local t = bp.libs.__target:get(target)
    
            if m and t and t.x and t.y and t.z then
                return ((V{m.x, m.y, m.z} - V{t.x, t.y, t.z}):length())
            end
            return 0
    
        end
    
        function self:pet(target)
            local m = windower.ffxi.get_mob_by_target('pet') or false
            local t = bp.libs.__target:get(target)
    
            if m and t then
                return ((V{m.x, m.y, m.z} - V{t.x, t.y, t.z}):length())
            end
            return 0
    
        end

        return setmetatable({}, {__index = self})

    end

    return internal

end
return library()