function bootstrap()
    local internal = {}

    function internal:build()

        -- Class resources.
        self.packets        = require('packets')
        self.res            = require('resources')
        self.extdata        = require('extdata')
        self.files          = require('files')
        self.texts          = require('texts')
        self.sets           = require('sets')
        self.images         = require('images')
        self.queues         = require('queues')
        require('actions')
        require('strings')
        require('lists')
        require('tables')
        require('chat')
        require('logger')
        require('pack')

        -- Class variables.
        self.delay          = 0.25
        self.enabled        = false
        self.authorized     = false

        -- Class Objects.
        self.JA             = {}
        self.MA             = {}
        self.WS             = {}
        self.IT             = {}
        self.BUFFS          = {}
        self.libraries      = {}

        -- Private Functions
        local buildResources = function()

            for _,v in pairs(self.res.job_abilities) do
                if v.en then
                    self.JA[v.en] = v
                    self.JA[v.en:lower()] = v
                end
            end
    
            for _,v in pairs(self.res.spells) do
                if v.en then
                    self.MA[v.en] = v
                    self.MA[v.en:lower()] = v
                end
            end
    
            for _,v in pairs(self.res.weapon_skills) do
                if v.en then
                    self.WS[v.en] = v
                    self.WS[v.en:lower()] = v
                end
            end
    
            for _,v in pairs(self.res.items) do
                if v.en then
                    self.IT[v.en] = v
                    self.IT[v.en:lower()] = v
                end
            end
    
            for _,v in pairs(self.res.buffs) do
                if v.en then
                    self.BUFFS[v.en] = v
                    self.BUFFS[v.en:lower()] = v
                end
            end
    
        end
        buildResources()

        local loadLibraries = function()
            local directory = string.format('"%s%s"', windower.addon_path, 'core/libraries/')
        
            for filename in io.popen(string.format('dir %s /b', directory)):lines() do 
                
                if filename:match('.lua') then
                    local name = filename:gsub('.lua', '')

                    if name then
                        local library = dofile(string.format('%s%s.lua', directory:gsub("\"", ''), name))

                        if library and library.new then
                            self.libraries[name] = library:new(self)
                        end
                        
                    end

                end

            end

        end
        loadLibraries()

        return setmetatable({}, {__index = self})

    end

    return internal

end
return bootstrap()