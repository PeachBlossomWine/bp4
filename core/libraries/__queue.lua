local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __ready   = 0
    local __protect = 0
    local __ranges  = {false,03.40,04.47,05.76,06.89,07.80,08.40,10.40,12.40,14.50,16.40,20.40,23.40}
    local __bypass  = {}
    local __queue   = Q{}

    -- Public Variables.

    -- Private Methods.
    pm.attempt = function(prefix, action, target)
        
        if bp and bp.player and __queue and action and target and __queue[1] and __queue[1].attempts and (os.clock()-__protect) > 1 then

            if action.en == 'Ranged' then
                windower.send_command(string.format('input %s', prefix))
                __queue[1].attempts = (__queue[1].attempts + 1)
                __protect = os.clock()

            else
                windower.send_command(string.format('input %s "%s" %s', prefix, action.en, target.id))
                __queue[1].attempts = (__queue[1].attempts + 1)
                __protect = os.clock()

            end

        end

    end

    pm.push = function(action, target, priority)

        if action and target and priority then
            __queue:push({action=action, target=target, priority=priority, attempts=0})
            __queue:sort(function(a, b) return a.priority > b.priority and a.attempts == 0 and b.attempts == 0 end)

        end

    end

    -- Public Methods.
    self.updateReady    = function(action) __ready = self.getDelay(action) end
    self.getReady       = function() return __ready end
    self.getQueue       = function() return __queue end
    self.clear          = function() __queue = Q{} end

    self.isReady = function()
        
        if bp and bp.player and (os.clock()-__ready) > 0 and {[0]=0,[1]=1}[bp.player.status] then
            return true
        end
        return false

    end

    self.getRange = function(action)
        local action = type(action) == 'table' and action or bp.MA[action] or bp.JA[action] or bp.WS[action] or bp.IT[action] or false
        
        if action and action.range and __ranges[action.range] then
            return action and action.range and __ranges[action.range]
        end
        return 999

    end

    self.getDelay = function(action)
        
        if action and action.prefix then

            if S{'/jobability','/pet'}:contains(action.prefix) then
                return (os.clock() + 1.50)

            elseif S{'/magic','/ninjutsu','/song'}:contains(action.prefix) then
                return (os.clock() + 2.75)

            elseif S{'/weaponskill'}:contains(action.prefix) then
                return (os.clock() + 1.50)

            elseif S{'/ra'}:contains(action.prefix) then
                return (os.clock() + 2.50)

            elseif action.flags and action.flags:contains('Usable') then
                return (os.clock() + action.cast_delay + 1.50)

            end
            
        end
        return 2
    
    end

    self.add = function(action, target, priority, force)
        
        if bp and bp.player and action and target then
            local action = type(action) == 'table' and action or bp.MA[action] or bp.JA[action] or bp.WS[action] or bp.IT[action] or false
            local target = bp.__target.get(target)
            local vitals = bp.player['vitals']
            
            if target and action and T{0,1}:contains(bp.player.status) and not bp.__buffs.silent() then
                local range     = bp.__queue.getRange(action)
                local distance  = bp.__distance.get(target)

                -- JOB ABILITIES.
                if S{'/jobability','/pet'}:contains(action.prefix) then
                    local pet = windower.ffxi.get_mob_by_target('pet') or false

                    if action.prefix == '/jobability' and bp.__target.castable(target, action) then

                        if action.type == 'JobAbility' and (distance - target.model_size) < range then

                            if action.en == 'Pianissimo' then
                                pm.push(action, target, priority)

                            elseif bp.__actions.isReady(action.en) and not bp.__queue.inQueue(action, target) and bp.__actions.canAct() then
                                pm.push(action, target, priority)

                            end

                        elseif bp.__actions.canAct() and not bp.__queue.inQueue(action, target) then

                            if action.type == 'CorsairShot' then
                                
                                if bp.__actions.isReady(action.en) and (distance - target.model_size) < range then
                                    local index, count = bp.__inventory.findByName("Trump Card", 0)
                                
                                    if count > 0 then
                                        pm.push(action, target, priority)
                                    end

                                end

                            elseif action.type == 'CorsairRoll' then

                                if bp.__actions.isReady(action.en) and (distance - target.model_size) < range then
                                    pm.push(action, target, priority)
                                end

                            elseif action.type == 'Scholar' then
                                
                                if bp.__actions.isReady(action.en) and (distance - target.model_size) < range then
                                    pm.push(action, target, priority)
                                end

                            elseif action.type == 'Rune' then

                                if bp.__actions.isReady(action.en) and (distance - target.model_size) < range then
                                    pm.push(action, target, priority)
                                end

                            elseif action.type == 'Ward' then
                                
                                if bp.__actions.isReady(action.en) and (distance - target.model_size) < range then
                                    pm.push(action, target, priority)
                                end

                            elseif action.type == 'Effusion' then
                                
                                if bp.__actions.isReady(action.en) and (distance - target.model_size) < range then
                                    pm.push(action, target, priority)
                                end

                            elseif action.type == 'Jig' then
                                
                                if bp.__actions.isReady(action.en) and (distance - target.model_size) < range then
                                    pm.push(action, target, priority)
                                end

                            elseif S{'Samba','Waltz'}:contains(action.type) and action.tp_cost <= vitals.tp then
                                
                                if bp.__actions.isReady(action.en) and (distance - target.model_size) < range then
                                    pm.push(action, target, priority)
                                end

                            elseif S{'Flourish1','Flourish2','Flourish3'}:contains(action.type) then
                                
                                if bp.__actions.isReady(action.en) and (distance - target.model_size) < range then
                                    pm.push(action, target, priority)
                                end

                            end

                        end

                    elseif action.prefix == '/pet' then
                        
                        if action.type == 'Monster' then
                            print(action.en)

                        elseif S{'BloodPactRage','BloodPactRage'}:contains(action.type) then
                            print(action.en)

                        elseif bp.__actions.isReady(action.en) and not bp.__queue.inQueue(action, target) then
                            pm.push(action, target, priority)

                        end

                    end

                -- SPELLS.
                elseif S{'/magic','/ninjutsu','/song'}:contains(action.prefix) then

                    if action.prefix == '/magic' and (action.mp_cost and (action.mp_cost <= vitals.mp or bp.__buffs.active({47,229}))) and bp.__actions.canCast() then

                        if bp.__actions.isReady(action.en) and (distance - target.model_size) < range and not bp.__queue.inQueue(action, target) then

                            if action.en:startswith("Geo-") then
                                
                                if (not pet or bp.__bubbles.geoRecast()) then
                                    pm.push(action, target, priority)
                                end

                            elseif action.en:startswith("Indi-") then

                                if (bp.player.id == target.id and not bp.__buffs.active(612) or bp.__bubbles.indiRecast()) or (bp.player.id ~= target.id and bp.__buffs.active(584) and not bp.core.hasBuff(target.id, 612) or bp.__bubbles.indiRecast()) then
                                    pm.push(action, target, priority)
                                end

                            elseif bp.__target.castable(target, action) then

                                if action.status and bp.__party.isMember(target.id, true) and not bp.__buffs.hasBuff(target.id, action.status) then
                                    pm.push(action, target, priority)

                                else
                                    pm.push(action, target, priority)

                                end

                            end

                        end

                    elseif action.prefix == '/ninjutsu' then
                        
                        if bp.__actions.isReady(action.en) and (distance - target.model_size) < range and not bp.__queue.inQueue(action, target) then
                            pm.push(action, bp.player, priority)
                        end

                    elseif action.prefix == '/song' then
                        print(action.en)

                    elseif action.prefix == '/trust' then
                        
                        if bp.__actions.isReady(action.en) and (distance - target.model_size) < range and not bp.__queue.inQueue(action, target) then
                            pm.push(action, target, priority)
                        end

                    end

                -- WEAPON SKILLS.
                elseif S{'/weaponskill'}:contains(action.prefix) then

                    if vitals.tp >= 1000 and bp.__actions.isReady(action.en) and (distance - target.model_size) < range and not bp.__queue.typeInQueue(action) then
                        pm.push(action, target, priority)
                    end

                -- RANGED ATTACKS.
                elseif S{'/ra'}:contains(action.prefix) then
                    pm.push({id=65536, en='Ranged', element=-1, prefix='/ra', type='Ranged', range=13, cast_delay=2}, target, 1)

                -- USEABLE ITEMS.
                elseif action.flags and action.flags:contains('Usable') and bp.__actions.canItem() and not bp.__queue.inQueue(action, target) then
                    pm.push(action, target, 1)

                end

            end

        end

    end

    self.handle = function()
        
        if bp and bp.player and __queue and __queue[1] and __queue[1].action and __queue[1].target and __queue[1].priority and __queue[1].attempts and self.isReady() then
            local target    = bp.__target.get(__queue[1].target)
            local action    = __queue[1].action
            local priority  = __queue[1].priority
            local attempts  = __queue[1].attempts
            local vitals    = bp.player['vitals']
            
            if action and target and priority and attempts and (not bp.__actions.isMoving() or S{'Provoke','Flash','Stun','Chi Blast','Animated Flourish','Full Circle'}:contains(action.en)) then
                local range     = bp.__queue.getRange(action)
                local distance  = bp.__distance.get(target)

                if S{'/jobability','/pet'}:contains(action.prefix) then
                    local pet = windower.ffxi.get_mob_by_target('pet') or false

                    if action.prefix == '/jobability' then

                        if action.en == 'Pianissimo' then

                        elseif S{'Full Circle','Ecliptic Attrition','Lasting Emanation','Radial Arcana','Mending Halation'}:contains(action.en) then
                            
                            if pet and not T{2,3}:contains(pet.status) then

                                if action.en == 'Ecliptic Attrition' then
                                    
                                    if not bp.__buffs.active(513) then
                                        pm.attempt(action.prefix, action, target)

                                    else
                                        __queue:remove(1)

                                    end

                                else
                                    pm.attempt(action.prefix, action, target)

                                end

                            else
                                __queue:remove(1)

                            end

                        else

                            if attempts < 15 and (distance - target.model_size) < range and bp.__target.castable(target, action) and bp.__actions.isReady(action.en) and bp.__actions.canAct() then
                                pm.attempt(action.prefix, action, target)

                            else
                                __queue:remove(1)

                            end


                        end

                    elseif action.prefix == '/pet' then

                        if action.type == 'Monster' then

                        elseif S{'BloodPactRage','BloodPactRage'}:contains(action.type) then

                        else
                            
                            if attempts < 15 and (distance - target.model_size) < range and bp.__target.castable(target, action) then
                                pm.attempt(action.prefix, action, target)

                            else
                                __queue:remove(1)

                            end

                        end

                    end

                elseif S{'/magic','/ninjutsu','/song'}:contains(action.prefix) then

                    if action.prefix == '/magic' then

                        if attempts < 15 and (distance - target.model_size) < range and (bp.__target.castable(target, action) or action.skill == 44) and bp.__actions.canCast() then

                            if bp.__status.isRemoval(action.id) then
                                pm.attempt(action.prefix, action, target)

                            elseif T{44,34,37,39}:contains(action.skill) and action.status then
                                
                                if action.en:startswith("Geo-") then

                                    if (not pet or bp.__bubbles.geoRecast()) then
                                        pm.attempt(action.prefix, action, target)
                                        
                                    else
                                        __queue:remove(1)

                                    end

                                elseif action.en:startswith("Indi-") then

                                    if (bp.player.id == target.id and not bp.__buffs.active(612) or bp.__bubbles.indiRecast()) or (bp.player.id ~= target.id and bp.__buffs.active(584) and not bp.core.hasBuff(target.id, 612) or bp.__bubbles.indiRecast()) then
                                        pm.attempt(action.prefix, action, target)

                                    else
                                        __queue:remove(1)

                                    end

                                elseif not bp.__buffs.hasBuff(target.id, action.status) then
                                    pm.attempt(action.prefix, action, target)

                                else
                                    __queue:remove(1)

                                end

                            else
                                pm.attempt(action.prefix, action, target)

                            end

                        else
                            __queue:remove(1)

                        end

                    elseif action.prefix == '/ninjutsu' then

                        if attempts < 15 and (distance - target.model_size) < range and bp.__target.castable(target, action) and bp.__actions.canCast() then
                            pm.attempt(action.prefix, action, target)

                        else
                            __queue:remove(1)

                        end

                    elseif action.prefix == '/song' then

                    end

                elseif S{'/weaponskill'}:contains(action.prefix) then
                    
                    if vitals.tp >= 1000 and bp.__actions.isReady(action.en) and (distance - target.model_size) < range and bp.__target.castable(target, action) then
                        pm.attempt(action.prefix, action, target)

                    else
                        __queue:remove(1)

                    end

                elseif S{'/ra'}:contains(action.prefix) then

                    if bp.__actions.canAct() and (distance - target.model_size) < range then
                        pm.attempt("/ra", action, target)

                    else
                        __queue:remove(1)

                    end

                elseif action.flags and action.flags:contains('Usable') then

                    if bp.__actions.canItem() and (distance - target.model_size) < 10 and bp.__target.castable(target, action) then
                        pm.attempt("/item", action, target)

                    else
                        __queue:remove(1)

                    end

                end

            end

        end

    end

    self.update = function(action, target, update)
        local action = type(action) == 'table' and action or bp.MA[action] or bp.JA[action] or bp.WS[action] or bp.IT[action] or false
        local update = type(action) == 'table' and update or bp.MA[update] or bp.JA[update] or bp.WS[update] or bp.IT[update] or false

        if action and target and update then

        end

    end

    self.remove = function(action, target, index)
        local action = type(action) == 'table' and action or bp.MA[action] or bp.JA[action] or bp.WS[action] or bp.IT[action] or false

        if bp and action then

            if not index then
            
                if not target then

                    for act, index in __queue:it() do

                        if action.en == act.action.en then
                            self.updateReady(action)
                            return __queue:remove(index)
                        end

                    end

                elseif target then

                    for act, index in __queue:it() do
                        
                        if action.en == act.action.en and target.id == act.target.id then
                            self.updateReady(action)
                            return __queue:remove(index)
                        end

                    end

                end

            elseif index and __queue.data[index] then
                self.updateReady(__queue.data[index].action)
                return __queue:remove(index)

            end

        end

    end

    self.removeType = function(action)
        local action = type(action) == 'table' and action or bp.MA[action] or bp.JA[action] or bp.WS[action] or bp.IT[action] or false

        if bp and action and (action.prefix == '/weaponskill' or action.type) then

            for act, index in __queue:it() do

                if action.prefix == '/weaponskill' and act.action.prefix and act.action.prefix == action.prefix then
                    __queue:remove(index)

                elseif action.type and act.action.type and act.action.type == action.type then
                    __queue:remove(index)

                end

            end

        end

    end

    self.inQueue = function(action, target)
        local action = type(action) == 'table' and action or bp.MA[action] or bp.JA[action] or bp.WS[action] or bp.IT[action] or false

        if action and type(action) == 'table' and __queue:length() > 0 then

            if action and target  then

                for act in T(__queue.data):it() do

                    if act.action and act.target and act.action.id == action.id and act.action.en == action.en and act.target.id == target.id then
                        return true
                    end

                end

            elseif action and not target then

                for act in T(__queue.data):it() do

                    if act.action and act.target and act.action.id == action.id and act.action.en == action.en then
                        return true
                    end

                end

            end

        end
        return false

    end

    self.typeInQueue = function(action)
        local action = type(action) == 'table' and action or bp.MA[action] or bp.JA[action] or bp.WS[action] or bp.IT[action] or false

        if bp and action and __queue:length() > 0 and (action.type or action.prefix == '/weaponskill') then

            for act in __queue:it() do

                if action.prefix and act.action.prefix and action.prefix == '/weaponskill' and act.action.prefix == '/weaponskill' then
                    return true

                else

                    if act.action.type == action.type then
                        return true
                    end

                end

            end

        end
        return false

    end

    self.searchInQueue = function(search)

        if bp and __queue:length() > 0 then
        
            for act in __queue:it() do
                        
                if type(search) == 'string' then
                    
                    if act.action.en:lower():match(search:lower()) then
                        return true
                    end

                elseif type(search) == 'table' then

                    for check in T(search):it() do

                        if act.action.en:lower():match(check:lower()) then
                            return true
                        end

                    end

                end
                
            end

        end
        return false

    end

    -- Private Events.
    windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
    
        if bp and id == 0x028 then
            local parsed    = bp.packets.parse('incoming', original)
            local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
            local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
            
            if parsed and bp.player and actor and target and actor.id == bp.player.id then
                local count, category, param = parsed['Target Count'], parsed['Category'], parsed['Param']
    
                -- Finish Ranged Attack.
                if category == 2 then
                    self.remove({id=65536, en='Ranged', element=-1, prefix='/ra', type='Ranged', range=13, cast_time=-999})
    
                -- Finish Weaponskill.
                elseif category == 3 and bp.res.weapon_skills[param] then
                    self.remove(bp.res.weapon_skills[param], target, 1)
    
                -- Finish Spell Casting.
                elseif category == 4 and bp.res.spells[param] then
                    self.remove(bp.res.spells[param], target, 1)
    
                -- Finish using an Item.
                elseif category == 5 and bp.res.items[param] then
                    self.remove(bp.res.items[param], target, 1)
    
                -- Use Job Ability.
                elseif category == 6 then
                    self.remove(bp.res.job_abilities[param], target, 1)
    
                -- Use Weaponskill.
                elseif category == 7 then
                    self.remove(bp.res.job_abilities[param], target, 1)
    
                -- Begin Spell Casting.
                elseif category == 8 then
    
                    if param == 24931 and bp.res.spells[parsed['Target 1 Action 1 Param']] then
                        __ready = (os.clock() + bp.res.spells[parsed['Target 1 Action 1 Param']].cast_time)

                    else
                        __ready = (os.clock() + 1.50)

                    end
    
                -- Begin Item Usage.
                elseif category == 9 then
    
                    if param == 24931 and bp.res.items[parsed['Target 1 Action 1 Param']] then
                        __ready = (os.clock() + bp.res.items[parsed['Target 1 Action 1 Param']].cast_time)

                    else
                        __ready = (os.clock() + 1.50)

                    end
    
                -- NPC TP Move.
                elseif category == 11 then
    
                -- Begin Ranged Attack.
                elseif category == 12 then
                    __ready = (os.clock() + 1)
    
                -- Finish Pet Ability / Weaponskill.
                elseif category == 13 then
                    self.remove(bp.res.job_abilities[param], target, 1)
    
                -- DNC Abilities
                elseif category == 14 then
                    self.remove(bp.res.job_abilities[param], target, 1)
    
                -- RUN Abilities
                elseif category == 15 then
                    self.remove(bp.res.job_abilities[param], target, 1)
    
                end
    
            end
    
        end
        
    end)

    windower.register_event('status change', function(new, old)

        if T{2,3,4,5,33,38,39,40,41,42,43,44,47,48,51,52,53,54,55,56,57,58,59,60,61,85}:contains(new) then
            self.clear()

        elseif new == 0 and old == 1 then
            self.clear()

        end

    end)

    windower.register_event('zone change', function()
        __ready = (os.clock() + 12)
        self.clear()
    
    end)

    return self

end
return library