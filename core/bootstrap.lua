local buildManager = dofile(string.format("%score/manager.lua", windower.addon_path))
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
        self.info           = windower.ffxi.get_info()
        self.player         = windower.ffxi.get_player()
        self.party          = windower.ffxi.get_party()
        self.me             = windower.ffxi.get_mob_by_target('me') or {}
        self.pinger         = (os.clock() + 10)
        self.delay          = 0.25
        self.enabled        = false
        self.authorized     = false

        -- Class Objects.
        self.helpers        = buildManager(self)
        self.JA             = {}
        self.MA             = {}
        self.WS             = {}
        self.IT             = {}
        self.BUFFS          = {}
        self.displays       = {}
        self.libs           = {}

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

                        if helper then
                            self.helpers:add(helper, name)
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

        -- Class Functions.
        self.clearEvents = function(events)

            for id in T(events):it() do
                windower.unregister_event(id)
            end

        end

        self.toggleOption = function(option, setting, message)

            if option and message and setting ~= nil and type(setting) == 'boolean' then

                if option == '!' then
                    setting = true
                    --bp.helpers['console'].log(string.format('BLOCK SPELL INTERRUPTIONS: %s.', tostring(private.__castlock)))

                elseif option == '#' then
                    setting = false
                    --bp.helpers['console'].log(string.format('BLOCK SPELL INTERRUPTIONS: %s.', tostring(private.__castlock)))

                else
                    setting = setting ~= true and true
                    --bp.helpers['popchat'].pop(string.format('BLOCK SPELL INTERRUPTIONS: %s.', tostring(private.__castlock)))

                end

            end

        end

        self.setOption = function(option, setting, updated, message)
            
            if option and setting and updated and message and type(updated) == 'table' and #updated == 2 then

                if option == '!' then
                    setting = updated[1]
                    --bp.helpers['console'].log(string.format('BLOCK SPELL INTERRUPTIONS: %s.', tostring(private.__castlock)))
                    print('on')

                elseif option == '#' then
                    setting = updated[2]
                    --bp.helpers['console'].log(string.format('BLOCK SPELL INTERRUPTIONS: %s.', tostring(private.__castlock)))
                    print('off')

                end

            end

        end

        -- Class Events.
        windower.register_event('prerender', function()
            self.party  = windower.ffxi.get_party() or false
            self.player = windower.ffxi.get_player() or false
            self.info   = windower.ffxi.get_info() or false
            self.me     = windower.ffxi.get_mob_by_target('me') or false
    
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

        return self

    end

    return internal:build()

end
return bootstrap()