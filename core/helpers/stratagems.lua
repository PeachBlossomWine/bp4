local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=200, y=80}, bg={alpha=0, red=0, green=0, blue=0, visible=false}, flags={draggable=true, bold=false}, text={size=15, font='Impact', alpha=255, red=245, green=200, blue=20, stroke={width=2, alpha=255, red=0, green=0, blue=0}}, padding=5}
    local settings  = bp.__settings.new('stratagems')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.

        do -- Private Settings.
            settings.layout     = settings.layout or layout
            settings.visible    = settings.visible or false
            settings.display    = settings:getDisplay()

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.render = function()

            if bp and bp.player and (bp.player.main_job == 'SCH' or bp.player.sub_job == 'SCH') and settings.visible then

                bp.__ui.renderUI(settings.display, function()
                    settings.display:text(string.format("[[  \\cs(%s)%d\\cr/\\cs(%s)%d\\cr  ]]", bp.colors.setting, bp.__stratagems.current or 0, bp.colors.teal, bp.__stratagems.max))
                
                end)

            end

        end

        pvt.updateDisplay = function(id, original)

            if id == 0x028 then
                local parsed = bp.packets.parse('incoming', original)

                if parsed and parsed['Category'] == 6 then
                    pvt.updateDisplay()
                end

            end

        end

        -- Private Events.
        helper('prerender', pvt.render)
        helper('mouse', function(param, x, y, delta, blocked) settings:saveDisplay(x, y, param) end)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'sgems' then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then

                    if ("visible"):startswith(command) then
                        settings.visible = (settings.visible ~= true) and true or false
                        bp.popchat.pop(string.format("STRATAGEMS DISPLAY: \\cs(%s)%s\\cr", bp.colors.setting, tostring(settings.visible)))

                    elseif ("position"):startswith(command) and #commands > 0 then
                        settings.display:pos(tonumber(commands[1]) or settings.display:pos_x(), tonumber(commands[2]) or settings.display:pos_y())

                    end

                end
                settings:save()
    
            end        
    
        end)

        return new

    end

    return helper

end
return buildHelper