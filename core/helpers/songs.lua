local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout1   = {pos={x=200, y=80}, bg={alpha=000, red=0, green=0, blue=0, visible=true}, flags={draggable=true, bold=false}, text={size=20, font='Lucida Console', alpha=255, red=245, green=200, blue=20, stroke={width=1, alpha=255, red=0, green=0, blue=0}}, padding=5}
    local layout2   = {pos={x=200, y=80}, bg={alpha=175, red=0, green=0, blue=0, visible=true}, flags={draggable=true, bold=false}, text={size=10, font='Lucida Console', alpha=255, red=245, green=200, blue=20, stroke={width=1, alpha=255, red=0, green=0, blue=0}}, padding=5}
    local settings  = bp.__settings.new('songs')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __hover       = bp.libs.__displays.new(settings.hover or layout2)
        local __loop        = Q{}
        local __position    = 195
        local __recast      = 0
        local __reset       = 0
        local __max         = false

        do -- Private Settings.
            settings.delay      = settings.delay or 230
            settings.dummy      = settings.dummy or 1
            settings.layout     = settings.layout or layout1
            settings.hover      = settings.hover or layout2
            settings.display    = settings:getDisplay()

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.render = function()

            bp.libs.__ui.renderUI(settings.display, function()

                if bp and bp.player and settings.display:text() == "" then
                    settings.display:text("♫")
                end
            
            end)
        
        end

        pvt.loop = function(commands)
            __loop:push(commands)            
        end

        pvt.setDummy = function(option)
            local option = tonumber(option)

            if option and option >= 1 and option <= 3 then
                settings.dummy = option

            else
                settings.dummy = ((settings.dummy + 1) <= 3) and (settings.dummy + 1) or 1

            end

        end

        pvt.setDelay = function(value)
            local value = tonumber(value)

            if value and value >= 30 and value <= 900 then
                settings.delay = value
            end

        end

        pvt.resetPosition = function()

            if (os.time()-__reset) >= 60 and __position ~= 195 then
                __position = 195
            end

        end

        pvt.pushSVCC = function()

            if bp.core.get("1hr") and bp.__songs.svccReady() then

                if not bp.__queue.inQueue(bp.JA["Soul Voice"]) and not bp.__queue.inQueue(bp.JA["Clarion Call"]) then
                    bp.__queue.add(bp.JA["Soul Voice"], bp.player, 200)
                    bp.__queue.add(bp.JA["Clarion Call"], bp.player, 200)
                end

            end

        end

        pvt.pushNitro = function()

            if not bp.__queue.inQueue(bp.JA["Nightingale"]) and not bp.__queue.inQueue(bp.JA["Troubadour"]) then
                bp.__queue.add(bp.JA["Nightingale"], bp.player, 199)
                bp.__queue.add(bp.JA["Troubadour"], bp.player, 199)

                if bp.__actions.isReady("Marcato") and not bp.__queue.inQueue(bp.JA["Marcato"]) and not bp.__queue.inQueue(bp.JA["Soul Voice"]) then
                    bp.__queue.add(bp.JA["Marcato"], bp.player, 200)
                end

            end

        end

        pvt.addSong = function(song, target, dummy)
            local dummies = bp.__songs.getDummies(settings.dummy)
            local queue = {}

            if song and target and bp.MA[song] then

                if bp.player.id ~= target.id and dummy and dummies and dummies[dummy] then
                    table.insert(queue, {action=bp.JA['Pianissimo'], target=bp.player})
                    table.insert(queue, {action=dummies[dummy], target=target})
                    table.insert(queue, {action=bp.JA['Pianissimo'], target=bp.player})
                    table.insert(queue, {action=bp.MA[song], target=target})

                elseif bp.player.id ~= target.id and not dummy then
                    table.insert(queue, {action=bp.JA['Pianissimo'], target=bp.player})
                    table.insert(queue, {action=bp.MA[song], target=target})

                elseif bp.player.id == target.id and dummy and dummies and dummies[dummy] then
                    table.insert(queue, {action=dummies[dummy], target=bp.player})
                    table.insert(queue, {action=bp.MA[song], target=bp.player})

                elseif bp.player.id == target.id and not dummy then
                    table.insert(queue, {action=bp.MA[song], target=bp.player})

                end

            end
            return queue

        end

        pvt.buildSongs = function(commands, target)
            local allowed = bp.__songs.getSongCount()
            local sing = {}

            if bp.core.get("ja") and bp.core.get("1hr") and bp.__songs.nitroReady() and bp.__songs.svccReady() then
                allowed = (allowed + 1)
            end

            if commands then
                local complex = bp.__songs.getComplex()

                for i=1, allowed do
                    local song = commands[i]

                    if complex[song] then

                        if song == 'march' and complex[song].count == 1 and not bp.__songs.hasHonorMarch() then
                            complex[song].count = (complex[song].count + 1)
                        end

                        if T{1,2}:contains(i) then
                            table.insert(sing, pvt.addSong(complex[song].songs[complex[song].count], target or bp.player))

                        elseif i == 3 and (bp.__buffs.active(499) or bp.__queue.inQueue(bp.JA["Clarion Call"])) then
                            table.insert(sing, pvt.addSong(complex[song].songs[complex[song].count], target or bp.player))

                        elseif i == 3 then
                            table.insert(sing, pvt.addSong(complex[song].songs[complex[song].count], target or bp.player, 1))

                        elseif i == 4 and (bp.__buffs.active(499) or bp.__queue.inQueue(bp.JA["Clarion Call"])) then
                            table.insert(sing, pvt.addSong(complex[song].songs[complex[song].count], target or bp.player, 1))

                        elseif i == 4 then
                            table.insert(sing, pvt.addSong(complex[song].songs[complex[song].count], target or bp.player, 2))

                        elseif i == 5 and (bp.__buffs.active(499) or bp.__queue.inQueue(bp.JA["Clarion Call"]) or __max) then
                            table.insert(sing, pvt.addSong(complex[song].songs[complex[song].count], target or bp.player, 2))

                        end
                        complex[song].count = (complex[song].count + 1)

                    elseif bp.__songs.getSpecific(song) and bp.MA[bp.__songs.getSpecific(song)] then

                        if T{1,2}:contains(i) then
                            table.insert(sing, pvt.addSong(bp.MA[bp.__songs.getSpecific(song)], target or bp.player))

                        elseif i == 3 and (bp.__buffs.active(499) or bp.__queue.inQueue(bp.JA["Clarion Call"])) then
                            table.insert(sing, pvt.addSong(bp.MA[bp.__songs.getSpecific(song)], target or bp.player))

                        elseif i == 3 then
                            table.insert(sing, pvt.addSong(bp.MA[bp.__songs.getSpecific(song)], target or bp.player, 1))

                        elseif i == 4 and (bp.__buffs.active(499) or bp.__queue.inQueue(bp.JA["Clarion Call"])) then
                            table.insert(sing, pvt.addSong(bp.MA[bp.__songs.getSpecific(song)], target or bp.player, 1))

                        elseif i == 4 then
                            table.insert(sing, pvt.addSong(bp.MA[bp.__songs.getSpecific(song)], target or bp.player, 2))

                        elseif i == 5 and (bp.__buffs.active(499) or bp.__queue.inQueue(bp.JA["Clarion Call"]) or __max) then
                            table.insert(sing, pvt.addSong(bp.MA[bp.__songs.getSpecific(song)], target or bp.player, 2))

                        end

                    end
                    __reset = os.time()

                end

            end
            return sing

        end

        pvt.sing = function(commands)
            local pianiss = bp.__party.findMember(commands[#commands]:sub(2))

            if pianiss then
                table.remove(commands, #commands)
            end

            do -- Handle songs.
                local songs = T(pvt.buildSongs(commands, pianiss))

                if #songs > 0 and bp.__actions.canAct() and bp.__actions.canCast() then

                    -- Buff songs.
                    if bp.core.get("ja") and bp.__songs.nitroReady() then
                        pvt.pushSVCC()
                        pvt.pushNitro()        
                    end

                    -- Loop through build list and queue actions.
                    for list in songs:it() do
                        
                        for sing in T(list):it() do
                            bp.__queue.add(sing.action.en, sing.target, __position)
                            __position = (__position - 1)

                        end

                    end

                end

            end

        end

        -- Public Methods.
        new.clear = function() __loop = Q{} end
        new.handleSongs = function()

            if (os.time()-__recast) >= settings.delay and __loop:length() > 0 then
                
                for commands in __loop:it() do
                    pvt.sing(commands)
                end
                __recast = os.time()

            end

        end
        
        -- Private Events.
        helper('prerender', pvt.render)
        helper('mouse', function(param, x, y, delta, blocked) settings:saveDisplay(x, y, param) end)
        helper('time change', pvt.resetPosition)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'songs' and #commands > 0 then
                local command = commands[1] and commands[1]:lower() or false

                if command == 'dummy' then
                    pvt.setDummy(commands[1])

                elseif command == 'delay' then
                    pvt.setDelay(commands[1])

                elseif command == 'loop' then
                    table.remove(commands, 1)
                    pvt.loop(commands)

                else
                    pvt.sing(commands)

                end

            end
    
        end)

        helper('mouse', function(param, x, y, delta, blocked)

            if bp.player.main_job == 'BRD' and param == 0 then
                
                if __loop:length() > 0 and settings.display:hover(x, y) and not __hover:visible() then
                    local update = {}
                    local x, y = settings.display:extents()

                    for i=1, __loop:length() do
                        local target = bp.__party.findMember(table.concat(__loop.data[__loop:length()], " "):sub(2))
                        local recast = (settings.delay - (os.time()-__recast))

                        if i == 1 then
                            table.insert(update, string.format("RECASTING LOOPS IN \\cs(%s)%s\\cr SECONDS\n", bp.colors.important, recast > 0 and recast or 0))
                        end
                        table.insert(update, string.format("SINGING ON: [ \\cs(%s)%s\\cr ]\n COMMAND → \\cs(%s)%s\\cr", bp.colors.important, target and target.name or bp.player.name, bp.colors.important, table.concat(__loop.data[i], " ")))

                    end
                    __hover:pos(settings.display:pos_x() + (x + 5), settings.display:pos_y() + 5)
                    __hover:text(table.concat(update, "\n"))
                    __hover:show()
    
                elseif not settings.display:hover(x, y) and __hover:visible() then
                    __hover:hide()
    
                end
    
            end

        end)

        return new

    end

    return helper

end
return buildHelper