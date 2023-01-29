local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local settings  = bp.__settings.new('init', true)

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local default_aliases = {

            -- RINGS.
            {'wring',       "bp wring"},
            {'dring',       "bp dring"},
            {'hring',       "bp hring"},
            {'mring',       "bp mring"},
            {'wrings',      "bp ord p bp wring"},
            {'drings',      "bp ord p bp dring"},
            {'hrings',      "bp ord p bp hring"},
            {'mrings',      "bp ord p bp mring"},
    
        }
        
        local default_binds = {

            '@b bp toggle',
            '@f bp follow',
            '@s bp request_stop',
            '@a bp assist',
            '@p poke',
            '@m bp ord p bp mount',
            '@t bp target t',
            '@p bp target pt',
            '@, bp target lt',
            '@. bp target et',
            '@[ bp ord p bp on',
            '@] bp ord p bp off',
            '@/ bp mode',
    
        }

        do -- Private Settings.
            settings.accounts   = settings.accounts or T{}
            settings.aliases    = settings.aliases or default_aliases
            settings.binds      = settings.binds or default_binds

            do -- Initialize settings.
                bp.accounts = T(settings.accounts)
                bp.__keybinds.register(settings.binds)
                bp.__alias.register(settings.aliases)

            end

        end

        -- Save after all settings have been initialized.
        if settings.isNew then settings:save() end

        return new

    end

    return helper

end
return buildHelper