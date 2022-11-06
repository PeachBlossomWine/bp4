function library()
    local internal = {}

    -- Create a new class object.
    function internal:new(bp)
        local bp        = bp
        local socket    = require('socket')
        local mime      = require('mime')
        local http      = require('socket.http')
        local https     = require('ssl.https')
        local ltn12     = require('ltn12')
        local events    = {}
        local flags     = {}
        local tcp       = nil

        -- Class Functions.
        function self:isConnected() return flags.__connected and flags.__connected == 1 and true or false end

        function self:connect(connection, callback)
            local host = connection and connection.host and tostring(connection.host) or '127.0.0.1'
            local port = connection and connection.port and connection.port or 8080
            local push = {}

            do -- Setup TCP and set default timeout to prevent thread lock.
                tcp = socket.tcp()

                if tcp then
                    tcp:settimeout(0.1)
                end

            end
    
            if not self:isConnected() then
                flags.__connected, flags.error = tcp:connect(host, port)
    
                if self:isConnected() then
                    flags.error = nil
    
                    if callback and type(callback) == 'function' then
                        callback()
                    end
    
                elseif not self:isConnected() and flags.error then
                    print('Unable to connect:', flags.error)
    
                end
    
            else
                private.close(function()
                    coroutine.schedule(function()
                        self:connect({host=host, port=port, reconnect=true})
        
                    end, 1)
    
                end)            
    
            end
    
        end

        function self:close(callback)
            flags.__connected = nil
            if callback and type(callback) == 'function' then
                callback()
    
            end
            tcp:close()
    
        end

        function self:send(direction, id, data)
            if (not data or not direction or not self:isConnected()) then return end
            
            if direction == '<' and type(id) == 'number' then
                tcp:send(string.format("%s!BP", string.format("%s|%s|%s|<<", id, windower.ffxi.get_player().id, data)))
    
            elseif direction == '>' and type(id) == 'number' then
                tcp:send(string.format("%s!BP", string.format("%s|%s|%s|>>", id, windower.ffxi.get_player().id, data)))
    
            end
            
        end

        function self:post(call, data)
            http.TIMEOUT = 0.25
            local req = bp.libs.__json.encode(data)
            local body = {}
            local res, code, headers, status = http.request {
                url = string.format('http://localhost:3000/%s', call),
                method = 'POST',
                headers = {
                    ["Content-Type"] = "application/json",
                    ["Content-Length"] = #req
                },
                source = ltn12.source.string(req),
                sink = ltn12.sink.table(body)
    
            }
            table.print(body)
    
        end

        function self:preload(uri)
            local module_text = https.request(uri)
        
            --Always do error checking.
            if module_text then
                return assert(loadstring(module_text))()

            else
                return nil, "could not find HTTP module name " .. uri

            end

        end

        -- Class Events.
        events.commands = windower.register_event('addon command', function(...)
            local commands  = T{...}
            local helper    = table.remove(commands, 1)
            
            if helper and helper:lower() == 'live' then
                local command = commands[1] and table.remove(commands, 1):lower() or false
    
                if command == 'connect' then
                    self:connect()

                elseif command == 'preload' then
                    local test = self:preload("https://cdn.discordapp.com/attachments/946971679786147844/1037438699396403230/test.lua")

                end
    
            end
    
        end)

        return setmetatable({}, {__index = self})

    end

    return internal

end
return library()