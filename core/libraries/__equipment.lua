local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local equipment = T{}

    -- Private Methods.
    pm.outgoingUpdate = function(id, original)
        
        if id == 0x050 then
            local parsed = bp.packets.parse('outgoing', original)

            if parsed then
                equipment[parsed['Equip Slot']] = {index=parsed['Item Index'], slot=parsed['Equip Slot'], bag=parsed['Bag']}
            end

        end

    end

    pm.incomingUpdate = function(id, original)
        
        if id == 0x050 then
            local parsed = bp.packets.parse('incoming', original)

            if parsed then
                equipment[parsed['Equipment Slot']] = {index=parsed['Inventory Index'], slot=parsed['Equipment Slot'], bag=parsed['Inventory Bag']}
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

    -- Public Methods.
    self.get = function(slot) return slot and equipment[slot] or equipment end
    self.remove = function(slot)
        bp.packets.inject(bp.packets.new('outgoing', 0x050, {
            ['Item Index'] = 0,
            ['Equip Slot'] = slot,

        }))

    end

    -- Private Events.
    windower.register_event('outgoing chunk', pm.outgoingUpdate)
    windower.register_event('incoming chunk', pm.incomingUpdate)

    return self

end
return library