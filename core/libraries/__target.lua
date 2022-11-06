function library()
    local internal = {}

    -- Create a new class object.
    function internal:new(bp)
        local bp = bp

        -- Class Functions.
        function self:get(target)
    
            if type(target) == 'string' then
                local types = T{'t','bt','st','me','ft','ht','pet'}
    
                if types:contains(target) and windower.ffxi.get_mob_by_target(target) then
                    return windower.ffxi.get_mob_by_target(target)
    
                elseif tonumber(target) == nil and #target > 1 then
                    local target = string.format("%s%s", target:sub(1,1):upper(), target:sub(2):lower())
    
                    if windower.ffxi.get_mob_by_name(target) then
                        return windower.ffxi.get_mob_by_name(target)
                    end
    
                elseif tonumber(target) ~= nil then
                    local target = tonumber(target)
    
                    if windower.ffxi.get_mob_by_id(target) then
                        return windower.ffxi.get_mob_by_id(target)
        
                    elseif windower.ffxi.get_mob_by_index(target) then
                        return windower.ffxi.get_mob_by_index(target)
        
                    end                
    
                end
    
            elseif type(target) == 'number' then
                    
                if windower.ffxi.get_mob_by_id(target) then
                    return windower.ffxi.get_mob_by_id(target)
    
                elseif windower.ffxi.get_mob_by_index(target) then
                    return windower.ffxi.get_mob_by_index(target)
    
                end
    
            elseif type(target) == 'table' then
                
                if target.mob and target.mob then
                    return target.mob
    
                elseif target.id and windower.ffxi.get_mob_by_id(target.id) then
                    return windower.ffxi.get_mob_by_id(target.id)
                    
                end
    
            end
            return false
    
        end

        function self:valid(target)
            local target = self:get(target)
    
            if target and type(target) == 'table' and target.distance ~= nil then
                local distance = bp.libs.__distance:get(target)

                if (distance == 0.089004568755627 or distance > 35) and distance ~= 0 then
                    return false
                end

                if not target then
                    return false
                end

                if target.hpp == 0 then
                    return false
                end

                if not target.valid_target then
                    return false
                end

                if not self:isEnemy(target) and not bp.libs.__party:isMember(target, true) then
                    return false
                end
                return true
    
            end
            return false
    
        end

        function self:canEngage(target)
            local target = self:get(target)

            if bp and bp.player and target then

                if target.spawn_type == 16 and not target.charmed and not self:isDead(target) and target.valid_target then

                    if (target.claim_id == 0 or bp.libs.__party:isMember(target.claim_id, true) or bp.helpers['buffs'].buffActive(603) or bp.helpers['buffs'].buffActive(511) or bp.helpers['buffs'].buffActive(257) or bp.helpers['buffs'].buffActive(267)) then
                        return true
                    end
        
                end

            end
            return false
    
        end
    
        function self:isEnemy(target)
            local target = self:get(target)

            if bp and target and target.spawn_type == 16 then
                return true
            end
            return false
    
        end

        function self:onlySelf(spell)
            local targets = spell and spell.targets or {}
    
            if #targets == 1 and targets[1] == 'Self' and spell.prefix ~= '/song' then
                return true
            end
            return false
    
        end
    
        function self:isDead(target)
            local target = self:get(target)
    
            if target and target.status and S{2,3}:contains(target.status) then
                return true
            end
            return false
    
        end
    
        function self:castable(target, spell)
            local targets   = spell and spell.targets or false
            local target    = self:get(target)
    
            if bp and target and targets then
    
                for i,v in pairs(targets) do
    
                    if i == 'Self' and target.name == bp.player.name then
                        return v
    
                    elseif i == 'Party' and bp.libs.__party:isMember(target) then
                        return v
    
                    elseif i == 'Ally' and bp.libs.__party:isMember(target, true) then
                        return v
    
                    elseif i == 'Player' and not target.is_npc then
                        return v
    
                    elseif i == 'NPC' and target.is_npc then
                        return v
    
                    elseif i == 'Enemy' and target.spawn_type == 16 and (target.claim_id == 0 or bp.libs.__party:isMember(target.claim_id, true)) then
                        return v
    
                    end
    
                end
    
            end
            return false
    
        end
    
        function self:inRange(target, r, outside)
            local target = self:get(target)
    
            if bp and bp.me and target and type(target) == 'table' and target.x and target.y then
                local r = r or 6.6
                    
                if (( (bp.me.x-target.x)^2 + (bp.me.y-target.y)^2) < r^2) and not outside then
                    return true
                    
                elseif (( (bp.me.x-target.x)^2 + (bp.me.y-target.y)^2) > r^2) and outside then
                    return true
                    
                end
    
            end
            return false
    
        end

        function self:id(index)
            
            if bp and bp.info and index then
                return ( (bp.info.zone * 4096) + (16777216 + index) )
            end
            return false

        end
    
        function self:index(id)
            
            if bp and bp.info and id then
                return (id - ((bp.info.zone * 4096) + 16777216))
            end
            return false

        end

        return setmetatable({}, {__index = self})

    end

    return internal

end
return library()