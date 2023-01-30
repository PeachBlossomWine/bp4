local library = {}
function library:new(bp)
    local bp = bp

    -- Public Methods.
    self.getMemberList = function()
        local list = T{inside={}, outside={}}

        if bp and bp.party then
            
            for member, index in T(bp.party):it() do
                
                if type(member) == 'table' and member.name then

                    if index:sub(1,1) == 'p' then
                        table.insert(list.inside, member.name)
                    
                    elseif index:sub(1,1) == 'a' then
                        table.insert(list.outside, member.name)

                    end

                end
            
            end

        end
        return list

    end

    self.count = function(party)
        return party and bp.party and bp.party[string.format('party%s_count', party)] or (bp.party['party1_count'] + bp.party['party2_count'] + bp.party['party3_count'])
    end
    
    self.getAllyLeader = function()
        return bp and bp.party and bp.party['alliance_leader'] and bp.party['alliance_leader'] or false    
    end

    self.getPartyLeader = function()
        return bp and bp.party and bp.party['party1_leader'] and bp.party['party1_leader'] or false    
    end

    self.getLeader = function()

        if bp and bp.party and (bp.party['alliance_leader'] or bp.party['party1_leader']) then
            return not self.getAllyLeader() and self.getPartyLeader() or self.getAllyLeader()
        end
        return -1
        
    end

    self.isAllyLeader = function()
        return self.getAllyLeader() and self.getAllyLeader() == bp.player.id or false
    end

    self.isPartyLeader = function()
        return self.getPartyLeader() and self.getPartyLeader() == bp.player.id or false
    end

    self.isLeader = function()
        return self.getLeader() and self.getLeader() == bp.player.id or false
    end

    self.getMembers = function(alliance)
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

    self.getMember = function(target, alliance)

        if bp and bp.party and target then
            local target = bp.__target.get(target)

            for index, member in pairs(bp.party) do

                if target and index:sub(1,1) == "p" and tonumber(index:sub(2)) ~= nil and member.mob and target.id == member.mob.id then
                    return member

                elseif target and alliance and index:sub(1,1) == "a" and tonumber(index:sub(2)) ~= nil and member.mob and target.id == member.mob.id then
                    return member

                end

            end
        
        end
        return false

    end

    self.isMember = function(player, alliance)

        if bp and player and bp.party then
            local player = bp.__target.get(player)

            for index, member in pairs(bp.party) do

                if player and index:sub(1,1) == "p" and tonumber(index:sub(2)) ~= nil and player.name:lower() == member.name:lower() then
                    return true

                elseif player and index:sub(1,1) == "a" and tonumber(index:sub(2)) ~= nil and player.name:lower() == member.name:lower() then
                    return true

                end

            end

        end
        return false

    end

    self.findMember = function(player, alliance)
        local player = bp.__target.get(player) and player.name or player
        
        if bp and bp.party and player and type(player) == 'string' then

            for member, index in T(bp.party):it() do

                if index:sub(1,1) == "p" and tonumber(index:sub(2)) ~= nil and member.name and member.name:lower():startswith(player:lower()) then
                    return member

                elseif alliance and index:sub(1,1) == "a" and tonumber(index:sub(2)) ~= nil and member.name and member.name:lower():startswith(player:lower()) then
                    return member

                end

            end
        
        end
        return false

    end

    self.isInZone = function(target)
        local member = self.getMember(target)

        if member and member.mob and member.zone == bp.info.zone then
            return true
        end
        return false

    end

    self.inRange = function(distance)
        local count, pass = (bp.party.party1_count + bp.party.party2_count or 0 + bp.party.party3_count or 0), 0

        if bp and bp.party then

            for index, member in pairs(bp.party) do
                
                if (index:sub(1,1) == "p" or index:sub(1,1) == "a") and tonumber(index:sub(2)) ~= nil and member.mob and not member.mob.is_npc then
                    
                    if bp.__distance.get(v.mob) <= distance and member.zone == bp.info.zone then
                        pass = (pass + 1)
                    end

                end

            end
            return count == pass

        end
        return 0

    end

    return self

end
return library