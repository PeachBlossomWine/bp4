local switches = {}
switches['am'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if #commands > 0 then
            local value = tonumber(commands[1])

            if value and type(value) == 'number' and T{1,2,3}:contains(value) then
                setting.tp = (value * 1000)
                bp.helpers.popchat.pop(string.format('AUTO-AFTERMATH LEVEL SET TO: %s.', setting.tp))

            else
                bp.helpers.popchat.pop('VALUE MUST BE BETWEEN 1 & 3!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-AFTERMATH: %s.', tostring(setting.enabled)))

    end

end

switches['ra'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        for i in ipairs(commands) do
            local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]
            
            if type(value) == 'number' then    

                if value >= 1000 and value <= 3000 then
                    flags.tp = value
                    bp.helpers.popchat.pop(string.format('AUTO-RANGED WEAPONSKILL TP THRESHOLD SET TO: %s.', flags.tp))

                else
                    bp.helpers.popchat.pop('VALUE MUST BE BETWEEN 1000 & 3000!')

                end

            elseif not set then
                local value = {}
                for i,v in ipairs(commands) do

                    if not tonumber(v) then
                        table.insert(value, windower.convert_auto_trans(v))
                    end

                end
                set = true

                do
                    local value = table.concat(value, ' ')
                    local weaponskills = bp.res.weapon_skills

                    for _,v in pairs(windower.ffxi.get_abilities().weapon_skills) do
                                
                        if weaponskills[v] and weaponskills[v].en then
                            local match = (weaponskills[v].en):match(("[%a%s%'%:]+"))
                            
                            if value:sub(1,8):lower() == match:sub(1,8):lower() then
                                flags.name = weaponskills[v].en
                                bp.helpers.popchat.pop(string.format('AUTO-RANGED WEAPONSKILL SET TO: %s.', flags.name))
                                break

                            end
                            
                        end
                        
                    end

                end

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-RANGED: %s.', tostring(setting.enabled)))

    end

end

switches['ws'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        for i in ipairs(commands) do
            local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]
            
            if type(value) == 'number' then

                if value >= 1000 and value <= 3000 then
                    flags.tp = value
                    bp.helpers.popchat.pop(string.format('AUTO-WEAPONSKILL TP THRESHOLD SET TO: %s.', flags.tp))

                else
                    bp.helpers.popchat.pop('VALUE MUST BE BETWEEN 1000 & 3000!')

                end
                table.remove(commands)

            elseif not set then
                local value = {}
                for i,v in ipairs(commands) do

                    if not tonumber(v) then
                        table.insert(value, windower.convert_auto_trans(v))
                    end

                end
                set = true

                do
                    local value = table.concat(value, ' ')
                    local weaponskills = bp.res.weapon_skills

                    for _,v in pairs(windower.ffxi.get_abilities().weapon_skills) do
                                
                        if weaponskills[v] and weaponskills[v].en then
                            local match = (weaponskills[v].en):match(("[%a%s%'%:]+"))
                            
                            if value:lower() == match:sub(1, #value):lower() then
                                flags.name = weaponskills[v].en
                                bp.helpers.popchat.pop(string.format('AUTO-WEAPONSKILL SET TO: %s.', flags.name))
                                break

                            end
                            
                        end
                        
                    end

                end

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-WEAPONSKILL: %s.', tostring(setting.enabled)))

    end

end

switches['skillup'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if #commands > 0 then
            local value = #commands > 1 and table.concat(commands, ' ') or windower.convert_auto_trans(commands[1])
            local found = false

            for _,skill in ipairs({"Enhancing Magic","Divine Magic","Enfeebling Magic","Elemental Magic","Dark Magic","Singing","Summoning","Blue Magic","Geomancy"}) do

                if value:lower() == skill:sub(1, #value):lower() then
                    found = true
                    flags.skill = skill
                    bp.helpers.popchat.pop(string.format('AUTO-SKILLUP SPELL SET TO: %s.', flags.skill))
                    break

                end

            end

            if not found then
                bp.helpers.popchat.pop('INVALID SKILL NAME!')
            end

        end
    
    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-SKILLUP: %s.', tostring(setting.enabled)))

    end

end

switches['food'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        for i in ipairs(commands) do
            local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

            if value then
                local food = bp.helpers['inventory'].findItemByName(windower.convert_auto_trans(value))

                if food and bp.IT[food.en] then
                    flags.name = food.en
                    bp.helpers.popchat.pop(string.format('AUTO-FOOD SET TO: %s.', flags.name))

                else
                    bp.helpers.popchat.pop('UNABLE TO FIND THAT FOOD IN YOUR INVENTORY!')

                end

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-FOOD: %s.', tostring(setting.enabled)))

    end

end

switches['limit'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if #commands > 0 then
            local value = tonumber(commands[1])

            if type(value) == 'number' then
                flags.hpp = value
                bp.helpers.popchat.pop(string.format('MOB HPP LIMIT SET TO: %s.', flags.hpp))

            else
                bp.helpers.popchat.pop('VALUE MUST BE BETWEEN 1 & 3!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('MOB HPP LIMIT: %s.', tostring(setting.enabled)))

    end

end

switches['hate'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        for i in ipairs(commands) do
            local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

            if value then

                if type(value) == 'string' then

                    if value == 'aoe' then
                        flags.aoe = flags.aoe ~= true and true or false
                        bp.helpers.popchat.pop(string.format('AOE HATE SPELLS: %s.', tostring(flags.aoe)))

                    end

                elseif type(value) == 'number' then
                    
                    if value >= 0 and value <= 30 then
                        flags.delay = value
                        bp.helpers.popchat.pop(string.format('AUTO-ENMITY DELAY SET TO: %s.', flags.delay))

                    else
                        bp.helpers.popchat.pop('ENMITY DELAY VALUE MUST BE A NUMBER BETWEEN 0 & 30!')

                    end

                end

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-ENMITY: %s.', tostring(setting.enabled)))

    end

end

switches['mb'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        for i in ipairs(commands) do
            local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

            if value then
                local elements = {'Fire','Ice','Earth','Wind','Water','Lightning','Random'}
                
                if type(value) == 'string' then

                    if value == 'multi' then
                        flags.multi = flags.multi ~= true and true or false
                        bp.helpers.popchat.pop(string.format('MULTIPLE MAGIC BURST ATTEMPTS: %s.', tostring(flags.multi)))

                    else
                        
                        for _,element in ipairs(elements) do

                            if value:lower() == element:sub(1, #value):lower() then
                                flags.element = element
                                bp.helpers.popchat.pop(string.format('AUTO-MAGIC BURST ELEMENT SET TO: %s.', flags.element))
                                break

                            end

                        end

                    end

                elseif type(value) == 'number' then
                    
                    if value >= 2 and value <= 6 then
                        flags.tier = value
                        bp.helpers.popchat.pop(string.format('AUTO-MAGIC BURST TIER SET TO: %s.', flags.tier))

                    else
                        bp.helpers.popchat.pop('BURST TIER VALUE MUST BE A NUMBER BETWEEN 2 & 6!')

                    end

                end

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-MAGIC BURST: %s.', tostring(setting.enabled)))

    end

end

switches['sanguine blade'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 25 and value <= 75 then
                setting.hpp = value
                bp.helpers.popchat.pop(string.format('AUTO-SANGUINE HP%% SET TO: %s.', setting.hpp))

            else
                bp.helpers.popchat.pop('ENTER A HP% VALUE BETWEEN 25 & 75!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-SANGUINE BLADE: %s.', tostring(setting.enabled)))

    end

end

switches['myrkr'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 25 and value <= 75 then
                setting.mpp = value
                bp.helpers.popchat.pop(string.format('AUTO-MYRKR MP%% SET TO: %s.', setting.mpp))

            else
                bp.helpers.popchat.pop('ENTER A HP% VALUE BETWEEN 25 & 75!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-MYRKR: %s.', tostring(setting.enabled)))

    end

end

switches['moonlight'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 25 and value <= 75 then
                setting.mpp = value
                bp.helpers.popchat.pop(string.format('AUTO-MOONLIGHT MP%% SET TO: %s.', setting.mpp))

            else
                bp.helpers.popchat.pop('ENTER A HP% VALUE BETWEEN 25 & 75!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-MOONLIGHT: %s.', tostring(setting.enabled)))

    end

end

switches['chakra'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 25 and value <= 75 then
                flags.hpp = value
                bp.helpers.popchat.pop(string.format('AUTO-CHAKRA HP%% SET TO: %s.', setting.hpp))

            else
                bp.helpers.popchat.pop('ENTER A HP% VALUE BETWEEN 25 & 75!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-CHAKRA: %s.', tostring(setting.enabled)))

    end

end

switches['martyr'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        for i in ipairs(commands) do
            local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

            if (value or target) then
                
                if type(value) == 'number' then
                    
                    if value >= 10 and value <= 75 then
                        flags.hpp = value
                        bp.helpers.popchat.pop(string.format('AUTO-MARTYR HP%% SET TO: %s.', flags.hpp))

                    else
                        bp.helpers.popchat.pop('ENTER A HP% VALUE BETWEEN 10 & 75!')

                    end

                end
                
                if target and target.name ~= bp.player.name then
                    local target = value ~= nil and windower.ffxi.get_mob_by_name(value) or target

                    if target and bp.helpers['party'].isInParty(target) then
                        flags.target = target.name
                        bp.helpers.popchat.pop(string.format('AUTO-MARTYR TARGET SET TO: %s.', flags.target))

                    else
                        bp.helpers.popchat.pop('INVALID TARGET SELECTED!')

                    end

                end

            end

        end

    elseif flags and #commands == 0 then
        
        if not target then
            flags.enabled = flags.enabled ~= true and true or false
            bp.helpers.popchat.pop(string.format('AUTO-MARTYR: %s.', tostring(flags.enabled)))

        else

            if target and target.name ~= bp.player.name then

                if target and bp.helpers['party'].isInParty(target) then
                    flags.target = target.name
                    bp.helpers.popchat.pop(string.format('AUTO-MARTYR TARGET SET TO: %s.', flags.target))

                else
                    bp.helpers.popchat.pop('INVALID TARGET SELECTED!')

                end

            end

        end

    end

end

switches['devotion'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        for i in ipairs(commands) do
            local option = commands[i]

            if tonumber(option) ~= nil then
                local value = tonumber(option)
                    
                if value >= 25 and value <= 75 then
                    flags.mpp = value
                    bp.helpers.popchat.pop(string.format('AUTO-DEVOTION MP%% SET TO: %s.', flags.mpp))

                else
                    bp.helpers.popchat.pop('ENTER A MP% VALUE BETWEEN 25 & 75!')

                end

            elseif tonumber(option) == nil then
                local target = bp.helpers['target'].getValidTarget(option)
                
                if target and target.name ~= bp.player.name then

                    if target and bp.helpers['party'].isInParty(target) then
                        flags.target = target.name
                        bp.helpers.popchat.pop(string.format('AUTO-DEVOTION TARGET SET TO: %s.', flags.target))

                    else
                        bp.helpers.popchat.pop('INVALID TARGET SELECTED!')

                    end

                end

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-DEVOTION: %s.', tostring(setting.enabled)))

    end

end

switches['boost'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if commands[1] then
            local options = S{'Boost-STR','Boost-DEX','Boost-INT','Boost-CHR','Boost-AGI','Boost-VIT','Boost-MND'}
            local spell = windower.convert_auto_trans(commands[1]):lower()
            
            for boost in options:it() do
                    
                if boost:lower():startswith(spell) then
                    setting.name = boost
                    break

                end

            end
            bp.helpers.popchat.pop(string.format('AUTO-WHM BOOST SPELL SET TO: %s.', setting.name))

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-BOOST: %s.', tostring(setting.enabled)))

    end

end

switches['cascade'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 1000 and value <= 3000 then
                setting.tp = value
                bp.helpers.popchat.pop(string.format('AUTO-CASCADE TP%% SET TO: %s.', setting.tp))

            else
                bp.helpers.popchat.pop('ENTER A TP% VALUE BETWEEN 1000 & 3000!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-CASCADE: %s.', tostring(setting.enabled)))

    end

end

switches['gems'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        for _,ability in ipairs(commands) do
            
            for name, list in pairs(setting) do
                
                if ability == name:sub(1, #ability) then
                    table.remove(commands, 1)

                    do
                        local spell = table.concat(commands, ' '):lower()

                        if setting[name] and not T(flags[name]):contains(spell) and bp.MA[spell] then
                            table.insert(flags[name], spell)
                            bp.helpers.popchat.pop(string.format('%s ADDED TO AUTO-%s.', spell, name))

                        elseif setting[name] and spell == 'Clear' then
                            setting[name] = {}
                            bp.helpers.popchat.pop(string.format('%s LIST CLEARED!', name))

                        end

                    end
                    break
                    
                end

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-STRATAGEMS: %s.', tostring(setting.enabled)))

    end

end

switches['spikes'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        for i in ipairs(commands) do
            local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

            if value then

                if type(value) == 'string' then            
                    local spell = windower.convert_auto_trans(value)
        
                    if (S{'BLM','RDM','SCH','RUN'}:contains(bp.player.main_job) or S{'BLM','RDM','SCH','RUN'}:contains(bp.player.sub_job)) then
        
                        if S{'Blaze Spikes','Ice Spikes','Shock Spikes'}:contains(spell) then
                            flags.name = spell
                            bp.helpers.popchat.pop(string.format('AUTO-SPIKES SPELL SET TO: %s.', flags.name))
    
                        else
                            bp.helpers.popchat.pop('INVALID SPELL NAME!')
    
                        end
    
                    elseif S{'DRK'}:contains(bp.player.main_job) then
    
                        if spell == 'Dread Spikes' then
                            flags.name = spell
                            bp.helpers.popchat.pop(string.format('AUTO-SPIKES SPELL SET TO: %s.', flags.name))
    
                        else
                            bp.helpers.popchat.pop('INVALID SPELL NAME!')
    
                        end
    
                    end

                end

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-SPIKES: %s.', tostring(setting.enabled)))

    end

end

switches['footwork'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if commands[1] then
            
            if ("impetus"):startswith(commands[1]:lower()) then
                local option = commands[2] and commands[2]:lower() or false

                if S{"!","#"}:contains(option) then
                    
                    if option == "!" then
                        setting.impetus = true

                    elseif option == "#" then
                        setting.impetus = false

                    end

                else
                    setting.impetus = setting.impetus ~= true and true or false

                end

            end
            bp.helpers.popchat.pop(string.format('FOOTWORK DURING IMPETUS SET TO: %s.', tostring(setting.impetus)))

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-FOOTWORK: %s.', tostring(setting.enabled)))

    end

end

switches['drain'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 1 and value <= 75 then
                setting.mpp = value
                bp.helpers.popchat.pop(string.format('AUTO-DRAIN HP%% SET TO: %s.', setting.hpp))

            else
                bp.helpers.popchat.pop('AUTO-DRAIN HP%% VALUE NEEDS TO BE A NUMBER BETWEEN 1 & 75!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-DRAIN: %s.', tostring(setting.enabled)))

    end

end

switches['aspir'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        if commands[1] then
            local value = tonumber(commands[1])
                    
            if value and value >= 1 and value <= 75 then
                setting.mpp = value
                bp.helpers.popchat.pop(string.format('AUTO-ASPIR MP%% SET TO: %s.', setting.mpp))

            else
                bp.helpers.popchat.pop('AUTO-ASPIR MP%% VALUE NEEDS TO BE A NUMBER BETWEEN 1 & 75!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-ASPIR: %s.', tostring(setting.enabled)))

    end

end

switches['convert'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        if commands[1] then
            local value = tonumber(commands[1])

            if value and value >= 25 and value <= 75 then
                setting.mpp = value
            end

        end

        if commands[2] then
            local value = tonumber(commands[2])

            if value and value >= 25 and value <= 75 then
                setting.hpp = value
            end

        end
        bp.helpers.popchat.pop(string.format('CONVERT → MP%% [ %s ] / HP%% [ %s ]', setting.mpp, setting.hpp))

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-CONVERT: %s.', tostring(setting.enabled)))

    end

end

switches['gain'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if commands[1] then
            local options = S{'Gain-VIT','Gain-DEX','Gain-CHR','Gain-MND','Gain-AGI','Gain-STR','Gain-INT'}
            local spell = windower.convert_auto_trans(commands[i]):lower()

            for gain in options:it() do

                if gain:lower():startswith(spell) then
                    setting.name = gain
                    break

                end

            end
            bp.helpers.popchat.pop(string.format('AUTO-GAIN SPELL SET TO: %s.', setting.name))

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-GAIN: %s.', tostring(setting.enabled)))

    end

end

switches['en'] = function(bp, settings, commands, command)
    local setting = settings[bp.player.sub_job][command] ~= nil and settings[bp.player.sub_job][command] or settings[bp.player.main_job][command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        for i=1, #commands do

            if tonumber(commands[i]) and T{1,2}:contains(tonumber(commands[i])) then
                setting.tier = tonumber(commands[i])
                setting.name = (setting.tier) == 2 and string.format('%s II', setting.name) or setting.name

            else
                local options = S{'Enfire','Enaero','Enblizzard','Enstone','Enthunder','Enwater'}
                local spell = windower.convert_auto_trans(commands[i]):lower()

                for enspell in options:it() do

                    if enspell:lower():startswith(spell) then
                        setting.name = (setting.tier) == 2 and string.format('%s II', enspell) or enspell
                        break

                    end

                end

            end

        end
        bp.helpers.popchat.pop(string.format('AUTO-ENSPELL SET TO: %s.', setting.name))
        table.print(setting)

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-ENSPELL: %s.', tostring(setting.enabled)))

    end

end

switches['cover'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if bp.libs.__target(commands[1] or windower.ffxi.get_mob_by_target('t')) then
            local target = bp.libs.__target(commands[1] or windower.ffxi.get_mob_by_target('t'))

            if target.name ~= bp.player.name and bp.libs.__party.isMember(target) then
                setting.target = target.name
                bp.helpers.popchat.pop(string.format('AUTO-COVER TARGET SET TO: %s.', setting.target))

            else
                bp.helpers.popchat.pop('INVALID TARGET SELECTED!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-COVER: %s.', tostring(setting.enabled)))

    end

end

switches['chivalry'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if #commands > 0 then
            
            if commands[1] then
                local value = tonumber(commands[1])
                        
                if value and value >= 25 and value <= 75 then
                    setting.mpp = value
                    bp.helpers.popchat.pop(string.format('CHIVALRY MP%% SET TO: %s.', setting.mpp))

                else
                    bp.helpers.popchat.pop('MP%% MUST BE A NUMBER BETWEEN 25 & 75!')

                end

            end

            if commands[2] then
                local value = tonumber(commands[2])

                if value and value >= 1000 and value <= 3000 then
                    setting.tp = value
                    bp.helpers.popchat.pop(string.format('CHIVALRY TP%% SET TO: %s.', setting.tp))

                else
                    bp.helpers.popchat.pop('TP%% MUST BE A NUMBER BETWEEN 1000 & 3000!')

                end

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-CHIVALRY: %s.', tostring(setting.enabled)))

    end

end

switches['absorb'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if commands[1] then
            local options = S{'Absorb-VIT','Absorb-DEX','Absorb-CHR','Absorb-MND','Absorb-AGI','Absorb-STR','Absorb-INT','Absorb-ACC','Absorb-TP','Absorb-Attri'}
            local spell = windower.convert_auto_trans(commands[1]):lower()

            for absorb in options:it() do

                if absorb:lower():startswith(spell) then
                    setting.name = absorb
                    break

                end

            end
            bp.helpers.popchat.pop(string.format('AUTO-ABSORB SPELL SET TO: %s.', setting.name))

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-ABSORB: %s.', tostring(setting.enabled)))

    end

end

switches['reward'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        if commands[1] then
            local value = tonumber(commands[1])

            if value and value >= 1 and value <= 75 then
                setting.hpp = value
                bp.helpers.popchat.pop(string.format('AUTO-REWARD HP%% SET TO: %s.', setting.hpp))

            else
                bp.helpers.popchat.pop('HP% MUST BE A NUMBER BETWEEN 1 & 75!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-REWARD: %s.', tostring(setting.enabled)))

    end

end

switches['ready'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        if commands[1] then
            local value = windower.convert_auto_trans(commands[1])

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-READY: %s.', tostring(setting.enabled)))

    end

end

switches['decoy shot'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if bp.libs.__target(commands[1] or windower.ffxi.get_mob_by_target('t')) then
            local target = bp.libs.__target(commands[1] or windower.ffxi.get_mob_by_target('t'))

            if target.name ~= bp.player.name and bp.libs.__party.isMember(target) then
                setting.target = target.name
                bp.helpers.popchat.pop(string.format('AUTO-DECOY SHOT TARGET SET TO: %s.', setting.target))

            else
                bp.helpers.popchat.pop('INVALID TARGET SELECTED!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-DECOY SHOT: %s.', tostring(setting.enabled)))

    end

end

switches['elemental siphon'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if commands[1] then
            local value = tonumber(commands[1])

            if value and value >= 1 and value <= 75 then
                settings.mpp = value
                bp.helpers.popchat.pop(string.format('AUTO-ELEMENTAL SIPHON MP%% SET TO: %s.', setting.mpp))

            else
                bp.helpers.popchat.pop('MP% MUST BE A NUMBER BETWEEN 1 & 75!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-ELEMENTAL SIPHON: %s.', tostring(setting.enabled)))

    end

end

switches['summon'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if commands[1] then
            local summons = S{'Carbuncle','Cait Sith','Ifrit','Shiva','Garuda','Ramuh','Titan','Leviathan','Fenrir','Diabolos','Siren','Atomos'}
            local spell = windower.convert_auto_trans(commands[1]):lower()

            for summon in options:it() do

                if summon:lower():startswith(spell) then
                    setting.name = summon
                    break                        

                end

            end
            bp.helpers.popchat.pop(string.format('AUTO-SUMMON SET TO: %s.', setting.name))

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-SUMMON: %s.', tostring(setting.enabled)))

    end

end

switches['bpr'] = function(bp, settings, commands, command)
    local setting = settings[command]
    local rages = {

        ['Carbuncle']   = S{'Poison Nails','Meteorite','Holy Mist'},
        ['Cait Sith']   = S{'Regal Scratch','Level ? Holy', 'Regal Gash'},
        ['Ifrit']       = S{'Flaming Crush','Meteor Strike','Conflag Strike'},
        ['Shiva']       = S{'Double Slap','Rush','Heavenly Strike'},
        ['Garuda']      = S{'Claw','Predator Claws','Wind Blade'},
        ['Titan']       = S{'Mountain Buster','Geocrush','Crag Throw'},
        ['Ramuh']       = S{'Thunderspark','Thunderstorm','Volt Strike'},
        ['Leviathan']   = S{'Spinning Dive','Grand Fall'},
        ['Fenrir']      = S{'Eclipse Bite','Lunar Bay','Impact'},
        ['Diabolos']    = S{'Nether Blast','Night Terror'},
        ['Siren']       = S{'Sonic Buffet','Hysteric Assault'},

    }

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if #commands > 0 then
            local summons = S{'Carbuncle','Cait Sith','Ifrit','Shiva','Garuda','Ramuh','Titan','Leviathan','Fenrir','Diabolos','Siren','Atomos'}
            local pet = windower.convert_auto_trans(commands[1]):lower()

            if commands[2] then
                local match = commands[2]:lower()

                for summon in summons:it() do

                    if summon:lower():startswith(pet) and rages[summon] and setting.pacts[summon] ~= nil then

                        for rage, index in rages[summon]:it() do

                            if rage:lower():startswith(match) then
                                setting.pacts[summon] = rage
                                bp.helpers.popchat.pop(string.format('AUTO-BLOOD PACT: RAGE SET TO: %s.', setting.pacts[summon]))
                                break

                            end

                        end

                    end

                end

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-BLOOD PACT RAGES: %s.', tostring(setting.enabled)))

    end

end

switches['bpw'] = function(bp, settings, commands, command)
    local setting = settings[command]
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
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if #commands > 0 then
            local summons = S{'Carbuncle','Cait Sith','Ifrit','Shiva','Garuda','Ramuh','Titan','Leviathan','Fenrir','Diabolos','Siren','Atomos'}
            local pet = windower.convert_auto_trans(commands[1]):lower()

            if commands[2] then
                local match = commands[2]:lower()

                for summon in summons:it() do

                    if summon:lower():startswith(pet) and wards[summon] and setting.pacts[summon] ~= nil then

                        for ward, index in wards[summon]:it() do

                            if ward:lower():startswith(match) then
                                setting.pacts[summon] = ward
                                bp.helpers.popchat.pop(string.format('AUTO-BLOOD PACT: WARD SET TO: %s.', setting.pacts[summon]))
                                break

                            end

                        end

                    end

                end

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-BLOOD PACT WARDS: %s.', tostring(setting.enabled)))

    end

end

switches['shikikoyo'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        for i=1, #commands do

            if bp.libs.__target(commands[i] or windower.ffxi.get_mob_by_target('t')) then
                local target = bp.libs.__target(commands[i] or windower.ffxi.get_mob_by_target('t'))

                if target.name ~= bp.player.name and bp.libs.__party.isMember(target) then
                    setting.target = target.name
                    bp.helpers.popchat.pop(string.format('AUTO-SHIKIKOYO TARGET SET TO: %s.', setting.target))

                else
                    bp.helpers.popchat.pop('INVALID TARGET SELECTED!')

                end

            elseif tonumber(commands[i]) then
                local value = tonumber(commands[i])

                if value and value >= 1000 and value <= 3000 then
                    setting.tp = value
                    bp.helpers.popchat.pop(string.format('AUTO-SHIKIKOYO TP%% SET TO: %s.', setting.tp))

                else
                    bp.helpers.popchat.pop('ENTER A TP% VALUE BETWEEN 1000 & 3000!')

                end

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-SHIKIKOYO TARGET SET TO: %s.', flags.target))

    end

end

switches['quick draw'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if commands[1] then
            local options = S{'Fire Shot','Water Shot','Thunder Shot','Earth Shot','Wind SHot','Ice SHot','Light Shot','Dark Shot'}
            local spell = windower.convert_auto_trans(commands[1]):lower()

            for shot in options:it() do

                if shot:lower():startswith(spell) then
                    setting.name = shot
                    break

                end

            end
            bp.helpers.popchat.pop(string.format('AUTO-QUICK DRAW SET TO: %s.', setting.name))

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-QUICK DRAW: %s.', tostring(setting.enabled)))

    end

end

switches['repair'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if commands[1] then
            local value = tonumber(commands[1])

            if value and value >= 1 and value <= 75 then
                setting.hpp = value
                bp.helpers.popchat.pop(string.format('AUTO-REPAIR HP%% SET TO: %s.', setting.hpp))

            else
                bp.helpers.popchat.pop('HP% MUST BE A NUMBER BETWEEN 1 & 75!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-REPAIR: %s.', tostring(setting.enabled)))

    end

end

switches['maneuvers'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        if #commands > 0 then
            local options = S{'Fire Maneuver','Water Maneuver','Wind Maneuver','Ice Maneuver','Earth Maneuver','Thunder Maneuver','Light Maneuver','Dark Maneuver'}

            for i=1, #commands do
                local spell = windower.convert_auto_trans(commands[i]):lower()

                for maneuver in options:it() do

                    if maneuver:lower():startswith(spell) then
                        setting[string.format('maneuver%s', i)] = maneuver
                        bp.helpers.popchat.pop(string.format('AUTO-MANEUVER #%s SET TO: %s.', i, setting[string.format('maneuver%s', i)]))

                    end

                end

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-MANEUVERS: %s.', tostring(setting.enabled)))

    end

end

switches['sambas'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if #commands > 0 then
            local options = S{'Drain Samba','Aspir Samba','Haste Samba','Drain Samba II','Aspir Samba II','Drain Samba III'}
            local spell = windower.convert_auto_trans(table.concat(commands, " ")):lower()

            for samba in options:it() do

                if samba:lower():startswith(spell) then
                    setting.name = samba
                    break

                end

            end
            bp.helpers.popchat.pop(string.format('AUTO-SAMBAS SET TO: %s.', setting.name))

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-SAMBA: %s.', tostring(setting.enabled)))

    end

end

switches['steps'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if #commands > 0 then
            local options = S{'Quickstep','Box Step','Stutter Step','Feather Step'}
            local spell = windower.convert_auto_trans(table.concat(commands, " ")):lower()

            for step in options:it() do

                if step:lower():startswith(spell) then
                    setting.name = step
                    break

                end

            end
            bp.helpers.popchat.pop(string.format('AUTO-STEPS SET TO: %s.', setting.name))

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-STEP: %s.', tostring(setting.enabled)))

    end

end

switches['flourishes'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if #commands > 0 then
            local cat1 = T{'Animated Flourish','Desperate Flourish','Violent Flourish'}
            local cat2 = T{'Reverse Flourish','Building Flourish','Wild Flourish'}
            local cat3 = T{'Climactic Flourish','Striking Flourish','Ternary Flourish'}

            for i in ipairs(commands) do
                local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                if value then
                    local spell = windower.convert_auto_trans(value)

                    if cat1:contains(spell) then
                        local options = cat1
                        local spell = windower.convert_auto_trans(value)
                        local error = true

                        for _,flourish in ipairs(options) do

                            if flourish:lower():sub(1, #spell) == spell:lower():sub(1, #spell) then
                                flags.cat_1 = flourish
                                error = false

                            end

                        end

                        if error then
                            bp.helpers.popchat.pop(string.format('INVALID OPTION (#%s) - FLOURISH NAME NOT FOUND!', i))

                        else
                            bp.helpers.popchat.pop(string.format('AUTO-FLOURISHES (CATEGORY I) SET TO: %s.', flags.cat_1))

                        end

                    elseif cat2:contains(spell) then
                        local options = cat2
                        local spell = windower.convert_auto_trans(value)
                        local error = true

                        for _,flourish in ipairs(options) do

                            if flourish:lower():sub(1, #spell) == spell:lower():sub(1, #spell) then
                                flags.cat_2 = flourish
                                error = false

                            end

                        end

                        if error then
                            bp.helpers.popchat.pop(string.format('INVALID OPTION (#%s) - FLOURISH NAME NOT FOUND!', i))

                        else
                            bp.helpers.popchat.pop(string.format('AUTO-FLOURISHES (CATEGORY I) SET TO: %s.', flags.cat_1))

                        end

                    elseif cat3:contains(spell) then
                        local options = cat3
                        local spell = windower.convert_auto_trans(value)
                        local error = true

                        for _,flourish in ipairs(options) do

                            if flourish:lower():sub(1, #spell) == spell:lower():sub(1, #spell) then
                                flags.cat_3 = flourish
                                error = false

                            end

                        end

                        if error then
                            bp.helpers.popchat.pop(string.format('INVALID OPTION (#%s) - FLOURISH NAME NOT FOUND!', i))

                        else
                            bp.helpers.popchat.pop(string.format('AUTO-FLOURISHES (CATEGORY I) SET TO: %s.', flags.cat_1))

                        end

                    end

                end

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-FLOURISHES: %s.', tostring(setting.enabled)))

    end

end

switches['jigs'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if #commands > 0 then
            local options = S{'Spectral Jig','Chocobo Jig','Chocobo Jig II'}
            local spell = windower.convert_auto_trans(table.concat(commands, " ")):lower()

            for jig in options:it() do

                if jig:lower():startswith(spell) then
                    setting.name = jig
                    break

                end

            end
            bp.helpers.popchat.pop(string.format('AUTO-JIGS SET TO: %s.', setting.name))

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-JIG: %s.', tostring(setting.enabled)))

    end

end

switches['skillchain'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if commands[1] then
            local options = S{'Compression','Liquefaction','Scission','Reverberation','Detonation','Induration','Impaction','Gravitation','Distortion','Fusion','Fragmentation'}
            local element = windower.convert_auto_trans(commands[1]):lower()

            for skillchain in options:it() do
                
                if skillchain:lower():startswith(element) then
                    setting.mode = skillchain
                    break

                end

            end
            bp.helpers.popchat.pop(string.format('AUTO-SCH SKILLCHAIN MODE SET TO: %s.', setting.mode))

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-SCH SKILLCHAIN: %s.', tostring(setting.enabled)))

    end

end

switches['sublimation'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if commands[1] then
            local value = tonumber(commands[1])

            if value and value >= 1 and value <= 60 then
                setting.mpp = value
                bp.helpers.popchat.pop(string.format('AUTO-SUBLIMATION MP%% SET TO: %s.', setting.mpp))

            else
                bp.helpers.popchat.pop('VALUE MUST BE BETWEEN 1 & 60!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-SUBLIMATION: %s.', tostring(setting.enabled)))

    end

end

switches['storms'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if #commands > 0 then
            local options = S{'Sandstorm','Rainstorm','Windstorm','Firestorm','Hailstorm','Thunderstorm','Voidstorm','Aurorastorm'}
            local spell = windower.convert_auto_trans(commands[1]):lower()

            for storm in options:it() do

                if storm:lower():startswith(spell) then
                    setting.name = storm
                    break

                end

            end
            bp.helpers.popchat.pop(string.format('AUTO-STORMS SPELL SET TO: %s.', setting.name))

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-STORMS: %s.', tostring(setting.enabled)))

    end

end

switches['full circle'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        if commands[1] then
            local value = tonumber(commands[1])

            if value and value >= 10 and value <= 30 then
                flags.distance = value
                bp.helpers.popchat.pop(string.format('AUTO-FULL CIRCLE DISTANCE SET TO: %s.', flags.distance))

            else
                bp.helpers.popchat.pop('DISTANCE MUST BE A NUMBER BETWEEN 10 & 30!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-FULL CIRCLE: %s.', tostring(setting.enabled)))

    end

end

switches['vivacious pulse'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)
        
        if commands[1] then
            local value = tonumber(commands[1])

            if value >= 1 and value <= 75 then
                setting.hpp = value
                bp.helpers.popchat.pop(string.format('AUTO-V. PULSE HP%% SET TO: %s.', setting.hpp))

            else
                bp.helpers.popchat.pop('HP% MUST BE A NUMBER BETWEEN 1 & 75!')

            end

        end

        if commands[2] then
            local value = tonumber(commands[2])

            if value and value >= 1 and value <= 75 then
                setting.mpp = value
                bp.helpers.popchat.pop(string.format('AUTO-V. PULSE MP%% SET TO: %s.', setting.mpp))

            else
                bp.helpers.popchat.pop('MP% MUST BE A NUMBER BETWEEN 1 & 75!')

            end

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-VIVACIOUS PULSE: %s.', tostring(setting.enabled)))

    end

end

switches['embolden'] = function(bp, settings, commands, command)
    local setting = settings[command]

    if setting and #commands > 0 then
        bp.libs.__core.hardSet(bp, settings, commands, command)

        if #commands > 0 then
            local options = S{'Protect','Crusade','Temper','Phalanx','Foil'}
            local spell = windower.convert_auto_trans(commands[1]):lower()

            for name in options:it() do

                if name:lower():startswith(spell) then
                    setting.name = (name == "Protect") and string.format('%s IV', name) or name
                    break

                end

            end
            bp.helpers.popchat.pop(string.format('AUTO-EMBOLDEN SPELL SET TO: %s.', setting.name))

        end

    elseif setting and #commands == 0 then
        setting.enabled = setting.enabled ~= true and true or false
        bp.helpers.popchat.pop(string.format('AUTO-EMBOLDEN: %s.', tostring(setting.enabled)))

    end

end
return switches