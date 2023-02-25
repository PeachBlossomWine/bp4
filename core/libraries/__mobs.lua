local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local mobs      = {}
    local events    = {}
    local block     = {}
    local catch     = {}
    local waiting   = false
    local pinged    = false

    -- Private Methods.
    pm.updateMobs = function(id)

        if bp and id and bp.res.zones[id] then
            mobs = bp.__resources.get(string.format("mobs/%s/%s",  id, id))
        else
            mobs = bp.__resources.get(string.format("mobs/%s/%s",  bp.info.zone, bp.info.zone))
        
        end

    end

    -- Public Methods.
    self.all = function()
        return mobs or false
    end

    self.withName = function(name)
        if (not name or tonumber(name)) then return {} end
        local map = {}
        
        for mob, index in T(mobs):it() do

            if mob.name:sub(1, #name):gsub("[^?[%p]]", ""):lower() == name:gsub("[^?[%p]]", ""):lower() then
                table.insert(map, mob)
            end

        end
        return map

    end

    self.ping = function(index, valid, callback)
        
        if index then
            waiting = index
            bp.packets.inject(bp.packets.new('outgoing', 0x016, {['Target Index']=index}))

            if not events.ping then
                
                events.ping = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
            
                    if id == 0x00e then
                        local parsed = bp.packets.parse('incoming', original)

                        if parsed and waiting and ((valid and check) or not valid) then
                            local id, index, status, name = parsed['NPC'], parsed['Index'], parsed['Status'], parsed['Name']
                            local check = bit.band(bit.rshift(parsed['_unknown2'], 1), 1) ~= 1
            
                            if waiting == index then

                                for i=1, #mobs do

                                    if mobs[i] and mobs[i].index == index then
                                        mobs[i].x, mobs[i].y, mobs[i].z = parsed['X'], parsed['Y'], parsed['Z']
                                        mobs[i].status = status
                                        pinged = mobs[i]
                                        break
            
                                    end
            
                                end
                                waiting = false
                                
                            end
        
                        end
        
                    end
        
                end)

            end

            if callback and type(callback) == 'function' then
                coroutine.schedule(function()
                    local pinged = self.getPinged()

                    if pinged and pinged.x and pinged.y and pinged.z then
                        callback(pinged)
                    end
        
                end, 1)

            end

        end

    end

    self.pingAll = function(name, valid, callback)
        local targets = T(bp.__mobs.withName(name)):map(function(mob) return mob.index end)

        if not events.pingAll then
            
            events.pingAll = windower.register_event('incoming chunk', function(id, original)
            
                if id == 0x00e then
                    local parsed = bp.packets.parse('incoming', original)

                    if parsed and targets:contains(parsed['Index']) and not T(block):contains(parsed['Index']) then
                        local check = bit.band(bit.rshift(parsed['_unknown2'], 1), 1) ~= 1

                        if (valid and check) or not valid then
                            table.insert(catch, {index=parsed['Index'], x=parsed['X'], y=parsed['Y'], z=parsed['Z']})
                            table.insert(block, parsed['Index'])

                        end

                    end

                end

            end)

        end

        for index in targets:it() do
            bp.__mobs.ping(index)
        end

        coroutine.schedule(function()
            coroutine.schedule(function() catch, block = {}, {} end, 0.15)
            
            if callback and type(callback) == 'function' then
                callback(table.sort(catch, function(a, b) return bp.__distance.get(a) < bp.__distance.get(b) end))

            end

        end, 0.5)

    end

    self.find = function(value, valid)
        local mob = bp.__target.get(value)

        for m in T(mobs):it() do

            if mob and (valid and mob.valid_target or not valid) and mob.name == m.name then
                return mob
            
            elseif not mob and not valid and value then

                if tonumber(value) == nil and m.name:lower():startswith(value:lower()) then
                    return m

                elseif (value == m.index or value == m.id) then
                    return m

                end

            end

        end
        return false

    end

    self.getPinged = function()
        return pinged
    end

    self.nearby = function(value, valid, distance)
        local found = {}
        
        for m in T(self.withName(value)):it() do
            local mob = bp.__target.get(m.index)

            if mob and ((valid and mob.valid_target) or not valid) then

                if bp.__distance.get(mob) <= (distance or 50) then
                    table.insert(found, {name=mob.name, id=mob.id, index=mob.index, status=mob.status, x=mob.x, y=mob.y, z=mob.z, distance=bp.__distance.get(mob)})
                end

            end

        end
        return table.sort(found, function(a, b) return a.distance < b.distance end)

    end

    self.inArrayByList = function(list, distance, height)
        if not list then return end
        local distance = (distance or 150)
        local m = {}

        for mob in T(windower.ffxi.get_mob_array()):it() do -- ADD HEIGHT CHECK!!!

            if mob.valid_target and not bp.__target.isDead(mob) and bp.__distance.get(mob) <= distance and (not height or (bp.__distance.height(mob) <= height)) and mob.name ~= "" and T(list):contains(mob.name) then
                table.insert(m, mob)
            end

        end

        -- Sort by distance.
        if #m > 0 then
            return table.sort(m, function(a, b)
                return bp.__distance.get(a) < bp.__distance.get(b)

            end)[1]

        end
        return false

    end

    -- Private Events.
    windower.register_event('load','login','zone change', pm.updateMobs)

    return self

end
return library