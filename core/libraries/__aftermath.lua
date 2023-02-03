local library = {}
function library:new(bp)
    local bp = bp

    -- Private Variables.
    local __level       = {270,271,272}
    local __levels      = {270,271,272,273}
    local __relics      = {"Spharai","Mandau","Excalibur","Ragnarok","Guttler","Bravura","Apocalypse","Gungnir","Kikoku","Amanomurakumo","Mjollnir","Claustrum","Yoichinoyumi","Annihilator"}
    local __aftermaths  = {
        
        ["Verethragna"]         = "Victory Smite",
        ["Glanzfaust"]          = "Ascetic's Fury",
        ["Kenkonken"]           = "Stringing Pummel",
        ["Godhands"]            = "Shijin Spiral",
        ["Twashtar"]            = "Rudra's Storm",
        ["Vajra"]               = "Mandalic Stab",
        ["Carnwenhan"]          = "Mordant Rime",
        ["Terpsichore"]         = "Pyrrihic Kleos",
        ["Aeneas"]              = "Exenterator",
        ["Almace"]              = "Chant du Cygne",
        ["Burtgang"]            = "Atonement",
        ["Murgleis"]            = "Death Blossom",
        ["Tizona"]              = "Expiacion",
        ["Sequence"]            = "Requiescat",
        ["Caladbolg"]           = "Torcleaver",
        ["Epeolatry"]           = "Dimidiation",
        ["Lionheart"]           = "Resolution",
        ["Farsha"]              = "Cloudsplitter",
        ["Aymur"]               = "Primal Rend",
        ["Tri-edge"]            = "Ruinator",
        ["Ukonvasara"]          = "Ukko's Fury",
        ["Conqueror"]           = "King's Justice",
        ["Chango"]              = "Upheaval",
        ["Redemption"]          = "Quietus",
        ["Liberator"]           = "Insurgency",
        ["Anguta"]              = "Entropy",
        ["Rhongomiant"]         = "Camlann's Torment",
        ["Ryunohige"]           = "Drakesbane",
        ["Trishula"]            = "Stardiver",
        ["Kannagi"]             = "Blade: Hi",
        ["Nagi"]                = "Blade: Kamu",
        ["Heishi Shorinken"]    = "Blade: Shun",
        ["Masamune"]            = "Tachi: Fudo",
        ["Kogarasumaru"]        = "Tachi: Rana",
        ["Dojikiri Yasutsuna"]  = "Tachi: Shoha",
        ["Gambateinn"]          = "Dagan",
        ["Yagrush"]             = "Mystic Boon",
        ["Idris"]               = "Exudation",
        ["Tishtrya"]            = "Realmrazer",
        ["Hvergelmir"]          = "Myrkr",
        ["Laevteinn"]           = "Vidohunir",
        ["Nirvana"]             = "Garland of Bliss",
        ["Tupsimati"]           = "Omniscience",
        ["Khatvanga"]           = "Shattersoul",
        ["Gandiva"]             = "Jishnu's Radiance",
        ["Fail-not"]            = "Apex Arrow",
        ["Armageddon"]          = "Wildfire",
        ["Gastraphetes"]        = "Trueflight",
        ["Death Penalty"]       = "Leaden Salute",
        ["Fomalhaut"]           = "Last Stand",
        ["Spharai"]             = "Final Heaven",
        ["Mandau"]              = "Mercy Stroke",
        ["Excalibur"]           = "Kights of Round",
        ["Ragnarok"]            = "Scourge",
        ["Guttler"]             = "Onslaught",
        ["Bravura"]             = "Metatron Torment",
        ["Apocalypse"]          = "Catastrophe",
        ["Gungnir"]             = "Geirskogul",
        ["Kikoku"]              = "Blade: Metsu",
        ["Amanomurakumo"]       = "Tachi: Kaiten",
        ["Mjollnir"]            = "Randgrith",
        ["Claustrum"]           = "Gates of Tartarus",
        ["Yoichinoyumi"]        = "Namas Arrow",
        ["Annihilator"]         = "Coronach",
        
    }

    -- Public Methods.
    self.weaponskill = function(weapon) return weapon and __aftermaths[weapon] or false end
    self.active = function()
        
        for id in T(bp.player.buffs):it() do
                    
            if T(__levels):contains(id) then
                return true
            end
            
        end
        return false

    end

    self.canReplace = function()
        if not bp.core.get('am') then return false end

        for id in T(bp.player.buffs):it() do

            if T(__levels):contains(id) then
                local level = __level[id]

                if level and bp.core.get('am').level > level then
                    return true
                end

            end

        end

    end

    self.getWeapon = function()

        if T{'COR','RNG'}:contains(bp.player.main_job) then
            return bp.__inventory.getByIndex(bp.__equipment.get(2).bag, bp.__equipment.get(2).index)

        else
            return bp.__inventory.getByIndex(bp.__equipment.get(0).bag, bp.__equipment.get(0).index)

        end
        return nil

    end

    self.getAvailable = function()
        local available = {}

        for slot in T{0,2}:it() do
            local index, count, id, status, bag, resource = bp.__inventory.getByIndex(bp.__equipment.get(slot).bag, bp.__equipment.get(slot).index)

            if index and resource and __aftermaths[resource.en] then
                table.insert(available, __aftermaths[resource.en])
            end

        end
        return available

    end

    return self

end
return library