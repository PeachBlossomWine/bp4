local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __aggro   = {}
    local __timers  = {}

    -- Private Methods.
    pm.update = function(id, original)

        if bp and id == 0x028 then
            local parsed    = bp.packets.parse('incoming', original)
            local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
            local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
            local category  = parsed['Category']
            
            if bp.player and actor and target and T{1,6,7,8,12,13,14,15}:contains(category) and bp.__target.isEnemy(actor) and bp.__party.isMember(target, true) then

                if not T(__aggro):contains(actor.id) then
                    table.insert(__aggro, actor.id)

                    do  -- Add timer.
                        __timers[actor.id] = os.time()

                    end

                elseif T(__aggro):contains(actor.id) then
                    __timers[actor.id] = os.time()

                end

            end

        end

    end

    pm.remove = function(id, original)

        for id, index in T(__aggro):it() do
            local target = bp.__target.get(id)

            if (not target or T{2,3}:contains(target.status) or bp.__distance.get(target) > 21 or target.status == 0 or (os.time()-__timers[id]) >= 10) then
                table.remove(__aggro, index)

                do -- Remove from the timers also.
                    __timers[id] = nil

                end

            end

        end

    end

    -- Public Methods.
    self.hasAggro = function() return #__aggro > 0 and true or false  end
    self.getCount = function() return #__aggro end
    self.getAggro = function() return __aggro end

    -- Private Events.
    windower.register_event('incoming chunk', pm.update)
    windower.register_event('time change', pm.remove)

    return self

end
return library