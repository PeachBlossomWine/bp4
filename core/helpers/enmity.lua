local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=200, y=80}, bg={alpha=0, red=0, green=0, blue=0, visible=false}, flags={draggable=true, bold=false}, text={size=18, font='Calibri', alpha=255, red=245, green=200, blue=20, stroke={width=2, alpha=255, red=0, green=0, blue=0}}, padding=5}
    local settings  = bp.libs.__settings.new('enmity')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __last = false

        do -- Private Settings.
            settings.layout     = settings.layout or layout
            settings.display    = settings:getDisplay()

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.render = function()

            bp.__ui.renderUI(settings.display, function()
                local enmity = bp.__enmity.hasEnmity()

                if enmity and (not __last or (__last and enmity.name ~= __last) ) and bp.target.get() then
                    settings.display:text(string.format("→ \\cs(%s)%s\\cr ←", bp.colors.setting, enmity.name))
                    __last = enmity.name

                elseif settings.display:visible() and not __enmity then
                    settings.display:hide()
                    __last = false

                end
        
            end)

        end
        
        -- Private Events.
        helper('prerender', pvt.render)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'enmity' and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if ('position'):startswith(command) and #commands > 0 then
                    settings.display:pos(tonumber(commands[1]) or settings.display:pos_x(), tonumber(commands[2]) or settings.display:pos_y())
                end
                settings:save()

            end
    
        end)

        return new

    end

    return helper

end
return buildHelper