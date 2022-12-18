local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local settings  = bp.__settings.new(string.format("jobs/%s", bp.player.main_job))

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local core = bp.__core.getJob(bp.player.main_job):init(bp, settings, true)

        do -- Private Settings.
            settings.core = T(settings.core) or bp.__core.newSettings()

            do -- Update settings if a new version was detected, then save them.
                coroutine.schedule(function()
                    bp.__core.updateSettings(settings.core)
                    coroutine.schedule(function()
                        settings:save()

                    end, 1)

                    new.__idle         = os.clock()
                    new.main           = bp.player.main_job
                    new.sub            = bp.player.sub_job
                    new.target         = bp.target.get
                    new.add            = bp.__queue.add
                    new.getTarget      = bp.__target.get
                    new.distance       = bp.__distance.get
                    new.buff           = bp.__buffs.active
                    new.hasBuff        = bp.__buffs.hasBuff
                    new.inQueue        = bp.__queue.inQueue
                    new.range          = bp.__queue.getRange
                    new.canAct         = bp.__actions.canAct
                    new.isReady        = bp.__actions.isReady
                    new.canCast        = bp.__actions.canCast
                    new.canItem        = bp.__actions.canItem
                    new.canMove        = bp.__actions.canMove
                    new.searchQueue    = bp.__queue.searchInQueue
                    new.available      = bp.__actions.isAvailable
                    new.priority       = bp.helpers.priorities.get

                end, 1)
            
            end

        end

        -- Private Methods.
        pvt.cures = function() bp.cures.handle() end
        pvt.statuses = function() bp.__status.fix() end
        pvt.buffs = function() bp.buffs.cast() end
        pvt.weaponskill = function()
            local target = bp.core.target()

            if bp.player.status == 1 or (bp.player.status == 0 and target) then
                local target = (bp.player.status == 1) and windower.ffxi.get_mob_by_target('t') or target or false

                -- Handle HP% Limiting weapon skills.
                if settings.limit and settings.limit.enabled then

                    if settings.limit.option == '>' and target.hpp > settings.limit.hpp then
                        return

                    elseif settings.limit.option == '<' and target.hpp < settings.limit.hpp then
                        return

                    end

                end

                -- Handle melee distance weapon skills.
                if target and bp.core.canAct() and settings.ws and settings.ws.enabled and bp.__distance.canMelee(target) then
                    local range     = bp.core.range(settings.ws.name)
                    local distance  = bp.core.distance(target)

                    if settings['sanguine blade'] and settings['sanguine blade'].enabled and bp.core.vitals.hpp <= settings['sanguine blade'].hpp and (distance - target.model_size) <= bp.core.range("Sanguine Blade") then
                        bp.core.add("Sanguine Blade", target, bp.core.priority("Sanguine Blade"))

                    elseif settings['myrkr'] and settings['myrkr'].enabled and bp.core.vitals.mpp <= settings['myrkr'].mpp and (distance - target.model_size) <= bp.core.range("Myrkr") then
                        bp.core.add("Myrkr", target, bp.core.priority("Myrkr"))

                    elseif settings['moonlight'] and settings['moonlight'].enabled and bp.core.vitals.mpp <= settings['moonlight'].mpp and (distance - target.model_size) <= bp.core.range("Moonlight") and bp.player.skills.club >= 100 then

                        if bp.player.skills.club >= 125 then
                            bp.core.add("Moonlight", bp.player, bp.core.priority("Moonlight"))

                        else
                            bp.core.add("Starlight", bp.player, bp.core.priority("Starlight"))

                        end

                    else
                        local weapon = bp.__inventory.getByIndex(bp.__equipment.get(0).bag, bp.__equipment.get(0).index)
                        
                        if weapon and bp.res.items[weapon.id] and settings.am and settings.am.enabled and bp.core.vitals.tp >= settings.am.tp and not bp.__aftermath.active() and bp.__aftermath.weaponskill(bp.res.items[weapon.id].en) then
                            bp.core.add(bp.__aftermath.weaponskill(bp.res.items[weapon.id].en), target, bp.core.priority(bp.__aftermath.weaponskill(bp.res.items[weapon.id].en)))

                        elseif (settings.am and settings.am.enabled and bp.__aftermath.active()) or (settings.am and not settings.am.enabled) or not bp.__aftermath.weaponskill(bp.res.items[weapon.id].en) then

                            if bp.core.vitals.tp >= settings.ws.tp then
                                bp.core.add(settings.ws.name, target, bp.core.priority(settings.ws.name))
                            end

                        end
                        
                    end

                -- Handle ranged distance weapon skills.
                elseif target and core.canAct() and settings.rws and settings.rws.enabled and not bp.__distance.canMelee(target) then
                    local range     = bp.core.range(settings.rws.name)
                    local distance  = bp.core.distance(target)

                    if settings['myrkr'] and settings['myrkr'].enabled and bp.core.vitals.mpp <= settings['myrkr'].mpp and (distance - target.model_size) <= bp.core.range("Myrkr") then
                        bp.core.add("Myrkr", target, bp.core.priority("Myrkr"))

                    elseif settings['moonlight'] and settings['moonlight'].enabled and bp.core.vitals.mpp <= settings['moonlight'].mpp and (distance - target.model_size) <= bp.core.range("Moonlight") and bp.player.skills.club >= 100 then

                        if bp.player.skills.club >= 125 then
                            bp.core.add("Moonlight", bp.player, bp.core.priority("Moonlight"))

                        else
                            bp.core.add("Starlight", bp.player, bp.core.priority("Starlight"))

                        end

                    else
                        local weapon = bp.__inventory.getByIndex(bp.__equipment.get(2).bag, bp.__equipment.get(2).index)

                        if weapon and bp.res.items[weapon.id] and settings.am and settings.am.enabled and bp.core.vitals.tp >= settings.am.tp and not bp.__aftermath.active() and bp.__aftermath.weaponskill(bp.res.items[weapon.id].en) then
                            bp.core.add(bp.__aftermath.weaponskill(bp.res.items[weapon.id].en), target, bp.core.priority(bp.__aftermath.weaponskill(bp.res.items[weapon.id].en)))

                        elseif (settings.am and settings.am.enabled and bp.__aftermath.active()) or (settings.am and not settings.am.enabled) or not bp.__aftermath.weaponskill(bp.res.items[weapon.id].en) then

                            if bp.core.vitals.tp >= settings.rws.tp then
                                bp.core.add(settings.rws.name, target, bp.core.priority(settings.rws.name))
                            end

                        end
                        
                    end

                end
                
            end

        end

        pvt.skillup = function()
                    
            if settings.skillup and settings.skillup.enabled then
                local __useFood = settings.food and settings.food.enabled and true or false

                if __useFood and not bp.core.buff(251) and not bp.core.inQueue("B.E.W. Pitaru") then
                    local index, count = bp.__inventory.findByName("B.E.W. Pitaru")

                    if index and count > 0 then
                        bp.core.add("B.E.W. Pitaru", bp.player, bp.core.priority("B.E.W. Pitaru"))
                    end

                elseif (__useFood and bp.core.buff(251)) or not __useFood then

                    if bp.core.main == 'SMN' and settings.skillup.skill == "Summoning" and windower.ffxi.get_mob_by_target('pet') then
                        bp.core.add("Release", bp.player, bp.core.priority("Release"))

                    elseif bp.__skillup.get(settings.skillup.skill) then
                        local selected = bp.__skillup.get(settings.skillup.skill)

                        if selected and type(selected) == 'table' and selected.spells and selected.target then

                            if (S{'RDM','RUN'}:contains(bp.core.main) or S{'RDM','RUN'}:contains(bp.core.sub)) and not core.buff(43) then

                                if bp.core.main == 'RDM' and bp.core.jp >= 1200 and bp.core.available("Refresh III") then

                                    if bp.core.isReady("Refersh III") then
                                        bp.core.add("Refresh III", bp.player, bp.core.priority("Refresh III"))
                                    end
                                
                                elseif bp.core.main == 'RDM' and bp.core.jp < 1200 and bp.core.available("Refresh II") then

                                    if bp.core.isReady("Refresh II") then
                                        bp.core.add("Refresh II", bp.player, bp.core.priority("Refresh II"))
                                    end

                                elseif bp.core.available("Refresh") then
                                    bp.core.add("Refresh", bp.player, bp.core.priority("Refresh"))

                                end

                            else

                                for spell in T(selected.spells):it() do
                                    bp.core.add(spell, bp.core.target() or bp.core.getTarget(selected.target), bp.core.priority(spell))
                                end

                            end

                        end

                    end

                end
                
            end

        end

        pvt.ranged = function()
            local target = (bp.player.status == 1) and windower.ffxi.get_mob_by_target('t') or bp.core.target() or false
            local ranged = bp.__equipment.get(2)
            local ammo = bp.__equipment.get(3)

            if bp.core.get('ra') and ranged and ammo and ranged.index > 0 and target then
                local ranged = bp.__inventory.getByIndex(ranged.bag, ranged.index)
                
                if ranged and bp.res.items[ranged.id] and T{25,26}:contains(bp.res.items[ranged.id].skill) and new.ready({id=65536, en='Ranged', element=-1, prefix='/ra', type='Ranged', range=13, cast_delay=2}) then
                    bp.core.add({id=65536, en='Ranged', element=-1, prefix='/ra', type='Ranged', range=13, cast_delay=2}, target, 1)
                end

            end

        end

        pvt.debuff = function()
            local target = (bp.player.status == 1) and windower.ffxi.get_mob_by_target('t') or bp.core.target() or false

            if target then
                bp.debuffs.cast(target)
            end

        end

        pvt.handleIdle = function()
            
            if core and new.__idle then

                if bp.__actions.isMoving() then
                    new.__idle = os.clock()

                elseif bp.enabled and math.floor(math.floor(os.clock()-new.__idle) / 60) >= 15 and (not bp.rob or (bp.rob and bp.rob.active)) then
                    bp.popchat.pop("YOU ARE NOW IDLE!")
                    bp.enabled = false

                end

            end

        end
        
        -- Public Methods.
        new.automate = function()

            if core and core.automate and bp.__queue.isReady() then
                new.updateVitals()

                do
                    pvt.cures()
                    pvt.buffs()
                    pvt.debuff()
                    pvt.ranged()
                    pvt.skillup()
                    pvt.statuses()
                    pvt.weaponskill()

                end
                core:automate().__subjob:automate()
                bp.__queue.handle()

            end

        end
        
        new.get = function(name) return settings[name] end
        new.set = function(commands)
            bp.__core.set(settings, commands)
            settings:save()

        end

        new.unloadEvents = function()
            
            for name,id in pairs(core.__events) do
                windower.unregister_event(id)
            end

        end

        new.updateVitals = function()
            new.mlevel = bp.player.main_job_level, bp.player.main_job_level
            new.slevel = bp.player.sub_job_level, bp.player.sub_job_level
            new.vitals = bp.player['vitals'], bp.player['vitals']
            new.jp = bp.player.job_points[new.main:lower()].jp_spent

        end

        new.resetIdle = function()

            if new.__idle then
                new.__idle = os.clock()
            end

        end

        new.ready = function(action, buffs)

            if action and bp.__queue.isReady(action) and not bp.__queue.inQueue(action) then

                if buffs and not bp.__buffs.active(buffs) then
                    return true

                elseif buffs == nil then
                    return true
                    
                end

            end
            return false

        end

        new.addNuke = function(commands)
            local spell = table.concat(commands, ' '):lower()

            if core and core.__nukes and spell and bp.MA[spell] then
                table.insert(core.__nukes, bp.MA[spell].en)
                bp.popchat.pop(string.format("%s ADDED TO AUTO-NUKE LIST!", bp.MA[spell].en:upper()))

            end

        end

        new.clearNukes = function()

            if core and core.__nukes then
                core._nukes = T{}
                bp.popchat.pop('AUTO-NUKES TABLE CLEARED!')

            end

        end

        new.deleteNuke = function(commands)
            local spell = table.concat(commands, ' '):lower()

            if core and core.__nukes and spell and bp.MA[spell] then
                
                for nuke, index in core.__nukes:it() do

                    if nuke:lower() == spell then
                        table.remove(core.__nukes, index)
                        bp.popchat.pop(string.format("%s REMOVED FROM AUTO-NUKE LIST!", bp.MA[spell].en:upper()))
                        break

                    end

                end

            end

        end
        
        -- Private Events.
        helper('prerender', pvt.handleIdle)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == '?' and #commands > 0 then
                new.set(commands)

            elseif bp and command and command:lower() == 'core' and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false
    
                if ("nukes"):startswith(command) then
                    local option = commands[1] and table.remove(commands, 1):lower() or false
    
                    if option == '+' and #commands > 0 then
                        bp.core.addNuke(commands)
    
                    elseif option == '-' and #commands > 0 then
                        bp.core.deleteNuke(commands)
    
                    elseif option == 'clear' then
                        bp.core.clearNukes()
    
                    end
    
                end
        
            end
    
        end)

        helper('job change', function(n, o)
            settings:save()

            if bp.player.main_job_id ~= n then
                settings = bp.__settings.new(string.format("jobs/%s", bp.res.jobs[n].ens))

                do -- Reset the events.
                    new.unloadEvents()

                    do -- Reload the helper after updating the settings.
                        bp.helpers:reload('core')

                    end

                end

            end

        end)

        return new

    end

    return helper

end
return buildHelper