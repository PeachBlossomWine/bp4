local library = {}
function library:new(bp)
    local bp = bp

    -- Public Varibles
    self.done = {0, 16384, 0, false}

    -- Public Methods
    self.send = function(parsed, options, delay, success)
        local delay = (delay or 0)

        if bp and parsed and options and type(options) == 'table' then
            coroutine.schedule(function()

                for option, index in T(options):it() do
                    local option = T(option)

                    coroutine.schedule(function()
                        bp.packets.inject(bp.packets.new('outgoing', 0x05b, {
                            ['Menu ID']             = parsed['Menu ID'],
                            ['Zone']                = parsed['Zone'],
                            ['Target Index']        = parsed['NPC Index'],
                            ['Target']              = parsed['NPC'],
                            ['Option Index']        = option[1],
                            ['_unknown1']           = option[2],
                            ['_unknown2']           = option[3],
                            ['Automated Message']   = option[4]
            
                        }))
            
                        if success and type(success) == 'function' and index == options:length() then
                            coroutine.schedule(function()
                                success(parsed, options)
                            
                            end, 0.35)
            
                        end

                    end, (index * 0.25))

                end
            
            end, delay)

        end

    end

    return self

end
return library