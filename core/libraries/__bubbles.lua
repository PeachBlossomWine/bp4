local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __map = {'East','Southeast','South','Southwest','West','Northwest','North','Northeast'}
  
    -- Public Variables.
    self.shortcuts = {}

    do -- Handle Bubble shortcuts map.    
        self.shortcuts.indicolure = {
            
            ["str"]    = "Indi-STR",         ["dex"]     = "Indi-DEX",
            ["agi"]    = "Indi-AGI",         ["int"]     = "Indi-INT",
            ["mnd"]    = "Indi-MND",         ["chr"]     = "Indi-CHR",
            ["vit"]    = "Indi-VIT",         ["refresh"] = "Indi-Refresh",
            ["regen"]  = "Indi-Regen",       ["haste"]   = "Indi-Haste",
            ["eva"]    = "Indi-Voidance",    ["acc"]     = "Indi-Precision",
            ["mev"]    = "Indi-Attunement",  ["macc"]    = "Indi-Focus",
            ["def"]    = "Indi-Barrier",     ["att"]     = "Indi-Fury",
            ["mdb"]    = "Indi-Fend",        ["mab"]     = "Indi-Acumen",
            ["para"]   = "Indi-Paralysis",   ["grav"]    = "Indi-Gravity",
            ["poison"] = "Indi-Poison",      ["Slow"]    = "Indi-Slow",
            ["macc-"]  = "Indi-Vex",         ["eva-"]    = "Indi-Torpor",
            ["acc-"]   = "Indi-Slip",        ["mev-"]    = "Indi-Languor",
            ["def-"]   = "Indi-Frailty",     ["att-"]    = "Indi-Wilt",
            ["mdb-"]   = "Indi-Malaise",     ["mab-"]    = "Indi-Fade",
            
        }

        self.shortcuts.geocolure = {

            ["str"]    = "Geo-STR",         ["dex"]     = "Geo-DEX",
            ["agi"]    = "Geo-AGI",         ["int"]     = "Geo-INT",
            ["mnd"]    = "Geo-MND",         ["chr"]     = "Geo-CHR",
            ["vit"]    = "Geo-VIT",         ["refresh"] = "Geo-Refresh",
            ["regen"]  = "Geo-Regen",       ["haste"]   = "Geo-Haste",
            ["eva"]    = "Geo-Voidance",    ["acc"]     = "Geo-Precision",
            ["mev"]    = "Geo-Attunement",  ["macc"]    = "Geo-Focus",
            ["def"]    = "Geo-Barrier",     ["att"]     = "Geo-Fury",
            ["mdb"]    = "Geo-Fend",        ["mab"]     = "Geo-Acumen",
            ["para"]   = "Geo-Paralysis",   ["grav"]    = "Geo-Gravity",
            ["poison"] = "Geo-Poison",      ["Slow"]    = "Geo-Slow",
            ["macc-"]  = "Geo-Vex",         ["eva-"]    = "Geo-Torpor",
            ["acc-"]   = "Geo-Slip",        ["mev-"]    = "Geo-Languor",
            ["def-"]   = "Geo-Frailty",     ["att-"]    = "Geo-Wilt",
            ["mdb-"]   = "Geo-Malaise",     ["mab-"]    = "Geo-Fade",

        }

    end

    -- Private Methods.
    pm.getDirection = function(rotation)
        local rotation = rotation or 0

        if rotation >= 0 and rotation <= 0.785 then
            return 1

        elseif rotation > 0.785 and rotation <= 1.570 then
            return 2

        elseif rotation > 1.570 and rotation <= 2.355 then
            return 3

        elseif rotation > 2.355 and rotation <= 3.140 then
            return 4

        elseif rotation > 3.140 and rotation <= 3.925 then
            return 5

        elseif rotation > 3.925 and rotation <= 4.710 then
            return 6

        elseif rotation > 4.710 and rotation <= 5.495 then
            return 7

        elseif rotation > 5.495 and rotation <= 6.280 then
            return 8

        end
        return 1

    end

    pm.frontOffset = function(direction, size, scale)
        local directions = {}

        if bp and direction and size and scale then

            directions['East']      = function(adjust) return {x=(1+adjust+math.random()), y=0} end
            directions['Northeast'] = function(adjust) return {x=(1+adjust+math.random()), y=(1+adjust+math.random())} end
            directions['North']     = function(adjust) return {x=0, y=(1+adjust+math.random())} end
            directions['Northwest'] = function(adjust) return {x=(-1+((adjust+math.random())*-1)), y=(1+adjust+math.random())} end
            directions['West']      = function(adjust) return {x=(-1+((adjust+math.random())*-1)), y=0} end
            directions['Southwest'] = function(adjust) return {x=(-1+((adjust+math.random())*-1)), y=(-1+((adjust+math.random())*-1))} end
            directions['South']     = function(adjust) return {x=0, y=(-1+((adjust+math.random())*-1))} end
            directions['Southeast'] = function(adjust) return {x=(1+adjust+math.random()), y=(-1+((adjust+math.random())*-1))} end

            if __map[direction] then
                return directions[__map[direction]]((size/2) * scale)
            end

        end
        return {x=0, y=0}

    end

    pm.sideOffset = function(direction, size, scale)
        local directions = {}

        if direction and size and scale then

            directions['East']      = function(adjust) return {x=0, y=(1+adjust+math.random())} end
            directions['Northeast'] = function(adjust) return {x=(1+adjust+math.random()), y=(-1+((adjust+math.random())*-1))} end
            directions['North']     = function(adjust) return {x=(1+adjust+math.random()), y=0} end
            directions['Northwest'] = function(adjust) return {x=(1+adjust+math.random()), y=(1+adjust+math.random())} end
            directions['West']      = function(adjust) return {x=0, y=(1+adjust+math.random())} end
            directions['Southwest'] = function(adjust) return {x=(-1+((adjust+math.random())*-1)), y=(1+adjust+math.random())} end
            directions['South']     = function(adjust) return {x=(-1+((adjust+math.random())*-1)), y=0} end
            directions['Southeast'] = function(adjust) return {x=(-1+((adjust+math.random())*-1)), y=(-1+((adjust+math.random())*-1))} end

            if __map[direction] then
                return directions[__map[direction]]((size/2) * scale)
            end

        end
        return {x=0, y=0}

    end

    -- Public Methods.
    self.isGeocolure = function(name) return name:startswith("Geo-") end
    self.isIndicolure = function(name) return name:startswith("Indi-") end
    self.getPosition = function(position) return (position == 2) and 'SIDE' or 'FRONT' end    
    self.buildAction = function(target, param, category, position)

        if bp and target and param and category and position then
            local target = bp.__target.get(target)

            if target then
                local offset = (position == 2) and pm.sideOffset(pm.getDirection(bp.__actions.getFacing(target)), target.model_size, target.model_scale) or pm.frontOffset(pm.getDirection(bp.__actions.getFacing(target)), target.model_size, target.model_scale)
                
                if offset and offset.x and offset.y then
                    return bp.packets.new('outgoing', 0x01a, {
                        ["Target"]        = target.id,
                        ["Target Index"]  = target.index,
                        ["Category"]      = category,
                        ["Param"]         = param,
                        ['X Offset']      = offset.x,
                        ['Y Offset']      = offset.y,

                    })

                end

            end

        end
        return false

    end

    -- Private Events.

    return self

end
return library