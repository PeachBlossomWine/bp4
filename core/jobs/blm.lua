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
    self.__timers   = {hate=0, aoehate=0}
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

                if bp.core.canCast() and bp.core.ready(spellspell) then

                    if settings.cascade and settings.cascade.enabled and bp.core.vitals.tp >= settings.cascade.tp and bp.core.ready("Cascade", 598) and bp.core.canAct() then
                        bp.core.add("Cascade", target, bp.core.priority("Cascade"))
                    end
                    bp.core.add(spell, target, bp.core.priority(spell))

                end

            end

        end

        return self

    end

    function self:automate()

        self:useItems()
        if bp.player.status == 1 then
            local target = bp.core.target() or windower.ffxi.get_mob_by_target('t') or false

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target then

                -- STUN.
                if settings.stun and bp.core.ready("Stun") then
                    bp.core.add("Stun", target, bp.core.priority("Stun"))
                    self.__timers.hate = os.clock()

                end

            end

            -- JOB ABILITIES.
            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] then

                    if settings.manafont and bp.core.ready("Manafont", 47) and target then
                        bp.core.add("Manafont", bp.player, bp.core.priority("Manafont"))
                    end
                    
                    if settings["subtle sorcery"] and bp.core.ready("Subtle Sorcery", 490) and target then
                        bp.core.add("Subtle Sorcery", bp.player, bp.core.priority("Subtle Sorcery"))
                    end

                end

            end

            -- BUFFS.
            if settings.buffs then

                if bp.core.canAct() then

                    -- ELEMENTAL SEAL.
                    if settings["elemental seal"] and (settings.nuke or settings.debuffs) and bp.core.ready("Elemental Seal", 79) then
                        bp.core.add("Elemental Seal", bp.player, bp.core.priority("Elemental Seal"))
                    end

                    -- MANA WALL.
                    if settings["mana wall"] and bp.core.ready("Mana Wall", 437) then
                        local enmity = bp.__enmity.hasEnmity()

                        if enmity and enmity.id == bp.player.id then
                            bp.core.add("Mana Wall", bp.player, bp.core.priority("Mana Wall"))
                        end

                    end

                    -- ENMITY DOUSE.
                    if settings["enmity douse"] and bp.core.ready("Enmity Douse") then
                        local enmity = bp.__enmity.hasEnmity()

                        if enmity and enmity.id == bp.player.id then
                            bp.core.add("Enmity Douse", bp.player, bp.core.priority("Enmity Douse"))
                        end

                    end

                    -- MANAWELL.
                    if settings.manawell and (settings.nuke or (settings.mb and settings.mb.enabled)) and bp.core.ready("Manawell", 229) then
                        bp.core.add("Manawell", bp.player, bp.core.priority("Manawell"))
                    end

                end

                if bp.core.canCast() then

                    -- SPIKES.
                    if settings.spikes and settings.spikes.enabled and not bp.__buffs.hasSpikes() then
                        local spikes = settings.spikes.name

                        if spikes and bp.core.ready(spikes) then
                            bp.core.add(spikes, bp.player, bp.core.priority(spikes))
                        end

                    end

                    -- DRAINS.
                    if settings.drain and settings.drain.enabled and bp.core.vitals.hpp < settings.drain.hpp and target then

                        for drain in T{"Drain III","Drain II","Drain"}:it() do

                            if cp.core.ready(drain) then
                                bp.core.add(drain, target, bp.core.priority(drain))
                            end

                        end

                    end

                    -- ASPIRS.
                    if settings.aspir and settings.aspir.enabled and bp.core.vitals.mpp < settings.aspir.mpp and target then

                        for aspir in T{"Aspir III","Aspir II","Aspir"}:it() do

                            if cp.core.ready(aspir) then
                                bp.core.add(aspir, target, bp.core.priority(aspir))
                            end

                        end

                    end

                end

            end
            self:castNukes(target)

        elseif bp.player.status == 0 then

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target then

                -- STUN.
                if settings.stun and bp.core.ready("Stun") then
                    bp.core.add("Stun", target, bp.core.priority("Stun"))
                    self.__timers.hate = os.clock()

                end

            end

            -- JOB ABILITIES.
            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] then

                    if settings.manafont and bp.core.ready("Manafont", 47) and target then
                        bp.core.add("Manafont", bp.player, bp.core.priority("Manafont"))
                    end
                    
                    if settings["subtle sorcery"] and bp.core.ready("Subtle Sorcery", 490) and target then
                        bp.core.add("Subtle Sorcery", bp.player, bp.core.priority("Subtle Sorcery"))
                    end

                end

            end

            -- BUFFS.
            if settings.buffs then

                if bp.core.canAct() then

                    -- ELEMENTAL SEAL.
                    if settings["elemental seal"] and (settings.nuke or settings.debuffs) and bp.core.ready("Elemental Seal", 79) then
                        bp.core.add("Elemental Seal", bp.player, bp.core.priority("Elemental Seal"))
                    end

                    -- MANA WALL.
                    if settings["mana wall"] and bp.core.ready("Mana Wall", 437) then
                        local enmity = bp.__enmity.hasEnmity()

                        if enmity and enmity.id == bp.player.id then
                            bp.core.add("Mana Wall", bp.player, bp.core.priority("Mana Wall"))
                        end

                    end

                    -- ENMITY DOUSE.
                    if settings["enmity douse"] and bp.core.ready("Enmity Douse") then
                        local enmity = bp.__enmity.hasEnmity()

                        if enmity and enmity.id == bp.player.id then
                            bp.core.add("Enmity Douse", bp.player, bp.core.priority("Enmity Douse"))
                        end

                    end

                    -- MANAWELL.
                    if settings.manawell and (settings.nuke or (settings.mb and settings.mb.enabled)) and bp.core.ready("Manawell", 229) then
                        bp.core.add("Manawell", bp.player, bp.core.priority("Manawell"))
                    end

                end

                if bp.core.canCast() then

                    -- SPIKES.
                    if settings.spikes and settings.spikes.enabled and not bp.__buffs.hasSpikes() then
                        local spikes = settings.spikes.name

                        if spikes and bp.core.ready(spikes) then
                            bp.core.add(spikes, bp.player, bp.core.priority(spikes))
                        end

                    end

                    -- DRAINS.
                    if settings.drain and settings.drain.enabled and bp.core.vitals.hpp < settings.drain.hpp and target then

                        for drain in T{"Drain III","Drain II","Drain"}:it() do

                            if bp.core.ready(drain) then
                                bp.core.add(drain, target, bp.core.priority(drain))
                            end

                        end

                    end

                    -- ASPIRS.
                    if settings.aspir and settings.aspir.enabled and bp.core.vitals.mpp < settings.aspir.mpp and target then

                        for aspir in T{"Aspir III","Aspir II","Aspir"}:it() do

                            if bp.core.ready(aspir) then
                                bp.core.add(aspir, target, bp.core.priority(aspir))
                            end

                        end

                    end

                end

            end
            self:castNukes(target)

        end

        return self

    end
    
    return self

end
return job