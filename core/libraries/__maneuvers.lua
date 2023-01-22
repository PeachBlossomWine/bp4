local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Public Methods.
    self.active = function() return T(bp.player.buffs):map(function(id) return T{300,301,302,303,304,305,306,307}:contains(id) and bp.res.buffs[id].en or nil end) end
    self.getMissing = function(maneuvers)
        local current = self.active()

        if maneuvers and #maneuvers > 0 then

            for ci=1, #current do
                                    
                for mi=1, 3 do

                    if maneuvers[mi] == current[ci] then
                        table.remove(maneuvers, mi)
                    end

                end

            end
            return maneuvers

        end
        return T{}

    end

    return self

end
return library