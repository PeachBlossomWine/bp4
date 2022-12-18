local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __dummies = {{bp.res.spells[378], bp.res.spells[379]}, {bp.res.spells[409], bp.res.spells[410]}, {bp.res.spells[403], bp.res.spells[404]}}
    local __complex = {

        ["march"]       = {count=1, songs={"Honor March","Victory March","Advancing March"}},
        ["min"]         = {count=1, songs={"Valor Minuet V","Valor Minuet IV","Valor Minuet III","Valor Minuet II","Valor Minuet"}},
        ["mad"]         = {count=1, songs={"Blade Madrigal","Sword Madrigal"}},
        ["prelude"]     = {count=1, songs={"Archer's Prelude","Hunter's Prelude"}},
        ["minne"]       = {count=1, songs={"Knight's Minne V","Knight's Minne IV","Knight's Minne III","Knight's Minne II","Knight's Minne"}},
        ["ballad"]      = {count=1, songs={"Mage's Ballad III","Mage's Ballad II","Mage's Ballad"}},
        ["mambo"]       = {count=1, songs={"Dragonfoe Mambo","Sheepfoe Mambo"}},
        ["str"]         = {count=1, songs={"Herculean Etude","Sinewy Etude"}},
        ["dex"]         = {count=1, songs={"Uncanny Etude","Dextrous Etude"}},
        ["vit"]         = {count=1, songs={"Vital Etude","Vivacious Etude"}},
        ["agi"]         = {count=1, songs={"Swift Etude","Quick Etude"}},
        ["int"]         = {count=1, songs={"Sage Etude","Learned Etude"}},
        ["mnd"]         = {count=1, songs={"Logical Etude","Spirited Etude"}},
        ["chr"]         = {count=1, songs={"Bewitching Etude","Enchanting Etude"}},
        ["fire"]        = {count=1, songs={"Fire Carol","Fire Carol II"}},
        ["ice"]         = {count=1, songs={"Ice Carol","Ice Carol II"}},
        ["wind"]        = {count=1, songs={"Wind Carol","Wind Carol II"}},
        ["earth"]       = {count=1, songs={"Earth Carol","Earth Carol II"}},
        ["thunder"]     = {count=1, songs={"Lightning Carol","Lightning Carol II"}},
        ["water"]       = {count=1, songs={"Water Carol","Water Carol II"}},
        ["light"]       = {count=1, songs={"Light Carol","Light Carol II"}},
        ["dark"]        = {count=1, songs={"Dark Carol","Dark Carol II"}},

    }

    local __specific = {

        ["req1"]      = "Foe Requiem",          ["req2"]        = "Foe Requiem II",        ["req3"]      = "Foe Requiem III",      ["req4"]      = "Foe Requiem IV",
        ["req5"]      = "Foe Requiem V",        ["req6"]        = "Foe Requiem VI",        ["req7"]      = "Foe Requiem VII",      ["lull1"]     = "Foe Lullaby",
        ["lull2"]     = "Foe Lullaby II",       ["horde1"]      = "Horde Lullaby",         ["horde2"]    = "Horde Lullaby II",     ["army1"]     = "Army's Paeon",
        ["army2"]     = "Army's Paeon II",      ["army3"]       = "Army's Paeon III",      ["army4"]     = "Army's Paeon IV",
        ["army5"]     = "Army's Paeon V",       ["army6"]       = "Army's Paeon VI",       ["ballad1"]   = "Mage's Ballad",        ["ballad2"]   = "Mage's Ballad II",
        ["ballad3"]   = "Mage's Ballad III",    ["minne1"]      = "Knight's Minne",        ["minne2"]    = "Knight's Minne II",
        ["minne3"]    = "Knight's Minne III",   ["minne4"]      = "Knight's Minne IV",     ["minne5"]    = "Knight's Minne V",
        ["min1"]      = "Valor Minuet",         ["min2"]        = "Valor Minuet II",       ["min3"]      = "Valor Minuet III",     ["min4"]      = "Valor Minuet IV",
        ["min5"]      = "Valor Minuet V",       ["mad1"]        = "Sword Madrigal",        ["mad2"]      = "Blade Madrigal",
        ["lude1"]     = "Hunter's Prelude",     ["lude2"]       = "Archer's Prelude",      ["mambo1"]    = "Sheepfoe Mambo",       ["mambo2"]    = "Dragonfoe Mambo",
        ["herb1"]     = "Herb Pastoral",        ["shining1"]    = "Shining Fantasia",      ["oper1"]     = "Scop's Operetta",      ["oper2"]     = "Puppet's Operetta",
        ["gold1"]     = "Gold Capriccio",       ["round1"]      = "Warding Round",         ["gob1"]      = "Goblin Gavotte",       ["march1"]    = "Advancing March",
        ["march2"]    = "Victory March",        ["hm"]          = "Honor March",           ["elegy1"]    = "Battlefield Elegy",    ["elegy2"]    = "Carnage Elegy",
        ["str1"]      = "Sinewy Etude",         ["str2"]        = "Herculean Etude",       ["dex1"]      = "Dextrous Etude",       ["dex2"]      = "Uncanny Etude",
        ["vit1"]      = "Vivacious Etude",      ["vit2"]        = "Vital Etude",           ["agi1"]      = "Quick Etude",          ["agi2"]      = "Swift Etude",
        ["int1"]      = "Learned Etude",        ["int2"]        = "Sage Etude",            ["mnd1"]      = "Spirited Etude",       ["mnd2"]      = "Logical Etude",
        ["chr1"]      = "Enchanting Etude",     ["chr2"]        = "Bewitching Etude",      ["firec1"]    = "Fire Carol",           ["firec2"]    = "Fire Carol II",
        ["icec1"]     = "Ice Carol",            ["icec2"]       = "Ice Carol II",          ["windc1"]    = "Wind Carol",           ["windc2"]    = "Wind Carol II",
        ["earthc1"]   = "Earth Carol",          ["earthc2"]     = "Earth Carol II",        ["thunderc1"] = "Lightning Carol",      ["thunderc2"] = "Lightning Carol II",
        ["waterc1"]   = "Water Carol",          ["waterc2"]     = "Water Carol II",        ["lightc1"]   = "Light Carol",          ["lightc2"]   = "Light Carol II",
        ["darkc1"]    = "Dark Carol",           ["darkc2"]      = "Dark Carol II",         ["firet1"]    = "Fire Threnody",        ["firet2"]    = "Fire Threnody II",
        ["icet1"]     = "Ice Threnody",         ["icet2"]       = "Ice Threnody II",       ["windt1"]    = "Wind Threnody",        ["windt2"]    = "Wind Threnody II",
        ["eartht1"]   = "Earth Threnody",       ["eartht2"]     = "Earth Threnody II",     ["thundt1"]   = "Lightning Threnody",   ["thundt2"]   = "Lightning Threnody II",
        ["watert1"]   = "Water Threnody",       ["watert2"]     = "Water Threnody II",     ["lightt1"]   = "Light Threnody",       ["lightt2"]   = "Light Threnody II",
        ["darkt1"]    = "Dark Threnody",        ["darkt2"]      = "Dark Threnody II",      ["finale"]    = "Magic Finale",         ["ghym"]      = "Goddess's Hymnus",
        ["scherzo"]   = "Sentinel's Scherzo",   ["pining"]      = "Pining Nocturne",       ["zurka1"]    = "Raptor Mazurka",       ["zurka2"]    = "Chocobo Mazurka",
        ["fcarol1"]   = "Fire Carol",           ["fcarol2"]     = "Fire Carol II",         ["icarol1"]   = "Ice Carol",            ["icarol2"]   = "Ice Carol II",
        ["wcarol1"]   = "Wind Carol",           ["wcarol2"]     = "Wind Carol II",         ["ecarol1"]   = "Earth Carol",          ["ecarol2"]   = "Earth Carol II",
        ["tcarol1"]   = "Lightning Carol",      ["tcarol2"]     = "Lightning Carol II",    ["wcarol1"]   = "Water Carol",          ["waterc2"]   = "Water Carol II",
        ["lcarol1"]   = "Light Carol",          ["lcarol2"]     = "Light Carol II",        ["dcarol1"]   = "Dark Carol",           ["dcarol2"]   = "Dark Carol II",
        ["dirg"]      = "Adventurer's Dirge",   ["dirge"]       = "Adventurer's Dirge",    ["sirv"]      = "Foe Sirvente",         ["sirvente"]  = "Foe Sirvente",

    }
  
    -- Public Variables.
    self.list = T(bp.res.spells):map(function(spell) return spell.type == "BardSong" and spell.en or nil end)

    -- Private Methods.

    -- Public Methods.
    self.getComplex = function() return T(__complex):copy() end
    self.getSpecific = function(song) return __specific[song] end
    self.getDummies = function(mode) return __dummies[mode] end

    self.nitroReady = function()
        return (bp.__actions.isReady("Nightingale") and bp.__actions.isReady("Troubadour"))
    end

    self.svccReady = function()
        return (bp.__actions.isReady("Soul Voice") and bp.__actions.isReady("Clarion Call"))
    end

    self.hasHonorMarch = function()
        local bags = bp.__inventory.getBags('Everywhere', true)

        for bag in bags:it() do
            local match = T(bp.__inventory.findByName("Marsyas", bag.id))

            if match and #match > 0 then
                return match
            end

        end
        return false

    end

    self.getSongCount = function()
        local bags  = bp.__inventory.getBags('Everywhere', true)
        local items = T{}
        local max   = 2

        for bag in bags:it() do
            local matches = T(bp.__inventory.findByName({"Daurdabla","Terpander","Blurred Harp","Blurred Harp +1"}, bag.id))

            if matches and #matches > 0 then

                for match in matches:it() do
                    table.insert(items, match)
                end

            end

        end

        for item in items:it() do
            local index, count, id, status, bag, res = table.unpack(item)

            if res.en == 'Daurdabla' then
                return 4

            elseif S{"Terpander","Blurred Harp","Blurred Harp +1"}:contains(res.en) then
                max = 3

            end

        end
        return max

    end

    -- Private Events.

    return self

end
return library