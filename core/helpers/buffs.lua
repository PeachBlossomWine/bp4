local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=1, y=1}, bg={alpha=75, red=0, green=0, blue=0, visible=true}, flags={draggable=true, bold=false}, text={size=8, font='Lucida Console', alpha=255, red=245, green=200, blue=20, stroke={width=1, alpha=255, red=0, green=0, blue=0}}, padding=10}
    local settings  = bp.libs.__settings.new('buffs')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __allowed = require('resources').spells:skill(34)
        local __buffing = {}

        do -- Private Settings.
            settings.layout     = settings.layout or layout
            settings.display    = settings:getDisplay()

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.render = function() bp.libs.__ui.renderUI(settings.display) end
        pvt.update = function()
            
            if bp and #__buffing > 0 then
                local update = {}
    
                for index, data in ipairs(__buffing) do
                    local player = bp.libs.__target.get(data.player.id)
    
                    if player and bp.libs.__distance.get(player) < 30 and (bp.libs.__distance.get(player) ~= 0 or bp.player.id == player.id) then
                        table.insert(update, string.format('%s%s → \\cs(%s)%s\\cr', player.name:sub(1,8), (' '):rpad(' ', (10-(player.name:sub(1,8):len()))), bp.colors.important, T(data.spells):keyset():map(function(id) return bp.res.spells[id] and bp.res.spells[id].en end):sort():tostring()))
                    end
                    T(update):sort()
    
                end
                settings.display:text(table.concat(update, '\n'))
    
            else
                settings.display:text('')
    
            end
    
        end

        pvt.getSpell = function(name)
            local name = windower.convert_auto_trans(table.concat(name, ' '))
    
            if bp and name and tostring(name) ~= nil then
    
                for spell in T(__allowed):it() do

                    if spell.en:lower() == name:lower() and bp.libs.__actions.isAvailable(spell.en) then
                        return spell
                    end
    
                end
    
            end
            return false
    
        end

        pvt.getPlayerIndex = function(id)
            if not id then return false end
    
            for index, data in ipairs(__buffing) do

                if data.player.id == id then
                    return index
                end

            end
            return false
    
        end
        
        -- Public Methods.
        new.add = function(target, spell)
            local spell = pvt.getSpell(spell)

            if bp and spell and target then
                local index = pvt.getPlayerIndex(target.id)
    
                if not index and bp.libs.__target.castable(target, spell) then
                    table.insert(__buffing, {player=target, spells={[spell.id] = {last=0, delay=3, status=spell.status}}})
    
                elseif __buffing[index] and not __buffing[index].spells[spell.id] and bp.libs.__target.castable(target, spell) then
                    __buffing[index].spells[spell.id] = {last=0, delay=3, status=spell.status}
    
                end
                pvt.update()
    
            end
    
        end

        new.remove = function(target, spell)

            if bp and spell and target then
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

        new.cast = function()
            
            for data in T(__buffing):it() do
                local target = data.player

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
        
        -- Private Events.
        helper('prerender', pvt.render)
        helper('mouse', function(param, x, y, delta, blocked) settings:saveDisplay(x, y, param) end)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'buffs' and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then
                    local target = bp.libs.__target.get(commands[#commands]:gsub("^%l", string.upper))
                    
                    if #commands > 0 and target then
                        table.remove(commands, commands[#commands])

                    else
                        target = windower.ffxi.get_mob_by_target('t') or false

                    end

                    if target then

                        if S{'a','add','+'}:contains(command) then
                            new.add(target, commands)
    
                        elseif S{'r','remove','-'}:contains(command) then
                            new.remove(target, commands)
    
                        end

                    else

                        if S{'c','clear'}:contains(command) then
                            pvt.clear()
                        end

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
                        local index = pvt.selferIndex(target.id)
                            
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