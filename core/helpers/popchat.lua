local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=300, y=450}, bg={alpha=0, red=0, green=0, blue=0, visible=false}, flags={draggable=false, bold=false}, text={size=20, font='Impact', alpha=255, red=100, green=215, blue=0, stroke={width=0, alpha=0, red=0, green=0, blue=0}}, padding=2}
    local settings  = bp.libs.__settings.new('popchat')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)

        -- Private Variables.
        local timer         = 0
        local messages      = T{}

        do -- Private Settings.
            settings.layout     = settings.layout or layout
            settings.delay      = settings.delay or 5
            settings.display    = settings:getDisplay()

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        local updateDisplay = function()
    
            if #messages > 0 then
                settings.display:text(table.concat(messages:map(function(m) return m.message end), '\n'))

            else
                settings.display:text("")
    
            end
            
        end

        local remove = function()
            local map = messages:map(function(m) return (os.time()-m.time) >= settings.delay and m or nil end)
            
            if #map > 0 then

                for _,index in map:it() do
                    messages:remove(index)
                end
                updateDisplay()

            end
            timer = os.time()

        end

        local render = function()

            bp.libs.__ui.renderUI(settings.display, function()
                
                if bp and bp.player and #messages > 0 and (os.time()-timer) >= 1 then
                    remove()        
                end
            
            end)

        end

        -- Public Methods.
        new.pop = function(message)
            table.insert(messages, {message=string.format('[  %s  ]', message:upper()), time=os.time()})
            updateDisplay()

        end

        -- Private Events.
        helper('time change', render)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'popchat' and #commands > 0 then
                new.pop(table.concat(commands, ' '))    
            end
    
        end)

        return new

    end

    return helper

end
return buildHelper