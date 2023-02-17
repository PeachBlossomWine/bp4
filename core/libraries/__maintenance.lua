local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __enabled = false
    local __inject  = false

    -- Private Methods.
    pm.handle = function(id, original, modified, injected, blocked)

        if id == 0x037 then
            local parsed = bp.packets.parse('incoming', original)

            -- Store packet data.
            if not injected and T{0,5,85}:contains(parsed['Status']) then
                __inject = parsed

            elseif not injected and __enabled and __inject then
                parsed['Status'] = 31
                return bp.packets.build(parsed)

            end

        elseif id == 0x00d then
            local parsed = bp.packets.parse('incoming', original)

            if not injected and __enabled and __inject then
                parsed['Status'] = 31
                return bp.packets.build(parsed)

            end

        end

    end
    
    -- Private Events.
    windower.register_event('incoming chunk', pm.handle)
    windower.register_event('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)

        if bp and bp.player and command and command:lower() == 'maint' then
            __enabled = __enabled ~= true and true or false

            if __inject then
                local updated = T(__inject):copy()

                if __enabled then
                    updated['Status'] = 31
                    bp.packets.inject(updated)

                else
                    bp.packets.inject(__inject)

                end
                bp.popchat.pop(string.format("MAINTENANCE MODE: \\cs(%s)%s\\cr", bp.colors.setting, tostring(__enabled):upper()))

            else
                bp.popchat.pop("MAINTENANCE MODE IS NOT AVAILABLE YET.")

            end

        end

    end)

    return self

end
return library