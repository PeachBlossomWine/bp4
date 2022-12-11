local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __runes = S(bp.res.job_abilities):map(function(ability) return ability.type == 'Rune' and ability.en end)

    -- Public Methods.
    self.count = function() return self.active():length() end
    self.isRune = function(name) return __runes:contains(name) end

    self.active = function()
        return T(bp.player.buffs):map(function(buff)
            
            if bp.res.buffs[buff] and __runes:contains(bp.res.buffs[buff].en) then
                return buff
            end
        
        end)
    
    end

    self.current = function()
        return T(bp.player.buffs):map(function(buff)

            if bp.res.buffs[buff] and __runes:contains(bp.res.buffs[buff].en) then
                return bp.res.buffs[buff].en
            end

        end)
    
    end

    self.max = function()

        if bp and bp.player and (bp.player.main_job == 'RUN' or bp.player.sub_job == 'RUN') then
            local mlevel = bp.player.main_job_level
            local slevel = bp.player.sub_job_level

            if bp.player.main_job == 'RUN' then
                return (mlevel < 35) and 1 or (mlevel >= 35 and mlevel < 65) and 2 or (mlevel >= 65) and 3

            elseif bp.player.sub_job == 'RUN' then
                return (slevel < 35) and 1 or (slevel >= 35 and slevel < 65) and 2 or (slevel >= 65) and 3

            end

        end
        return 0

    end

    return self

end
return library