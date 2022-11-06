function library()
    local internal = {}

    -- Create a new class object.
    function internal:new(bp)
        local bp        = bp
        local events    = {}

        -- Class Functions.
        function self:newMenu(parsed, options, success)

            if bp and parsed and options and type(options) == 'table' and #options == 4 then
                bp.packets.inject(bp.packets.new('outgoing', 0x05b, {
                    ['Menu ID']             = parsed['Menu ID'],
                    ['Zone']                = parsed['Zone'],
                    ['Target Index']        = parsed['NPC Index'],
                    ['Target']              = parsed['NPC'],
                    ['Option Index']        = options[1],
                    ['_unknown1']           = options[2],
                    ['_unknown2']           = options[3],
                    ['Automated Message']   = options[4]
    
                }))
    
                if success and type(success) == 'function' then
                    coroutine.schedule(function()
                        success(parsed, options)
                    
                    end, 0.35)
    
                end
    
            end

        end        

        -- Class Events.
        events.commands = windower.register_event('addon command', function(...)
            local commands  = T{...}
            local helper    = table.remove(commands, 1)
            
            if helper and helper:lower() == 'menus' then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then

                end

            end
    
        end)

        events.incoming = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)

        end)

        return setmetatable({}, {__index = self})

    end

    return internal

end
return library()