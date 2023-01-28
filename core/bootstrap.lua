local manager = dofile(string.format("%score/manager.lua", windower.addon_path))
local bootstrap, mt = {}, {}

mt.__index = function(t, key)
    
    if key:sub(1, 2) == '__' and rawget(t.libs, key) then
        return rawget(t.libs, key)

    elseif t.helpers[key] then
        return t.helpers[key]

    end

end

setmetatable(bootstrap, mt)
function bootstrap:new()

    -- Initialization functions.
    local init = {}

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

    -- Class Variables.
    self.accounts       = false
    self.info           = windower.ffxi.get_info()
    self.player         = windower.ffxi.get_player()
    self.party          = windower.ffxi.get_party()
    self.pet            = windower.ffxi.get_mob_by_target('pet')
    self.me             = windower.ffxi.get_mob_by_target('me') or {}
    self.pinger         = (os.clock() + 3)
    self.delay          = 0.25
    self.enabled        = false
    self.authorized     = false
    self.memory         = false

    -- Class Objects.
    self.helpers        = manager:new(self)
    self.common         = {}
    self.JA             = {}
    self.MA             = {}
    self.WS             = {}
    self.IT             = {}
    self.BUFFS          = {}
    self.libs           = {}
    self.colors         = {

        important   = string.format('%s,%s,%s', 025, 165, 200),
        setting     = string.format('%s,%s,%s', 200, 200, 200),
        on          = string.format('%s,%s,%s', 020, 250, 020),
        off         = string.format('%s,%s,%s', 090, 090, 090),
        teal        = string.format('%s,%s,%s', 050, 160, 160),

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
            if v.en and not v.unlearnable then
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

    do -- Update any packet fields that may be needed.
        self.packets.raw_fields.incoming[0x0DD] = L{
            {ctype='unsigned int',      label='ID',                 fn=id},             -- 04
            {ctype='unsigned int',      label='HP'},                                    -- 08
            {ctype='unsigned int',      label='MP'},                                    -- 0C
            {ctype='unsigned int',      label='TP',                 fn=percent},        -- 10
            {ctype='bit[2]',            label='Party Number'},                          -- 14:0
            {ctype='bit[1]',            label='Party Leader',       fn=bool},           -- 14:2
            {ctype='bit[1]',            label='Alliance Leader',    fn=bool},           -- 14:3
            {ctype='bit[4]',            label='_unknown0',          fn=bool},           -- 14:4
            {ctype='unsigned char',     label='_unknown1'},                             -- 15
            {ctype='unsigned short',    label='_unknown2'},                             -- 16
            {ctype='unsigned short',    label='Index',              fn=index},          -- 18
            {ctype='unsigned char',     label='Party Index'},                           -- 1A
            {ctype='unsigned char',     label='_unknown3'},                             -- 1B
            {ctype='unsigned char',     label='_unknown4'},                             -- 1C
            {ctype='unsigned char',     label='HP%',                fn=percent},        -- 1D
            {ctype='unsigned char',     label='MP%',                fn=percent},        -- 1E
            {ctype='unsigned char',     label='_unknown5'},                             -- 1F
            {ctype='unsigned short',    label='Zone',               fn=zone},           -- 20
            {ctype='unsigned char',     label='Main Job',           fn=job},            -- 22
            {ctype='unsigned char',     label='Main Job Level'},                        -- 23
            {ctype='unsigned char',     label='Sub Job',            fn=job},            -- 24
            {ctype='unsigned char',     label='Sub Job Level'},                         -- 25
            {ctype='unsigned char',     label='Master Level'},                          -- 26
            {ctype='boolbit',           label='Master Breaker'},                        -- 27
            {ctype='bit[7]',            label='_junk2'},                                -- 27
            {ctype='char*',             label='Name'},                                  -- 28
        }

    end

    -- Setup all the libraries before building helpers.
    init.loadLibraries = function()
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
        init.loadHelpers()

    end

    -- Setup all the helper classes.
    init.loadHelpers = function()
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

        -- Load user built libraries & helpers.
        self.usettings.loadLibraries:schedule(0.2)
        self.usettings.loadHelpers:schedule(0.4)

    end
    init.loadLibraries()

    -- Send helper data to client.
    self.helpers.updateSettings:schedule(5)

    -- Addon Events.
    windower.register_event('prerender', function()
        self.party  = windower.ffxi.get_party() or false
        self.player = windower.ffxi.get_player() or false
        self.info   = windower.ffxi.get_info() or false
        self.me     = windower.ffxi.get_mob_by_target('me') or false
        self.pet    = windower.ffxi.get_mob_by_target('pet') or false

        if self.player and self.enabled and not self.__zones:isInJail() and (os.clock() - self.pinger) > self.delay and not self.__buffs.silent() then

            if not self.__zones:isInTown() and self.core then
                self.core:automate()

            elseif self.__zones:isInTown() then
                self.__queue.handle()
                

            end
            self.pinger = os.clock()
            
        end
        if self.memory then windower.send_command('lua memory bp4') end

    end)

    windower.register_event('unhandled command', function(command, ...)
    
        if command:sub(1,1) == '/' then
            windower.send_command(string.format('bp %s %s', command:sub(2), table.concat(T{...}, ' ')))
        end

    end)

    return self

end
return bootstrap:new()