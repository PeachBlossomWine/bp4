local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __inventory   = {gil=0, slots={}}
    local __items       = {}
    local __bags        = {}

    -- Public Variables.

    -- Private Methods.
    pm.getBagType = function(access, equippable)
        return S(bp.res.bags):filter(function(key) return (key.access == access and key.equippable == equippable) or key.id == 0 and key end)
    end

    do -- Setup Bags.
        __bags.equippable = T(pm.getBagType('Everywhere', true))
        __bags.storeable  = T(pm.getBagType('Everywhere', false))

    end

    -- Public Methods.
    self.getBags = function(region, equippable) return pm.getBagType(region, equippable) end
    self.hasKeyItem = function(id)
        if not id then return false end
            
        for ki in T(windower.ffxi.get_key_items()):it() do

            if ki == id then
                return true
            end
        
        end
        return false
        
    end

    self.getByIndex = function(bag, index)
        return windower.ffxi.get_items(bag, index)
    end

    self.findByName = function(search, bag)
        local items = {}

        for item, index in T(windower.ffxi.get_items(bag or 0)):it() do

            if type(search) == 'table' and type(item) == 'table' and item.id and bp.res.items[item.id] then

                for compare in T(search):it() do

                    if bp.res.items[item.id].en:lower():startswith(compare:lower()) then
                        table.insert(items, {index, item.count, item.id, item.status, bag or 0, bp.res.items[item.id]})
                    end

                end

            elseif type(search) == 'string' and type(item) == 'table' then

                if item.id and bp.res.items[item.id] and bp.res.items[item.id].en:lower():startswith(search:lower()) then
                    return index, item.count, item.id, item.status, bag or 0, bp.res.items[item.id]
                end

            end

        end
        return items and #items > 0 and items or false

    end

    self.findByIndex = function(search, bag)
        local items = {}
        
        for item, index in T(windower.ffxi.get_items(bag or 0)):it() do

            if type(search) == 'table' and type(item) == 'table' and item.id and bp.res.items[item.id] then

                for compare in T(search):it() do

                    if index == compare then
                        table.insert(items, {index, item.count, item.id, item.status, bag or 0, bp.res.items[item.id]})
                    end

                end

            elseif type(search) == 'string' then

                if type(item) == 'table' and item.id and bp.res.items[item.id] and index == compare then
                    return index, item.count, item.id, item.status, bag or 0, bp.res.items[item.id]
                end

            end

        end
        return items and #items > 0 and items or false

    end

    self.findByID = function(search, bag)
        local items = {}
        
        for item, index in T(windower.ffxi.get_items(bag or 0)):it() do

            if type(search) == 'table' and type(item) == 'table' and item.id and bp.res.items[item.id] then

                for compare in T(search):it() do

                    if item.id == compare then
                        table.insert(items, {index, item.count, item.id, item.status, bag or 0, bp.res.items[item.id]})
                    end

                end

            elseif type(search) == 'string' then

                if type(item) == 'table' and item.id and bp.res.items[item.id] and item.id == compare then
                    return index, item.count, item.id, item.status, bag or 0, bp.res.items[item.id]
                end

            end

        end
        return items and #items > 0 and items or false

    end

    self.getAmount = function(search, bag)
        return T(windower.ffxi.get_items(bag or 0)):filter(function(item) return type(item) == 'table' and bp.res.items[item.id] and bp.res.items[item.id].en:lower():startswith(search:lower()) and item end):length()
    end

    self.getCount = function(search)
        local count = 0

        if type(search) == 'table' then
            return T(search):map(function(item) return item[2] and item[2] end):sum()

        else

            for item, index in T(windower.ffxi.get_items(bag or 0)):it() do
                
                if type(item) == 'table' and item.id and bp.res.items[item.id] and bp.res.items[item.id].en:lower():startswith(search:lower()) then
                    count = (count + item.count)
                end

            end

        end
        return count

    end

    self.getTotal = function(search)
        local count = 0

        for bag in T(__bags.storeable):it() do

            for item, index in T(windower.ffxi.get_items(bag.id)):it() do
                
                if type(item) == 'table' and item.id and bp.res.items[item.id] and bp.res.items[item.id].en:lower():startswith(search:lower()) then
                    count = (count + item.count)
                end

            end

        end
        return count

    end

    self.hasSpace = function(bag)
        return windower.ffxi.get_bag_info(bag or 0).count < windower.ffxi.get_bag_info(bag or 0).max and true or false
    end

    self.getSpace = function(bag)
        local bag = windower.ffxi.get_bag_info(bag or 0)

        if bag.count < bag.max then
            return (bag.max - bag.count)
        end
        return 0

    end

    self.canEquip = function(search)

        for bag in T(__bags.equippable):it() do

            for item, index in T(windower.ffxi.get_items(bag.id)):it() do
                
                if type(item) == 'table' and item.id and bp.res.items[item.id] and bp.res.items[item.id].en:lower():startswith(search:lower()) then
                    return true
                end

            end

        end
        return false

    end

    self.isEquippable = function(bag)
        return T(__bags.equippable):contains(bag)
    end

    return self

end
return library