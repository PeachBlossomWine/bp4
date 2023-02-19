local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __event = nil

    -- Public Methods.
    self.start = function(target, block, success)
        local target = bp.__target.get(target)

        if target and bp.player.status == 0 and bp.__distance.get(target) < 7 then

            if not __event then
                
                __event = windower.register_event('incoming chunk', function(id, original)

                    if (id == 0x032 or id == 0x034) then
                        local parsed = bp.packets.parse('incoming', original)

                        if parsed and target and parsed['NPC Index'] == target.index then
                            windower.unregister_event(__event)
                            __event = nil

                            if success and type(success) == 'function' then
                                success(parsed, target)
                            end

                            if block then
                                return true
                            end

                        else
                            windower.unregister_event(__event)
                            __event = nil
                            
                        end

                    end

                end)

            end
            bp.__actions.perform(target, 'interact', 0)

        end

    end

    self.trade = function(target, items, block, success)
        local target = bp.__target.get(target)

        if target and items and bp.player.status == 0 and bp.__distance.get(target) < 7 then
            
            if not __event then
                
                __event = windower.register_event('incoming chunk', function(id, original)

                    if (id == 0x032 or id == 0x034) then
                        local parsed = bp.packets.parse('incoming', original)

                        if parsed and parsed['NPC Index'] == target.index then
                            windower.unregister_event(__event)
                            __event = nil

                            if success and type(success) == 'function' then
                                success(parsed, target)
                            end

                            if block then
                                return true
                            end

                        elseif parsed and not target or (target and parsed['NPC Index'] ~= target.index) then
                            windower.unregister_event(__event)
                            __event = nil

                        end

                    end

                end)

            end
            bp.__actions.trade(target, items)

        end

    end

    return self

end
return library