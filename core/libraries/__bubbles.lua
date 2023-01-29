local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __indirecast  = false
    local __georecast   = false
  
    -- Public Variables.
    self.list = T(bp.res.spells):map(function(spell) return spell.type == "Geomancy" and spell.en or nil end)
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
    pm.handleRecast = function(id, original)

        if id == 0x028 and bp.core and bp.core.get('bubbles') and bp.core.get('bubbles').list then
            local parsed = bp.packets.parse('incoming', original)

            if parsed and parsed['Category'] == 4 then
                local indicolure = bp.core.get('bubbles').list[1]
                local geocolure = bp.core.get('bubbles').list[2]

                if bp.res.spells[parsed['Param']].en == indicolure then
                    __indirecast = false

                elseif bp.res.spells[parsed['Param']].en == geocolure then
                    __georecast = false

                end

            end

        end

    end

    -- Public Methods.
    self.active = function(id) return bp.__buffs and bp.__buffs.hasAura(id) or T{} end
    self.isGeocolure = function(name) return name and name:startswith("Geo-") or false end
    self.isIndicolure = function(name) return name and name:startswith("Indi-") or false end
    self.indiRecast = function() return __indirecast end
    self.geoRecast = function() return __georecast end
    self.recast = function(name, value)

        if name and name == 'indi' and type(value) == 'boolean' then
            __indirecast = value

        elseif name and name == 'geo' and type(value) == 'boolean' then
            __georecast = value

        end

    end

    -- Private Events.
    windower.register_event('incoming chunk', pm.handleRecast)

    return self

end
return library