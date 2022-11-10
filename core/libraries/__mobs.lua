local library = {}
function library:new(bp)
    local bp = bp

    -- Private Variables.
    local mobs      = {}
    local waiting   = false
    local pinged    = false

    -- Private Methods.
    local updateMobs = function()
        mobs = bp and bp.libs.__resources.get(string.format("mobs/%s/%s",  bp.info.zone, bp.info.zone))
    end

    -- Public Methods.
    self.all = function()
        return mobs or false
    end

    self.withName = function(name)
        if tonumber(name) then return {} end
        return T(mobs):filter(function(mob)
            return mob.name:sub(1, #name):gsub("[^?[%p]]", ""):lower() == name:gsub("[^?[%p]]", ""):lower()

        end)

    end

    self.ping = function(index, callback)
        local mob = self.find(tonumber(index))

        if mob and mob.index then
            waiting = mob.index
            bp.packets.inject(bp.packets.new('outgoing', 0x016, {['Target Index']=mob.index}))

            if callback and type(callback) == 'function' then
                
                coroutine.schedule(function()
                    local pinged = self.getPinged()

                    if pinged and pinged.x and pinged.y and pinged.z then
                        callback(pinged)
                    end

                end, 1)
                
            end
            return mob

        end

    end

    self.find = function(value, valid)
        local mob = bp.libs.__target.get(value)

        for m in T(mobs):it() do    
                
            if mob and (valid and mob.valid_target or not valid) and mob.name == m.name then
                return mob
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
            local mob = bp.libs.__target.get(m.index)

            if mob and (valid and mob.valid_target or not valid) then

                if bp.libs.__distance.get(mob) <= distance or 7 then
                    table.insert(found, {name=mob.name, id=mob.id, index=mob.index, status=mob.status, x=mob.x, y=mob.y, z=mob.z, distance=bp.libs.__distance.get(mob)})
                end

            end

        end
        return table.sort(found, function(a, b) return a.distance < b.distance end)

    end

    self.inArrayByList = function(list, distance, height)
        if not list then return end
        local m = T{}

        for mob in T(windower.ffxi.get_mob_array()):it() do -- ADD HEIGHT CHECK!!!

            if bp.libs.__distance.get(mob) <= distance or 150 and bp.libs.__target.canEngage(mob) and S(list):contains(mob.name) then
                m:insert(mob)
            end

        end

        -- Sort by distance.
        if #m > 0 then
            return table.sort(m, function(a, b)
                return bp.libs.__distance.get(a) < bp.libs.__distance.get(b)

            end)[1]

        end
        return false

    end

    -- Private Events.
    windower.register_event('load','login','zone change', updateMobs)
    windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
        
        if id == 0x00e then
            local parsed = bp.packets.parse('incoming', original)

            if parsed and waiting then
                local id     = parsed['NPC']
                local index  = parsed['Index']
                local status = parsed['Status']
                local name   = parsed['Name']

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

    return self

end
return library