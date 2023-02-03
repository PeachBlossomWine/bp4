local switches = {}
switches['am'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 0 then
            local value = tonumber(commands[1])

            if value and type(value) == 'number' and T{1,2,3}:contains(value) then
                setting.tp = (value * 1000)

            else
                bp.popchat.pop('VALUE MUST BE BETWEEN 1 & 3!')

            end

        end
        bp.popchat.pop(string.format('AUTO-AFTERMATH (\\cs(%s)%s\\cr): LEVEL → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.tp/1000))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-AFTERMATH (\\cs(%s)%s\\cr): LEVEL → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.tp/1000))

    end

end

switches['ws'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        for i=1, #commands do
            
            if tonumber(commands[i]) then
                local value = tonumber(commands[i])

                if value and value >= 1000 and value <= 3000 then
                    setting.tp = value
                    table.remove(commands, i)

                else
                    bp.popchat.pop('VALUE MUST BE BETWEEN 1000 & 3000!')

                end

            end

        end

        if #commands > 0 then
            local index1, count1, id1 = bp.__inventory.getByIndex(bp.__equipment.get(0).bag, bp.__equipment.get(0).index)
            local index2, count2, id2 = bp.__inventory.getByIndex(bp.__equipment.get(2).bag, bp.__equipment.get(2).index)
            local skill = windower.convert_auto_trans(table.concat(commands, " ")):lower()

            for i=1, #commands do

                if skill then
                    local options1 = id1 and bp.res.items[id1] and bp.res.items[id1].skill and T(bp.res.weapon_skills:skill(bp.res.items[id1].skill)):map(function(r) return r.en end) or T{}
                    local options2 = id2 and bp.res.items[id2] and bp.res.items[id2].skill and T(bp.res.weapon_skills:skill(bp.res.items[id2].skill)):map(function(r) return r.en end) or T{}

                    if options1 and options2 then
                        local options = options1:update(options2)

                        for ws in options:it() do
                            
                            if ws:lower():startswith(skill) then
                                setting.name = ws
                                break

                            end

                        end

                    end

                end

            end
        
        end
        bp.popchat.pop(string.format('AUTO-WEAPONSKILL (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr → @\\cs(%s)%s TP\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name, bp.colors.setting, setting.tp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-WEAPONSKILL (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr → @\\cs(%s)%s TP\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name, bp.colors.setting, setting.tp))

    end

end

switches['rws'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        for i=1, #commands do
            
            if tonumber(commands[i]) then
                local value = tonumber(commands[i])

                if value and value >= 1000 and value <= 3000 then
                    setting.tp = value
                    table.remove(commands, i)

                else
                    bp.popchat.pop('VALUE MUST BE BETWEEN 1000 & 3000!')

                end

            end

        end

        if #commands > 0 then
            local index, count, id = bp.__inventory.getByIndex(bp.__equipment.get(2).bag, bp.__equipment.get(2).index)
            local skill = windower.convert_auto_trans(table.concat(commands, " ")):lower()

            for i=1, #commands do

                if id and skill then
                    local options = bp.res.items[id] and bp.res.items[id].skill and T(bp.res.weapon_skills:skill(bp.res.items[id].skill)):map(function(r) return r.en end) or T{}

                    for ws in options:it() do
                        
                        if ws:lower():startswith(skill) then
                            setting.name = ws
                            break

                        end

                    end

                end

            end
        
        end
        bp.popchat.pop(string.format('AUTO-RANGED (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr → @\\cs(%s)%s TP\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name, bp.colors.setting, setting.tp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-RANGED (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr → @\\cs(%s)%s TP\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name, bp.colors.setting, setting.tp))

    end

end

switches['skillup'] = function(bp, setting, commands)    

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 0 then
            local options = S{"Enhancing Magic","Divine Magic","Enfeebling Magic","Elemental Magic","Dark Magic","Singing","Summoning","Blue Magic","Geomancy"}
            local stype = windower.convert_auto_trans(table.concat(commands, " ")):lower()            

            for skill in options:it() do

                if skill:lower():startswith(stype) then
                    setting.skill = skill
                    break

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-SKILLUP (\\cs(%s)%s\\cr): SKILL → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.skill))
    
    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-SKILLUP (\\cs(%s)%s\\cr): SKILL → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.skill))

    end

end

switches['food'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if #commands > 0 then
            local food = bp.IT[windower.convert_auto_trans(table.concat(commands, " ")):lower()]

            if food then
                local index, count, id, status, bag, food = bp.__inventory.findByName(food.en, 0)

                if food then
                    setting.name = food.en

                else
                    bp.popchat.pop('UNABLE TO FIND THAT FOOD IN YOUR INVENTORY!')

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-FOOD (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-FOOD (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    end

end

switches['limit'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 0 then
            bp.__core.hardSet(setting, commands)

            for i=1, #commands do
                local option = commands[i]

                if T{'<','>'}:contains(option) then
                    setting.option = (option == '<') and '<' or '>'

                elseif tonumber(option) then
                    local value = tonumber(option)

                    if value and value >= 1 and value <= 100 then
                        setting.hpp = value

                    else
                        bp.popchat.pop('VALUE MUST BE BETWEEN 1 & 1000!')

                    end

                end

            end

        end
        bp.popchat.pop(string.format('WS LIMIT (\\cs(%s)%s\\cr): HP%% \\cs(%s)%s %s%%\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.option, setting.hpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('WS LIMIT (\\cs(%s)%s\\cr): HP%% \\cs(%s)%s %s%%\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.option, setting.hpp))

    end

end

switches['hate'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        for i in ipairs(commands) do
            local option = commands[i]

            if T{'true','false'}:contains(option:lower()) then
                setting.aoe = (option == "true")
            
            elseif tonumber(option) then
                local value = tonumber(option)

                if value and value >= 0 and value <= 30 then
                    setting.delay = value

                else
                    bp.popchat.pop('ENMITY DELAY VALUE MUST BE A NUMBER BETWEEN 0 & 30!')

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-ENMITY (\\cs(%s)%s\\cr): DELAY → \\cs(%s)%s\\cr, (AOE: \\cs(%s)%s\\cr) ', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.delay, bp.colors.setting, tostring(setting.aoe):upper()))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-ENMITY (\\cs(%s)%s\\cr): DELAY → \\cs(%s)%s\\cr, (AOE: \\cs(%s)%s\\cr) ', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.delay, bp.colors.setting, tostring(setting.aoe):upper()))

    end

end

switches['mb'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        for i in ipairs(commands) do
            local options = S{'Fire','Ice','Earth','Wind','Water','Lightning','Random'}

            if T{'true','false'}:contains(commands[i]:lower()) then
                setting.multi = (commands[i]:lower() == 'true')

            elseif tonumber(commands[i]) then
                local value = tonumber(commands[i])

                if value and value >= 1 and value <= 6 then
                    setting.tier = value

                else
                    bp.popchat.pop('BURST TIER VALUE MUST BE A NUMBER BETWEEN 1 & 6!')

                end

            else

                for element in options:it() do

                    if element:lower():startswith(commands[i]) then
                        setting.element = element
                    end

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-MAGIC BURST (\\cs(%s)%s\\cr): \\cs(%s)%s %s\\cr → MULTI-NUKE: \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.element, setting.tier, bp.colors.setting, tostring(setting.multi)))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-MAGIC BURST (\\cs(%s)%s\\cr): \\cs(%s)%s %s\\cr → MULTI-NUKE: \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.element, setting.tier, bp.colors.setting, tostring(setting.multi)))

    end

end

switches['sanguine blade'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 25 and value <= 75 then
                setting.hpp = value

            else
                bp.popchat.pop('ENTER A HP% VALUE BETWEEN 25 & 75!')

            end

        end
        bp.popchat.pop(string.format('AUTO-SANGUINE (\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-SANGUINE (\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp))

    end

end

switches['myrkr'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 25 and value <= 75 then
                setting.mpp = value

            else
                bp.popchat.pop('ENTER A HP% VALUE BETWEEN 25 & 75!')

            end

        end
        bp.popchat.pop(string.format('AUTO-MYRKR (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-MYRKR (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp))

    end

end

switches['moonlight'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 25 and value <= 75 then
                setting.mpp = value

            else
                bp.popchat.pop('ENTER A HP% VALUE BETWEEN 25 & 75!')

            end

        end
        bp.popchat.pop(string.format('AUTO-MOONLIGHT (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-MOONLIGHT (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp))

    end

end

switches['chakra'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 25 and value <= 75 then
                setting.hpp = value

            else
                bp.popchat.pop('ENTER A HP% VALUE BETWEEN 25 & 75!')

            end

        end
        bp.popchat.pop(string.format('AUTO-CHAKRA (\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-CHAKRA (\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp))

    end

end

switches['martyr'] = function(bp, setting, commands)    

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        for i in ipairs(commands) do

            if bp.__target(commands[i] or windower.ffxi.get_mob_by_target('t')) then
                local target = bp.__target(commands[i] or windower.ffxi.get_mob_by_target('t'))
    
                if target.name ~= bp.player.name and bp.__party.isMember(target) then
                    setting.target = target.name
    
                else
                    bp.popchat.pop('INVALID TARGET SELECTED!')
    
                end

            elseif tonumber(commands[i]) then
                local value = tonumber(commands[i])

                if value and value >= 25 and value <= 75 then
                    setting.hpp = value

                else
                    bp.popchat.pop('ENTER A HP% VALUE BETWEEN 25 & 75!')

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-MARTYR (\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr, TARGET @\\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp, bp.colors.setting, setting.target or "None"))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-MARTYR (\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr, TARGET @\\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp, bp.colors.setting, setting.target or "None"))

    end

end

switches['devotion'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        for i in ipairs(commands) do

            if bp.__target(commands[i] or windower.ffxi.get_mob_by_target('t')) then
                local target = bp.__target(commands[i] or windower.ffxi.get_mob_by_target('t'))
    
                if target.name ~= bp.player.name and bp.__party.isMember(target) then
                    setting.target = target.name
    
                else
                    bp.popchat.pop('INVALID TARGET SELECTED!')
    
                end

            elseif tonumber(commands[i]) then
                local value = tonumber(commands[i])

                if value and value >= 25 and value <= 75 then
                    setting.mpp = value

                else
                    bp.popchat.pop('ENTER A MP% VALUE BETWEEN 25 & 75!')

                end
    
            end

        end
        bp.popchat.pop(string.format('AUTO-DEVOTION (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr TARGET @\\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp, bp.colors.setting, setting.target or "None"))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-DEVOTION (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr TARGET @\\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp, bp.colors.setting, setting.target or "None"))

    end

end

switches['boost'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if commands[1] then
            local options = S{'Boost-STR','Boost-DEX','Boost-INT','Boost-CHR','Boost-AGI','Boost-VIT','Boost-MND'}
            local spell = windower.convert_auto_trans(commands[1]):lower()
            
            for boost in options:it() do
                    
                if boost:lower():startswith(spell) then
                    setting.name = boost
                    break

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-WHM BOOST (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-WHM BOOST (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    end

end

switches['cascade'] = function(bp, setting, commands)    

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 1000 and value <= 3000 then
                setting.tp = value

            else
                bp.popchat.pop('ENTER A TP% VALUE BETWEEN 1000 & 3000!')

            end

        end
        bp.popchat.pop(string.format('AUTO-CASCADE (\\cs(%s)%s\\cr): TP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.tp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-CASCADE (\\cs(%s)%s\\cr): TP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.tp))

    end

end

switches['gems'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 1 then

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-STRATAGEMS: \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper()))

    end

end

switches['spikes'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 0 then
            local options = S{'Blaze Spikes','Ice Spikes','Shock Spikes','Dread Spikes'}
            local spell = windower.convert_auto_trans(table.concat(commands, ' ')):lower()

            for spikes in options:it() do

                if spikes:lower():startswith(spell) and bp.__actions.isAvailable(spikes) then
                    setting.name = spikes
                    break

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-SPIKES (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-SPIKES (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    end

end

switches['drain'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 1 and value <= 75 then
                setting.hpp = value

            else
                bp.popchat.pop('AUTO-DRAIN HP%% VALUE NEEDS TO BE A NUMBER BETWEEN 1 & 75!')

            end

        end
        bp.popchat.pop(string.format('AUTO-DRAIN (\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-DRAIN (\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp))

    end

end

switches['aspir'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 1 and value <= 75 then
                setting.mpp = value

            else
                bp.popchat.pop('AUTO-ASPIR MP%% VALUE NEEDS TO BE A NUMBER BETWEEN 1 & 75!')

            end

        end
        bp.popchat.pop(string.format('AUTO-ASPIR (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-ASPIR (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp))

    end

end

switches['convert'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if #commands > 0 then
            local mpp = commands[1] and tonumber(commands[1])
            local hpp = commands[2] and tonumber(commands[2])

            if mpp and mpp >= 25 and mpp <= 75 then
                setting.mpp = mpp
            end

            if hpp and hpp >= 25 and hpp <= 75 then
                setting.hpp = hpp
            end

        end
        bp.popchat.pop(string.format('AUTO-CONVERT (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr, HP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp, bp.colors.setting, setting.hpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-CONVERT (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr, HP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp, bp.colors.setting, setting.hpp))

    end

end

switches['gain'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if commands[1] then
            local options = S{'Gain-VIT','Gain-DEX','Gain-CHR','Gain-MND','Gain-AGI','Gain-STR','Gain-INT'}
            local spell = windower.convert_auto_trans(commands[1]):lower()

            for gain in options:it() do

                if gain:lower():startswith(spell) then
                    setting.name = gain
                    break

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-GAIN SPELL (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-GAIN SPELL (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    end

end

switches['en'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 0 then
            local update = ""

            for i=1, #commands do

                if tonumber(commands[i]) and T{1,2}:contains(tonumber(commands[i])) then
                    setting.tier = tonumber(commands[i])

                else
                    local options = S{'Enfire','Enaero','Enblizzard','Enstone','Enthunder','Enwater'}
                    local spell = windower.convert_auto_trans(commands[i]):lower()

                    for enspell in options:it() do

                        if enspell:lower():startswith(spell) then
                            update = enspell
                            break

                        end

                    end

                end

            end
            setting.name = string.format("%s%s", update, (setting.tier) == 2 and " II" or "")

        end
        bp.popchat.pop(string.format('AUTO-ENSPELL (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-ENSPELL (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    end

end

switches['cover'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if bp.__target(commands[1] or windower.ffxi.get_mob_by_target('t')) then
            local target = bp.__target(commands[1] or windower.ffxi.get_mob_by_target('t'))

            if target.name ~= bp.player.name and bp.__party.isMember(target) then
                setting.target = target.name

            else
                bp.popchat.pop('INVALID TARGET SELECTED!')

            end

        end
        bp.popchat.pop(string.format('AUTO-COVER (\\cs(%s)%s\\cr): @\\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.target or "None"))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-COVER (\\cs(%s)%s\\cr): @\\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.target or "None"))

    end

end

switches['chivalry'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 0 then
            
            if commands[1] then
                local value = tonumber(commands[1])
                        
                if value and value >= 25 and value <= 75 then
                    setting.mpp = value

                elseif commands[1] ~= '-' then
                    bp.popchat.pop('MP%% MUST BE A NUMBER BETWEEN 25 & 75!')

                end

            end

            if commands[2] then
                local value = tonumber(commands[2])

                if value and value >= 1000 and value <= 3000 then
                    setting.tp = value

                elseif commands[1] ~= '-' then
                    bp.popchat.pop('TP%% MUST BE A NUMBER BETWEEN 1000 & 3000!')

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-CHIVALRY (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr, TP → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp, bp.colors.setting, setting.tp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-CHIVALRY (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr, TP → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp, bp.colors.setting, setting.tp))

    end

end

switches['absorb'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if commands[1] then
            local options = S{'Absorb-VIT','Absorb-DEX','Absorb-CHR','Absorb-MND','Absorb-AGI','Absorb-STR','Absorb-INT','Absorb-ACC','Absorb-TP','Absorb-Attri'}
            local spell = windower.convert_auto_trans(commands[1]):lower()

            for absorb in options:it() do

                if absorb:lower():startswith(spell) then
                    setting.name = absorb
                    break

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-ABSORB SPELL (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-ABSORB SPELL (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    end

end

switches['reward'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if commands[1] then
            local value = tonumber(commands[1])

            if value and value >= 1 and value <= 75 then
                setting.hpp = value

            else
                bp.popchat.pop('HP% MUST BE A NUMBER BETWEEN 1 & 75!')

            end

        end
        bp.popchat.pop(string.format('AUTO-REWARD (\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-REWARD (\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp))

    end

end

switches['ready'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if commands[1] then
            local value = windower.convert_auto_trans(commands[1])

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-READY: \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper()))

    end

end

switches['decoy shot'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if bp.__target(commands[1] or windower.ffxi.get_mob_by_target('t')) then
            local target = bp.__target(commands[1] or windower.ffxi.get_mob_by_target('t'))

            if target.name ~= bp.player.name and bp.__party.isMember(target) then
                setting.target = target.name

            else
                bp.popchat.pop('INVALID TARGET SELECTED!')

            end

        end
        bp.popchat.pop(string.format('AUTO-DECOY SHOT (\\cs(%s)%s\\cr): @\\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.target or "None"))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-DECOY SHOT (\\cs(%s)%s\\cr): @\\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.target or "None"))

    end

end

switches['elemental siphon'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if commands[1] then
            local value = tonumber(commands[1])

            if value and value >= 25 and value <= 75 then
                settings.mpp = value

            else
                bp.popchat.pop('MP% MUST BE A NUMBER BETWEEN 25 & 75!')

            end

        end
        bp.popchat.pop(string.format('AUTO-ELEMENTAL SIPHON (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-ELEMENTAL SIPHON (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp))

    end

end

switches['summon'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if commands[1] then
            local options = S{'Carbuncle','Cait Sith','Ifrit','Shiva','Garuda','Ramuh','Titan','Leviathan','Fenrir','Diabolos','Siren'}
            local spell = windower.convert_auto_trans(commands[1]):lower()

            for summon in options:it() do

                if summon:lower():startswith(spell) then
                    setting.name = summon
                    break                        

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-SUMMON (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name or "None"))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-SUMMON (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name or "None"))

    end

end

switches['bpr'] = function(bp, setting, commands)
    local message = {summon=nil, pact=nil}
    local rages = {

        ['Carbuncle']   = {'Poison Nails','Meteorite','Holy Mist'},
        ['Cait Sith']   = {'Regal Scratch','Level ? Holy', 'Regal Gash'},
        ['Ifrit']       = {'Flaming Crush','Meteor Strike','Conflag Strike'},
        ['Shiva']       = {'Double Slap','Rush','Heavenly Strike'},
        ['Garuda']      = {'Claw','Predator Claws','Wind Blade'},
        ['Titan']       = {'Mountain Buster','Geocrush','Crag Throw'},
        ['Ramuh']       = {'Thunderspark','Thunderstorm','Volt Strike'},
        ['Leviathan']   = {'Spinning Dive','Grand Fall'},
        ['Fenrir']      = {'Eclipse Bite','Lunar Bay','Impact'},
        ['Diabolos']    = {'Nether Blast','Night Terror'},
        ['Siren']       = {'Sonic Buffet','Hysteric Assault'},

    }

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 1 then
            local pet = windower.convert_auto_trans(commands[1]):lower()
            local spell = windower.convert_auto_trans(commands[2]):lower()

            for rages, summon in T(rages):it() do

                if summon:lower():startswith(pet) then

                    for rage in S(rages):it() do

                        if rage:lower():startswith(spell) then
                            setting.pacts[summon], message = rage, {summon=summon, pact=rage}
                            break

                        end

                    end

                end

            end

        end
        
        if message.summon and message.pact then
            bp.popchat.pop(string.format('AUTO-BLOOD PACT: RAGE (\\cs(%s)%s\\cr): @\\cs(%s)%s\\cr → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, message.summon, bp.colors.setting, message.pact))

        else
            bp.popchat.pop(string.format('AUTO-BLOOD PACT: RAGE → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper()))

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-BLOOD PACT: RAGE → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper()))

    end

end

switches['bpw'] = function(bp, setting, commands)
    local message = {summon=nil, pact=nil}
    local wards = {

        ['Carbuncle']   = S{'Shining Ruby','Glittering Ruby','Healing Ruby II','Soothing Ruby'},
        ['Cait Sith']   = S{'Mewing Lullaby'},
        ['Ifrit']       = S{'Crimson Howl','Inferno Howl'},
        ['Shiva']       = S{'Crystal Blessing'},
        ['Garuda']      = S{'Whispering Wind','Hastega II'},
        ['Titan']       = S{'Earthen Armor'},
        ['Ramuh']       = S{'Rolling Thunder','Shock Squall'},
        ['Leviathan']   = S{'Spring Water'},
        ['Fenrir']      = S{'Ecliptic Growl','Ecliptic Howl','Lunar Roar'},
        ['Diabolos']    = S{'Somnolence','Dream Shroud'},
        ['Siren']       = S{'Bitter Elegy','Wind\'s Blessing'},

    }

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 1 then
            local pet = windower.convert_auto_trans(commands[1]):lower()
            local spell = windower.convert_auto_trans(commands[2]):lower()

            for wards, summon in T(wards):it() do

                if summon:lower():startswith(pet) then

                    for ward in S(wards):it() do

                        if ward:lower():startswith(spell) then
                            setting.pacts[summon], message = ward, {summon=summon, pact=ward}
                            break

                        end

                    end

                end

            end

        end

        if message.summon and message.pact then
            bp.popchat.pop(string.format('AUTO-BLOOD PACT: WARD (\\cs(%s)%s\\cr): @\\cs(%s)%s\\cr → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, message.summon, bp.colors.setting, message.pact))

        else
            bp.popchat.pop(string.format('AUTO-BLOOD PACT: WARD → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper()))

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-BLOOD PACT: WARD → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper()))

    end

end

switches['shikikoyo'] = function(bp, setting, commands)    

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        for i=1, #commands do

            if bp.__target(commands[i] or windower.ffxi.get_mob_by_target('t')) then
                local target = bp.__target(commands[i] or windower.ffxi.get_mob_by_target('t'))

                if target.name ~= bp.player.name and bp.__party.isMember(target) then
                    setting.target = target.name

                else
                    bp.popchat.pop('INVALID TARGET SELECTED!')

                end

            elseif tonumber(commands[i]) then
                local value = tonumber(commands[i])

                if value and value >= 1000 and value <= 3000 then
                    setting.tp = value

                else
                    bp.popchat.pop('ENTER A TP VALUE BETWEEN 1000 & 3000!')

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-SHIKIKOYO (\\cs(%s)%s\\cr): @\\cs(%s)%s\\cr ( %s )', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.target, bp.colors.setting, setting.tp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-SHIKIKOYO (\\cs(%s)%s\\cr): @\\cs(%s)%s\\cr ( %s )', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.target, bp.colors.setting, setting.tp))

    end

end

switches['diffusion'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if commands[1] then
            local options = T(windower.ffxi.get_mjob_data().spells):map(function(id) return (bp.res.spells[id] and bp.res.spells[id].targets:contains('Self')) and bp.res.spells[id].en or nil end)
            local spell = windower.convert_auto_trans(commands[1]):lower()

            for cast in options:it() do

                if cast:lower():startswith(spell) then
                    setting.name = cast
                    break

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-DIFFUSION (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-DIFFUSION (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    end

end

switches['magic hammer'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 25 and value <= 75 then
                setting.mpp = value

            else
                bp.popchat.pop('ENTER A HP% VALUE BETWEEN 25 & 75!')

            end

        end
        bp.popchat.pop(string.format('AUTO-MAGIC HAMMER (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-MAGIC HAMMER (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp))

    end

end

switches['quick draw'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if commands[1] then
            local options = T{'Fire Shot','Water Shot','Thunder Shot','Earth Shot','Wind SHot','Ice SHot','Light Shot','Dark Shot'}
            local spell = windower.convert_auto_trans(commands[1]):lower()

            for shot in options:it() do

                if shot:lower():startswith(spell) then
                    setting.name = shot
                    break

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-QUICK DRAW (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-QUICK DRAW (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    end

end

switches['rolls'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 0 then
            local options = bp.__rolls.list
            local roll1 = commands[1] and windower.convert_auto_trans(commands[1]):lower() or false
            local roll2 = commands[2] and windower.convert_auto_trans(commands[2]):lower() or false

            for roll in options:it() do

                if roll1 and (roll:lower():startswith(roll1) or bp.__rolls.getShort(roll1) == roll) and not T(setting.list):contains(roll) then
                    setting.list[1] = roll

                elseif roll2 and (roll:lower():startswith(roll2) or bp.__rolls.getShort(roll2) == roll) and not T(setting.list):contains(roll) then
                    setting.list[2] = roll

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-ROLLS (\\cs(%s)%s\\cr): { \\cs(%s)%s\\cr }', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, T(setting.list):concat(string.format("\\cr • \\cs(%s)", bp.colors.setting))))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-ROLLS (\\cs(%s)%s\\cr): { \\cs(%s)%s\\cr }', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, T(setting.list):concat(string.format("\\cr • \\cs(%s)", bp.colors.setting))))

    end

end

switches['repair'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if commands[1] then
            local value = tonumber(commands[1])

            if value and value >= 25 and value <= 75 then
                setting.hpp = value

            else
                bp.popchat.pop('HP% MUST BE A NUMBER BETWEEN 25 & 75!')

            end

        end
        bp.popchat.pop(string.format('AUTO-REPAIR(\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-REPAIR(\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp))

    end

end

switches['maneuvers'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if #commands > 0 then
            local options = T{'Fire Maneuver','Water Maneuver','Wind Maneuver','Ice Maneuver','Earth Maneuver','Thunder Maneuver','Light Maneuver','Dark Maneuver'}

            if commands[1] then
                local spell = windower.convert_auto_trans(commands[1]):lower()

                for maneuver in options:it() do

                    if maneuver:lower():startswith(spell) then
                        setting.list[1] = maneuver
                        break
                    end

                end

            end
            
            if commands[2] then
                local spell = windower.convert_auto_trans(commands[2]):lower()

                for maneuver in options:it() do

                    if maneuver:lower():startswith(spell) then
                        setting.list[2] = maneuver
                        break
                    end

                end

            end

            if commands[3] then
                local spell = windower.convert_auto_trans(commands[3]):lower()

                for maneuver in options:it() do

                    if maneuver:lower():startswith(spell) then
                        setting.list[3] = maneuver
                        break
                    end

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-MANEUVERS (\\cs(%s)%s\\cr): { \\cs(%s)%s\\cr } ', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, T(setting.list):concat(string.format("\\cr • \\cs(%s)", bp.colors.setting))))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-MANEUVERS (\\cs(%s)%s\\cr): { \\cs(%s)%s\\cr } ', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, T(setting.list):concat(string.format("\\cr • \\cs(%s)", bp.colors.setting))))

    end

end

switches['sambas'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 0 then
            local options = T{'Drain Samba','Aspir Samba','Haste Samba'}
            local spell = windower.convert_auto_trans(table.concat(commands, " ")):lower()

            for samba in options:it() do

                if samba:lower():startswith(spell) then
                    setting.name = samba
                    break

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-SAMBAS (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-SAMBAS (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    end

end

switches['steps'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 0 then
            local options = T{'Quickstep','Box Step','Stutter Step','Feather Step'}
            local spell = windower.convert_auto_trans(table.concat(commands, " ")):lower()

            for step in options:it() do

                if step:lower():startswith(spell) then
                    setting.name = step
                    break

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-STEPS (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-STEPS (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    end

end

switches['skillchain'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if commands[1] then
            local options = S{'Compression','Liquefaction','Scission','Reverberation','Detonation','Induration','Impaction','Gravitation','Distortion','Fusion','Fragmentation'}
            local element = windower.convert_auto_trans(commands[1]):lower()

            for skillchain in options:it() do
                
                if skillchain:lower():startswith(element) then
                    setting.mode = skillchain
                    break

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-SCHOLAR SKILLCHAIN (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mode))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-SCHOLAR SKILLCHAIN (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mode))

    end

end

switches['sublimation'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if commands[1] then
            local value = tonumber(commands[1])

            if value and value >= 1 and value <= 60 then
                setting.mpp = value

            else
                bp.popchat.pop('VALUE MUST BE BETWEEN 1 & 60!')

            end

        end
        bp.popchat.pop(string.format('AUTO-SUBLIMATION (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-SUBLIMATION (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp))

    end

end

switches['helix'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 0 then
            local update = ""

            for i=1, #commands do
                
                if tonumber(commands[i]) and T{1,2}:contains(tonumber(commands[i])) then
                    setting.tier = tonumber(commands[i])

                else
                    local options = S{'Pyrohelix','Cryohelix','Anemohelix','Geohelix','Ionohelix','Hydrohelix','Luminohelix','Noctohelix'}
                    local spell = windower.convert_auto_trans(table.concat(commands, ' ')):lower()

                    for helix in options:it() do

                        if helix:lower():startswith(spell) then
                            update = helix
                            break

                        end

                    end

                end

            end
            setting.name = string.format("%s%s", update, (setting.tier) == 2 and " II" or "")

        end
        bp.popchat.pop(string.format('AUTO-HELIX (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-HELIX (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    end

end

switches['storms'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 0 then
            local options = S{'Sandstorm','Rainstorm','Windstorm','Firestorm','Hailstorm','Thunderstorm','Voidstorm','Aurorastorm'}
            local spell = windower.convert_auto_trans(commands[1]):lower()

            for storm in options:it() do

                if storm:lower():startswith(spell) then
                    setting.name = storm
                    break

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-STORMS (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-STORMS (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    end

end

switches['bubbles'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 0 then

            for i=1, #commands do
                local spell = windower.convert_auto_trans(commands[i]):lower()

                if (bp.__bubbles.shortcuts.indicolure[spell] or bp.__bubbles.shortcuts.geocolure[spell] or (bp.MA[spell] and bp.MA[spell].type == 'Geomancy')) then
                    
                    if i == 1 and (bp.__bubbles.isIndicolure(bp.__bubbles.shortcuts.indicolure[spell]) or (bp.MA[spell] and bp.__bubbles.isIndicolure(bp.MA[spell].en))) then
                        setting.list[i] = bp.__bubbles.shortcuts.indicolure[spell] or bp.MA[spell].en
                        bp.__bubbles.recast('indi', true)

                    elseif i == 2 and (bp.__bubbles.isGeocolure(bp.__bubbles.shortcuts.geocolure[spell]) or (bp.MA[spell] and bp.__bubbles.isGeocolure(bp.MA[spell].en))) then
                        setting.list[i] = bp.__bubbles.shortcuts.geocolure[spell] or bp.MA[spell].en
                        bp.__bubbles.recast('geo', true)

                    elseif i == 3 and (bp.__bubbles.isIndicolure(bp.__bubbles.shortcuts.indicolure[spell]) or (bp.MA[spell] and bp.__bubbles.isIndicolure(bp.MA[spell].en))) then
                        setting.list[i] = bp.__bubbles.shortcuts.indicolure[spell] or bp.MA[spell].en
                        bp.__bubbles.recast('indi', true)

                    end

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-BUBBLES (\\cs(%s)%s\\cr): { \\cs(%s)%s\\cr }', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, T(setting.list):concat(string.format("\\cr • \\cs(%s)", bp.colors.setting))))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-BUBBLES (\\cs(%s)%s\\cr): { \\cs(%s)%s\\cr }', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, T(setting.list):concat(string.format("\\cr • \\cs(%s)", bp.colors.setting))))

    end

end

switches['full circle'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if commands[1] then
            local value = tonumber(commands[1])

            if value and value >= 10 and value <= 30 then
                setting.distance = value

            else
                bp.popchat.pop('DISTANCE MUST BE A NUMBER BETWEEN 10 & 30!')

            end

        end
        bp.popchat.pop(string.format('AUTO-FULL CIRCLE (\\cs(%s)%s\\cr): \\cs(%s)%05.2f\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.distance))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-FULL CIRCLE (\\cs(%s)%s\\cr): \\cs(%s)%05.2f\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.distance))

    end

end

switches['radial arcana'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 1 and value <= 75 then
                setting.mpp = value

            else
                bp.popchat.pop('AUTO-RADIAL ARCANA MP%% VALUE NEEDS TO BE A NUMBER BETWEEN 1 & 75!')

            end

        end
        bp.popchat.pop(string.format('AUTO-RADIAL ARCANA (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-RADIAL ARCANA (\\cs(%s)%s\\cr): MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.mpp))

    end

end

switches['mending halation'] = function(bp, setting, commands) -- NEEDS UPDATE!

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 1 and value <= 75 then
                setting.hpp = value

            else
                bp.popchat.pop('AUTO-MENDING HALATION HP%% VALUE NEEDS TO BE A NUMBER BETWEEN 1 & 75!')

            end

        end
        bp.popchat.pop(string.format('AUTO-MENDING HALATION (\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-MENDING HALATION (\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp))

    end

end

switches['runes'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 0 then

            if commands[1] then
                local rune = windower.convert_auto_trans(commands[1]):lower() or false

                if rune and bp.__runes.isRune(rune) then
                    setting.list[1] = bp.__runes.isRune(rune)
                end

            end

            if commands[2] then
                local rune = windower.convert_auto_trans(commands[2]):lower() or false

                if rune and bp.__runes.isRune(rune) then
                    setting.list[2] = bp.__runes.isRune(rune)
                end

            end

            if commands[3] then
                local rune = windower.convert_auto_trans(commands[3]):lower() or false

                if rune and bp.__runes.isRune(rune) then
                    setting.list[3] = bp.__runes.isRune(rune)
                end

            end

        end
        bp.popchat.pop(string.format('AUTO-RUNES (\\cs(%s)%s\\cr): { \\cs(%s)%s\\cr }', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, T(setting.list):concat(string.format("\\cr • \\cs(%s)", bp.colors.setting))))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-RUNES (\\cs(%s)%s\\cr): { \\cs(%s)%s\\cr }', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, T(setting.list):concat(string.format("\\cr • \\cs(%s)", bp.colors.setting))))

    end

end

switches['vivacious pulse'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)
        
        if commands[1] then
            local value = tonumber(commands[1])

            if value and value >= 25 and value <= 75 then
                setting.hpp = value

            elseif commands[1] ~= '-' then
                bp.popchat.pop('HP% MUST BE A NUMBER BETWEEN 25 & 75!')

            end

        end

        if commands[2] then
            local value = tonumber(commands[2])

            if value and value >= 25 and value <= 75 then
                setting.mpp = value

            elseif commands[1] ~= '-' then
                bp.popchat.pop('MP% MUST BE A NUMBER BETWEEN 25 & 75!')

            end

        end
        bp.popchat.pop(string.format('AUTO-V. PULSE (\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr, MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp, bp.colors.setting, setting.mpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-V. PULSE (\\cs(%s)%s\\cr): HP%% → \\cs(%s)%s\\cr, MP%% → \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.hpp, bp.colors.setting, setting.mpp))

    end

end

switches['embolden'] = function(bp, setting, commands)

    if setting and #commands > 0 then
        bp.__core.hardSet(setting, commands)

        if #commands > 0 then
            local options = T{'Protect','Crusade','Temper','Phalanx','Foil'}
            local spell = windower.convert_auto_trans(commands[1]):lower()

            for name in options:it() do

                if name:lower():startswith(spell) then
                    setting.name = (name == "Protect") and string.format('%s IV', name) or name
                    break

                end

            end

        end
        bp.popchat.pop(string.format('AUTO-EMBOLDEN (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.popchat.pop(string.format('AUTO-EMBOLDEN (\\cs(%s)%s\\cr): \\cs(%s)%s\\cr', bp.colors.setting, tostring(setting.enabled):upper(), bp.colors.setting, setting.name))

    end

end
return switches