local library = {}
function library:new(bp)
    local bp = bp

    -- Public Methods.
    self.canMelee = function(target) return target and self.get(target) < (1.85 + target.model_size + bp.me.model_size) or false end
    self.get = function(target)
        local t = (target and target.x and target.y and target.z) and target or bp.libs.__target.get(target)

        if bp.me and t and t.x and t.y and t.z then
            return ((V{bp.me.x, bp.me.y, (bp.me.z*-1)} - V{t.x, t.y, (t.z*-1)}):length())
        end
        return 0

    end

    self.pet = function(target)
        local t = (target and target.x and target.y and target.z) and target or bp.libs.__target.get(target)

        if bp.me and t then
            return ((V{bp.me.x, bp.me.y, (bp.me.z*-1)} - V{t.x, t.y, (t.z*-1)}):length())
        end
        return 0

    end

    self.height = function(target)

        if bp.me and target and target.z then
            return math.abs(target.z - bp.me.z)
        end

    end

    return self

end
return library