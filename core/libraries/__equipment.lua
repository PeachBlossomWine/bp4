local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local equipment = T{}

    -- Public Variables.
    self.get = function(slot) return slot and equipment[slot] or equipment end

    -- Private Methods.
    pm.update = function(id, original)
        
        if id == 0x050 then
            local parsed = bp.packets.parse('outgoing', original)

            if parsed then
                equipment[parsed['Equip Slot']] = {index=parsed['Item Index'], slot=parsed['Equip Slot'], bag=parsed['Bag']}
            end

        end

    end

    pm.init = function()
        local equip = windower.ffxi.get_items()['equipment']

        for i=0, 15 do
        
            if bp.res.slots[i] then
                local slot = bp.res.slots[i].en:gsub(" ", "_"):lower()

                if slot then
                    equipment[i] = {index=equip[slot], slot=i, bag=equip[string.format("%s_bag", slot)]}
                end

            end
        
        end

    end
    pm.init()

    -- Private Events.
    windower.register_event('outgoing chunk', pm.update)

    return self

end
return library