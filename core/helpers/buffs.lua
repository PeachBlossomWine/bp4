local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=1, y=1}, bg={alpha=0, red=0, green=0, blue=0, visible=false}, flags={draggable=true, bold=true}, text={size=12, font='Calibri', alpha=255, red=245, green=200, blue=20, stroke={width=1, alpha=255, red=0, green=0, blue=0}}, padding=10}
    local settings  = bp.__settings.new('buffs')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __buffing = {}

        do -- Private Settings.
            settings.layout     = settings.layout or layout
            settings.display    = settings:getDisplay()

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.render = function() bp.__ui.renderUI(settings.display) end
        pvt.update = function()
            
            if bp and #__buffing > 0 then
                local update = {}
    
                for index, data in ipairs(__buffing) do
                    local player = bp.__target.get(data.player)
    
                    if player and bp.__distance.get(player) < 30 and (bp.__distance.get(player) ~= 0 or bp.player.id == player.id) then
                        table.insert(update, string.format('%s%s → \\cs(%s)%s\\cr', player.name:sub(1,8), (' '):rpad(' ', (10-(player.name:sub(1,8):len()))), bp.colors.important, T(data.spells):keyset():map(function(id) return bp.res.spells[id] and bp.res.spells[id].en end):sort():tostring()))
                    end
                    T(update):sort()
    
                end
                settings.display:text(table.concat(update, '\n'))
    
            elseif settings.display:visible() then
                settings.display:hide()
    
            end
    
        end

        pvt.getSpell = function(name)
            local name = windower.convert_auto_trans(table.concat(name, ' '))

            if bp and name and bp.MA[name] and T{33,34,37,39,43}:contains(bp.MA[name].skill) and bp.__actions.isAvailable(bp.MA[name].en) then

                if bp.player.main_job == 'BLU' then
                    local spells = T(windower.ffxi.get_mjob_data().spells)

                    if spells:contains(bp.MA[name].id) then
                        return bp.MA[name]
                    end

                else
                    return bp.MA[name]

                end

            end
            return false
    
        end

        pvt.getPlayerIndex = function(id)
            if not id then return false end
    
            for index, data in ipairs(__buffing) do

                if data.player == id then
                    return index
                end

            end
            return false
    
        end
        
        -- Public Methods.
        new.add = function(target, spell)
            local spell = pvt.getSpell(spell)

            if bp and spell and target and not bp.__target.isTrust(target) then
                local index = pvt.getPlayerIndex(target.id)
    
                if not index and bp.__target.castable(target, spell) then
                    table.insert(__buffing, {player=target.id, spells={[spell.id] = {last=0, delay=3, status=spell.status}}})
    
                elseif __buffing[index] and not __buffing[index].spells[spell.id] and bp.__target.castable(target, spell) then
                    __buffing[index].spells[spell.id] = {last=0, delay=3, status=spell.status}
    
                end
                pvt.update()
    
            end
    
        end

        new.remove = function(target, spell)

            if bp and spell and target and target.id then
                local index = pvt.getPlayerIndex(target.id)
                local spell = pvt.getSpell(spell)
                
                if index and spell and spell.id and __buffing[index] and __buffing[index].spells[spell.id] then
                    __buffing[index].spells[spell.id] = nil
    
                    if #__buffing[index].spells == 0 then
                        __buffing[index] = nil
                    end
    
                end
                pvt.update()
    
            end
    
        end

        new.clear = function()
            __buffing = {}
            pvt.update()
            
        end

        new.cast = function()
            
            for data in T(__buffing):it() do
                local target = bp.__target.get(data.player)

                if target then

                    for id, spell in pairs(data.spells) do
                        
                        if spell.last and spell.status and not bp.__buffs.hasBuff(target.id, spell.status) and (os.clock()-spell.last) > spell.delay then
                            
                            if bp.res.spells[id] and not bp.__queue.inQueue(bp.res.spells[id], target) then
                                bp.__queue.add(bp.res.spells[id], target, bp.priorities.get(bp.res.spells[id].en, true))
                                spell.last = os.clock()

                            end

                        end

                    end

                end

            end
    
        end
        
        -- Private Events.
        helper('prerender', pvt.render)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'buffs' and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then
                    local target = commands[#commands] and bp.__party.getMember(commands[#commands]) and bp.__party.getMember(table.remove(commands, #commands)).mob or windower.ffxi.get_mob_by_target('t') or false

                    if command == '+' then
                        new.add(target, commands)

                    elseif command == '-' then
                        new.remove(target, commands)

                    elseif command == 'clear' then
                        new.clear()

                    end

                end

            end
    
        end)

        helper('incoming chunk', function(id, original)
        
            if bp and bp.player and id == 0x028 then
                local parsed    = bp.packets.parse('incoming', original)
                local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
                local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
    
                if parsed['Category'] == 4 and target then
            
                    if actor and bp.player and bp.player.id == actor.id and bp.res.spells[param] and bp.res.spells[param].type then
                        local index = pvt.getPlayerIndex(target.id)
                            
                        if index and spell and spell.id and __buffing[index] and __buffing[index].spells[spell.id] then
                            --- ???
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