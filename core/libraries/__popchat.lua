local library = {}
function library:new(bp)
    local bp = bp

    return self

end
return library

--[[
local popchat = {}
local player = windower.ffxi.get_player()
local files = require('files')
local texts = require('texts')
local f = files.new(string.format('bp/settings/%s/popchat/settings.lua', player.name))

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function popchat.new()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}, chats={}, delay=5}

    do
        private.settings    = dofile(string.format('%sbp/settings/%s/popchat/settings.lua', windower.addon_path, player.name))
        private.layout      = private.settings.layout ~= nil and private.settings.layout or {pos={x=300, y=450}, bg={alpha=0, red=0, green=0, blue=0, visible=false}, flags={draggable=false, bold=false}, text={size=20, font='Impact', alpha=255, red=100, green=215, blue=0, stroke={width=2, alpha=255, red=0, green=25, blue=15}}, padding=2}
        private.pos         = {x=private.layout.pos.x, y=private.layout.pos.y}
        private.display     = texts.new(private.layout)
        private.timer       = 0
                                                                                           
    end

    -- Private Functions.
    private.persist = function()

        if private.settings then
            private.settings.layout = private.layout            
        end

    end
    private.persist()

    private.updateDisplay = function()
        local update = {}

        for _,m in ipairs(private.chats) do
            table.insert(update, m.message)
        end

        if #private.chats > 0 then
            private.display:text(table.concat(update, '\n'))
            
            if not private.display:visible() then
                private.display:show()
            end

        elseif private.display:visible() then
            private.display:hide()

        end

    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
            bp.saveSettings(f, private.settings, private.persist)
        end

    end

    self.pop = function(message)
        table.insert(private.chats, {message=string.format('[  %s  ]', message:upper()), time=os.time()})
        private.updateDisplay()

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = table.remove(commands, 1)
        
        if bp and bp.player and helper and helper:lower() == 'popchat' and #commands > 0 then
            local message = {}
    
            for i=1, #commands do
                table.insert(message, commands[i])
            end
            self.pop(table.concat(message, ' '))

        end

    end)

    private.events.render = windower.register_event('prerender', function()

        if bp and bp.player and (os.time()-private.timer) >= 1 then
            local update = {}

            for m, index in T(private.chats):it() do
                
                if (os.time()-m.time) >= 5 then
                    table.remove(private.chats, index)
                    private.updateDisplay()

                end

            end
            private.timer = os.time()

        end

    end)

    return self

end
return popchat.new()
]]