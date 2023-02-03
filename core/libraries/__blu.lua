local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Public Methods.
    self.getSpellSet = function()

        if bp and bp.player and bp.player.main_job_id == 16 then
            return T(windower.ffxi.get_mjob_data().spells):filter(function(id) return id ~= 512 end) or T{}
        
        elseif bp and bp.player and bp.player.sub_job_id == 16 then
            return T(windower.ffxi.get_sjob_data().spells):filter(function(id) return id ~= 512 end) or T{}

        end

    end

    self.hasHateSpells = function(spells)
        return self.getSpellSet():filter(function(id) return bp.res.spells[id] and T(spells):contains(bp.res.spells[id].en) end)        
    end

    return self

end
return library