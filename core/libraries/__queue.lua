local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __ready   = 0
    local __protect = 0
    local __ranges  = {255,false,03.40,04.47,05.76,06.89,07.80,08.40,10.40,12.40,14.50,16.40,20.40,23.40}
    local __bypass  = {}
    local __queue   = Q{}

    -- Public Variables.

    -- Private Methods.
    pm.attempt = function(prefix, action, target)

        if bp and bp.player and __queue and action and target and __queue[1] and __queue[1].attempts then
            windower.send_command(string.format("input %s '%s' %s", prefix, action.en, target.id))
            --bp.helpers.coms.send(action, bp.player.name, __queue[1].attempts)
            __queue[1].attempts = (__queue[1].attempts + 1)

        else
            self.clear()

        end
        __protect = os.clock()

    end

    pm.handle = function()
        local __d = bp.libs.__distance
        local __a = bp.libs.__actions
        local __t = bp.libs.__target
        local __q = bp.libs.__queue
        local __b = bp.libs.__buffs

        if bp and bp.player and __queue and __queue[1].action and __queue[1].target and __queue[1].priority and __queue[1].attempts and __queue:length() > 0 and self.isReady() and (os.clock()-__protect) > 0.75 then
            local target    = __t.get(__queue[1].target)
            local action    = __queue[1].action
            local priority  = __queue[1].priority
            local attempts  = __queue[1].attempts
            
            if action and target and priority and attempts and (not __a.isMoving() or S{'Provoke','Flash','Stun','Chi Blast'}:contains(action.en)) then
                local range     = __q.getRange(action)
                local distance  = __d.get(target)

                if S{'/jobability','/pet'}:contains(action.prefix) then
                    local pet = windower.ffxi.get_mob_by_target('pet') or false

                elseif S{'/magic','/ninjutsu','/song'}:contains(action.prefix) then

                elseif S{'/weaponskill'}:contains(action.prefix) then

                elseif S{'/ra'}:contains(action.prefix) then

                elseif action.flags and action.flags:contains('Usable') then

                end

            end

        end

    end

    -- Public Methods.
    self.getDelay       = function(action) return (os.clock() + (action and action.cast_time or 1)) end
    self.getRange       = function(action) return action and action.range and __ranges[action.range] or 0 end
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

    self.add = function(action, target, priority)
        local __d = bp.libs.__distance
        local __a = bp.libs.__actions
        local __t = bp.libs.__target
        local __p = bp.libs.__party
        local __q = bp.libs.__queue
        local __b = bp.libs.__buffs
        
        if bp and bp.player and action and target then
            local target = __t.get(target)
            
            if target and T{0,1}:contains(bp.player.status) and not __b.silent() and (not __a.isMoving() or S{'Provoke','Flash','Stun','Chi Blast'}:contains(action.en)) then
                local range     = __q.getRange(action) + (target.model_size)
                local distance  = __d.get(target)

                if S{'/jobability','/pet'}:contains(action.prefix) then
                    local pet = windower.ffxi.get_mob_by_target('pet') or false

                elseif S{'/magic','/ninjutsu','/song'}:contains(action.prefix) then

                elseif S{'/weaponskill'}:contains(action.prefix) then

                elseif S{'/ra'}:contains(action.prefix) then

                elseif action.flags and action.flags:contains('Usable') then

                end

            end
            table.sort(__queue.data, function(a, b) return a.priority > b.priority end)

        end

    end

    self.force = function(action, target, priority)

    end

    self.remove = function(action)
        local cures = T{1,2,3,4,5,6,7,8,9,10,11,549,645,578,593,711,581,690}
        local waltz = T{190,191,192,193,311,195,262}

        if bp and action then
            self.updateReady(bp.res.weapon_skills[param])

            for index, act in ipairs(queue.data) do

                if (cures):contains(action.id) and (cures):contains(act.action.id) and action.prefix == '/magic' then
                    return queue:remove(index)

                elseif (waltz):contains(action.id) and (waltz):contains(act.action.id) and action.prefix == '/jobability' then
                    return queue:remove(index)

                elseif act.action.id == action.id and action.en ~= 'Pianissimo' then --???

                    if v.action.type == 'Weapon' then
                        return queue:remove(index)

                    elseif v.action.type == action.type and v.action.en == action.en then
                        return queue:remove(index)

                    end

                elseif action.en == 'Pianissimo' then
                    return queue:remove(index)

                end

            end

        end

    end

    self.inQueue = function(action, target)

        if action and target and __queue.data then

            for act in T(__queue.data):it() do

                if act.action and act.target and act.action.id == action.id and act.action.en == action.en and act.target.id == target.id then
                    return true
                end

            end

        elseif action and not target and __queue.data then

            for act in T(__queue.data):it() do

                if act.action and act.target and act.action.id == action.id and act.action.en == action.en then
                    return true
                end

            end

        end
        return false

    end

    self.typeInQueue = function(action)

        if bp and action and __queue.data and action.type then

            for act in __queue.data:it() do

                if act.action.type == action.type then
                    return true
                end

            end

        end
        return false

    end

    self.replace = function(action, target, name)
        --[[
        if bp and action and target and name then
            local helpers       = bp.helpers
            local action_type   = helpers['queue'].getType(action)
            local data          = __queue.data

            if data and name ~= '' then

                if #data > 0 then

                    for i,v in ipairs(data) do

                        if type(v) == 'table' and type(action) == 'table' and type(target) == 'table' and v.action and v.target then
                            local player = bp.player

                            if v.target.id == target.id and (name):match(v.action.en) and v.action.id ~= action.id then

                                -- Convert to self target.
                                if player and helpers['target'].onlySelf(action) and target.id ~= player.id then
                                    target = windower.ffxi.get_mob_by_target('me')
                                end

                                if action_type == 'JobAbility' then
                                    __queue.data[i] = {action=action, target=target, priority=0, attempts=1}
                                    break

                                elseif action_type == 'Magic' then
                                    __queue.data[i] = {action=action, target=target, priority=0, attempts=1}
                                    break

                                elseif action_type == 'WeaponSkill' then
                                    __queue.data[i] = {action=action, target=target, priority=0, attempts=1}
                                    break

                                end

                            elseif v.target.id == target.id and not (name):match(v.action.en) and v.action.id ~= action.id then

                                -- Convert to self target.
                                if player and helpers['target'].onlySelf(action) and target.id ~= player.id then
                                    target = windower.ffxi.get_mob_by_target('me')
                                end
                                helpers['queue'].add(action, target)
                                break

                            end

                        end

                    end

                end

            end

        end
        return false
        ]]

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
                    self.remove(bp.res.weapon_skills[param])
    
                -- Finish Spell Casting.
                elseif category == 4 and bp.res.spells[param] then
                    self.remove(spell)
    
                -- Finish using an Item.
                elseif category == 5 and bp.res.items[param] then
                    self.remove(bp.res.items[param])
    
                -- Use Job Ability.
                elseif category == 6 then
                    self.remove(bp.res.job_abilities[param])
    
                -- Use Weaponskill.
                elseif category == 7 then
                    self.remove(bp.res.job_abilities[param])
    
                -- Begin Spell Casting.
                elseif category == 8 then
    
                    if param == 24931 and bp.res.spells[parsed['Target 1 Action 1 Param']] then
                        self.ready = self.getDelay(bp.res.spells[parsed['Target 1 Action 1 Param']])

                    else
                        self.ready = self.getDelay()

                    end
    
                -- Begin Item Usage.
                elseif category == 9 then
    
                    if param == 24931 and bp.res.items[parsed['Target 1 Action 1 Param']] then
                        self.ready = self.getDelay(bp.res.items[parsed['Target 1 Action 1 Param']])

                    else
                        self.ready = self.getDelay()

                    end
    
                -- NPC TP Move.
                elseif category == 11 then
    
                -- Begin Ranged Attack.
                elseif category == 12 then
                    self.ready = (os.clock() + 1)
    
                -- Finish Pet Ability / Weaponskill.
                elseif category == 13 then
                    self.remove(bp.res.job_abilities[param])
    
                -- DNC Abilities
                elseif category == 14 then
                    self.remove(bp.res.job_abilities[param])
    
                -- RUN Abilities
                elseif category == 15 then
                    self.remove(bp.res.job_abilities[param])
    
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

    return self

end
return library