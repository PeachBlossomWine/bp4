local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __timers      = {perform={}}
    local __anchor      = {__set=false, __midcast=false, __position={x=0, y=0, z=0}}
    local __unique      = {ranged = {id=65536,en='Ranged',element=-1,prefix='/ra',type='Ranged', range=13}}
    local __death       = {last=0, delay=10}
    local __ftimer      = {last=0, delay=1}
    local __dtimer      = {last=0, delay=0.25}
    local __position    = {x=0, y=0, z=0}
    local __moving      = false
    local __act_protect = {[0]=T{0},[2]=T{0},[3]=T{0,1},[4]=T{1},[5]=T{0,1},[7]=T{1},[9]=T{0,1},[11]=T{2,3},[12]=T{0,2},[13]=T{2,3},[14]=T{0},[15]=T{1},[16]=T{1},[18]=T{85},[19]=T{2,3},[26]=T{0}}
    local __actions     = {

        ['interact']    = 0,    ['engage']          = 2,    ['/magic']          = 3,    ['magic']           = 3,    ['/mount'] = 26,
        ['disengage']   = 4,    ['/help']           = 5,    ['help']            = 5,    ['/weaponskill']    = 7,
        ['weaponskill'] = 7,    ['/jobability']     = 9,    ['jobability']      = 9,    ['return']          = 11,
        ['/assist']     = 12,   ['assist']          = 12,   ['accept raise']    = 13,   ['/fish']           = 14,
        ['fish']        = 14,   ['switch target']   = 15,   ['/range']          = 16,   ['range']           = 16,
        ['/dismount']   = 18,   ['dismount']        = 18,   ['zone']            = 20,   ['accept tractor']  = 19,
        ['mount']       = 26,

    }

    -- Public Variables.
    self.distance   = false
    self.facing     = false
    self.castlock   = true
    self.knockback  = true

    -- Private Methods.
    pm.updatePosition = function()

        if bp.me then
            __moving        = (bp.me.x ~= __position.x or bp.me.y ~= __position.y) and true or false
            __position.x    = bp.me.x
            __position.y    = bp.me.y
            __position.z    = bp.me.z

        else
            __moving        = true
            __position.x    = 0
            __position.y    = 0
            __position.z    = 0

        end

    end

    pm.updateDistance = function()

        if bp and self.distance and bp.player.status == 1 then
            local target = bp.__target.get('t')

            if target and bp.me and (os.clock()-__dtimer.last) > __dtimer.delay then
                local distance  = bp.__distance.get(target)
                local dmaximum   = ((2.4 + target.model_size) - bp.me.model_size)

                if distance > dmaximum then
                    self.move(target.x, target.y)

                elseif distance <= (dmaximum - 2) then
                    self.stop()
                    windower.send_command("setkey numpad2 down; wait 0.2; setkey numpad2 up")

                end
                __dtimer.last = os.clock()
                
            end

        end

    end

    pm.updateFacing = function()

        pm.updatePosition()
        pm.updateDistance()
        if bp and self.facing and bp.player.status == 1 then
            local target = bp.__target.get('t')
        
            if target and (os.clock()-__ftimer.last) > __ftimer.delay then
                bp.__actions.face(bp.__target.get(target))
                __ftimer.last = os.clock()
                
            end
            
        end

    end

    pm.block = function(_, act)
        if act.category ~= 11 or not self.knockback then
            return
        end

        for x = 1, act.target_count do

            for n = 1, act.targets[x].action_count do
                act.targets[x].actions[n].stagger = 0
                act.targets[x].actions[n].knockback = 0

            end

        end
        return act

    end
    ActionPacket.open_listener(pm.block)

    -- Public Functions.
    self.isMoving = function() return __moving end
    self.enterZone = function(zone) self.move:schedule(0.75, zone.x, zone.y) end
    
    self.move = function(x, y)
            
        if bp and bp.me and x and y then
            windower.ffxi.turn(-math.atan2(y-bp.me.y, x-bp.me.x))
            windower.ffxi.run(-math.atan2(y-bp.me.y, x-bp.me.x))
            
        end
        
    end
    
    self.perform = function(target, action, param, x, y, z)
        local target = bp.__target.get(target)

        if not __timers.perform.last or ((os.time()-__timers.perform.last) >= 1) then

            if target and action and __actions[action] and not windower.ffxi.get_info().mog_house and (os.clock()-__death.last) >= __death.delay then

                if __act_protect[__actions[action]] and __act_protect[__actions[action]]:contains(bp.player.status) then
                    __timers.perform.last = os.time()
                    bp.packets.inject(bp.packets.new('outgoing', 0x01A, {
                        ['Target Index']    = target.index,
                        ['Category']        = __actions[action],
                        ['Target']          = target.id,
                        ['Param']           = param or 0,
                        ['X Offset']        = x or 0,
                        ['Y Offset']        = y or 0,
                        ['Z Offset']        = z or 0,

                    }))

                end

            end

        end

    end

    self.trade = function(target, ...)
        local target = bp.__target.get(target)
        local total = T{...}:length()
        local items = T{...}
        
        if bp and target and total > 0 then
            local block = T{}
            local trade = bp.packets.new('outgoing', 0x036, {
                
                ['Target']          = target.id,
                ['Target Index']    = target.index,
                ['Number of Items'] = total,

            })

            for i=1, total do

                if items[i].name and items[i].count then
            
                    for item, index in T(windower.ffxi.get_items(0)):it() do

                        if item and index and item.id and bp.res.items[item.id] and bp.res.items[item.id].en == items[i].name then

                            if items[i].count <= item.count and not block:contains(index) then
                                trade[string.format('Item Index %s', i)] = index
                                trade[string.format('Item Count %s', i)] = items[i].count
                                table.insert(block, index)
                                break

                            else
                                trade[string.format('Item Index %s', i)] = 0
                                trade[string.format('Item Count %s', i)] = 0

                            end

                        else
                            trade[string.format('Item Index %s', i)] = 0
                            trade[string.format('Item Count %s', i)] = 0

                        end

                    end

                else
                    trade[string.format('Item Index %s', i)] = 0
                    trade[string.format('Item Count %s', i)] = 0

                end

            end
            bp.packets.inject(trade)

        end
        return false

    end

    self.tradeGil = function(target, amount)
        local target = bp.__target.get(target)
        local amount = tonumber(amount)

        if bp and target and amount and target.id and target.index and amount ~= nil and amount <= windower.ffxi.get_items().gil then
            bp.packets.inject(bp.packets.new('outgoing', 0x036, {                    
                ['Target']          = target.id,
                ['Target Index']    = target.index,
                ['Number of Items'] = 1,
                ['Item Index 1']    = 0,
                ['Item Count 1']    = amount,

            }))

        end
        return false

    end

    self.useItem = function(item, target, bag)
        local target = bp.__target.get(target)

        if item and target and type(item) == 'string' then
            local bag, index, id = bp.__inventory.findItem(item)

            if index and bag then
                bp.packets.inject(bp.packets.new('outgoing', 0x037, {
                    ['Player']          = target.id,
                    ['Player Index']    = target.index,
                    ['Slot']            = index,
                    ['Bag']             = bag,

                }))

            end

        elseif item and target and bag and tonumber(item) ~= nil and tonumber(bag) ~= nil then
            local index, count, id, status, bag = bp.__inventory.getByIndex(tonumber(bag), tonumber(item))

            if index and bag then
                bp.packets.inject(bp.packets.new('outgoing', 0x037, {
                    ['Player']          = target.id,
                    ['Player Index']    = target.index,
                    ['Slot']            = index,
                    ['Bag']             = bag,

                }))

            end

        end

    end

    self.equipItem = function(item, slot, bag)

        if item and slot and type(item) == 'string' and bp.res.slots[slot] then
            local bag, index = bp.__inventory.findItem(item)

            if index and bag then
                bp.packets.inject(bp.packets.new('outgoing', 0x050, {
                    ['Item Index'] = index,
                    ['Equip Slot'] = slot,
                    ['Bag'] = bag,

                }))

            end

        elseif item and slot and bag and tonumber(item) ~= nil and bp.res.slots[slot] and bp.res.bags[bag] then
            local index, count, id, status, bag = bp.__inventory.getByIndex(tonumber(bag), tonumber(item))
            
            if index and bag then
                bp.packets.inject(bp.packets.new('outgoing', 0x050, {
                    ['Item Index'] = index,
                    ['Equip Slot'] = slot,
                    ['Bag'] = bag,

                }))

            end

        end

    end

    self.synthItem = function(crystal, ingredients, materials)
        --[[
        local crystal       = bp.helpers['inventory'].findItemByName(crystal) or false
        local materials     = T(materials) or false
        local ingredients   = ingredients or 1
        
        if bp and crystal and materials then
            local crystal   = {name=crystal.en, id=crystal.id, index=bp.helpers['inventory'].findItemIndexByName(crystal.en)}
            local n         = 1
            
            -- Build Basic Packet.
            local synth = bp.packets.new("outgoing", 0x096, {
                
                ['_unknown1']           = 0,
                ['_unknown2']           = 0,
                ['Crystal']             = crystal.id,
                ['Crystal Index']       = crystal.index,
                ['Ingredient count']    = ingredients,

            })

            -- Rebuild the packet based on material data.
            for _,material in ipairs(materials) do
                
                if material and material.count then
                    local item  = bp.helpers['inventory'].findItemIndexByName(material.name, 0, material.count) or false
                    local count = bp.helpers['inventory'].getCountByIndex(item)
                    
                    if count and count >= material.count then

                        for ii=1, material.count do
                            synth[string.format('Ingredient %s', n)] = select(3, bp.helpers['inventory'].findItemByIndex(item))
                            synth[string.format('Ingredient Index %s', n)] = item
                            n = n + 1

                        end

                    else
                        return false

                    end

                else
                    synth[string.format('Ingredient %s', n)] = 0
                    synth[string.format('Ingredient Index %s', n)] = 0

                end

            end

            -- Build _unknown1 packet data.
            local c  = ((crystal.id % 6506) % 4238) % 4096
            local m  = (c + 1) * 6 + 77
            local b  = (c + 1) * 42 + 31
            local m2 = (8 * c + 26) + (synth['Ingredient 1'] - 1) * (c + 35)
            synth['_unknown1'] = ((m * synth['Ingredient 1'] + b + m2 * (ingredients - 1)) % 127)
            
            if (n-1) == ingredients then
                bp.packets.inject(synth)
            end

        end
        ]]

    end

    self.turn = function(x, y)

        if bp and bp.me and x and y then
            windower.ffxi.turn(-math.atan2(y-bp.me.y, x-bp.me.x))
        end

    end

    self.face = function(coords)

        if bp and bp.me and coords and coords.x and coords.y then
            windower.ffxi.turn(((math.atan2((coords.y - bp.me.y), (coords.x - bp.me.x))*180/math.pi)*-1):radian())
        end

    end

    self.aboutFace = function()
        windower.ffxi.turn(((bp.me.facing*-1)+math.pi)*-1)
    end

    self.toRadians = function(pos)

        if bp and pos and bp.me and pos.x and pos.y then
            return ((math.atan2((pos.y - bp.me.y), (pos.x - bp.me.x))*180/math.pi)*-1):radian()
        end
        return 0

    end

    self.getFacing = function(target)
        local target = bp.__target.get(target)

        if bp and target then
            return target.facing % math.tau

        elseif bp and bp.me and not target then
            return bp.me.facing % math.tau

        end
        
    end

    self.getRotation = function()

        if bp and bp.me then
            return (((self.getFacing()*180)/math.pi)*256/360)
        end
        return 0

    end

    self.convertRotation = function(rot)
        if not rot then return end
        local rotation = rot

        if bp and bp.me then
            return ((bit.band(rot, 0xff) * math.tau) * 0.00390625)
        end
        return 0

    end

    self.keyCombo = function(combo, delay, wait)
        local wait = tonumber(wait) ~= nil and tonumber(wait) or 0

        if combo and type(combo) == 'table' then
            coroutine.schedule(function()

                for i,v in ipairs(combo) do
                    coroutine.schedule(function()
                        windower.send_command(string.format('setkey %s down; wait 0.2; setkey %s up', v, v))

                    end, (i * (delay or 0.3)))

                end

            end, wait or 0)

        end

    end

    self.canCast = function()

        if bp and bp.player and {[0]=0,[1]=1}[bp.player.status] and not __moving then
            local bad = T{[0]=0,[2]=2,[6]=6,[7]=7,[10]=10,[14]=14,[17]=17,[19]=19,[22]=22,[28]=28,[29]=29,[193]=193,[252]=252,[262]=262}

            for buff in T(bp.player.buffs):it() do

                if bad[buff] then
                    return false
                end

            end

        end
        return true
    
    end

    self.canAct = function()

        if bp and bp.player and {[0]=0,[1]=1}[bp.player.status] then
            local bad = T{[0]=0,[2]=2,[7]=7,[10]=10,[14]=14,[16]=16,[17]=17,[19]=19,[22]=22,[193]=193,[252]=252,[261]=261}

            for buff in T(bp.player.buffs):it() do

                if bad[buff] then
                    return false
                end

            end

        end
        return true

    end

    self.canItem = function()

        if bp and bp.player and {[0]=0,[1]=1}[bp.player.status] and not __moving then
            local bad = T{[473]=473,[252]=252}

            for buff in T(bp.player.buffs):it() do

                if bad[buff] then
                    return false
                end

            end

        end
        return true

    end

    self.canMove = function()

        if bp and bp.player and {[0]=0,[1]=1,[10]=10,[11]=11,[85]=85}[bp.player.status] then
            local bad = T{[0]=0,[2]=2,[7]=7,[11]=11,[14]=14,[17]=17,[19]=19,[193]=193}

            for buff in T(bp.player.buffs):it() do

                if bad[buff] then
                    return false
                end

            end

        end
        return true

    end

    self.isReady = function(action)

        if bp and bp.player then
            local action = type(action) == 'table' and action or bp.MA[action] or bp.JA[action] or bp.WS[action] or bp.IT[action] or false

            if action and S{'/jobability','/pet'}:contains(action.prefix) then
                local skills = windower.ffxi.get_abilities().job_abilities
                local recast = windower.ffxi.get_ability_recasts()

                if skills then

                    for _,v in ipairs(skills) do

                        if v == action.id then

                            if recast[action.recast_id] and recast[action.recast_id] < 1 then
                                return true
                            end

                        end

                    end

                end

            elseif action and S{'/magic','/ninjutsu','/song'}:contains(action.prefix) then
                local spells    = windower.ffxi.get_spells()
                local recast    = windower.ffxi.get_spell_recasts()
                local jpoints   = bp.player['job_points'][bp.player.main_job:lower()].jp_spent
                local job       = {main = {id=bp.player.main_job_id, level=bp.player.main_job_level}, sub = {id=bp.player.sub_job_id, level=bp.player.sub_job_level}}

                if spells and spells[action.id] and recast[action.recast_id] and recast[action.recast_id] < 1 then
                    local main  = action.levels[job.main.id] or false
                    local sub   = action.levels[job.sub.id] or false

                    if main then

                        if main < 100 and job.main.level >= main then
                            return true

                        elseif main >= 100 and jpoints >= main then
                            return true
                        end

                    elseif sub then

                        if sub < 100 and job.sub.level >= sub then
                            return true
                        end

                    end

                end

            elseif action and S{'/weaponskill'}:contains(action.prefix) then
                local skills = windower.ffxi.get_abilities().weapon_skills

                if bp.player['vitals'].tp > 999 then

                    for skill in T(skills):it() do

                        if action.id == skill then
                            return true
                        end

                    end

                end

            end

        end
        return false

    end

    self.isAvailable = function(name)

        if bp and bp.player and name then

            if bp.JA[name] then

                for id in T(windower.ffxi.get_abilities().job_abilities):it() do

                    if id == bp.JA[name].id then
                        return true
                    end

                end

            elseif bp.MA[name] then

                if windower.ffxi.get_spells()[bp.MA[name].id] then
                    return true
                end

            elseif bp.WS[name] then

                for id in T(windower.ffxi.get_abilities().weapon_skills):it() do
                    
                    if id == bp.WS[name].id then
                        return true
                    end

                end

            end

        end
        return false

    end

    self.acceptRaise = function()
        self.perform(bp.player, 'accept raise', 0)
    end

    self.engage = function(target)
        self.perform(target, 'engage', 0)
    end

    self.disengage = function()
        
        if bp and bp.player.status == 1 then
            self.perform(bp.__target.get('t'), 'disengage', 0)
        end

    end

    self.switchTarget = function(target)
        local target = bp.__target.get(target)

        if target and bp.__target.canEngage(target) then

            if bp.player.status == 1 then
                self.perform(target, 'switch target', 0)
            
            elseif bp.player.status == 0 then
                self.engage(target)
                
            end

        end

    end

    self.weaponskill = function(target)
        local target = bp.__target.get(target)

        if target and bp.player.status == 1 then
            bp.__queue.add(bp.core.get('ws').name, target, 100)
        end        

    end
    
    self.stop = function()
        windower.ffxi.run(false)
        self.keyCombo:schedule(0.01, {'numpad7','numpad7'})
        
    end

    self.isFacing = function(target)
        local target = bp.__target.get(target)

        if bp and bp.me and target then
            local m_degrees = ((self.getFacing()*180)/math.pi)
            local t_degrees = ((((target.facing)*180)/math.pi) + 180) >= 360 and ((((target.facing)*180)/math.pi)-180) or ((((target.facing)*180)/math.pi)+180)
            local d = ((V{bp.me.x, bp.me.y, bp.me.z} - V{target.x, target.y, target.z}):length())

            if math.abs(m_degrees - t_degrees) <= 15 and d < (3 - (bp.me.model_size + target.model_size)) then
                return true
            end

        end
        return false

    end

    self.isBehind = function(target)
        local target = bp.__target.get(target)

        if bp and bp.me and target then
            local m_degrees = ((self.getFacing()*180)/math.pi)
            local t_degrees = (((target.facing)*180)/math.pi)
            local d = ((V{bp.me.x, bp.me.y, bp.me.z} - V{target.x, target.y, target.z}):length())
            
            if math.abs(m_degrees - t_degrees) <= 15 and d < (3 - (bp.me.model_size + target.model_size)) then
                return true
            end

        end
        return false

    end

    self.inRange = function(target)
        local target = bp.__target.get(target)

        if bp and bp.me and target then
            local d = ((V{bp.me.x, bp.me.y, bp.me.z} - V{target.x, target.y, target.z}):length())

            if d < (3 - (bp.me.model_size + target.model_size)) then
                return true
            end

        end
        return false

    end

    self.inConal = function(target)
        local target = bp.__target.get(target)

        if bp and bp.me and target then
            local m_degrees = ((self.getFacing()*180)/math.pi)
            local t_degrees = ((((target.facing)*180)/math.pi) + 180) >= 360 and ((((target.facing)*180)/math.pi)-180) or ((((target.facing)*180)/math.pi)+180)

            if math.abs(m_degrees - t_degrees) <= 38 then
                return true
            end

        end
        return false

    end

    self.itemReady = function(lookup, bag)

        if lookup and type(lookup) == 'string' then
            local bag, index, id = bp.__inventory.findItem(lookup)

            if bp and bag and index and id and bp.res.items[id] then
                local index, count, id, status, bag = bp.__inventory.getByIndex(bag, index)
                local data = index and bag and bp.extdata.decode(windower.ffxi.get_items(bag, index)) or false

                if index and data and data.type and data.type == 'Enchanted Equipment' then
                    local charges   = data.charges_remaining
                    local ready     = math.max((data.activation_time + 18000) - os.time(), 0)
                    local next_use  = math.max((data.next_use_time + 18000) - os.time(), 0)

                    if charges > 0 and ready == 0 and next_use == 0 then
                        return index, count, id, status, bag, bp.res.items[id]
                    end

                end

            end

        elseif lookup and bag and tonumber(lookup) ~= nil and tonumber(bag) ~= nil then
            local index, count, id, status, bag = bp.__inventory.getByIndex(bag, lookup)
            local data = index and bag and bp.extdata.decode(windower.ffxi.get_items(bag, index)) or false

            if index and data and data.type and data.type == 'Enchanted Equipment' then
                local charges   = data.charges_remaining
                local ready     = math.max((data.activation_time + 18000) - os.time(), 0)
                local next_use  = math.max((data.next_use_time + 18000) - os.time(), 0)

                if charges > 0 and ready == 0 and next_use == 0 then
                    return index, count, id, status, bag, bp.res.items[id]
                end

            end

        end
        return false

    end

    self.castItem = function(name, slot)
        local index, count, id, status, bag = bp.__actions.itemReady(name)
            
        if index and bag and slot and bp.res.items[id] then
            local item = bp.res.items[id]

            if item and item.cast_delay then

                if status == 0 then
                    bp.__actions.equipItem(index, slot, bag)
                    bp.__actions.useItem:schedule((item.cast_delay + 2), index, bp.player, bag)
                    return (item.cast_delay + 2)

                elseif status == 5 then
                    bp.__actions.useItem(index, bp.player, bag)
                    return (item.cast_delay + 2)

                end

            end

        end
        return 0

    end

    -- Private Events.
    windower.register_event('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)

        if bp and bp.player and command and S{'action','act'}:contains(command:lower()) then
            local command = commands[1] and table.remove(commands, 1):lower() or false
            
            if command then
                local target = bp.__target.get('t')
                
                if command == 'weaponskill' and target then
                    bp.__orders.deliver('r', string.format('bp action __weaponskill %s', target.id))

                elseif command == 'switch' and target then
                    bp.__orders.deliver('r', string.format('bp action __switch %s', target.id))

                elseif command == '__weaponskill' and commands[1] then
                    self.weaponskill(tonumber(commands[1]))

                elseif command == '__switch' and commands[1] then
                    self.switchTarget(tonumber(commands[1]))

                elseif command == 'castlock' then
                    local option = commands[1] and table.remove(commands, 1):lower() or false

                    if T{'!','#'}:contains(option) then
                        self.castlock = (option == '!')
                        bp.popchat.pop(string.format('NO-INTERRUPT: \\cs(%s)%s\\cr', bp.colors.setting, tostring(self.castlock):upper()))

                    else
                        self.castlock = self.castlock ~= true and true or false
                        bp.popchat.pop(string.format('NO-INTERRUPT: \\cs(%s)%s\\cr', bp.colors.setting, tostring(self.castlock):upper()))

                    end

                elseif ('distance'):startswith(command) then
                    local option = commands[1] and table.remove(commands, 1):lower() or false

                    if T{'!','#'}:contains(option) then
                        self.distance = (option == '!')
                        bp.popchat.pop(string.format('AUTO-DISTANCING: \\cs(%s)%s\\cr', bp.colors.setting, tostring(self.distance):upper()))

                    else
                        self.distance = self.distance ~= true and true or false
                        bp.popchat.pop(string.format('AUTO-DISTANCING: \\cs(%s)%s\\cr', bp.colors.setting, tostring(self.distance):upper()))

                    end

                elseif ('facing'):startswith(command) then
                    local option = commands[1] and table.remove(commands, 1):lower() or false

                    if T{'!','#'}:contains(option) then
                        self.facing = (option == '!')
                        bp.popchat.pop(string.format('AUTO-FACING: \\cs(%s)%s\\cr', bp.colors.setting, tostring(self.facing):upper()))

                    else
                        self.facing = self.facing ~= true and true or false
                        bp.popchat.pop(string.format('AUTO-FACING: \\cs(%s)%s\\cr', bp.colors.setting, tostring(self.facing):upper()))

                    end

                elseif ('knockback'):startswith(command) then
                    local option = commands[1] and table.remove(commands, 1):lower() or false

                    if T{'!','#'}:contains(option) then
                        self.knockback = (option == '!')
                        bp.popchat.pop(string.format('KNOCKBACK: \\cs(%s)%s\\cr', bp.colors.setting, tostring(self.knockback):upper()))

                    else
                        self.knockback = self.knockback ~= true and true or false
                        bp.popchat.pop(string.format('KNOCKBACK: \\cs(%s)%s\\cr', bp.colors.setting, tostring(self.knockback):upper()))

                    end

                end

            end

        end

    end)

    windower.register_event('prerender', pm.updateFacing)
    windower.register_event('zone change', function() __anchor.__set = false end)
    windower.register_event('outgoing chunk', function(id, original, modified, injected, blocked)

        if bp and not blocked and id == 0x015 and self.castlock then
            local parsed = bp.packets.parse('outgoing', original)

            if parsed and __anchor.__set and __anchor.__position and math.abs(T(__anchor.__position):sum()) > 0 then

                do
                    parsed['Run Count'] = 2
                    parsed['X'] = __anchor.__position.x
                    parsed['Y'] = __anchor.__position.y
                    parsed['Z'] = __anchor.__position.z

                end
                return bp.packets.build(parsed)
            
            else
                __anchor.__position = {x=parsed['X'], y=parsed['Y'], z=parsed['Z']}
            
            end

        elseif bp and not blocked and id == 0x01a and self.castlock then
            local parsed = bp.packets.parse('outgoing', original)

            if parsed['Category'] == 3 and not __anchor.__set then
                __anchor.__set = true
            end

        end

    end)

    windower.register_event('incoming chunk', function(id, original)

        if bp and id == 0x028 and self.castlock then
            local parsed = bp.packets.parse('incoming', original)
            
            if bp.player and parsed then
                local category = parsed['Category']

                if category == 8 and parsed['Actor'] == bp.player.id then

                    if parsed['Param'] ~= 24931 then
                        __anchor.__set, __anchor.__midcast = false, true
                    end

                elseif category == 4 then
                    __anchor.__set, __anchor.__midcast = false, false

                end

            end

        elseif id == 0x029 then
            local parsed = bp.packets.parse('incoming', original)

            if bp.player and parsed and parsed['Actor'] == bp.player.id and T{4,5,16,17,18,49,313,581}:contains(parsed['Message']) and not __anchor.__midcast then
                __anchor.__set = false
            end

        elseif id == 0x053 then
            local parsed = bp.packets.parse('incoming', original)

            if parsed['Message ID'] == 298 and not __anchor.__midcast then
                __anchor.__set = false
            end

        end
        
    end)

    windower.register_event('status change', function(new, old)

        if new == 0 and T{2,3}:contains(old) then
            __death.last = os.clock()
        end

    end)

    return self

end
return library