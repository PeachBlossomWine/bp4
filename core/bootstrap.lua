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
        self.accounts       = false
        self.info           = windower.ffxi.get_info()
        self.player         = windower.ffxi.get_player()
        self.party          = windower.ffxi.get_party()
        self.me             = windower.ffxi.get_mob_by_target('me') or {}
        self.pinger         = (os.clock() + 3)
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
        self.colors         = {

            important   = string.format('%s,%s,%s', 025, 165, 200),
            setting     = string.format('%s,%s,%s', 200, 200, 200),
    
        }

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
    
        end

        -- Addon Events.
        windower.register_event('prerender', function()
            self.party  = windower.ffxi.get_party() or false
            self.player = windower.ffxi.get_player() or false
            self.info   = windower.ffxi.get_info() or false
            self.me     = windower.ffxi.get_mob_by_target('me') or false
    
            if self.player and self.enabled and not self.libs.__zones:isInJail() and (os.clock() - self.pinger) > self.delay and not self.libs.__buffs.silent() then

                if not self.libs.__zones:isInTown() then
                    self.helpers.core.automate()

                elseif self.libs.__zones:isInTown() then
                    self.helpers.core.automate()
                    
    
                end
                self.pinger = os.clock()
                
            end
    
        end)

        windower.register_event('unhandled command', function(command, ...)
        
            if command:sub(1,1) == '/' then
                windower.send_command(string.format('bp %s %s', command:sub(2), table.concat(T{...}, ' ')))
            end
    
        end)

        return self

    end

    return internal:build()

end
return bootstrap()