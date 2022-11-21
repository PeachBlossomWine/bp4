local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local subjobs   = bp.files.new('core/jobs/resources/subjobs.lua'):exists() and dofile(string.format('%score/jobs/resources/subjobs.lua', windower.addon_path)) or {}
    local switches  = bp.files.new('core/jobs/resources/switches.lua'):exists() and dofile(string.format('%score/jobs/resources/switches.lua', windower.addon_path)) or {}
    local timers    = {}
    local base      = {

        ["__version"]               = {_addon.version},
        ["am"]                      = {enabled=false, tp=3000},
        ["ra"]                      = {enabled=false, tp=1000, name="Hot Shot"},
        ["ws"]                      = {enabled=false, tp=1000, name="Combo"},
        ["hate"]                    = {enabled=false, delay=2, aoe=false},
        ["mb"]                      = {enabled=false, element="Fire", tier=2, multi=false},
        ["skillup"]                 = {enabled=false, skill="Enhancing Magic"},
        ["food"]                    = {enabled=false, name=""},
        ["limit"]                   = {enabled=false, hpp=10},
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
        },

        ["MNK"] = {
            ["footwork"]            = {enabled=false, impetus=false},
            ["chakra"]              = {enabled=false, hpp=45},
            ["chi blast"]           = false,
            ["dodge"]               = false,
            ["focus"]               = false,
            ["impetus"]             = false,
            ["counterstance"]       = false,
            ["mantra"]              = false,
            ["formless strikes"]    = false,
            ["perfect counter"]     = false,
        },

        ["WHM"] = {
            ["martyr"]              = {enabled=false, hpp=45, target=""},
            ["devotion"]            = {enabled=false, mpp=45, target=""},
            ["boost"]               = {enabled=false, name="Boost-STR"},
            ["moonlight"]           = {enabled=false, mpp=45},
            ["misery"]              = false,
            ["sacrosanctity"]       = false,
            ["aquaveil"]            = false,
            ["blink"]               = false,
            ["stoneskin"]           = false,
            ["auspice"]             = false,
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
        },

        ["RDM"] = {
            ["en"]                  = {enabled=false, name="Enfire", tier=1},
            ["spikes"]              = {enabled=false, name="Blaze Spikes"},
            ["gain"]                = {enabled=false, name="Gain-DEX"},
            ["convert"]             = {enabled=false, mpp=55, hpp=55},
            ["sanguine blade"]      = {enabled=false, hpp=55},
            ["composure"]           = false,
            ["saboteur"]            = false,
            ["spontaneity"]         = false,
            ["blink"]               = false,
            ["aquaveil"]            = false,
            ["stoneskin"]           = false,
        },

        ["THF"] = {
            ["steal"]               = false,
            ["sneak attack"]        = false,
            ["flee"]                = false,
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
            ["holy circle"]         = false,
            ["shield bash"]         = false,
            ["sentinel"]            = false,
            ["rampart"]             = false,
            ["majesty"]             = false,
            ["fealty"]              = false,
            ["divine emblem"]       = false,
            ["sepulcher"]           = false,
            ["palisade"]            = false,
        },

        ["DRK"] = {
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
            ["spikes"]              = false,
        },

        ["BST"] = {
            ["reward"]              = {enabled=false, pet_hpp=55},
            ["ready"]               = {enabled=false, ""},
            ["call beast"]          = false,
            ["bestial loyalty"]     = false,
            ["killer instinct"]     = false,
            ["fight"]               = false,
            ["snarl"]               = false,
            ["spur"]                = false,
            ["run wild"]            = false,
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
            ["bpr"]                 = {enabled=false, pacts={}},
            ["bpw"]                 = {enabled=false, pacts={}},
            ["myrkr"]               = {enabled=false, mpp=45},
            ["elemental siphon"]    = {enabled=false, mpp=55},
            ["apogee"]              = false,
            ["mana cede"]           = false,
            ["assault"]             = false,
            ["rotate"]              = false,
            ["mbpact"]              = false,
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
        },

        ["DRG"] = {
            ["call wyvern"]         = false,
            ["ancient circle"]      = false,
            ["jump"]                = false,
            ["high jump"]           = false,
            ["super jump"]          = false,
            ["deep breathing"]      = false,
            ["angon"]               = false,
            ["spirit jump"]         = false,
            ["soul jump"]           = false,
            ["dragon breaker"]      = false,
            ["smiting breath"]      = false,
            ["restoring breath"]    = false,
            ["steady wing"]         = false,
        },

        ["BLU"] = {
            ["tickle"]              = {enabled=false, delay=45},
            ["sanguine blade"]      = {enabled=false, hpp=55},
            ["moonlight"]           = {enabled=false, mpp=45},
            ["aspir"]               = {enabled=false, mpp=45},
            ["hammer"]              = {enabled=false, mpp=30},
            ["burst affinity"]      = false,
            ["chain affinity"]      = false,
            ["convergence"]         = false,
            ["diffusion"]           = false,
            ["efflux"]              = false,
            ["winds"]               = false,
            ["unbridled learning"]  = false,
        },

        ["COR"] = {
            ["quick draw"]          = {enabled=false, name="Light Shot"},
            ["rolls"]               = false,
            ["random deal"]         = false,
            ["triple shot"]         = false,
        },

        ["PUP"] = {
            ["maneuvers"]           = {enabled=false, maneuver1="Fire Maneuver", maneuver2="Wind Maneuver", maneuver3="Light Maneuver"},
            ["repair"]              = {enabled=false, pet_hpp=55},
            ["activate"]            = false,
            ["maintenance"]         = false,
            ["cooldown"]            = false,
            ["deploy"]              = false,
        },

        ["DNC"] = {
            ["flourishes"]          = {enabled=false, cat_1="Animated Flourish", cat_2="Reverse Flourish", cat_3="Climactic Flourish"},
            ["sambas"]              = {enabled=false, name="Haste Samba"},
            ["steps"]               = {enabled=false, name="Quickstep"},
            ["jigs"]                = {enabled=false, name="Chocobo Jig"},
            ["contradance"]         = false,
            ["saber dance"]         = false,
            ["fan dance"]           = false,
            ["foot rise"]           = false,
            ["presto"]              = false,
        },

        ["SCH"] = {
            ['gems']                = {enabled=false, penury={}, celerity={}, accession={}, rapture={}, perpetuance={}, parsimony={}, alacrity={}, manifestation={}, ebullience={}},
            ["spikes"]              = {enabled=false, name="Blaze Spikes"},
            ["helix"]               = {enabled=false, name="Pyrohelix"},
            ["storms"]              = {enabled=false, name="Firestorm"},
            ["skillchain"]          = {enabled=false, mode="Fusion"},
            ["sublimation"]         = {enabled=false, mpp=65},
            ["drain"]               = {enabled=false, hpp=55},
            ["aspir"]               = {enabled=false, mpp=55},
            ["myrkr"]               = {enabled=false, mpp=45},
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
            ["full circle"]         = {enabled=false, distance=22},
            ["drain"]               = {enabled=false, hpp=55},
            ["aspir"]               = {enabled=false, mpp=55},
            ["radial"]              = {enabled=false, mpp=55},
            ["moonlight"]           = {enabled=false, mpp=45},
            ["theurgic focus"]      = false,
            ["lasting emanation"]   = false,
            ["ecliptic attrition"]  = false,
            ["life cycle"]          = false,
            ["blaze of glory"]      = false,
            ["dematerialize"]       = false,
        },

        ["RUN"] = {
            ["spikes"]              = {enabled=false, name="Blaze Spikes"},
            ["vivacious pulse"]     = {enabled=false, hpp=55, mpp=55},
            ["embolden"]            = {enabled=false, name=""},
            ["sanguine blade"]      = {enabled=false, hpp=55},
            ["runes"]               = false,
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
        },

    }

    -- Public Methods.
    self.getSubjob = function(job) return subjobs[job] and subjobs[job] end
    self.getJob = function(job)
        if not job then return end
        local file = bp.files.new(string.format('core/jobs/%s.lua', job:lower()))

        if file:exists() then
            return dofile(string.format('%score/jobs/%s.lua', windower.addon_path, job:lower()))
        end
        return false
    
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
            bp.helpers.popchat.pop("SETTINGS HAVE BEEN UPDATED TO THE LATEST VERSION!")
        end

    end

    self.set = function(settings, commands)
        local command = commands[1] and table.remove(commands, 1):lower() or false

        if switches and settings and commands then
            local match = false

            for _,switch in T(switches):it() do
                
                if switch:lower():startswith(command) and switches[switch] then
                    switches[switch](bp, settings[switch], commands)
                    match = true

                end 
            
            end

            if not match and settings[command] ~= nil then

                if switches[command] then
                    switches[command](bp, settings[command], commands)

                else
                        
                    if S{"!","#"}:contains(commands[1]) then
                        self.hardSet(settings[command], commands)

                    else
                        settings[command] = settings[command] ~= true and true or false
                        bp.helpers.popchat.pop(string.format('%s: \\cs(%s)%s\\cr', command:upper(), bp.colors.setting, tostring(settings[command]):upper()))

                    end

                end

            end

        end

    end

    self.hardSet = function(setting, commands)

        if #commands > 0 then
            local option = S{"!","#"}:contains(commands[1]) and table.remove(commands, 1) or false

            if type(setting) == 'table' and setting.enabled ~= nil then
                setting.enabled = (option == "!") and true or false

            elseif type(setting) == 'boolean' then
                setting = (option == "!") and true or false

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
                        local is_nin = (player.main_job == 'NIN' or player.sub_job == 'NIN') and true or false

                        if is_nin and (spell.en):match('Utsusemi') then
                            timers.utsusemi = os.clock()
                        end

                    end

                end

            end

        end

    end)

    return self

end
return library