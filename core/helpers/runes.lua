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

            ['Ignis']       = {string.format('%s,%s,%s', 100, 190, 255),    string.format('%s,%s,%s', 195, 25, 35)},
            ['Gelus']       = {string.format('%s,%s,%s', 100, 190, 30),     string.format('%s,%s,%s', 100, 190, 255)},
            ['Flabra']      = {string.format('%s,%s,%s', 170, 145, 75),     string.format('%s,%s,%s', 100, 190, 30)},
            ['Tellus']      = {string.format('%s,%s,%s', 110, 10, 195),     string.format('%s,%s,%s', 25, 165, 200)},
            ['Sulpor']      = {string.format('%s,%s,%s', 25, 35, 195),      string.format('%s,%s,%s', 110, 10, 195)},
            ['Unda']        = {string.format('%s,%s,%s', 195, 25, 35),      string.format('%s,%s,%s', 25, 35, 195)},
            ['Lux']         = {string.format('%s,%s,%s', 155, 0, 60),       string.format('%s,%s,%s', 155, 0, 60)},
            ['Tenebrae']    = {string.format('%s,%s,%s', 230, 235, 250),    string.format('%s,%s,%s', 230, 235, 250)},

        }

        do -- Private Settings.
            settings.runes      = settings.runes or {"Ignis","Ignis","Ignis"}
            settings.mode       = settings.mode or 1
            settings.visible    = settings.visible ~= nil and settings.visible or true
            settings.layout     = settings.layout or layout
            settings.display    = settings:getDisplay()

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.render = function()

            if settings.visible then

                bp.__ui.renderUI(settings.display, function()

                    if bp and bp.player and settings.visible and settings.display:text() == "" and (bp.player.main_job == 'RUN' or bp.player.sub_job == 'RUN') then
                        pvt.updateDisplay()

                    elseif settings.display:visible() then
                        settings.display:hide()

                    end
                
                end)

            end
        
        end

        pvt.updateDisplay = function()
            local updated = {}
            local mode = settings.mode or 1

            for i=1, bp.__runes.max() do
                local rune = settings.runes[i]

                if rune then
                    table.insert(updated, string.format("\\cs(%s)%s\\cr", __colors[rune][mode], rune))
                end

            end
            settings.display:text(string.format("{ %s }", table.concat(updated, "  +  ")))

        end

        pvt.matchRune = function(search)
            
            if (("ignis"):startswith(search) or ("fire"):startswith(search)) then
                return "Ignis"

            elseif (("gelus"):startswith(search) or ("ice"):startswith(search)) then
                return "Gelus"

            elseif (("flabra"):startswith(search) or ("wind"):startswith(search)) then
                return "Flabra"

            elseif (("tellus"):startswith(search) or ("earth"):startswith(search)) then
                return "Tellus"

            elseif (("sulpor"):startswith(search) or ("thunder"):startswith(search)) then
                return "Sulpor"

            elseif (("unda"):startswith(search) or ("water"):startswith(search)) then
                return "Unda"

            elseif (("lux"):startswith(search) or ("light"):startswith(search)) then
                return "Lux"

            elseif (("tenebrae"):startswith(search) or ("dark"):startswith(search)) then
                return "Tenebrae"

            end
            return false

        end
        
        -- Public Methods.
        new.get = function() return T(settings.runes):copy() end
        new.setRunes = function(runes)
            
            for i=1, #runes do
                local rune = pvt.matchRune(runes[i])

                if rune then
                    settings.runes[i] = rune
                end

            end
            pvt.updateDisplay()

        end

        new.inactive = function()
            local runes = new.get()

            for i=1, bp.__runes.count() do
                
                if bp.__runes.current[i] == runes[i] then
                    table.remove(runes, i)
                end

            end
            return T(runes)
            
        end
        
        -- Private Events.
        helper('prerender', pvt.render)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'runes' and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then

                    if ("visible"):startswith(command) then
                        settings.visible = (settings.visible ~= true) and true or false
                        bp.popchat.pop(string.format("RUNES DISPLAY: \\cs(%s)%s\\cr", bp.colors.setting, tostring(settings.visible)))

                    elseif ("mode"):startswith(command) and tonumber(commands[1]) then
                        settings.mode = (tonumber(commands[1]) and tonumber(commands[1]) == 1) and 1 or 2
                        bp.popchat.pop(string.format("RUNES MODE: \\cs(%s)%s\\cr", bp.colors.setting, (settings.mode == 1) and "RESISTANCE" or "DAMAGE"))

                    else
                        new.setRunes({command, commands[1], commands[2]})

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