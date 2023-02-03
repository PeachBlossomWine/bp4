local job = {}
function job:init(bp, settings, __getsub)

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return
    end

    -- Public Variables.
    self.__subjob   = (__getsub and bp.__core.getJob(bp.player.sub_job):init(bp, settings, false))
    self.__events   = {}
    self.__flags    = {}
    self.__timers   = {hate=0}
    self.__nukes    = T{}

    function self:useItems()

        if self.__subjob and settings.food and settings.skillup and not settings.skillup.enabled and bp.core.canItem() then

        elseif bp.core.canItem() then

            if bp.player.status == 1 then

            elseif bp.player.status == 0 then

            end

        end

        return self

    end

    function self:castNukes(target)

        if target and settings.nuke then

            for spell in self.__nukes:it() do

                if bp.core.canCast() and bp.core.ready(spell) then

                    if bp.MA[spell] and bp.MA[spell].element == 15 then

                        if settings.buffs and bp.core.canAct() then

                            -- CHAIN AFFINITY.
                            if settings["chain affinity"] and bp.core.ready("Chain Affinity", 164) then
                                bp.core.add("Chain Affinity", target, bp.core.priority("Chain Affinity"))
                            end

                            -- EFFLUX.
                            if settings.efflux and bp.core.ready("Efflux", 457) then
                                bp.core.add("Efflux", target, bp.core.priority("Efflux"))                        
                            end

                        end
                        bp.core.add(spell, target, bp.core.priority(spell))

                    else

                        if settings.buffs and bp.core.canAct() then

                            -- CONVERGENCE.
                            if settings.convergence and bp.core.ready("Convergence", 355) then
                                bp.core.add("Convergence", target, bp.core.priority("Convergence"))
                            end

                        end
                        bp.core.add(spell, target, bp.core.priority(spell))

                    end

                end

            end

        end

        return self

    end

    function self:automate()
        local spells = bp.__blu.getSpellSet()
        local target = bp.core.target()

        self:useItems()
        if bp.player.status == 1 then
            local target = bp.core.target() or windower.ffxi.get_mob_by_target('t') or false

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target and bp.core.canCast() then

                if bp.__blu.hasHateSpells({"Blank Gaze"}) and bp.core.ready("Blank Gaze") then
                    bp.core.add("Blank Gaze", target, bp.core.priority("Blank Gaze"))
                    self.__timers.hate = os.clock()

                elseif settings.hate.aoe and bp.__blu.hasHateSpells({"Geist Wall","Jettatura","Soporific","Sheep Song"}) then

                    for spell in T{"Jettatura","Geist Wall","Soporific","Sheep Song"}:it() do

                        if bp.core.ready(spell) then
                            bp.core.add(spell, target, bp.core.priority(spell))
                            self.__timers.hate = os.clock()
                            break

                        end

                    end

                end

            end

            -- BUFFS.
            if settings.buffs then

                if bp.core.canAct() then

                    -- DIFFUSION.
                    if settings.diffusion and settings.diffusion.enabled and bp.core.ready("Diffusion") and bp.core.canCast() then
                        local spell = settings.diffusion.spell

                        if spell and bp.MA[spell] and bp.core.ready(spell, bp.MA[spell].status) and target and spells:contains(bp.MA[spell].id) then
                            local unbridled = T{"Carcharian Verve","Mighty Guard","Pyric Bulwark","Harden Shell"}

                            if unbridled:contains(spell) then

                                if settings["unbridled learning"] and bp.core.ready("Unbridled Learning", 485) then
                                    bp.core.add("Unbridled Learning", bp.player, bp.core.priority("Unbridled Learning"))
                                    bp.core.add("Diffusion", bp.player, bp.core.priority("Diffusion"))
                                    bp.core.add(spell, bp.player, bp.core.priority(spell))

                                end

                            else
                                bp.core.add("Diffusion", bp.player, bp.core.priority("Diffusion"))
                                bp.core.add(spell, bp.player, bp.core.priority(spell))

                            end

                        end

                    end

                end

            end

            -- MAGIC HAMMER.
            if settings["magic hammer"] and settings["magic hammer"].enabled and spells:contains(bp.MA["Magic Hammer"].id) and bp.core.ready("Magic Hammer") and bp.core.vitals.mpp < settings["magic hammer"].mpp and target then
                bp.core.add("Magic Hammer", target, bp.core.priority("Magic Hammer"))
            
            end
            self:castNukes(target)

        elseif bp.player.status == 0 then

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target and bp.core.canCast() then

                if bp.__blu.hasHateSpells({"Blank Gaze"}) and bp.core.ready("Blank Gaze") then
                    bp.core.add("Blank Gaze", target, bp.core.priority("Blank Gaze"))
                    self.__timers.hate = os.clock()

                elseif settings.hate.aoe and bp.__blu.hasHateSpells({"Geist Wall","Jettatura","Soporific","Sheep Song"}) then

                    for spell in T{"Jettatura","Geist Wall","Soporific","Sheep Song"}:it() do

                        if bp.core.ready(spell) then
                            bp.core.add(spell, target, bp.core.priority(spell))
                            self.__timers.hate = os.clock()
                            break

                        end

                    end

                end

            end

            -- BUFFS.
            if settings.buffs then

                if bp.core.canAct() then

                    -- DIFFUSION.
                    if settings.diffusion and settings.diffusion.enabled and bp.core.ready("Diffusion") and bp.core.canCast() then
                        local spell = settings.diffusion.name

                        if spell and bp.MA[spell] and bp.core.ready(spell, bp.MA[spell].status) and target and spells:contains(bp.MA[spell].id) then
                            local unbridled = T{"Carcharian Verve","Mighty Guard","Pyric Bulwark","Harden Shell"}

                            if unbridled:contains(spell) then

                                if settings["unbridled learning"] and bp.core.ready("Unbridled Learning", 485) then
                                    bp.core.add("Unbridled Learning", bp.player, bp.core.priority("Unbridled Learning"))
                                    bp.core.add("Diffusion", bp.player, bp.core.priority("Diffusion"))
                                    bp.core.add(spell, bp.player, bp.core.priority(spell))

                                end

                            else
                                bp.core.add("Diffusion", bp.player, bp.core.priority("Diffusion"))
                                bp.core.add(spell, bp.player, bp.core.priority(spell))

                            end

                        end

                    end

                end

            end

            -- MAGIC HAMMER.
            if settings["magic hammer"] and settings["magic hammer"].enabled and spells:contains(bp.MA["Magic Hammer"].id) and bp.core.ready("Magic Hammer") and bp.core.vitals.mpp < settings["magic hammer"].mpp and target then
                bp.core.add("Magic Hammer", target, bp.core.priority("Magic Hammer"))
            
            end
            self:castNukes(target)

        end

        return self

    end
    
    return self

end
return job