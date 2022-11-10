local library = {}
function library:new(bp)
    local bp = bp

    -- Private Variables.
    local levels     = {270,271,272,273}
    local relics     = {"Spharai","Mandau","Excalibur","Ragnarok","Guttler","Bravura","Apocalypse","Gungnir","Kikoku","Amanomurakumo","Mjollnir","Claustrum","Yoichinoyumi","Annihilator"}
    local aftermaths = {
        
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
        ["Dojikiri Yasutsuna"]  = "Tashi: Shoha",
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
    self.weaponskill = function(weapon)
        return weapon and aftermaths[weapon] or false            
    end

    self.id = function(level)
        
        if self.checkRelic() then
            return levels[4]
        
        elseif level and levels[level] then
            return levels[level]

        end
        return false
        
    end

    self.active = function()
        
        for id in T(bp.player.buffs):it() do
                    
            if T(levels):contains(v) then
                return true
            end
            
        end
        return false

    end

    self.checkRelic = function() -- UPDATE!
        
    end

    return self

end
return library