local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __removable   = T{2,3,4,5,6,7,8,9,11,12,13,15,14,17,19,20,21,31,128,129,130,131,132,133,136,137,138,139,140,141,142,134,135,144,145,146,147,148,149,167,174,175,186,193,194,217,223,404,557,558,559,560,561,562,563,564,566,567}
    local __auras       = T{}

    -- Public Variables.
    self.removal    = T{}
    self.current    = T{}
    self.count      = 0

    -- Private Methods.
    pm.parsePlayer = function(id, original, modified)

        if bp and id and original and id == 0x063 then
            local parsed = bp.packets.parse('incoming', original)
            local buffs = T{}

            if bp and bp.player and parsed then
                table.insert(buffs, {id=bp.player.id, list={}})

                for i=1, 32 do
                    local buff = tonumber(parsed[string.format('Buffs %s', i)]) or 0
                    local time = tonumber(parsed[string.format('Time %s', i)]) or 0
                    
                    if buff > 0 and buff ~= 255 then

                        if not __auras:contains(buff) and math.ceil(1009810800 + (time / 60) + 0x100000000 / 60 * 9) - os.time() == 5 then
                            table.insert(__auras, buff)
                            windower.send_ipc_message(string.format('AURAS+ADD+%s+%s', bp.player.id, buff))

                        end
                        table.insert(buffs[1].list, buff)

                    end

                end
                pm.send(buffs)

            end

        end

    end

    pm.parseParty = function(id, original) -- Credit: Byrth.

        if bp and id and id == 0x076 then
            local parsed = bp.packets.parse('incoming', original)
            local buffs = T{}

            for i=1,5 do
                table.insert(buffs, {id=parsed[string.format('ID %s', i)], list={}})

                for ii=1,32 do
                    local buff = original:byte((i-1)*48+5+16+ii-1) + 256 * (math.floor( original:byte((i-1)*48+5+8 + math.floor((ii-1)/4)) / 4^((ii-1)%4) )%4)

                    if buff > 0 and buff ~= 255 then
                        table.insert(buffs[i].list, buff)
                    end

                end

            end
            pm.send(buffs)

        end

    end

    pm.send = function(buffs)
            
        for buff in buffs:it() do
            
            if #buff.list > 0 then
                windower.send_ipc_message(string.format('BPBUFFS+%s+%s', buff.id, table.concat(buff.list, ':')))
                windower.send_command(string.format('bp BPBUFFS+%s+%s', buff.id, table.concat(buff.list, ':')))

            else
                windower.send_ipc_message(string.format('BPBUFFS+%s', buff.id))
                windower.send_command(string.format('bp BPBUFFS+%s', buff.id))

            end

        end

    end

    pm.receive = function(command)
        local options = command and command:split('+')
        local command = options and options[1] and table.remove(options, 1) or false
        
        if command and command == 'BPBUFFS' and options[1] then
            local member = bp.__target.get(tonumber(options[1]))
            local buffs = options[2] and options[2]:split(':') or false
            
            if member and pm.exists(member.id) then

                for player, index in self.current:it() do

                    if player.id == member.id then
                        self.current[index] = {id=member.id, list={}}
                        self.removal[index] = {id=member.id, list={}}

                        for buff in T(buffs):it() do
                            
                            if __removable:contains(buff) then
                                table.insert(self.removal[index].list, tonumber(buff))

                            else
                                table.insert(self.current[index].list, tonumber(buff))

                            end

                        end
                        break
                    
                    end

                end

            elseif member and not pm.exists(member.id) then
                table.insert(self.current, {id=member.id, list={}})
                table.insert(self.removal, {id=member.id, list={}})

                for buff in T(buffs):it() do

                    if __removable:contains(buff) then
                        table.insert(self.removal[#self.removal].list, tonumber(buff))

                    else
                        table.insert(self.current[#self.current].list, tonumber(buff))
                    
                    end

                end

            end

        end

    end

    pm.exists = function(id)

        for member in self.current:it() do

            if member.id == id then
                return true
            end

        end
        return false

    end

    pm.removeAura = function(id)

        if id and __auras:contains(id) then

            for aura, index in __auras:it() do
                
                if aura == id then
                    windower.send_ipc_message(string.format('AURAS+REMOVE+%s+%s', bp.player.id, aura))
                    return table.remove(__auras, index)
                end

            end

        end
        return nil

    end

    pm.handleAuras = function(message)
        local options = message and message:split('+')
        local command = options and options[1] and table.remove(options, 1) or false

        if #options > 2 then
            local call, player, buff = options[1], bp.__target.get(tonumber(options[2])), tonumber(options[3])

            if call and player and buff then
                
                if call == 'ADD' and not __auras:contains(buff) then
                    table.insert(__auras, buff)

                elseif call == 'REMOVE' and __auras:contains(buff) then
                    pm.removeAura(buff)

                end

            end

        end

    end

    -- Public Methods.
    self.getBuffs = function() return self.current end
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
    self.hasAura = function(id) return __auras:contains(id) end

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

        for player in self.current:it() do

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

    self.getFinishingMoves = function()

        if bp and bp.player then

            for buff in T(bp.player.buffs) do

                if v == 381 then
                    return 1
                elseif v == 382 then
                    return 2
                elseif v == 383 then
                    return 3
                elseif v == 384 then
                    return 4
                elseif v == 385 then
                    return 5
                elseif v == 588 then
                    return 6
                end

            end

        end
        return 0

    end

    -- Private Events.
    --windower.register_event('time change', function() print(__auras) end)
    windower.register_event('incoming chunk', pm.parsePlayer)
    windower.register_event('incoming chunk', pm.parseParty)
    windower.register_event('lose buff', pm.removeAura)
    windower.register_event('addon command', pm.receive)
    windower.register_event('ipc message', function(message)
        
        if message and message:sub(1,7) == 'BPBUFFS' then
            pm.receive(message)

        elseif message and message:sub(1,5) == 'AURAS' then
            pm.handleAuras(message)

        end
    
    end)

    return self

end
return library