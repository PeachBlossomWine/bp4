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
                    new.range          = bp.__queue.inQueue
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
        pvt.statuses = function() bp.status.fix() end
        pvt.buffs = function() bp.buffs.cast() end
        pvt.weaponskill = function()
            local target = core.target()

            if bp.player.status == 1 or (bp.player.status == 0 and target) then
                local target = core.target() or windower.ffxi.get_mob_by_target('t') or false

                -- Handle HP% Limiting weapon skills.
                if settings.limit and settings.limit.enabled then

                    if settings.limit.option == '>' and target.hpp > settings.limit.hpp then
                        return

                    elseif settings.limit.option == '<' and target.hpp < settings.limit.hpp then
                        return

                    end

                end

                -- Handle melee distance weapon skills.
                if target and core.canAct() and settings.ws and settings.ws.enabled and bp.__distance.canMelee(target) then
                    local range     = core.range(settings.ws.name)
                    local distance  = core.distance(target)

                    if settings['sanguine blade'] and settings['sanguine blade'].enabled and core.vitals.hpp <= settings['sanguine blade'].hpp and (distance - target.model_size) <= core.range("Sanguine Blade") then
                        core.add("Sanguine Blade", target, core.priority("Sanguine Blade"))

                    elseif settings['myrkr'] and settings['myrkr'].enabled and core.vitals.mpp <= settings['myrkr'].mpp and (distance - target.model_size) <= core.range("Myrkr") then
                        core.add("Myrkr", target, core.priority("Myrkr"))

                    elseif settings['moonlight'] and settings['moonlight'].enabled and core.vitals.mpp <= settings['moonlight'].mpp and (distance - target.model_size) <= core.range("Moonlight") and bp.player.skills.club >= 100 then

                        if bp.player.skills.club >= 125 then
                            core.add("Moonlight", bp.player, core.priority("Moonlight"))

                        else
                            core.add("Starlight", bp.player, core.priority("Starlight"))

                        end

                    else
                        local weapon = bp.__inventory.getByIndex(bp.__equipment.get(0).bag, bp.__equipment.get(0).index)

                        if weapon and bp.res.items[weapon.id] and settings.am and settings.am.enabled and core.vitals.tp >= settings.am.tp and not bp.__aftermath.active() and bp.__aftermath.weaponskill(bp.res.items[weapon.id].en) then
                            core.add(bp.__aftermath.weaponskill(bp.res.items[weapon.id].en), target, core.priority(bp.__aftermath.weaponskill(bp.res.items[weapon.id].en)))

                        elseif (settings.am and settings.am.enabled and bp.__aftermath.active()) or (settings.am and not settings.am.enabled) or not bp.__aftermath.weaponskill(bp.res.items[weapon.id].en) then

                            if core.vitals.tp >= settings.ws.tp then
                                core.add(settings.ws.name, target, core.priority(settings.ws.name))
                            end

                        end
                        
                    end

                -- Handle ranged distance weapon skills.
                elseif target and core.canAct() and settings.rws and settings.rws.enabled and not bp.__distance.canMelee(target) then
                    local range     = core.range(settings.rws.name)
                    local distance  = core.distance(target)

                    if settings['myrkr'] and settings['myrkr'].enabled and core.vitals.mpp <= settings['myrkr'].mpp and (distance - target.model_size) <= core.range("Myrkr") then
                        core.add("Myrkr", target, core.priority("Myrkr"))

                    elseif settings['moonlight'] and settings['moonlight'].enabled and core.vitals.mpp <= settings['moonlight'].mpp and (distance - target.model_size) <= core.range("Moonlight") and bp.player.skills.club >= 100 then

                        if bp.player.skills.club >= 125 then
                            core.add("Moonlight", bp.player, core.priority("Moonlight"))

                        else
                            core.add("Starlight", bp.player, core.priority("Starlight"))

                        end

                    else
                        local weapon = bp.__inventory.getByIndex(bp.__equipment.get(2).bag, bp.__equipment.get(2).index)

                        if weapon and bp.res.items[weapon.id] and settings.am and settings.am.enabled and core.vitals.tp >= settings.am.tp and not bp.__aftermath.active() and bp.__aftermath.weaponskill(bp.res.items[weapon.id].en) then
                            core.add(bp.__aftermath.weaponskill(bp.res.items[weapon.id].en), target, core.priority(bp.__aftermath.weaponskill(bp.res.items[weapon.id].en)))

                        elseif (settings.am and settings.am.enabled and bp.__aftermath.active()) or (settings.am and not settings.am.enabled) or not bp.__aftermath.weaponskill(bp.res.items[weapon.id].en) then

                            if core.vitals.tp >= settings.rws.tp then
                                core.add(settings.rws.name, target, core.priority(settings.rws.name))
                            end

                        end
                        
                    end

                end
                
            end

        end

        pvt.skillup = function()
                    
            if settings.skillup and settings.skillup.enabled then
                local __useFood = settings.food and settings.food.enabled and true or false

                if __useFood and not core.buff(251) and not core.inQueue("B.E.W. Pitaru") then
                    local index, count = bp.__inventory.findByName("B.E.W. Pitaru")

                    if index and count > 0 then
                        core.add("B.E.W. Pitaru", bp.player, core.priority("B.E.W. Pitaru"))
                    end

                elseif (__useFood and core.buff(251)) or not __useFood then

                    if core.main == 'SMN' and settings.skillup.skill == "Summoning" and windower.ffxi.get_mob_by_target('pet') then
                        core.add("Release", bp.player, core.priority("Release"))

                    elseif bp.__skillup.get(settings.skillup.skill) then
                        local selected = bp.__skillup.get(settings.skillup.skill)

                        if selected and type(selected) == 'table' and selected.spells and selected.target then

                            if (S{'RDM','RUN'}:contains(core.main) or S{'RDM','RUN'}:contains(core.sub)) and not core.buff(43) then

                                if core.main == 'RDM' and core.jp >= 1200 and core.available("Refresh III") then

                                    if core.isReady("Refersh III") then
                                        core.add("Refresh III", bp.player, core.priority("Refresh III"))
                                    end
                                
                                elseif core.main == 'RDM' and core.jp < 1200 and core.available("Refresh II") then

                                    if core.isReady("Refresh II") then
                                        core.add("Refresh II", bp.player, core.priority("Refresh II"))
                                    end

                                elseif core.available("Refresh") then
                                    core.add("Refresh", bp.player, core.priority("Refresh"))

                                end

                            else

                                for spell in T(selected.spells):it() do
                                    core.add(spell, core.target() or core.getTarget(selected.target), core.priority(spell))
                                end

                            end

                        end

                    end

                end
                
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