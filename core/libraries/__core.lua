local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local switches  = bp.files.new('core/jobs/resources/switches.lua'):exists() and dofile(string.format('%score/jobs/resources/switches.lua', windower.addon_path)) or {}
    local timers    = {}
    local base      = {

        ["__version"]               = {_addon.version},
        ["am"]                      = {enabled=false, tp=3000},
        ["rws"]                     = {enabled=false, tp=1000, name="Hot Shot"},
        ["ws"]                      = {enabled=false, tp=1000, name="Combo"},
        ["hate"]                    = {enabled=false, delay=2, aoe=false},
        ["mb"]                      = {enabled=false, element="Fire", tier=2, multi=false},
        ["skillup"]                 = {enabled=false, skill="Enhancing Magic"},
        ["food"]                    = {enabled=false, name=""},
        ["limit"]                   = {enabled=false, hpp=10, option=">"},
        ["ra"]                      = false,
        ["items"]                   = false,
        ["buffs"]                   = false,
        ["debuffs"]                 = false,
        ["tank"]                    = false,
        ["1hr"]                     = false,
        ["ja"]                      = false,
        ["nuke"]                    = false,

        ["WAR"] = {
            ["sanguine blade"]      = {enabled=false, hpp=45},
            ["moonlight"]           = {enabled=false, mpp=45},
            ["provoke"]             = false,
            ["berserk"]             = false,
            ["defender"]            = false,
            ["warcry"]              = false,
            ["aggressor"]           = false,
            ["retaliation"]         = false,
            ["warrior's charge"]    = false,
            ["tomahawk"]            = false,
            ["restraint"]           = false,
            ["blood rage"]          = false,
            ["mighty strikes"]      = false,
            ["brazen rush"]         = false,
        },

        ["MNK"] = {
            ["chakra"]              = {enabled=false, hpp=45},
            ["impetus"]             = false,
            ["footwork"]            = false,
            ["chi blast"]           = false,
            ["dodge"]               = false,
            ["focus"]               = false,
            ["counterstance"]       = false,
            ["mantra"]              = false,
            ["formless strikes"]    = false,
            ["perfect counter"]     = false,
            ["hundred fists"]       = false,
            ["inner strength"]      = false,
        },

        ["WHM"] = {
            ["martyr"]              = {enabled=false, hpp=45, target=""},
            ["devotion"]            = {enabled=false, mpp=45, target=""},
            ["boost"]               = {enabled=false, name="Boost-STR"},
            ["moonlight"]           = {enabled=false, mpp=45},
            ["cures"]               = false,
            ["status"]              = false,
            ["divine seal"]         = false,
            ["solace"]              = false,
            ["misery"]              = false,
            ["sacrosanctity"]       = false,
            ["sacrifice"]           = false,
            ["aquaveil"]            = false,
            ["blink"]               = false,
            ["stoneskin"]           = false,
            ["auspice"]             = false,
            ["haste"]               = false,
            ["protect"]             = false,
            ["shell"]               = false,
            ["regen"]               = false,
            ["benediction"]         = false,
            ["asylum"]              = false,
        },

        ["BLM"] = {
            ["spikes"]              = {enabled=false, name="Blaze Spikes"},
            ["cascade"]             = {enabled=false, tp=1000},
            ["drain"]               = {enabled=false, hpp=55},
            ["aspir"]               = {enabled=false, mpp=55},
            ["myrkr"]               = {enabled=false, mpp=45},
            ["elemental seal"]      = false,
            ["mana wall"]           = false,
            ["enmity douse"]        = false,
            ["manawell"]            = false,
            ["manafont"]            = false,
            ["subtle sorcery"]      = false,
        },

        ["RDM"] = {
            ["en"]                  = {enabled=false, name="Enfire", tier=1},
            ["spikes"]              = {enabled=false, name="Blaze Spikes"},
            ["gain"]                = {enabled=false, name="Gain-DEX"},
            ["convert"]             = {enabled=false, mpp=55, hpp=55},
            ["sanguine blade"]      = {enabled=false, hpp=55},
            ["cures"]               = false,
            ["composure"]           = false,
            ["saboteur"]            = false,
            ["spontaneity"]         = false,
            ["blink"]               = false,
            ["aquaveil"]            = false,
            ["stoneskin"]           = false,
            ["haste"]               = false,
            ["phalanx"]             = false,
            ["temper"]              = false,
        },

        ["THF"] = {
            ["steal"]               = false,
            ["sneak attack"]        = false,
            ["trick attack"]        = false,
            ["mug"]                 = false,
            ["assassin's charge"]   = false,
            ["feint"]               = false,
            ["despoil"]             = false,
            ["conspirator"]         = false,
            ["bully"]               = false,
        },

        ["PLD"] = {
            ["chivalry"]            = {enabled=false, mpp=55, tp=1500},
            ["cover"]               = {enabled=false, target=""},
            ["sanguine blade"]      = {enabled=false, hpp=55},
            ["moonlight"]           = {enabled=false, mpp=45},
            ["cures"]               = false,
            ["holy circle"]         = false,
            ["shield bash"]         = false,
            ["sentinel"]            = false,
            ["rampart"]             = false,
            ["majesty"]             = false,
            ["fealty"]              = false,
            ["divine emblem"]       = false,
            ["sepulcher"]           = false,
            ["palisade"]            = false,
            ["flash"]               = false,
            ["reprisal"]            = false,
            ["phalanx"]             = false,
            ["crusade"]             = false,
            ["enlight"]             = false,
            ["invincible"]          = false,
            ["intervene"]           = false,
        },

        ["DRK"] = {
            ["spikes"]              = {enabled=false, name="Blaze Spikes"},
            ["absorb"]              = {enabled=false, name="Absorb-ACC"},
            ["drain"]               = {enabled=false, hpp=55},
            ["aspir"]               = {enabled=false, mpp=55},
            ["sanguine blade"]      = {enabled=false, hpp=55},
            ["moonlight"]           = {enabled=false, mpp=45},
            ["arcane circle"]       = false,
            ["last resort"]         = false,
            ["weapon bash"]         = false,
            ["souleater"]           = false,
            ["consume mana"]        = false,
            ["dark seal"]           = false,
            ["diabolic eye"]        = false,
            ["nether void"]         = false,
            ["arcane crest"]        = false,
            ["scarlet delirium"]    = false,
            ["endark"]              = false,
            ["stun"]                = false,
            ["blood weapon"]        = false,
            ["soul enslavement"]    = false,
        },

        ["BST"] = {
            ["reward"]              = {enabled=false, pet_hpp=55},
            ["ready"]               = {enabled=false, moves=""},
            ["call beast"]          = false,
            ["bestial loyalty"]     = false,
            ["killer instinct"]     = false,
            ["fight"]               = false,
            ["snarl"]               = false,
            ["spur"]                = false,
            ["run wild"]            = false,
            ["unleash"]             = false,
        },

        ["RNG"] = {
            ["decoy shot"]          = {enabled=false, target=""},
            ["sharpshot"]           = false,
            ["scavenge"]            = false,
            ["camouflage"]          = false,
            ["barrage"]             = false,
            ["velocity shot"]       = false,
            ["unlimited shot"]      = false,
            ["flashy shot"]         = false,
            ["stealth shot"]        = false,
            ["double shot"]         = false,
            ["bounty shot"]         = false,
            ["hover shot"]          = false,
        },

        ["SMN"] = {
            ["summon"]              = {enabled=false, name="Carbuncle"},
            ["bpr"]                 = {enabled=false, pacts={["Ifrit"]="Flaming Crush"}},
            ["bpw"]                 = {enabled=false, pacts={["Ifrit"]="Crimson Howl"}},
            ["myrkr"]               = {enabled=false, mpp=45},
            ["elemental siphon"]    = {enabled=false, mpp=55},
            ["apogee"]              = false,
            ["mana cede"]           = false,
            ["assault"]             = false,
            ["rotate"]              = false,
            ["mbpact"]              = false,
            ["astral flow"]         = false,
            ["astral conduit"]      = false,
        },

        ["SAM"] = {
            ["shikikoyo"]           = {enabled=false, tp=1500, target=""},
            ["moonlight"]           = {enabled=false, mpp=45},
            ["warding circle"]      = false,
            ["third eye"]           = false,
            ["hasso"]               = false,
            ["meditate"]            = false,
            ["seigan"]              = false,
            ["sekkanoki"]           = false,
            ["konzen-ittai"]        = false,
            ["blade bash"]          = false,
            ["sengikori"]           = false,
            ["hamanoha"]            = false,
            ["hagakure"]            = false,
        },

        ["NIN"] = {
            ["yonin"]               = false,
            ["innin"]               = false,
            ["sange"]               = false,
            ["futae"]               = false,
            ["issekigan"]           = false,
            ["utsusemi"]            = false,
            ["mikage"]              = false,
        },

        ["DRG"] = {
            ["call wyvern"]         = false,
            ["ancient circle"]      = false,
            ["jump"]                = false,
            ["high jump"]           = false,
            ["super jump"]          = false,
            ["spirit jump"]         = false,
            ["soul jump"]           = false,
            ["deep breathing"]      = false,
            ["angon"]               = false,
            ["dragon breaker"]      = false,
            ["smiting breath"]      = false,
            ["restoring breath"]    = false,
            ["steady wing"]         = false,
            ["spirit surge"]        = false,
            ["fly high"]            = false,
        },

        ["BLU"] = {
            ["diffusion"]           = {enabled=false, name="Mighty Guard"},
            ["sanguine blade"]      = {enabled=false, hpp=55},
            ["moonlight"]           = {enabled=false, mpp=45},
            ["magic hammer"]        = {enabled=false, mpp=30},
            ["cures"]               = false,
            ["burst affinity"]      = false,
            ["chain affinity"]      = false,
            ["convergence"]         = false,
            ["efflux"]              = false,
            ["unbridled learning"]  = false,
            ["azure lore"]          = false,
            ["unbridled wisdom"]    = false,
        },

        ["COR"] = {
            ["quick draw"]          = {enabled=false, name="Light Shot"},
            ["rolls"]               = {enabled=false, list={"Chaos Roll","Samurai Roll"}},
            ["crooked cards"]       = false,
            ["random deal"]         = false,
            ["triple shot"]         = false,
        },

        ["PUP"] = {
            ["maneuvers"]           = {enabled=false, list={}},
            ["repair"]              = {enabled=false, hpp=55},
            ["activate"]            = false,
            ["cooldown"]            = false,
            ["deploy"]              = false,
        },

        ["DNC"] = {
            ["sambas"]              = {enabled=false, name="Haste Samba"},
            ["steps"]               = {enabled=false, name="Quickstep"},
            ["cures"]               = false,
            ["animated flourish"]   = false,
            ["violent flourish"]    = false,
            ["reverse flourish"]    = false,
            ["building flourish"]   = false,
            ["wild flourish"]       = false,
            ["climactic flourish"]  = false,
            ["striking flourish"]   = false,
            ["ternary flourish"]    = false,
            ["contradance"]         = false,
            ["saber dance"]         = false,
            ["fan dance"]           = false,
            ["no foot rise"]        = false,
            ["presto"]              = false,
            ["trance"]              = false,
            ["grand pas"]           = false,
        },

        ["SCH"] = {
            ["gems"]                = {enabled=false, penury=false, celerity=false, accession=false, rapture=false, perpetuance=false, parsimony=false, alacrity=false, manifestation=false, ebullience=false},
            ["helix"]               = {enabled=false, name="Pyrohelix", tier=1},
            ["spikes"]              = {enabled=false, name="Blaze Spikes"},
            ["storms"]              = {enabled=false, name="Firestorm"},
            ["skillchain"]          = {enabled=false, mode="Fusion"},
            ["sublimation"]         = {enabled=false, mpp=65},
            ["drain"]               = {enabled=false, hpp=55},
            ["aspir"]               = {enabled=false, mpp=55},
            ["myrkr"]               = {enabled=false, mpp=45},
            ["cures"]               = false,
            ["status"]              = false,
            ["light arts"]          = false,
            ["addendum"]            = false,
            ["modus veritas"]       = false,
            ["enlightenment"]       = false,
            ["libra"]               = false,
            ["aquaveil"]            = false,
            ["blink"]               = false,
            ["stoneskin"]           = false,
        },

        ["GEO"] = {
            ["bubbles"]             = {enabled=false, list={"Indi-Fury","Geo-Frailty","Indi-Haste"}},
            ["full circle"]         = {enabled=false, distance=22},
            ["drain"]               = {enabled=false, hpp=55},
            ["aspir"]               = {enabled=false, mpp=55},
            ["radial arcana"]       = {enabled=false, mpp=55},
            ["mending halation"]    = {enabled=false, hpp=55},
            ["moonlight"]           = {enabled=false, mpp=45},
            ["theurgic focus"]      = false,
            ["lasting emanation"]   = false,
            ["ecliptic attrition"]  = false,
            ["life cycle"]          = false,
            ["blaze of glory"]      = false,
            ["dematerialize"]       = false,
            ["indicolure"]          = false,
            ["geocolure"]           = false,
            ["entrust"]             = false,
        },

        ["RUN"] = {
            ["spikes"]              = {enabled=false, name="Blaze Spikes"},
            ["runes"]               = {enabled=false, list={"Ignis","Ignis","Ignis"}},
            ["vivacious pulse"]     = {enabled=false, hpp=55, mpp=55},
            ["embolden"]            = {enabled=false, name="Temper"},
            ["sanguine blade"]      = {enabled=false, hpp=55},
            ["vallation"]           = false,
            ["swordplay"]           = false,
            ["swipe"]               = false,
            ["lunge"]               = false,
            ["pflug"]               = false,
            ["valiance"]            = false,
            ["gambit"]              = false,
            ["battuta"]             = false,
            ["rayke"]               = false,
            ["liement"]             = false,
            ["one for all"]         = false,
            ["aquaveil"]            = false,
            ["blink"]               = false,
            ["stoneskin"]           = false,
            ["temper"]              = false,
            ["flash"]               = false,
            ["foil"]                = false,
            ["refresh"]             = false,
            ["phalanx"]             = false,
            ["regen"]               = false,
            ["crusade"]             = false,
            ["elemental sforzo"]    = false,
            ["odyllic subterfuge"]  = false,
        },

    }

    -- Public Methods.
    self.getJob = function(job)

        if job then
            local file = bp.files.new(string.format('core/jobs/%s.lua', job:lower()))

            if file:exists() then
                return setmetatable(dofile(string.format('%score/jobs/%s.lua', windower.addon_path, job:lower())), {__index = function(t, key)
                    
                    if rawget(t, key) ~= nil then
                        return rawget(t, key)            
                    
                    else
                        return (function() return end)
                
                    end
                
                end})

            end

        elseif not job then
            return {init = function() return {automate = function() return end} end}

        end
    
    end

    self.newSettings = function() return T(base):copy() end
    self.updateSettings = function(settings)
        local flagged = false

        if settings and (not settings.__version or not _addon.version == settings.__version) then

            for values, index in T(base):it() do
                
                if T{'WAR','MNK','WHM','BLM','RDM','THF','PLD','DRK','BST','BRD','RNG','SMN','SAM','NIN','DRG','BLU','COR','PUP','DNC','SCH','GEO','RUN'}:contains(index) then

                    if settings[index] == nil then
                        settings[index] = values
                        flagged = true

                    else

                        for updated, name in T(values):it() do
                            
                            if settings[index][name] == nil then
                                settings[index][name] = updated
                                flagged = true

                            end

                        end

                    end

                else

                    if settings[index] == nil then
                        settings[index] = values
                        flagged = true

                    end

                end

            end

        end
        
        if flagged then
            bp.popchat.pop("SETTINGS HAVE BEEN UPDATED TO THE LATEST VERSION!")
        end

    end

    self.set = function(settings, commands)
        local commands  = type(commands) == 'string' and T(commands:split(" ")) or commands
        local command   = commands[1] and table.remove(commands, 1):lower() or false
        
        if switches and settings and command then
            local setting = settings():keyfind(function(key) return key:gsub(' ', ''):startswith(command) end) or T(settings[bp.player.sub_job]):keyfind(function(key) return key:gsub(' ', ''):startswith(command) end) or T(settings[bp.player.main_job]):keyfind(function(key) return key:gsub(' ', ''):startswith(command) end)

            if switches[setting] then
                switches[setting](bp, settings[setting], commands)

                --[[ ???
                for _,switch in T(switches):it() do

                    if switch:lower():startswith(command) and switches[switch] then
                        switches[switch](bp, settings[switch], commands)
                    end 
                
                end
                ]]

            elseif settings[setting] ~= nil then

                if S{"!","#"}:contains(commands[1]) then
                    settings[setting] = self.hardSet(settings[setting], commands)
                    bp.popchat.pop(string.format('%s: \\cs(%s)%s\\cr', setting:upper(), bp.colors.setting, tostring(settings[setting]):upper()))

                else
                    settings[setting] = settings[setting] ~= true and true or false
                    bp.popchat.pop(string.format('%s: \\cs(%s)%s\\cr', setting:upper(), bp.colors.setting, tostring(settings[setting]):upper()))

                end

            end

        end

    end

    self.hardSet = function(setting, commands)
        
        if #commands > 0 then
            local option = S{"!","#"}:contains(commands[1]) and table.remove(commands, 1) or false

            if option and type(setting) == 'table' and setting.enabled ~= nil then
                setting.enabled = (option == "!") and true or false

            elseif option and type(setting) == 'boolean' then
                return (option == "!") and true or false

            end

        end

    end

    -- Private Events.
    windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)

        if bp and id == 0x028 then
            local parsed    = bp.packets.parse('incoming', original)
            local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
            local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
            local category  = parsed['Category']
            local param     = parsed['Param']
            
            if bp.player and actor and target and bp.player.id == actor.id and actor.id == target.id then

                if category == 4 and bp.res.spells[param] then
                    local spell = bp.res.spells[param]

                    if spell.type then
                        timers.utsusemi = (bp.player.main_job == 'NIN' or bp.player.sub_job == 'NIN') and os.clock() or timers.utsusemi
                    end

                end

            end

        end

    end)

    return self

end
return library