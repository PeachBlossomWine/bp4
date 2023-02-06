local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Public Methods.
    self.active = function() return T(T(bp.player.buffs):map(function(id) return T{300,301,302,303,304,305,306,307}:contains(id) and bp.res.buffs[id].en or nil end)) end
    self.getMissing = function()
        local current = self.active()
        
        if bp and bp.core and bp.core.get('maneuvers') and #bp.core.get('maneuvers').list > 0 then
            local maneuvers = T(bp.core.get('maneuvers').list):copy()
            
            for maneuver in current:it() do
                
                for mi=1, 3 do

                    if maneuvers[mi] == maneuver then
                        table.remove(maneuvers, mi)
                    end

                end

            end
            return T(maneuvers)

        end
        return T{}

    end

    return self

end
return library