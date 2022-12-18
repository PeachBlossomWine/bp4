local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=200, y=80}, bg={alpha=0, red=0, green=0, blue=0, visible=false}, flags={draggable=true, bold=false}, text={size=15, font='Impact', alpha=255, red=245, green=200, blue=20, stroke={width=1, alpha=255, red=0, green=0, blue=0}}, padding=5}
    local settings  = bp.libs.__settings.new('runes')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __colors = {

            ['Ignis']       = {string.format('%s,%s,%s', 100, 190, 255),    string.format('%s,%s,%s', 235, 65, 75)},
            ['Gelus']       = {string.format('%s,%s,%s', 100, 190, 30),     string.format('%s,%s,%s', 100, 190, 255)},
            ['Flabra']      = {string.format('%s,%s,%s', 170, 145, 75),     string.format('%s,%s,%s', 100, 190, 30)},
            ['Tellus']      = {string.format('%s,%s,%s', 155, 15, 235),     string.format('%s,%s,%s', 190, 135, 45)},
            ['Sulpor']      = {string.format('%s,%s,%s', 75, 110, 235),     string.format('%s,%s,%s', 110, 10, 195)},
            ['Unda']        = {string.format('%s,%s,%s', 235, 65, 75),      string.format('%s,%s,%s', 75, 110, 235)},
            ['Lux']         = {string.format('%s,%s,%s', 155, 0, 60),       string.format('%s,%s,%s', 230, 235, 250)},
            ['Tenebrae']    = {string.format('%s,%s,%s', 230, 235, 250),    string.format('%s,%s,%s', 155, 0, 60)},

        }

        do -- Private Settings.
            settings.mode       = settings.mode or 1
            settings.visible    = settings.visible ~= nil and settings.visible or true
            settings.layout     = settings.layout or layout
            settings.display    = settings:getDisplay()

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.render = function()

            if bp and settings.visible and (bp.player.main_job == 'RUN' or bp.player.sub_job == 'RUN') then

                bp.__ui.renderUI(settings.display, function()

                    if bp and bp.player and settings.visible and settings.display:text() == "" then
                        pvt.updateDisplay()
                    end
                
                end)

            end
        
        end

        pvt.updateDisplay = function()
            local updated = {}

            if bp.core.get('runes') then

                for i=1, bp.__runes.max() do
                    local rune = bp.core.get('runes').list[i]

                    if rune then
                        table.insert(updated, string.format("\\cs(%s)%s\\cr", __colors[rune][settings.mode], rune:upper()))
                    end

                end
                settings.display:text(string.format("{ %s }", table.concat(updated, "  •  ")))

            end

        end
        
        -- Private Events.
        helper('prerender', pvt.render)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)

            if command == "?" then
                coroutine.schedule(function()
                    pvt.updateDisplay()
                end, 0.15)
            end
            
            if bp and command and command:lower() == 'runes' and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then

                    if ('visible'):startswith(command) then
                        settings.visible = (settings.visible ~= true) and true or false
                        bp.popchat.pop(string.format("RUNES DISPLAY: \\cs(%s)%s\\cr", bp.colors.setting, tostring(settings.visible)))

                    elseif ('mode'):startswith(command) and tonumber(commands[1]) then
                        settings.mode = (tonumber(commands[1]) and tonumber(commands[1]) == 1) and 1 or 2
                        bp.popchat.pop(string.format("RUNES MODE: \\cs(%s)%s\\cr", bp.colors.setting, (settings.mode == 1) and "RESISTANCE" or "DAMAGE"))

                    elseif ('position'):startswith(command) and #commands > 0 then
                        settings.display:pos(tonumber(commands[1]) or settings.display:pos_x(), tonumber(commands[2]) or settings.display:pos_y())

                    end
                    pvt.updateDisplay()

                end
                settings:save()

            end

        end)

        return new

    end

    return helper

end
return buildHelper