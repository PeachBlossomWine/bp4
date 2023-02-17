local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local completed_map = {["sandoria"]=0x090,["bastok"]=0x098,["windurst"]=0x0A0,["jeuno"]=0x0A8,["other"]=0x0B0,["outlands"]=0x0B8,["ahturhgan"]=0x0C0,['wings']=0x0C8,["abyssea"]=0x0E8,["seekers"]=0x0F8,["coalitions"]=0x108}
    local current_map   = {['abyssea']=0x0E0,['coalitions']=0x100}

    -- Public Variables.
    self.completed  = {}
    self.current    = {}
    self.quests     = bp.files.new('core/resources/quests/quests.lua'):exists() and T(dofile(string.format('%s%s', windower.addon_path, 'core/resources/quests/quests.lua'))) or T{}

    do -- Build maps.
        coroutine.schedule(function()
            self[0x090] = self.quests:length() > 0 and self.map('sandoria') or T{}
            self[0x098] = self.quests:length() > 0 and self.map('bastok') or T{}
            self[0x0A0] = self.quests:length() > 0 and self.map('windurst') or T{}
            self[0x0A8] = self.quests:length() > 0 and self.map('jeuno') or T{}
            self[0x0B0] = self.quests:length() > 0 and self.map('other') or T{}
            self[0x0B8] = self.quests:length() > 0 and self.map('frontier') or T{}
            self[0x0C0] = self.quests:length() > 0 and self.map('ahturhgan') or T{}
            self[0x0C8] = self.quests:length() > 0 and self.map('wings') or T{}
            self[0x0E8] = self.quests:length() > 0 and self.map('abyssea') or T{}
            self[0x0F8] = self.quests:length() > 0 and self.map('seekers') or T{}
            self[0x108] = self.quests:length() > 0 and self.map('coalition') or T{}
        
        end, 1.5)

    end

    -- Private Methods.
    pm.buildCompleted = function(t, flags)
        local build = {}

        -- CURRENT QUESTS.
        build[0x100] = function(flags)
            self.current[t] = {}
            for i=1, 32 do
                local flags = T{ flags[i]:unpack('q8') }
                for b=1, 8 do table.insert(self.current[t], flags[b]) end
            end
        end

        -- COMPLETED QUESTS.
        build[0x090] = function(flags)
            self.completed[t] = {}
            for i=1, 32 do
                local flags = T{ flags[i]:unpack('q8') }
                for b=1, 8 do table.insert(self.completed[t], flags[b]) end
            end
        end

        build[0x098] = function(flags)
            self.completed[t] = {}
            for i=1, 32 do
                local flags = T{ flags[i]:unpack('q8') }
                for b=1, 8 do table.insert(self.completed[t], flags[b]) end
            end
        end

        build[0x0A0] = function(flags)
            self.completed[t] = {}
            for i=1, 32 do
                local flags = T{ flags[i]:unpack('q8') }
                for b=1, 8 do table.insert(self.completed[t], flags[b]) end
            end
        end

        build[0x0A8] = function(flags)
            self.completed[t] = {}
            for i=1, 32 do
                local flags = T{ flags[i]:unpack('q8') }
                for b=1, 8 do table.insert(self.completed[t], flags[b]) end
            end
        end

        build[0x0B0] = function(flags)
            self.completed[t] = {}
            for i=1, 32 do
                local flags = T{ flags[i]:unpack('q8') }
                for b=1, 8 do table.insert(self.completed[t], flags[b]) end
            end
        end

        build[0x0B8] = function(flags)
            self.completed[t] = {}
            for i=1, 32 do
                local flags = T{ flags[i]:unpack('q8') }
                for b=1, 8 do table.insert(self.completed[t], flags[b]) end
            end
        end

        build[0x0C0] = function(flags)
            self.completed[t] = {}
            for i=1, 32 do
                local flags = T{ flags[i]:unpack('q8') }
                for b=1, 8 do table.insert(self.completed[t], flags[b]) end
            end
        end

        build[0x0C8] = function(flags)
            self.completed[t] = {}
            for i=1, 32 do
                local flags = T{ flags[i]:unpack('q8') }
                for b=1, 8 do table.insert(self.completed[t], flags[b]) end
            end
        end

        build[0x0E8] = function(flags)
            self.completed[t] = {}
            for i=1, 32 do
                local flags = T{ flags[i]:unpack('q8') }
                for b=1, 8 do table.insert(self.completed[t], flags[b]) end
            end
        end

        build[0x0F8] = function(flags)
            self.completed[t] = {}
            for i=1, 32 do
                local flags = T{ flags[i]:unpack('q8') }
                for b=1, 8 do table.insert(self.completed[t], flags[b]) end
            end
        end

        build[0x108] = function(flags)
            self.completed[t] = {}
            for i=1, 32 do
                local flags = T{ flags[i]:unpack('q8') }
                for b=1, 8 do table.insert(self.completed[t], flags[b]) end
            end
        end

        if t and flags and build[t] then
            build[t](flags)
        end

    end

    -- Public Methods.
    self.build = function()
        local quests = T(dofile(string.format("%s%s.lua", windower.addon_path, 'core/resources/quests/__q')))
        local map = T(dofile(string.format("%s%s.lua", windower.addon_path, 'core/resources/quests/__qmap')))

        self.quests = {}
        for res, index in quests:it() do
            table.insert(self.quests, string.format('\t{index=%d, memoryIndex=%d, name="%s", type="%s"},', map[index].questIndex, res.index, res.resource:gsub('+', ''), res.questType))
        
        end
        bp.files.new('core/resources/quests/quests.lua'):write(string.format('return {\n%s\n}', table.concat(self.quests, '\n')))

    end

    self.get = function(t, index)
        local index = index == 0 and 1 or (index + 1)

        if t and index then
            local list = self.map(t)

            if list[index] then
                return list[index]
            end

        end
        return {}

    end
    
    self.filter = function(t)
        
        if t and type(t) == 'string' and self.quests:length() > 0 then
            return self.quests:filter(function(res) return res.type:lower():startswith(t:lower()) end)
        end

    end

    self.map = function(t)
        local map = {}

        if t and type(t) == 'string' and self.quests:length() > 0 then

            for res in T(bp.__quests.filter(t)):it() do
                map[res.index + 1] = res
            end
            return map

        end
        return nil

    end

    self.getCompleted = function(t)
        local r = {}

        if t and completed_map[t] and self.completed[completed_map[t]] then
            local completed = self.completed[completed_map[t]]

            for i=1, #completed do
                local mapped = self[completed_map[t]] or nil

                if completed[i] and mapped[i] then
                    table.insert(r, {index=mapped[i].index, name=mapped[i].name, type=mapped[i].type})
                end

            end
            return r

        end
        return {}

    end

    self.getCurrent = function(t)
        local r = {}

        if t and current_map[t] and self.completed[current_map[t]] then
            local current = self.current[current_map[t]]

            for i=1, #current do
                local mapped = self[current_map[t]] or nil

                if current[i] and mapped[i] then
                    table.insert(r, {index=mapped[i].index, name=mapped[i].name, type=mapped[i].type})
                end

            end
            return r

        end
        return {}

    end

    self.isComplete = function(t, index)
        local list = t and completed_map[t] and self.completed[completed_map[t]] or nil

        if list and index and list[index + 1] ~= nil then
            return list[index + 1]
        end
        return false

    end

    self.isCurrent = function(t, index)
        local list = t and current_map[t] and self.current[current_map[t]] or nil

        if list and index and list[index + 1] ~= nil then
            return list[index + 1]
        end
        return false

    end

    -- Private Events.
    windower.register_event('incoming chunk', function(id, original)

        if id == 0x056 then
            local parsed = bp.packets.parse('incoming', original)

            if parsed and parsed['Type'] and parsed['Quest Flags'] then
                pm.buildCompleted(parsed['Type'], parsed['Quest Flags'])
            end

        end

    end)

    return self

end
return library