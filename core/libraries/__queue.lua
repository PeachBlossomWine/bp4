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
    local __tools   = {
        
        ["Monomi"]      = {cast={"Shikanofuda","Sanjaku-Tenugui"}, toolbags={"Toolbag (Shika)","Toolbag (Sanja)"}},
        ["Aisha"]       = {cast={"Chonofuda","Soshi"}, toolbags={"Toolbag (Cho)","Toolbag (Soshi)"}},
        ["Katon"]       = {cast={"Inoshishinofuda","Uchitake"}, toolbags={"Toolbag (Ino)","Toolbag (Uchi)"}},
        ["Hyoton"]      = {cast={"Inoshishinofuda","Tsurara"}, toolbags={"Toolbag (Ino)","Toolbag (Tsura)"}},
        ["Huton"]       = {cast={"Inoshishinofuda","Kawahori-Ogi"}, toolbags={"Toolbag (Ino)","Toolbag (Kawa)"}},
        ["Doton"]       = {cast={"Inoshishinofuda","Makibishi"}, toolbags={"Toolbag (Ino)","Toolbag (Maki)"}},
        ["Raiton"]      = {cast={"Inoshishinofuda","Hiraishin"}, toolbags={"Toolbag (Ino)","Toolbag (Hira)"}},
        ["Suiton"]      = {cast={"Inoshishinofuda","Mizu-Deppo"}, toolbags={"Toolbag (Ino)","Toolbag (Mizu)"}},
        ["Utsusemi"]    = {cast={"Shikanofuda","Shihei"}, toolbags={"Toolbag (Shika)","Toolbag (Shihe)"}},
        ["Jubaku"]      = {cast={"Chonofuda","Jusatsu"}, toolbags={"Toolbag (Cho)","Toolbag (Jusa)"}},
        ["Hojo"]        = {cast={"Chonofuda","Kaginawa"}, toolbags={"Toolbag (Cho)","Toolbag (Kagi)"}},
        ["Kurayami"]    = {cast={"Chonofuda","Sairui-Ran"}, toolbags={"Toolbag (Cho)","Toolbag (Sai)"}},
        ["Dokumori"]    = {cast={"Chonofuda","Kodoku"}, toolbags={"Toolbag (Cho)","Toolbag (Kodo)"}},
        ["Tonko"]       = {cast={"Shikanofuda","Shinobi-Tabi"}, toolbags={"Toolbag (Shika)","Toolbag (Shino)"}},
        ["Gekka"]       = {cast={"Shikanofuda","Ranka"}, toolbags={"Toolbag (Shika)","Toolbag (Ranka)"}},
        ["Yain"]        = {cast={"Shikanofuda","Furusumi"}, toolbags={"Toolbag (Shika)","Toolbag (Furu)"}},
        ["Myoshu"]      = {cast={"Shikanofuda","Kabenro"}, toolbags={"Toolbag (Shika)","Toolbag (Kaben)"}},
        ["Yurin"]       = {cast={"Chonofuda","Jinko"}, toolbags={"Toolbag (Cho)","Toolbag (Jinko)"}},
        ["Kakka"]       = {cast={"Shikanofuda","Ryuno"}, toolbags={"Toolbag (Shika)","Toolbag (Ryuno)"}},
        ["Migawari"]    = {cast={"Shikanofuda","Mokujin"}, toolbags={"Toolbag (Shika)","Toolbag (Moku)"}},
    
    }

    -- Public Variables.

    -- Private Methods.
    pm.attempt = function(prefix, action, target)
        
        if bp and bp.player and __queue and action and target and __queue[1] and __queue[1].attempts then
            windower.send_command(string.format("input %s '%s' %s", prefix, action.en, target.id))
            __queue[1].attempts = (__queue[1].attempts + 1)

        end
        __protect = os.clock()

    end

    pm.push = function(action, target, priority)

        if action and target and priority then
            __queue:push({action=action, target=target, priority=priority, attempts=1})
            __queue:sort(function(a, b) return a.priority > b.priority end)

        end

    end

    -- Public Methods.
    self.getDelay       = function(action) return (os.clock() + (action and action.cast_time and action.cast_time >= 3 and action.cast_time or 3)) end
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

    self.add = function(action, target, priority, force)
        
        if bp and bp.player and action and target then
            local action = type(action) == 'table' and action or bp.MA[action] or bp.JA[action] or bp.WS[action] or bp.IT[action] or false
            local target = bp.__target.get(target)
            local vitals = bp.player['vitals']
            
            if target and T{0,1}:contains(bp.player.status) and not bp.__buffs.silent() then
                local range     = bp.__queue.getRange(action)
                local distance  = bp.__distance.get(target)

                -- JOB ABILITIES.
                if S{'/jobability','/pet'}:contains(action.prefix) then
                    local pet = windower.ffxi.get_mob_by_target('pet') or false

                    if action.prefix == '/jobability' and bp.__target.castable(target, action) then

                        if action.type == 'JobAbility' and (distance - target.model_size) < range then

                            if action.en == 'Pianissimo' then
                                pm.push(action, target, priority)

                            elseif bp.__actions.isReady(action.en) and bp.__actions.canAct() and not bp.__queue.inQueue(action, target) then
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

                        end

                    end

                -- SPELLS.
                elseif S{'/magic','/ninjutsu','/song'}:contains(action.prefix) then

                    if action.prefix == '/magic' and (action.mp_cost and (action.mp_cost <= vitals.mp or bp.__buffs.active(47) or bp.__buffs.active(229))) and bp.__actions.canCast() then

                        if bp.__actions.isReady(action.en) and (distance - target.model_size) < range and not bp.__queue.inQueue(action, target) then

                            if bp.__target.castable(target, action) then
                                
                                if action.status and not bp.__buffs.hasBuff(target.id, action.status) then
                                    pm.push(action, target, priority)

                                else
                                    pm.push(action, target, priority)

                                end

                            else

                                if action.en:startswith("Indi-") and not bp.__target.castable(target, action) and (bp.__buffs.active(584) or bp.__queue.inQueue("Entrust", bp.player)) then
                                    pm.push(action, target, priority)
                                end

                            end

                        end

                    elseif action.prefix == '/ninjutsu' then
                        
                        if bp.__actions.isReady(action.en) and (distance - target.model_size) < range and not bp.__queue.inQueue(action, target) then
                            local tools = __tools[action.en:sub(1, 4)]

                            if tools then
                                local index, count = bp.__inventory.findByName(tools.cast, 0)

                                if count > 0 then
                                    pm.push(action, target, priority)

                                elseif count == 0 and bp.core.get('items') then
                                    local index, count, id = bp.__inventory.findByName(tools.toolbags, 0)

                                    if count > 0 and bp.res.items[id] and not bp.__queue.inQueue(bp.res.items[id].en, bp.player) then
                                        pm.push(bp.res.items[id], bp.player, bp.priorities.get(bp.res.items[id].en))
                                    end

                                end

                            end

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

                    if vitals.tp >= 1000 and bp.__actions.isReady(action.en) and (distance - target.model_size) < range and not bp.__queue.inQueue(action, target) then
                        pm.push(action, target, priority)
                    end

                -- RANGED ATTACKS.
                elseif S{'/ra'}:contains(action.prefix) then

                -- USEABLE ITEMS.
                elseif action.flags and action.flags:contains('Usable') and bp.__actions.canItem() and not bp.__queue.inQueue(action, target) then
                    pm.push(action, target, 1)

                end

            end

        end

    end

    self.handle = function()
        
        if bp and bp.player and __queue and __queue[1] and __queue[1].action and __queue[1].target and __queue[1].priority and __queue[1].attempts and self.isReady() and (os.clock()-__protect) > 0.75 then
            local target    = bp.__target.get(__queue[1].target)
            local action    = __queue[1].action
            local priority  = __queue[1].priority
            local attempts  = __queue[1].attempts
            local vitals    = bp.player['vitals']
            
            if action and target and priority and attempts and (not bp.__actions.isMoving() or S{'Provoke','Flash','Stun','Chi Blast','Animated Flourish'}:contains(action.en)) then
                local range     = bp.__queue.getRange(action)
                local distance  = bp.__distance.get(target)

                if S{'/jobability','/pet'}:contains(action.prefix) then
                    local pet = windower.ffxi.get_mob_by_target('pet') or false

                    if action.prefix == '/jobability' then

                        if action.en == 'Pianissimo' then

                        elseif action.en == 'Double-Up' then

                        else

                            if attempts < 15 and (distance - target.model_size) < range and bp.__target.castable(target, action) then
                                pm.attempt(action.prefix, action, target)

                            else
                                self.remove(action)

                            end


                        end

                    elseif action.prefix == '/pet' then

                    end

                elseif S{'/magic','/ninjutsu','/song'}:contains(action.prefix) then

                    if action.prefix == '/magic' then

                        if attempts < 15 and (distance - target.model_size) < range and bp.__target.castable(target, action) then
                            pm.attempt(action.prefix, action, target)

                        else
                            self.remove(action)

                        end

                    elseif action.prefix == '/ninjutsu' then

                    elseif action.prefix == '/song' then

                    end

                elseif S{'/weaponskill'}:contains(action.prefix) then

                    if vitals.tp >= 1000 and bp.__actions.isReady(action.en) and (distance - target.model_size) < range and bp.__target.castable(target, action) then
                        pm.attempt(action.prefix, action, target)

                    else
                        self.remove(action)

                    end

                elseif S{'/ra'}:contains(action.prefix) then

                elseif action.flags and action.flags:contains('Usable') then

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

    self.inQueue = function(action, target)
        local action = type(action) == 'table' and action or bp.MA[action] or bp.JA[action] or bp.WS[action] or bp.IT[action] or false

        if action and type(action) == 'table' and __queue.data then

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
                        __ready = self.getDelay(bp.res.spells[parsed['Target 1 Action 1 Param']])

                    else
                        __ready = self.getDelay()

                    end
    
                -- Begin Item Usage.
                elseif category == 9 then
    
                    if param == 24931 and bp.res.items[parsed['Target 1 Action 1 Param']] then
                        __ready = self.getDelay(bp.res.items[parsed['Target 1 Action 1 Param']])

                    else
                        __ready = self.getDelay()

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

    return self

end
return library