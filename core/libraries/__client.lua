local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local Socket    = require('socket')
    local __socket  = Socket.tcp()
    local __host    = '127.0.0.1'
    local __port    = 8080
    local __flags   = {}
    local __hbeat   = (os.time() - 20)
    local __upid    = tonumber(string.format("%s%s", bp.player.id, bp.info.server))
    local __skills  = {main=0, ranged=0}

    do 
        __socket:settimeout(0.001)
        __flags.receiveDelay = 5

    end

    -- Private Methods.
    pm.getData = function() return {upid=__upid, name=bp.player.name, main=bp.player.main_job, subj=bp.player.sub_job, party=bp.__party.getMemberList(), skills=__skills} end
    pm.connect = function(reconnect)
        local push = {}

        if bp and bp.player and bp.me and not self.isConnected() and not reconnect then
            coroutine.schedule(function()
                __flags.connection, __flags.error = __socket:connect(__host, __port)

                if self.isConnected() then
                    __flags.error = nil

                    do -- Gather some data.
                        local m = bp.__equipment.get(0)
                        local r = bp.__equipment.get(2)

                        do
                            __skills.main = m and bp.res.items[windower.ffxi.get_items(m.bag, m.index).id].skill
                            __skills.ranged = r and bp.res.items[windower.ffxi.get_items(r.bag, r.index).id].skill

                        end
                        self.send(0x001, bp.__json.encode(pm.getData()))

                    end

                elseif not self.isConnected() and __flags.error then
                    --print(__flags.error)

                end

            end, 2)

        elseif reconnect then
            pm.close(pm.connect)

        end

    end

    pm.close = function(callback)
        __flags.connection = nil
        __socket:close()

        if callback and type(callback) == 'function' then
            print('Running callback after closing...')
            callback()
        end

    end

    pm.heartbeat = function()

        if bp and bp.player and bp.me and self.isConnected() and (os.time() - __hbeat) >= 30 then
            self.send(0x003, bp.__json.encode(pm.getData()))
            __hbeat = os.time()

        end

    end

    local data
    pm.receive = function()

        if self.isConnected() and (os.clock()-__flags.receiveDelay) > 0.75 then
            coroutine.schedule(function()
                local s, status, partial = __socket:receive('*l')

                if (not status or status and not status == 'closed') then

                    if s then
                        print(s)
                        windower.send_command(s)                
                    end

                end
                __flags.receiveDelay = os.clock()
            
            end, 0)

        end

    end

    -- Public Methods.
    self.isConnected = function() return (__flags.connection and __flags.connection == 1) and true or false end
    self.send = function(id, data)
        if (not id or not data or not self.isConnected()) then
            return
        end

        coroutine.schedule(function()

            if bp and bp.player then
                __socket:send(string.format("%s!BP", string.format("%s|%s", tostring(id), data)))
            end
        
        end, 0)
        
    end

    -- Private Events.
    windower.register_event('prerender', pm.receive)
    windower.register_event('time change', pm.heartbeat)
    windower.register_event('load', function() pm.connect:schedule(0.8) end)
    windower.register_event('unload', function() self.send(0x002, bp.__json.encode(pm.getData())) end)
    windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = table.remove(commands, 1)
        
        if helper and helper:lower() == 'client' then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if command then

                if command == 'reconnect' then
                    pm.connect(true)
                end

            end

        end

    end)

    windower.register_event('job change', function(mi, ml, si, sl)
        self.send:schedule(0.5, 0x004, bp.__json.encode({upid=__upid, name=bp.player.name, main=bp.res.jobs[mi].ens, subj=bp.res.jobs[si].ens, party=bp.__party.getMemberList(), skills=__skills}))
        __hbeat = (__hbeat + 2)

    end)

    windower.register_event('incoming chunk', function(id, original)

        if id == 0x050 then
            local parsed = bp.packets.parse('incoming', original)

            if parsed and T{0,2}:contains(parsed['Equipment Slot']) then
                local item = windower.ffxi.get_items(parsed['Inventory Bag'], parsed['Inventory Index'])

                if item and parsed['Equipment Slot'] == 0 then
                    __skills.main = bp.res.items[item.id].skill

                elseif item and parsed['Equipment Slot'] == 2 then
                    __skills.ranged = bp.res.items[item.id].skill

                end
                self.send(0x005, bp.__json.encode(pm.getData()))

            end

        end

    end)

    return self

end
return library