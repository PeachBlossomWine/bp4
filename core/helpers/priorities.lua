local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local __ja      = bp.__settings.new("/priorities/abilities")
    local __ma      = bp.__settings.new("/priorities/spells")
    local __ws      = bp.__settings.new("/priorities/skills")
    local __it      = bp.__settings.new("/priorities/items")
    local base      = {
        
        __ja = bp.files.new('core/resources/priorities/__ja.lua'):exists() and dofile(string.format('%score/resources/priorities/__ja.lua', windower.addon_path)) or {},
        __ma = bp.files.new('core/resources/priorities/__ma.lua'):exists() and dofile(string.format('%score/resources/priorities/__ma.lua', windower.addon_path)) or {},
        __ws = bp.files.new('core/resources/priorities/__ws.lua'):exists() and dofile(string.format('%score/resources/priorities/__ws.lua', windower.addon_path)) or {},
        __it = bp.files.new('core/resources/priorities/__it.lua'):exists() and dofile(string.format('%score/resources/priorities/__it.lua', windower.addon_path)) or {},

    }

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        
        do -- Private Settings.
            __ja.priorities = __ja.priorities or base.__ja
            __ma.priorities = __ma.priorities or base.__ma
            __ws.priorities = __ws.priorities or base.__ws
            __it.priorities = __it.priorities or base.__it

        end

        -- Private Methods.
        pvt.set = function(resource, value)
            local resource = bp.MA[resource] or bp.JA[resource] or bp.WS[resource] or bp.IT[resource] or false
            local value = tonumber(value)
    
            if resource and value and new.get(resource.en) then
                
                if S{'/jobability','/pet'}:contains(resource.prefix) then
                    __ja.priorities[resource.id] = value
    
                elseif S{'/magic','/ninjutsu','/song'}:contains(resource.prefix) then
                    __ma.priorities[resource.id] = value
    
                elseif S{'/weaponskill'}:contains(resource.prefix) then
                    __ws.priorities[resource.id] = value
    
                elseif resource.flags and resource.flags:contains('Usable') then
                    __it.priorities[resource.id] = value
    
                end
    
            end

        end
        
        -- Public Methods.
        new.get = function(resource)
            local resource = bp.MA[resource] or bp.JA[resource] or bp.WS[resource] or bp.IT[resource] or false
    
            if resource then
                
                if S{'/jobability','/pet'}:contains(resource.prefix) then
                    return __ja.priorities[resource.id] or 1
    
                elseif S{'/magic','/ninjutsu','/song'}:contains(resource.prefix) then
                    return __ma.priorities[resource.id] or 1
    
                elseif S{'/weaponskill'}:contains(resource.prefix) then
                    return __ws.priorities[resource.id] or 1
    
                elseif resource.flags and resource.flags:contains('Usable') then
                    return __it.priorities[resource.id] or 1
    
                end
    
            end
            return 1
    
        end

        new.setupBase = function()
            local specific = T{

                ["Megalixir"]           = 250,
                ["Vile Elixir +1"]      = 250,
                ["Full Circle"]         = 102,
                ["Radial Arcana"]       = 101,
                ["Mending Halation"]    = 101,
                ["Blaze of Glory"]      = 99,
                ["Lasting Emanation"]   = 97,
                ["Ecliptic Attrition"]  = 97,
                ["Dematerialize"]       = 96,
                ["Life Cycle"]          = 96,
                ["Curaga V"]            = 50,
                ["Curaga IV"]           = 50,
                ["Curaga III"]          = 50,
                ["Cure VI"]             = 49,
                ["Cure V"]              = 49,
                ["Vivacious Pulse"]     = 49,
                ["Holy Water"]          = 48,
                ["Cursna"]              = 48,
                ["Stona"]               = 47,
                ["Curaga"]              = 47,
                ["Divine Waltz"]        = 47,
                ["Echo Drops"]          = 46,
                ["Silena"]              = 46,
                ["Panacea"]             = 45,
                ["Erase"]               = 45,
                ["Remedy"]              = 43,
                ["Viruna"]              = 43,
                ["Blindna"]             = 42,
                ["Paralyna"]            = 42,
                ["Poisona"]             = 42,
                ["Eye Drops"]           = 42,
                ["Antidote"]            = 42,
                ["Cure IV"]             = 40,
                ["Cure"]                = 40,
                ["Foil"]                = 30,
                ["Vallation"]           = 28,
                ["Valiance"]            = 28,
                ["Pflug"]               = 28,
                ["Soporific"]           = 26,
                ["Geist Wall"]          = 26,
                ["Sheep Song"]          = 26,
                ["Provoke"]             = 24,
                ["Shield Bash"]         = 24,
                ["Jettatura"]           = 24,
                ["Blank Gaze"]          = 24,
                ["Flash"]               = 22,
                ["Stun"]                = 22,
                ["Animated Flourish"]   = 22,
                ["Souleater"]           = 20,
                ["Last Resort"]         = 20,
                ["Stinking Gas"]        = 20,
                ["Poisonga"]            = 20,
                ["Toolbag (Shika)"]     = 20,
                ["Toolbag (Cho)"]       = 20,
                ["Toolbag (Ino)"]       = 20,
                ["Toolbag (Sanja)"]     = 20,
                ["Toolbag (Soshi)"]     = 20,
                ["Toolbag (Uchi)"]      = 20,
                ["Toolbag (Tsura)"]     = 20,
                ["Toolbag (Kawa)"]      = 20,
                ["Toolbag (Maki)"]      = 20,
                ["Toolbag (Hira)"]      = 20,
                ["Toolbag (Mizu)"]      = 20,
                ["Toolbag (Shihe)"]     = 20,
                ["Toolbag (Jusa)"]      = 20,
                ["Toolbag (Kagi)"]      = 20,
                ["Toolbag (Sai)"]       = 20,
                ["Toolbag (Kodo)"]      = 20,
                ["Toolbag (Shino)"]     = 20,
                ["Toolbag (Ranka)"]     = 20,
                ["Toolbag (Furu)"]      = 20,
                ["Toolbag (Kaben)"]     = 20,
                ["Toolbag (Jinko)"]     = 20,
                ["Toolbag (Ryuno)"]     = 20,
                ["Toolbag (Moku)"]      = 20,
                ["Utsusemi: San"]       = 19,
                ["Utsusemi: Ni"]        = 18,
                ["Utsusemi: Ichi"]      = 17,
                ["Raise"]               = 10,
                ["Raise II"]            = 10,
                ["Raise III"]           = 10,
                ["Arise"]               = 10,
                ["Reraise"]             = 10,
                ["Reraise II"]          = 10,
                ["Reraise III"]         = 10,
                ["Reraise IV"]          = 10,
                ["Phalanx"]             = 7,
                ["Phalanx II"]          = 7,
                ["Refresh"]             = 6,
                ["Refresh II"]          = 6,
                ["Refresh III"]         = 6,
                ["Cure III"]            = 4,
                ["Cure II"]             = 4,
                ["Curaga II"]           = 4,

            }

            -- 1 HOURS.
            for action in T{16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,93,96,135,181,210,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,356,377,378}:it() do
                pvt.set(bp.res.job_abilities[action].en, 100)
            end

            -- SELF-ENHANCING ABILITIES.
            for action in T(bp.res.job_abilities):it() do

                if (action.targets:contains('Self') or action.targets:contains('Player') or action.targets:contains('Party') or action.targets:contains('Ally')) and action.status then
                    pvt.set(action.en, 15)
                end

            end

            -- ENHANCING SPELLS.
            for action in T(bp.res.spells):it() do

                if (action.targets:contains('Self') or action.targets:contains('Player') or action.targets:contains('Party') or action.targets:contains('Ally')) and action.status and T{34,37,39}:contains(action.skill) then
                    pvt.set(action.en, 5)
                end

            end

            -- GEOMANCY SPELLS.
            for action in T(bp.res.spells):it() do

                if action.en:startswith("Geo-") then
                    pvt.set(action.en, 98)
                end

            end

            -- SPECIFIC DEFAULTS.
            for priority, action in specific:it() do
                pvt.set(action, priority)
            end

        end

        new.set = function(resource, value)
            local resource = bp.MA[resource] or bp.JA[resource] or bp.WS[resource] or bp.IT[resource] or false
            local value = tonumber(value)
    
            if resource and value and new.get(resource.en) then
                
                if S{'/jobability','/pet'}:contains(resource.prefix) then
                    bp.popchat.pop(string.format("\\cs(%s)%s\\cr PRIORITY → \\cs(%s)%s\\cr", bp.colors.setting, resource.en:upper(), bp.colors.setting, value))
                    __ja.priorities[resource.id] = value
                    __ja:save()
    
                elseif S{'/magic','/ninjutsu','/song'}:contains(resource.prefix) then
                    bp.popchat.pop(string.format("\\cs(%s)%s\\cr PRIORITY → \\cs(%s)%s\\cr", bp.colors.setting, resource.en:upper(), bp.colors.setting, value))
                    __ma.priorities[resource.id] = value
                    __ma:save()
    
                elseif S{'/weaponskill'}:contains(resource.prefix) then
                    bp.popchat.pop(string.format("\\cs(%s)%s\\cr PRIORITY → \\cs(%s)%s\\cr", bp.colors.setting, resource.en:upper(), bp.colors.setting, value))
                    __ws.priorities[resource.id] = value
                    __ws:save()
    
                elseif resource.flags and resource.flags:contains('Usable') then
                    bp.popchat.pop(string.format("\\cs(%s)%s\\cr PRIORITY → \\cs(%s)%s\\cr", bp.colors.setting, resource.en:upper(), bp.colors.setting, value))
                    __it.priorities[resource.id] = value
                    __it:save()
    
                end
    
            end
    
        end
        
        -- Private Events.
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'priority' and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command == 'default' then
                    __ja.priorities = base.__ja
                    __ma.priorities = base.__ma
                    __ws.priorities = base.__ws
                    __it.priorities = base.__it
                    bp.popchat.pop("PRIORITIES RESET TO DEFAULT VALUES!")

                    do -- Save to default values.
                        __ja:save()
                        __ma:save()
                        __ws:save()
                        __it:save()

                    end

                elseif tonumber(command) ~= nil and #commands > 0 then
                    local value = tonumber(command)
                    local spell = windower.convert_auto_trans(table.concat(commands, ' ')) or false

                    if spell and new.get(spell) and value then
                        new.set(spell, value)
                    end

                end

            end
    
        end)

        -- Setup Priorities
        new.setupBase()

        if __ja.isNew then __ja:save() end
        if __ma.isNew then __ma:save() end
        if __ws.isNew then __ws:save() end
        if __it.isNew then __it:save() end

        return new

    end

    return helper

end
return buildHelper