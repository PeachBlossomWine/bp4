function library()
    local internal = {}

    -- Create a new class object.
    function internal:new(bp)
        local bp        = bp
        local waiting   = false
        local pinged    = false

        local getFile = function()
            local temp = bp.files.new(string.format('core/resources/mobs/%s/%s.lua', windower.ffxi.get_info().zone, windower.ffxi.get_info().zone))

            if temp:exists() then
                return dofile(string.format('%score/resources/mobs/%s/%s.lua', windower.addon_path, windower.ffxi.get_info().zone, windower.ffxi.get_info().zone))
            end
            return {}

        end

        -- List of all mobs for current zone.
        self.list = getFile()
        
        -- Update on zone change.
        self.zone = windower.register_event('zone change', function()
            self.list = getFile()
            
        end)

        self.incoming = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
            
            if id == 0x00e then
                local parsed = bp.packets.parse('incoming', original)

                if parsed and waiting then
                    local id     = parsed['NPC']
                    local index  = parsed['Index']
                    local status = parsed['Status']
                    local name   = parsed['Name']

                    if waiting == index then

                        for i=1, #self.list do

                            if self.list[i] and self.list[i].index == index then
                                self.list[i].x, self.list[i].y, self.list[i].z = parsed['X'], parsed['Y'], parsed['Z']
                                self.list[i].status = status
                                pinged = self.list[i]
                                break

                            end

                        end
                        waiting = false

                    end

                end

            end

        end)

        -- Create a new mobs object.
        local new = function()
            return setmetatable({}, {__index = mobs})
        end

        -- Class Functions.    
        function self:all()
            return self.list or false
        end

        function self:withName(name)
            if tonumber(name) then return {} end
            return T(self.list):filter(function(mob)
                return mob.name:sub(1, #name):gsub("[^?[%p]]", ""):lower():find(name:gsub("[^?[%p]]", ""):lower())

            end)

        end

        function self:ping(index, callback)
            if tonumber(index) == nil then return end
            local mob = self:find(tonumber(index))

            if mob and mob.index then
                waiting = mob.index
                bp.packets.inject(bp.packets.new('outgoing', 0x016, {['Target Index']=mob.index}))

                if callback and type(callback) == 'function' then
                    
                    coroutine.schedule(function()
                        local pinged = self:getPinged()

                        if pinged and pinged.x and pinged.y and pinged.z then
                            callback(pinged)
                        end

                    end, 1)
                    
                end
                return mob

            end

        end

        function self:distance(value)
            if not value then return -1 end
            local m = windower.ffxi.get_mob_by_target('me') or false

            if m and tonumber(value) == nil and type(value) == 'table' and (value.index or value.id) then
                local t = self:find(value.index or value.id)

                if t and t.x and t.y and t.z then
                    return ((V{m.x, m.y, m.z} - V{t.x, t.y, t.z}):length())
                end

            elseif m and tonumber(value) ~= nil then
                local t = self:find(value)

                if t and t.x and t.y and t.z then
                    return ((V{m.x, m.y, m.z} - V{t.x, t.y, t.z}):length())
                end

            end
            return -1

        end

        function self:find(value, valid)
            if not value then return false end
                
            if tonumber(value) ~= nil then
                local valid = valid or false
                local value = tonumber(value)

                for mob in T(self.list):it() do    

                    if valid then
                        local mob = windower.ffxi.get_mob_by_index(value) or windower.ffxi.get_mob_by_id(value)
                        
                        if mob and mob.valid_target and (mob.id == value or mob.index == value) then
                            return mob
                        end

                    elseif not valid then

                        if (mob.id == value or mob.index == value) then
                            return mob
                        end

                    end

                end

            elseif type(value) == 'string' then

                for mob in T(self.list):it() do
                    if mob.name == value then
                        return mob
                    end    
                end

            end
            return false

        end

        function self:getPinged()
            return pinged
        end

        function self:nearby(name, valid, distance)
            local list  = self:withName(name)
            local found = {}
            
            for _,m in pairs(list) do
                local mob = windower.ffxi.get_mob_by_index(m.index)

                if mob then
                    local distance = distance or 7
                    local valid = valid or false

                    if valid and mob.valid_target then

                        if bp.helpers['distance'].getDistance(mob) < distance then
                            table.insert(found, {name=mob.name, id=mob.id, index=mob.index, status=mob.status, x=mob.x, y=mob.y, z=mob.z, distance=bp.helpers['distance'].getDistance(mob)})
                        end

                    elseif not valid then

                        if bp.helpers['distance'].getDistance(mob) < distance then
                            table.insert(found, {name=mob.name, id=mob.id, index=mob.index, status=mob.status, x=mob.x, y=mob.y, z=mob.z, distance=bp.helpers['distance'].getDistance(mob)})
                        end

                    end

                end

            end

            -- Sort by distance.
            if #found > 0 then
                return table.sort(found, function(a, b)
                    return a.distance < b.distance

                end)

            end
            return found

        end

        function self:inArrayByList(list, height, distance)
            if not list then return end
            local m = T{}

            for mob in T(windower.ffxi.get_mob_array()):it() do
                local height = height or 5
                local distance = distance or 150

                if bp.helpers['distance'].getDistance(mob) <= distance and bp.helpers['target'].canEngage(mob) and S(list):contains(mob.name) then
                    m:insert(mob)
                end            
            end

            -- Sort by distance.
            if #m > 0 then
                return table.sort(m, function(a, b)
                    return bp.helpers['distance'].getDistance(a) < bp.helpers['distance'].getDistance(b)

                end)[1]

            end
            return false

        end

        return setmetatable({}, {__index = self})

    end

    return internal

end
return library()