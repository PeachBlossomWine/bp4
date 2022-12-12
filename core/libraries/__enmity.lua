local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __reset   = 0
    local __target  = false

    -- Private Methods.
    pm.catchEnmity = function(id, original)

        if bp and id and id == 0x028 then
            local parsed = bp.packets.parse('incoming', original)

            if parsed then
                local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
                local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])

                if actor and target and T{1,6,7,8,11,12,13,14,15}:contains(parsed['Category']) then

                    if bp.__target.isEnemy(actor) and bp.__party.isMember(actor.claim_id, true) then
                        __target, __reset = target, os.clock()
                    end

                end

            end

        end

    end

    pm.validate = function()

        if not __target or (__target and bp.__target.valid(__target)) then
            __target = false
        end

    end

    -- Public Methods.
    self.hasEnmity = function() return __target end

    -- Private Events.
    windower.register_event('incoming chunk', pm.catchEnmity)
    windower.register_event('prerender', pm.validate)

    return self

end
return library