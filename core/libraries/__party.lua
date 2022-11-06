function library()
    local internal = {}

    -- Create a new class object.
    function internal:new(bp)
        local bp = bp

        -- Class Functions.
        function self:count(party)
            return party and bp.party and bp.party[string.format('party%s_count', party)] or (bp.party['party1_count'] + bp.party['party2_count'] + bp.party['party3_count'])
        end
        
        function self:getAllyLeader()
            return bp and bp.party and bp.party['alliance_leader'] and bp.party['alliance_leader'] or false    
        end
    
        function self:getPartyLeader()
            return bp and bp.party and bp.party['party1_leader'] and bp.party['party1_leader'] or false    
        end
    
        function self:getLeader()
    
            if bp and bp.party and (bp.party['alliance_leader'] or bp.party['party1_leader']) then
                return not bp.helpers['party'].getAllyLeader() and bp.helpers['party'].getPartyLeader() or bp.helpers['party'].getAllyLeader()
            end
            return -1
            
        end
    
        function self:isAllyLeader()
            return self.getAllyLeader() and self.getAllyLeader() == bp.player.id or false
        end
    
        function self:isPartyLeader()
            return self.getPartyLeader() and self.getPartyLeader() == bp.player.id or false
        end
    
        function self:isLeader()
            return self.getLeader() and self.getLeader() == bp.player.id or false
        end

        function self:getMembers(alliance)
            local members = {}
    
            if bp and bp.party then
    
                for i,v in pairs(bp.party) do

                    if i:sub(1,1) == "p" and tonumber(i:sub(2)) ~= nil then
                        table.insert(members, v)

                    elseif alliance and i:sub(1,1) == "a" and tonumber(i:sub(2)) ~= nil then
                        table.insert(members, v)

                    end
    
                end
    
            end
            return members
    
        end
    
        function self:getMember(target, alliance)
    
            if bp and bp.party and target then
                local target = bp.libs.__target:get(target)
    
                for index, member in pairs(bp.party) do
                    
                    if index:sub(1,1) == "p" and tonumber(index:sub(2)) ~= nil and member.mob and target.id == member.mob.id then
                        return v

                    elseif alliance and index:sub(1,1) == "a" and tonumber(index:sub(2)) ~= nil and member.mob and target.id == member.mob.id then
                        return v

                    end

                end
            
            end
            return false
    
        end
    
        function self:isMember(player, alliance)
    
            if bp and player and bp.party then
                local player = bp.libs.__target:get(player)
    
                for index, member in pairs(bp.party) do

                    if index:sub(1,1) == "p" and tonumber(index:sub(2)) ~= nil and player.name:lower() == member.name:lower() then
                        return true

                    elseif index:sub(1,1) == "a" and tonumber(index:sub(2)) ~= nil and player.name:lower() == member.name:lower() then
                        return true

                    end

                end
    
            end
            return false
    
        end
    
        function self:inRange(distance)
            local count, pass = (bp.party.party1_count + bp.party.party2_count or 0 + bp.party.party3_count or 0), 0
    
            if bp and bp.party then
    
                for index, member in pairs(bp.party) do
                    
                    if (index:sub(1,1) == "p" or index:sub(1,1) == "a") and tonumber(index:sub(2)) ~= nil and member.mob and not member.mob.is_npc then
                        
                        if bp.libs.__distance.get(v.mob) <= distance and v.zone == bp.info.zone then
                            pass = (pass + 1)
                        end
    
                    end
    
                end
                return count == pass
    
            end
            return 0
    
        end

        return setmetatable({}, {__index = self})

    end

    return internal

end
return library()