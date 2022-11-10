local library = {}
function library:new(bp)
    local bp = bp

    -- Public Methods
    self.send = function(parsed, options, success)

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

    return self

end
return library