function bootstrap()
    local internal = {}

    function internal:build()

        -- Class resources.
        self.res            = require('resources')
        self.packets        = require('packets')
        self.extdata        = require('extdata')
        self.images         = require('images')
        self.queues         = require('queues')
        self.files          = require('files')
        self.texts          = require('texts')
        self.sets           = require('sets')
        require('actions')
        require('strings')
        require('vectors')
        require('logger')
        require('tables')
        require('lists')
        require('chat')
        require('pack')

        -- Class variables.
        self.player         = windower.ffxi.get_player()
        self.party          = windower.ffxi.get_party()
        self.me             = windower.ffxi.get_mob_by_target('me') or {}
        self.pinger         = (os.clock() + 10)
        self.delay          = 0.25
        self.enabled        = false
        self.authorized     = false

        -- Class Objects.
        self.JA             = {}
        self.MA             = {}
        self.WS             = {}
        self.IT             = {}
        self.BUFFS          = {}
        self.displays       = {}
        self.libs           = {}
        self.helpers        = {}

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

        -- Setup all the libraries before building helpers.
        local loadLibraries = function()
            local directory = string.format('"%s%s"', windower.addon_path, 'core/libraries/')

            for filename in io.popen(string.format('dir %s /b', directory)):lines() do 
                
                if filename:match('.lua') then
                    local name = filename:gsub('.lua', '')

                    if name then
                        local library = dofile(string.format('%s%s.lua', directory:gsub("\"", ''), name))

                        if library and library.new then
                            self.libs[name] = library:new(self)

                        else
                            self.libs[name] = library

                        end
                        
                    end

                end

            end

        end
        loadLibraries()

        -- Setup all the helper classes.
        local loadHelpers = function()
            local directory = string.format('"%s%s"', windower.addon_path, 'core/helpers/')

            for filename in io.popen(string.format('dir %s /b', directory)):lines() do 
                
                if filename:match('.lua') then
                    local name = filename:gsub('.lua', '')

                    if name then
                        local helper = dofile(string.format('%s%s.lua', directory:gsub("\"", ''), name))

                        if helper and helper.new then
                            self.helpers[name] = helper:new(self)

                        else
                            self.helpers[name] = helper

                        end
                        
                    end

                end

            end

        end
        loadHelpers()

        local buildCore = function()
    
            if self.player and seelf.files then
    
                --if self.files.new('core/logic.lua'):exists() then
                    --self.core = dofile(string.format('%sbp/core/logic.lua', windower.addon_path))    
                --end
    
            end
    
        end
        --buildCore()

        -- BP Main Event Loop.
        windower.register_event('prerender', function()
            self.party  = windower.ffxi.get_party() or false
            self.player = windower.ffxi.get_player() or false
            self.info   = windower.ffxi.get_info() or false
            self.me     = windower.ffxi.get_mob_by_target('me') or false
            --self.hideUI = (self.info.mog_house or self.info.chat_open or (self.info.menu_open and self.player.status ~= 1)) and true or false
    
            if self.player and self.enabled and not self.libs.__zones:isInJail() then
    
                if not self.libs.__zones:isInTown() and (os.clock() - self.pinger) > self.delay then
                    
                    --if not self.helpers['buffs'].buffActive(69) and not self.helpers['buffs'].buffActive(71) then
                        --self.core.handleAutomation()
                        --self.helpers['items'].queueItems()
                    --end
                    self.pinger = os.clock()
    
                elseif self.libs.__zones:isInTown() and (os.clock() - self.pinger) > self.delay then
    
                    --if not self.helpers['buffs'].buffActive(69) and not self.helpers['buffs'].buffActive(71) then
                        --self.helpers['items'].queueItems()
                        --self.helpers['queue'].handle()
    
                    --end
                    self.pinger = os.clock()
    
                end
                
            end
    
        end)

        return setmetatable({}, {__index = self})

    end

    return internal:build()

end
return bootstrap()