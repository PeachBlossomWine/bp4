local library = {}
function library:new(bp)
    local bp = bp

    -- Public Methods.
    self.canMelee = function(target) return target and self.get(target) < (1.85 + target.model_size + bp.me.model_size) or false end
    self.get = function(target)
        local m = windower.ffxi.get_mob_by_target('me') or false
        local t = bp.libs.__target.get(target)

        if m and t and t.x and t.y and t.z then
            return ((V{m.x, m.y, (m.z*-1)} - V{t.x, t.y, (t.z*-1)}):length())
        end
        return 0

    end

    self.pet = function(target)
        local m = windower.ffxi.get_mob_by_target('pet') or false
        local t = bp.libs.__target.get(target)

        if m and t then
            return ((V{m.x, m.y, m.z} - V{t.x, t.y, t.z}):length())
        end
        return 0

    end

    return self

end
return library