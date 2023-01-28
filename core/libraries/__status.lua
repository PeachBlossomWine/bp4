local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __spells  = T{14,15,16,17,18,19,20,143}
    local __dnc     = T{["Erase"]=T{3,4,5,6,7,8,134,135,186,13,21,146,147,148,149,167,174,175,217,223,404,557,558,559,560,561,562,563,564,11,12,128,129,130,131,132,133,136,137,138,139,140,141,142,567},["Asleep"]=T{2,19}}
    local __map     = T{

        ["Poisona"]     = T{3},
        ["Blindna"]     = T{5},
        ["Silena"]      = T{6},
        ["Stona"]       = T{7},
        ["Viruna"]      = T{8,31},
        ["Paralyna"]    = T{4,566},
        ["Charmed"]     = T{14,17},
        ["Cursna"]      = T{9,15,20},
        ["Asleep"]      = T{2,19,193},
        ["Erase"]       = T{11,12,128,129,130,131,132,133,136,137,138,139,140,141,142,567,13,21,146,147,148,149,167,174,175,194,217,223,404,557,558,559,560,561,562,563,564,134,135,186,144,145},

    }

    -- Private Methods.
    pm.handle = function(id, original)
        
        if bp and id == 0x028 and bp.core and bp.core.get('status') then
            local parsed    = bp.packets.parse('incoming', original)
            local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
            local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
            local count     = parsed['Target Count']
            local category  = parsed['Category']
            local param     = parsed['Param']

            if actor and bp.player and bp.player.id == actor.id and bp.res.spells[param] and category == 4 and __spells:contains(param) then
                local queue = bp.__queue.getQueue()

                if queue:length() > 0 then
                    local targets = T{}
                
                    for i=0, count do
                        table.insert(targets, parsed[string.format('Target %s ID', i)])
                    end

                    if targets:length() > 0 then

                        for i=queue:length(), 1, -1 do
                            local action = queue[i] and queue[i].action or false
                            local target = queue[i] and queue[i].target or false

                            if action and target and action.id == param and T{33,34}:contains(action.skill) and self.isRemoval(action.id) then
                                bp.__queue.remove(action, target)
                            end

                        end

                    end

                end

            end

        end

    end

    pm["Poisona"] = function(target)
        local target = bp.__target.get(target)

        if target and bp.__actions.canCast() and not bp.__queue.inQueue("Poisona", target) then
            bp.__queue.add("Poisona", target, bp.priorities.get("Poisona"))
        end

    end

    pm["Blindna"] = function(target)
        local target = bp.__target.get(target)

        if target and bp.__actions.canCast() and not bp.__queue.inQueue("Blindna", target) then
            bp.__queue.add("Blindna", target, bp.priorities.get("Blindna"))
        end

    end

    pm["Silena"] = function(target)
        local target = bp.__target.get(target)

        if target and bp.__actions.canCast() and not bp.__queue.inQueue("Silena", target) then
            bp.__queue.add("Silena", target, bp.priorities.get("Silena"))
        end

    end

    pm["Stona"] = function(target)
        local target = bp.__target.get(target)

        if target and bp.__actions.canCast() and not bp.__queue.inQueue("Stona", target) then
            bp.__queue.add("Stona", target, bp.priorities.get("Stona"))
        end

    end

    pm["Viruna"] = function(target)
        local target = bp.__target.get(target)

        if target and bp.__actions.canCast() and not bp.__queue.inQueue("Viruna", target) then
            bp.__queue.add("Viruna", target, bp.priorities.get("Viruna"))
        end

    end

    pm["Paralyna"] = function(target)
        local target = bp.__target.get(target)

        if target and bp.__actions.canCast() and not bp.__queue.inQueue("Paralyna", target) then
            bp.__queue.add("Paralyna", target, bp.priorities.get("Paralyna"))
        end

    end

    pm["Charmed"] = function(target)
        local target = bp.__target.get(target)

        if target and bp.__actions.canCast() and not bp.__queue.inQueue("Repose", target) and bp.__party.isMember(target, true) then
            bp.__queue.add("Repose", target, bp.priorities.get("Repose"))
        end

    end

    pm["Cursna"] = function(target)
        local target = bp.__target.get(target)

        if target and bp.__actions.canCast() and not bp.__queue.inQueue("Cursna", target) then
            bp.__queue.add("Cursna", target, bp.priorities.get("Cursna"))
        end

    end

    pm["Asleep"] = function(target)
        local target = bp.__target.get(target)

        if target and bp.__actions.canCast() then

            if bp.__party.isMember(target) and not bp.__queue.inQueue("Curaga", target) then
                bp.__queue.add("Curaga", target, bp.priorities.get("Curaga"))
                
            elseif bp.__party.isMember(target, true) and not bp.__queue.inQueue("Cure", target) then
                bp.__queue.add("Cure", target, bp.priorities.get("Cure"))

            end

        end

    end

    pm["Erase"] = function(target)
        local target = bp.__target.get(target)

        if target and bp.__actions.canCast() and not bp.__queue.inQueue("Erase", target) and bp.__party.isMember(target) then
            bp.__queue.add("Erase", target, bp.priorities.get("Erase"))
        end

    end

    -- Public Methods.
    self.isRemoval = function(id) return __spells:contains(id) end
    self.fix = function()

        if bp.__buffs.removal:length() > 0 then

            if (bp.player.main_job == 'WHM' or bp.player.sub_job == 'WHM' or (bp.player.main_job == 'SCH' and bp.__buffs.active(401)) or (bp.player.sub_job == 'SCH' and bp.__buffs.active(401))) then
                    
                for player in bp.__buffs.removal:it() do

                    for list, category in __map:it() do
                        
                        for status in list:it() do

                            if T(player.list):contains(status) and pm[category] and not bp.__auras.hasAura(status) then
                                pm[category](player.id)
                            end

                        end

                    end
    
                end

            elseif (bp.player.main_job == 'DNC' or bp.player.sub_job == 'DNC') then
                    
                for player in bp.__buffs.removal:it() do

                    for status in T(player.list):it() do
                        
                        if T{3,4,5,6,7,8,134,135,186,13,21,146,147,148,149,167,174,175,217,223,404,557,558,559,560,561,562,563,564,11,12,128,129,130,131,132,133,136,137,138,139,140,141,142,567}:contains(status) and not bp.__auras.hasAura(status) then
                            local target = bp.__target.get(player.id)

                            if target and bp.__party.isMember(target, false) and bp.__actions.isReady("Healing Waltz") and not bp.__queue.inQueue("Healing Waltz", target) then
                                bp.__queue.add("Healing Waltz", target, bp.priorities.get("Healing Waltz"))
                            end

                        elseif T{2,19}:contains(status) then
                            local target = bp.__target.get(player.id)

                            if target and bp.__party.isMember(target, false) and bp.__actions.isReady("Divine Waltz") and not bp.__queue.inQueue("Divine Waltz", target) then
                                bp.__queue.add("Divine Waltz", target, bp.priorities.get("Divine Waltz"))
                            end

                        end

                    end
    
                end
                
            end

        end

    end

    -- Private Events.
    windower.register_event('incoming chunk', pm.handle)

    return self

end
return library