local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.

    -- Public Variables.
    self.buffs      = {}
    self.alliance   = {}
    self.count      = 0

    -- Private Methods.
    pm.parseParty = function(data) -- Credit: Byrth.
        local parsed = bp.packets.parse('incoming', data)
        local buffs = {}

        for i=1,5 do
            table.insert(buffs, {id=parsed[string.format('ID %s', i)], list={}})

            for ii=1,32 do
                local buff = data:byte((i-1)*48+5+16+ii-1) + 256 * (math.floor( data:byte((i-1)*48+5+8 + math.floor((ii-1)/4)) / 4^((ii-1)%4) )%4)

                if buff > 0 and buff ~= 255 then
                    table.insert(buffs[i].list, buff)
                end

            end

        end
        pm.send(buffs)
        
    end

    pm.parsePlayer = function(data)
        local parsed = bp.packets.parse('incoming', data)
        local buffs = {}

        if bp and bp.player then
            table.insert(buffs, {id=bp.player.id, list={}})

            for i=1, 32 do
                local buff = tonumber(parsed[string.format('Buffs %s', i)]) or 0
                
                if buff > 0 and buff ~= 255 then
                    table.insert(buffs[1].list, buff)
                end

            end
            pm.send(buffs)

        end

    end

    pm.send = function(buffs)
        
        if bp and bp.player and buffs and type(buffs) == 'table' then

            if #buffs > 0 then
                
                for _,v in ipairs(buffs) do
                    
                    if #v.list > 0 then
                        windower.send_ipc_message(string.format('%s+%s+%s', 'BUFFS', v.id, table.concat(v.list, ':')))
                        windower.send_command(string.format('%s+%s+%s', 'bp BUFFS', v.id, table.concat(v.list, ':')))

                    else
                        windower.send_ipc_message(string.format('%s+%s', 'BUFFS', v.id))
                        windower.send_command(string.format('%s+%s', 'bp BUFFS', v.id))

                    end

                end

            end

        end

    end

    pm.receive = function(message)

        if message then
            local split = message:split('+')
            local buffs
            
            if split[1] and split[2] and split[1] == 'BUFFS' and tonumber(split[2]) > 0 then
                local member = windower.ffxi.get_mob_by_id(tonumber(split[2])) or false

                if split[3] then
                    buffs = split[3]:split(':')

                else
                    buffs = false

                end
                
                if member and private.exists(member.id) then
                    
                    for i,v in ipairs(private.buffs) do

                        if v.id == member.id then
                            private.buffs[i] = {id=member.id, list={}}

                            if buffs and #buffs > 0 then

                                for _,vv in ipairs(buffs) do
                                    table.insert(private.buffs[i].list, tonumber(vv))
                                end
                            
                            end
                            break
                        
                        end

                    end

                elseif member and not private.exists(member.id) then
                    table.insert(private.buffs, {id=member.id, list={}})
                    
                    if buffs and #buffs > 0 then

                        for _,v in ipairs(buffs) do
                            table.insert(private.buffs[#private.buffs].list, tonumber(v))
                        end
                    
                    end

                end

            end

        end

    end

    pm.countBuffs = function()

        if bp and bp.player and bp.player.buffs then

            for i=1, 32 do
                    
                if bp.player.buffs[i] and bp.player.buffs[i] ~= 255 then
                    self.count = (self.count + 1)
                end

            end

        end

    end

    -- Public Methods.
    self.hasSpikes = function() return self.active({34,35,38,173}) end
    self.hasShadows = function() return self.active({444,445,446}) end
    self.hasWHMBoost = function() return self.active({119,120,121,122,123,124,125}) end
    self.hasStorm = function() return self.active({178,179,180,181,182,183,184,185}) end
    self.hasEnspell = function() return self.active({94,95,96,97,98,99,277,278,279,280,281,282}) end
    self.hasVorseals = function() return self.active(602) end
    self.isLvRestricted = function() return self.active(143) end
    self.hasRads = function() return bp and bp.player and bp.libs.__inventory.hasKeyItem(3031) and true or false end
    self.hasTribs = function() return bp and bp.player and bp.libs.__inventory.hasKeyItem(2894) and true or false end
    self.silent = function() return self.active(69) and self.active(71) and true or false end

    self.active = function(search)
        if not bp or not search then return false end

        if type(search) == 'table' then

            for buff in T(search):it() do

                if T(bp.player.buffs):contains(buff) then
                    return true
                end

            end
            return false

        else

            for buff in T(bp.player.buffs):it() do

                if buff == search then
                    return true
                end

            end

        end
        return false

    end

    self.hasBuff = function(pid, bid)
        if not bp or not pid or not bid then return false end

        for player in T(__buffs):it() do

            if player.id == pid and player.list and #player.list > 0 then

                for buff in T(player.list):it() do
                    
                    if buff == bid then
                        return true
                    end

                end
            
            end

        end
        return false

    end

    self.exists = function(id)

        for _,v in ipairs(private.buffs) do

            if v.id == id then
                return true
            end

        end
        return false

    end

    self.getFinishingMoves = function()

        if bp and bp.player then

            for _,v in ipairs(bp.player.buffs) do

                if v == 381 then
                    return 1
                elseif v == 382 then
                    return 2
                elseif v == 382 then
                    return 3
                elseif v == 382 then
                    return 4
                elseif v == 382 then
                    return 5
                elseif v == 588 then
                    return 6
                end

            end

        end
        return 0

    end

    -- Private Events.
    windower.register_event('ipc message', function(message)
        
        if message and message:sub(1,5) == 'BUFFS' then
            pm.receive(message)
        end
    
    end)

    windower.register_event('incoming chunk', function(id, original)

        if id == 0x076 then
            pm.parseParty(original)

        elseif id == 0x063 then
            pm.parsePlayer(original)

        end

    end)
    pm.countBuffs()

    return self

end
return library