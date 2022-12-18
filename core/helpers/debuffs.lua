local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=1, y=1}, bg={alpha=0, red=0, green=0, blue=0, visible=false}, flags={draggable=true, bold=true}, text={size=12, font='Calibri', alpha=255, red=245, green=200, blue=20, stroke={width=1, alpha=255, red=0, green=0, blue=0}}, padding=10}
    local settings  = bp.__settings.new('debuffs')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        do -- Private Settings.
            settings.debuffs    = settings.debuffs or {}
            settings.visible    = settings.visible ~= nil and settings.visible or true
            settings.layout     = settings.layout or layout
            settings.display    = settings:getDisplay()

        end

        -- Public Variables.
        new.list = T(bp.res.spells):map(function(spell) return (spell.status and spell.targets:contains('Enemy')) and spell.en or nil end)

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.render = function()

            if bp and bp.player and settings.debuffs[bp.player.main_job] and #settings.debuffs[bp.player.main_job] > 0 then
                local job = bp.player.main_job
            
                bp.__ui.renderUI(settings.display, function()
                    local update = {}

                    for i=1, #settings.debuffs[job] do
                        local last  = (os.clock() - settings.debuffs[job][i].last)
                        local delay = settings.debuffs[job][i].delay

                        if last and delay then
                            update[i] = string.format("[ \\cs(%s)%05.2f\\cr ] \\cs(%s)%s\\cr", bp.colors.setting, (delay - last) >= 0 and (delay - last) or 0, bp.colors.setting, settings.debuffs[job][i].spell)
                        end
                        
                    end
                    settings.display:text(table.concat(update, "\n"))

                end)

            elseif bp and bp.player and settings.debuffs[bp.player.main_job] and #settings.debuffs[bp.player.main_job] == 0 and settings.display:visible() then
                settings.display:hide()

            end
        
        end

        pvt.exists = function(spell)

            if not settings.debuffs[bp.player.main_job] then
                settings.debuffs[bp.player.main_job] = T{}
            end

            for option in T(settings.debuffs[bp.player.main_job]):it() do

                if option.spell:lower() == spell:lower() then
                    return true
                end

            end
            return false

        end

        pvt.add = function(commands)
            local delay = (tonumber(commands[#commands]) ~= nil) and tonumber(table.remove(commands, #commands)) or 120
            local spell = commands[1] and table.concat(commands, " "):lower() or false

            if spell and delay and bp.MA[spell] and not pvt.exists(bp.MA[spell].en) then
                settings.debuffs[bp.player.main_job]:insert({spell=bp.MA[spell].en, delay=delay, last=0})
                bp.popchat.pop(string.format("\\cs(%s)%s\\cr ADDED TO DEBUFF LIST", bp.colors.setting, bp.MA[spell].en:upper()))
            end

        end

        pvt.remove = function(commands)
            local spell = commands[1] and table.concat(commands, " "):lower() or false

            if spell and bp.MA[spell] and pvt.exists(bp.MA[spell].en) then
                
                for option, index in T(settings.debuffs[bp.player.main_job]):it() do

                    if option.spell == bp.MA[spell].en then
                        bp.popchat.pop(string.format("\\cs(%s)%s\\cr REMOVED FROM DEBUFF LIST", bp.colors.setting, bp.MA[spell].en:upper()))
                        return settings.debuffs[bp.player.main_job]:remove(index)

                    end
    
                end

            end

        end
        
        -- Public Methods.
        new.cast = function(target)

            if bp and bp.core and bp.core.get('debuffs') and target then

                for debuff in T(settings.debuffs[bp.player.main_job]):it() do

                    if bp.__actions.canCast() and bp.core.ready(debuff.spell) and (os.clock() - debuff.last) >= debuff.delay then
                        bp.core.add(debuff.spell, target, bp.priorities.get(debuff.spell))
                    end

                end

            end

        end

        new.add = function(spell, delay)
            local spell = type(spell) == 'table' and spell or bp.MA[spell] or false
            local delay = tonumber(delay) or 120

            if spell and delay and not pvt.exists(spell.en) then
                T(settings.debuffs[bp.player.main_job]):insert({spell=spell.en, delay=delay, last=0})
            end
            settings:save()

        end

        new.remove = function(spell)
            local spell = type(spell) == 'table' and spell or bp.MA[spell] or false

            if spell and pvt.exists(spell.en) then
                
                for option, index in T(settings.debuffs[bp.player.main_job]):it() do

                    if option.spell == spell.en then
                        return settings.debuffs[bp.player.main_job]:remove(index)
                    end
    
                end

            end
            settings:save()

        end

        new.clear = function()
            settings.debuffs = T{}
        end

        new.reset = function()

            for spell in T(settings.debuffs[bp.player.main_job]):it() do
                spell.delay = 0
            end

        end
        
        -- Private Events.
        helper('prerender', pvt.render)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'debuffs' and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if ('+'):startswith(command) and #commands > 0 then
                    pvt.add(commands)

                elseif ('-'):startswith(command) and #commands > 0 then
                    pvt.remove(commands)

                elseif ('clear'):startswith(command) then
                    new.clear()

                elseif ('visible'):startswith(command) then
                    settings.visible = (settings.visible ~= true) and true or false
                    bp.popchat.pop(string.format("DEBUFFS DISPLAY: \\cs(%s)%s\\cr", bp.colors.setting, tostring(settings.visible):upper()))

                elseif ('position'):startswith(command) and #commands > 0 then
                    settings.display:pos(tonumber(commands[1]) or settings.display:pos_x(), tonumber(commands[2]) or settings.display:pos_y())

                end
                settings:save()

            end
    
        end)

        helper('incoming chunk', function(id, original)
        
            if bp and id == 0x028 then
                local parsed    = bp.packets.parse('incoming', original)
                local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
                local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
                local param     = parsed['Param']
                
                if bp.player and actor and target and parsed['Category'] == 4 and actor.id == bp.player.id then
    
                    if bp.res.spells[param] and pvt.exists(bp.res.spells[param].en) then

                        for option in T(settings.debuffs[bp.player.main_job]):it() do

                            if option.spell == bp.res.spells[param].en then
                                option.last = os.clock()
                            end
            
                        end

                    end
        
                end
        
            end
            
        end)

        return new

    end

    return helper

end
return buildHelper