local library = {}
function library:new(bp)
    local bp = bp

    -- Public Methods.
    self.getSpellSet = function()
        return bp and bp.player and bp.player.main_job_id == 16 and T(windower.ffxi.get_mjob_data().spells):filter(function(id) return id ~= 512 end) or T{}
    end

    return self

end
return library