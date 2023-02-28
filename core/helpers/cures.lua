local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local settings = bp.libs.__settings.new('cures')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __debug       = false
        local __modes       = {'PARTY','ALLIANCE'}
        local __jobs        = {3,4,5,7,10,15,19,20,21}
        local __spells      = {1,2,3,4,5,6,7,8,9,10,11}
        local __abilities   = {190,191,192,193,311,195,262}
        local __party       = {}
        local __alliance    = {}
        local __priorities  = {}
        local __allowed     = {
        
            ['Cure'] = {
    
                {id=1,      priority=false, min=90},
                {id=2,      priority=false, min=200},
                {id=3,      priority=false, min=650},
                {id=4,      priority=true,  min=900},
                {id=5,      priority=true,  min=1100},
                {id=6,      priority=true,  min=1800}
    
            },
            
            ['Curaga'] = {
                
                {id=7,      priority=false, min=110},
                {id=8,      priority=false, min=275},
                {id=9,      priority=true,  min=700},
                {id=10,     priority=true,  min=980},
                {id=11,     priority=true,  min=1300}
    
            },
            
            ['Waltz'] = {
    
                {id=190,    priority=false, min=200},
                {id=191,    priority=false, min=650},
                {id=192,    priority=false, min=900},
                {id=193,    priority=true,  min=1100},
                {id=311,    priority=true,  min=1800},
    
            },
            
            ['Waltzga'] = {
    
                {id=195,    priority=false, min=100},
                {id=262,    priority=true,  min=400},
    
            },
            
        }

        do -- Private Settings.
            settings.mode       = settings.mode or 1
            settings.power      = settings.power or 15

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.validSpell = function(id) return T(__spells):contains(id) end
        pvt.validAbility = function(id) return T(__abilities):contains(id) end
        pvt.sort = function(t) return table.sort(t, function(a, b) return a.missing > b.missing end) end
        
        pvt.setMode = function(mode)
            local mode = tonumber(mode)
    
            if mode and mode >= 1 and mode <= 2 then
                settings.mode = mode
            end
    
        end

        pvt.buildParty = function()
            __party, __alliance = {}, {}

            if bp and bp.party then
                
                for i,v in pairs(bp.party) do
                    
                    if i:sub(1,1) == 'p' and tonumber(i:sub(2)) ~= nil and type(v) == 'table' and v.mob then
                        table.insert(__party, {id=v.mob.id, name=v.mob.name, distance=v.mob.distance, priority=1, hp=v.hp, hpp=v.hpp, missing=math.floor(v.hp/(v.hpp / 100)-v.hp)})
                    
                    elseif i:sub(1,1) == 'a' and tonumber(i:sub(2)) ~= nil and type(v) == 'table' and v.mob then
                        table.insert(__alliance, {id=v.mob.id, name=v.mob.name, distance=v.mob.distance, priority=1, hp=v.hp, hpp=v.hpp, missing=math.floor(v.hp/(v.hpp / 100)-v.hp)})                        
                    
                    end
                    
                end

            end
            
        end

        pvt.getWeight = function()
            local selected = {target=false, weight=0, count=0}
            local sorted = pvt.sort(__party)

            for target in T(sorted):it() do
                local target = bp.__target.get(target.id)

                if target and bp.__distance.get(target) <= 21 then
                    local weight, n = 0, 0

                    for _,m in ipairs(sorted) do
                        local member = bp.__target.get(m.id)
                        
                        if member and (((target.x-member.x)^2 + (target.y-member.y)^2) <= 10^2) then

                            if bp.player.main_job_level == 99 then
                                local curaga = false

                                for i=3, #__allowed['Curaga'] do
                                    local spell = __allowed['Curaga'][i]

                                    if spell and m.missing >= spell.min then
                                        curaga = spell
                                    end

                                end

                                if curaga then
                                    weight = (weight + m.missing)
                                    n = (n + 1)

                                end

                            elseif bp.player.main_job_level < 50 then

                                for i=1, #__allowed['Curaga'] do
                                    local spell = __allowed['Curaga'][i]

                                    if spell and m.missing >= spell.min then
                                        curaga = spell
                                    end

                                end

                                if curaga then
                                    weight, n = (weight + m.missing), (n + 1)
                                end

                            end

                        end

                    end

                    if weight > selected.weight then
                        selected = {target=target, weight=weight, count=n}                    
                    end
                    
                end

            end
            return selected
    
        end

        pvt.estimateCure = function(missing, percent)
            local estimate, once = false, true
            
            if bp and bp.player and missing and percent and missing > 0 then
                local vitals = bp.player.vitals
                local mlevel = bp.player.main_job_level
                
                if mlevel == 99 then
                
                    for cure in T(__allowed['Cure']):it() do
                        local spell = bp.res.spells[cure.id]
                                    
                        if spell and bp.__actions.isReady(spell.en) and cure.id and cure.min and cure.id > 2 and vitals.mp >= spell.mp_cost then
    
                            if (cure.min + (cure.min * (settings.power / 100))) <= missing then
                                estimate = spell
    
                            elseif missing > cure.min and percent < 85 and once then
                                estimate, once = spell, false
    
                            end
                        
                        end
    
                    end
    
                elseif mlevel < 99 and mlevel > 50 then

                    for cure in T(__allowed['Cure']):it() do
                        local spell = bp.res.spells[cure.id]
    
                        if spell and bp.__actions.isReady(spell.en) and cure.id > 1 and vitals.mp >= spell.mp_cost then
    
                            if (cure.min + (cure.min * (settings.power / 100))) <= missing then
                                estimate = spell
    
                            elseif missing > cure.min and percent < 85 and once then
                                estimate, once = spell, false
    
                            end
    
                        end
    
                    end
    
                elseif mlevel <= 50 then
    
                    for cure in T(__allowed['Cure']):it() do
                        local spell = bp.res.spells[cure.id]
    
                        if spell and bp.__actions.isReady(spell.en) and cure.id and cure.min and bp.player['vitals'].mp >= spell.mp_cost then
                            local reduced = (cure.min / 2)
    
                            if (reduced + (reduced * (settings.power / 100))) <= missing then
                                estimate = spell
    
                            elseif missing > cure.min and percent < 85 and once then
                                estimate, once = spell, false
    
                            end
    
                        end
    
                    end
    
                end
                
            end
            return estimate
            
        end

        pvt.estimateCuraga = function(w)
            local estimate = false
            
            if bp and bp.player and w and w.weight and w.count then
                local vitals = bp.player.vitals
                local mlevel = bp.player.main_job_level

                if mlevel == 99 then
                
                    for cure in T(__allowed['Curaga']):it() do
                        local spell = bp.res.spells[cure.id]
    
                        if spell and bp.__actions.isReady(spell.en) and cure.id > 8 and vitals.mp >= spell.mp_cost then
                            local weight = (w.weight/w.count)
    
                            if weight and (cure.min + (cure.min * (settings.power / 100))) <= weight then
                                estimate = bp.res.spells[cure.id]
                            end
    
                        end
    
                    end
    
                elseif mlevel < 50 then
    
                    for cure in T(__allowed['Curaga']):it() do
                        local spell = bp.res.spells[cure.id]
    
                        if spell and bp.__actions.isReady(spell.en) and vitals.mp >= spell.mp_cost then
                            local weight = (w.weight/w.count)
    
                            if weight and (cure.min + (cure.min * (settings.power / 100))) <= weight then
                                estimate = bp.res.spells[cure.id]
                            end
                            
                        end
    
                    end
    
                end
                
            end
            return estimate
            
        end

        pvt.estimateWaltz = function(missing, percent)
            local estimate, once = false, true
            
            if bp and bp.player and missing and percent and missing > 0 then
                local vitals = bp.player.vitals
                local mlevel = bp.player.main_job_level
                
                if bp.player.main_job == 'DNC' then
                    
                    if mlevel >= 87 then
                    
                        for cure in T(__allowed['Waltz']):it() do
                            local spell = bp.res.job_abilities[cure.id]
                                        
                            if spell and bp.__actions.isReady(spell.en) and cure.id > 191 and vitals.tp >= spell.tp_cost then
    
                                if (cure.min + (cure.min * (settings.power / 100))) <= missing then
                                    estimate = spell
    
                                elseif missing > cure.min and percent < 85 and once then
                                    estimate, once = spell, false
    
                                end
                            
                            end
    
                        end
    
                    else
    
                        for cure in T(__allowed['Waltz']):it() do
                            local spell = bp.res.job_abilities[cure.id]
    
                            if spell and bp.__actions.isReady(spell.en) and vitals.tp >= spell.tp_cost then
    
                                if (cure.min + (cure.min * (settings.power / 100))) <= missing then
                                    estimate = spell
    
                                elseif missing > cure.min and percent < 85 and once then
                                    estimate, once = spell, false
    
                                end
    
                            end
    
                        end
    
                    end
    
                elseif bp.player.sub_job == 'DNC' then
    
                    for cure in T(__allowed['Waltz']):it() do
                        local spell = bp.res.job_abilities[cure.id]
                                    
                        if spell and bp.__actions.isReady(spell.en) and cure.id > 190 and vitals.tp >= spell.tp_cost then
    
                            if (cure.min + (cure.min * (settings.power / 100))) <= missing then
                                estimate = spell
    
                            elseif missing > cure.min and percent < 85 and once then
                                estimate, once = spell, false
    
                            end
                        
                        end
    
                    end
    
                end
                
            end
            return estimate
            
        end

        pvt.updateCure = function(action, target)
            local action    = type(action) == 'table' and action or bp.MA[action] or bp.JA[action] or bp.WS[action] or bp.IT[action] or false
            local target    = bp.__target.get(target)
            local queue     = bp.__queue.getQueue()
                
            if action and target then
                local update = false
    
                for act, index in queue:it() do
                        
                    if act.action and act.target and (act.action.type == 'WhiteMagic' or act.action.type == 'Waltz') then
                        
                        if act.target.id == target.id and act.action.en ~= action.en and act.action.en:startswith('Cur') and not bp.__queue.inQueue(action.en, target) then
                            queue.data[index].action, queue.data[index].priority = bp.MA[action.en], bp.priorities.get(action.en)
                            update = true
    
                        elseif act.target.id == target.id and act.action.en ~= action.en and act.action.en:startswith('Waltz') and not bp.__queue.inQueue(action.en, target) then
                            queue.data[index].action, queue.data[index].priority = bp.JA[action.en], bp.priorities.get(action.en)
                            update = true
    
                        end
    
                    end
    
                end
    
                if not update then
                    bp.__queue.add(action.en, target, bp.priorities.get(action.en))
                    return true
    
                end
                queue:sort(function(a, b) return a.priority > b.priority end)
    
            end
            return false
    
        end
        
        -- Public Methods.
        new.handle = function()

            if __party and __alliance and bp.core.get('cures') then
                local curaga = new.getCuraga()

                if not curaga then
                    local party = settings.mode == 2 and pvt.sort(T(__party):extend(__alliance)) or __party

                    if (bp.player.main_job == 'WHM' or bp.player.sub_job == 'WHM') then
                        new.doWHMCures(party)

                    elseif (bp.player.main_job == 'DNC' or bp.player.sub_job == 'DNC') and not bp.__buffs.active(410) then
                        new.doDNCCures(party)

                    end

                elseif curaga then
                    pvt.updateCure(curaga, curaga.target.id)

                end
    
            end
    
        end

        new.getWeight = function() return pvt.getWeight() end
        new.getMode = function() return settings.mode end
        new.setMode = function(mode)
            local mode = tonumber(mode)

            if mode and mode >= 1 and mode <= 2 then
                settings.mode = mode
                bp.popchat.pop(string.format("CURES MODE: \\cs(%s)%s\\cr.", bp.colors.setting, __modes[mode]))

            end

        end
    
        new.setPriority = function(target, urgency)
            local target    = bp.__target.get(target)
            local urgency   = tonumber(urgency)
    
            if target and urgency and urgency >= 0 and urgency <= 100 then
                __priorities[target.id] = urgency
                bp.popchat.pop(string.format('PRIORITY FOR \\cs(%s)%s\\cr SET TO: \\cs(%s)%03d\\cr.', bp.colors.setting, target.name:upper(), bp.colors.setting, urgency))

            else

                if target and not urgency then
                    bp.popchat.pop('PLEASE ENTER A VALID NUMBER BETWEEN 0 & 100!')

                else
                    bp.popchat.pop('INVALID TARGET SELECTED!')

                end
    
            end
    
        end
    
        new.getPriority = function(target)
            local target = bp.__target.get(target)

            if target and __priorities[target.id] then
                return __priorities[target.id] or 0    
            end
            return 0
    
        end

        new.getCuraga = function()
            local weight = pvt.getWeight()

            if weight and weight.count > 2 and (bp.player.main_job == 'WHM' or bp.player.sub_job == 'WHM') then
                local cure = pvt.estimateCuraga(weight)

                if cure and not bp.__queue.inQueue(cure.en) then
                    cure.target = weight.target
                    cure.count  = weight.count

                    if cure.target and cure.count then
                        return cure
                    end

                end

            end
            return false

        end

        new.doWHMCures = function(party)

            for member in T(party):it() do
                local cure = pvt.estimateCure(member.missing, member.hpp)
                local target = bp.__target.get(member.id)

                if cure and target and not bp.__queue.inQueue(cure.en, target) then
                    
                    if (bp.__distance.get(target) - target.model_size) <= bp.__queue.getRange(cure.en) and not T{2,3}:contains(target.status) then
                        pvt.updateCure(cure, target.id)
                    end
                
                end

            end

        end

        new.doDNCCures = function(party)

            for member in T(party):it() do
                local cure = pvt.estimateWaltz(member.missing, member.hpp)
                local target = bp.__target.get(member.id)

                if cure and target and not bp.__queue.inQueue(cure.en, target) then
                    
                    if (bp.__distance.get(target) - target.model_size) <= bp.__queue.getRange(cure.en) and not T{2,3}:contains(target.status) then
                        pvt.updateCure(cure, target)
                    end
                
                end

            end

        end
        
        -- Private Events.
        helper('prerender', pvt.buildParty)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'cures' then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command and command:startswith('pri') and #commands > 0 then
                    local target    = tonumber(commands[#commands]) == nil and bp.__target.get(commands[#commands]) or windower.ffxi.get_mob_by_target('t')
                    local value     = tonumber(commands[1]) or false

                    if value and bp.__party.isMember(target, true) then
                        new.setPriority(target, value)
                    end

                elseif command and tonumber(command) then
                    new.setMode(command)

                end
                settings:save()

            end
    
        end)

        helper('incoming chunk', function(id, original)
        
            if bp and id == 0x028 and bp.core.get('cures') then
                local parsed    = bp.packets.parse('incoming', original)
                local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
                local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
                local count     = parsed['Target Count']
                local category  = parsed['Category']
                local param     = parsed['Param']
    
                if actor and bp.player and bp.player.id == actor.id and bp.res.spells[param] then
                    
                    if category == 4 and bp.res.spells[param].en:startswith('Cura') then
                        local queue = bp.__queue.getQueue()
    
                        if queue and queue:length() > 0 then
                            local targets = T{}
                            
                            for i=0, count do
                                table.insert(targets, parsed[string.format('Target %s ID', i)])
                            end
                            
                            if #targets > 0 then

                                for i=queue:length(), 1, -1 do

                                    if queue.data[i] and queue[i].action.en:startswith('Cure') and targets:contains(queue[i].target.id) then
                                        bp.__queue.remove(queue[i].action, queue[i].target)
                                    end

                                end

                            end

                        end
    
                    end
    
                end

            elseif bp and id == 0x0df and __debug then
                local parsed = bp.packets.parse('incoming', original)

                if parsed and parsed['ID'] ~= bp.player.id then
                    parsed['HPP'] = 33
                    return bp.packets.build(parsed)
                end

            end
    
        end)

        return new

    end

    return helper

end
return buildHelper