local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Public Variables.
    self.list = T(bp.res.job_abilities):map(function(ability) return ability.type == "Rune" and ability.en or nil end)

    -- Public Methods.
    self.count = function() return self.active():length() end
    self.active = function()
        return T(bp.player.buffs):map(function(buff)
            
            if bp.res.buffs[buff] and self.list:contains(bp.res.buffs[buff].en) then
                return buff
            end
        
        end)
    
    end

    self.missing = function()

        if bp.core.get('runes') then
            local runes = T(bp.core.get('runes').list):copy()

            for i=1, bp.__runes.count() do
                
                if bp.__runes.current[i] == runes[i] then
                    table.remove(runes, i)
                end

            end
            return T(runes)

        end
        
    end

    self.current = function()
        return T(bp.player.buffs):map(function(buff)

            if bp.res.buffs[buff] and self.list:contains(bp.res.buffs[buff].en) then
                return bp.res.buffs[buff].en
            end

        end)
    
    end

    self.get = function(n)
        
        if bp.core.get('runes') then
            local runes = bp.core.get('runes').list:copy()

            if n and runes[n] then
                return runes[n]
            end
            return runes

        end
        return nil

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

    self.isRune = function(search)
            
        if (("ignis"):startswith(search) or ("fire"):startswith(search)) then
            return "Ignis"

        elseif (("gelus"):startswith(search) or ("ice"):startswith(search)) then
            return "Gelus"

        elseif (("flabra"):startswith(search) or ("wind"):startswith(search)) then
            return "Flabra"

        elseif (("tellus"):startswith(search) or ("earth"):startswith(search)) then
            return "Tellus"

        elseif (("sulpor"):startswith(search) or ("thunder"):startswith(search)) then
            return "Sulpor"

        elseif (("unda"):startswith(search) or ("water"):startswith(search)) then
            return "Unda"

        elseif (("lux"):startswith(search) or ("light"):startswith(search)) then
            return "Lux"

        elseif (("tenebrae"):startswith(search) or ("dark"):startswith(search)) then
            return "Tenebrae"

        end
        return false

    end

    return self

end
return library