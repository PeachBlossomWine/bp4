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

                if bp.core.canCast() and bp.core.ready(spell) then
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
                if settings.stun and bp.core.ready("Stun") and bp.core.canCast() then
                    bp.core.add("Stun", target, bp.core.priority("Stun"))
                    self.__timers.hate = os.clock()

                end

            end

            -- JOB ABILITIES.
            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] then

                    if settings["blood weapon"] and bp.core.ready("Blood Weapon", 51) and target then
                        bp.core.add("Blood Weapon", bp.player, bp.core.priority("Blood Weapon"))
                    end
                    
                    if settings["soul enslavement"] and bp.core.ready("Soul Enslavement", 497) and target then
                        bp.core.add("Soul Enslavement", bp.player, bp.core.priority("Soul Enslavement"))
                    end

                end

                -- WEAPON BASH.
                if settings['weapon bash'] and bp.core.ready("Weapon Bash") and target then
                    bp.core.add("Weapon Bash", target, bp.core.priority("Weapon Bash"))
                end

            end

            -- BUFFS.
            if settings.buffs then

                if bp.core.canAct() and target then

                    -- CONSUME MANA.
                    if settings['consume mana'] and bp.core.ready("Consume Mana", 599) and bp.core.vitals.tp >= settings.ws.tp then
                        bp.core.add("Consume Mana", bp.player, bp.core.priority("Consume Mana"))
                    end

                    -- LAST RESORT.
                    if not settings.tank and settings['last resort'] and bp.core.ready("Last Resort", 63) then
                        bp.core.add("Last Resort", bp.player, bp.core.priority("Last Resort"))

                    -- SOULEATER.
                    elseif not settings.tank and settings['souleater'] and bp.core.ready("Souleater", 64) then
                        bp.core.add("Souleater", bp.player, bp.core.priority("Souleater"))

                    -- DIABOLIC EYE.
                    elseif settings['diabolic eye'] and bp.core.ready("Diabolic Eye", 349) then
                        bp.core.add("Diabolic Eye", bp.player, bp.core.priority("Diabolic Eye"))

                    -- SCARLET DELIRIUM.
                    elseif settings['scarlet delirium'] and bp.core.ready("Scarlet Delirium", {479,480}) then
                        bp.core.add("Scarlet Delirium", bp.player, bp.core.priority("Scarlet Delirium"))

                    end

                end

                if bp.core.canCast() then

                    -- ENDARK.
                    if settings.endark and not bp.core.searchQueue({"Endark","Endark II"}) and target then

                        if bp.core.jp >= 100 and bp.core.ready("Endark II", 288) then
                            bp.core.add("Endark II", bp.player, bp.core.priority("Endark II"))

                        elseif bp.core.jp < 100 and bp.core.ready("Endark", 288) then
                            bp.core.add("Endark", bp.player, bp.core.priority("Endark"))

                        end

                    end

                    -- ABSORBS.
                    if settings.absorb and settings.absorb.enabled and target then
                        local absorb = settings.absorb.name

                        if absorb and bp.core.ready(absorb) and (not bp.__buffs.hasAbsorb() or absorb == "Absorb-Attri" or absorb == "Absorb-TP") then

                            -- DARK SEAL.
                            if settings['dark seal'] and bp.core.ready("Dark Seal", 345) and bp.core.canAct() then
                                bp.core.add("Dark Seal", bp.player, bp.core.priority("Dark Seal"))
                            end

                            -- NETHER VOID.
                            if settings['nether void'] and bp.core.ready("Nether Void", 439) and bp.core.canAct() then
                                bp.core.add("Nether Void", bp.player, bp.core.priority("Nether Void"))
                            end
                            bp.core.add(absorb, target, bp.core.priority(absorb))

                        end

                    end

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

                                if drain == "Drain III" and settings['dark seal'] and bp.core.ready("Dark Seal", 345) and bp.core.canAct() then
                                    bp.core.add("Dark Seal", bp.player, bp.core.priority("Dark Seal"))
                                end                                
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

        elseif bp.player.status == 0 then
            local target = bp.core.target()

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target then

                -- STUN.
                if settings.stun and bp.core.ready("Stun") and bp.core.canCast() then
                    bp.core.add("Stun", target, bp.core.priority("Stun"))
                    self.__timers.hate = os.clock()

                end

            end

            -- JOB ABILITIES.
            if settings.ja and bp.core.canAct() then

                -- WEAPON BASH.
                if settings['weapon bash'] and bp.core.ready("Weapon Bash") and target then
                    bp.core.add("Weapon Bash", target, bp.core.priority("Weapon Bash"))
                end

            end

            -- BUFFS.
            if settings.buffs then

                if bp.core.canCast() then

                    -- ABSORBS.
                    if settings.absorb and settings.absorb.enabled and target then
                        local absorb = settings.absorb.name

                        if absorb and bp.core.ready(absorb) and (not bp.__buffs.hasAbsorb() or absorb == "Absorb-Attri" or absorb == "Absorb-TP") then

                            -- DARK SEAL.
                            if settings['dark seal'] and bp.core.ready("Dark Seal", 345) and bp.core.canAct() then
                                bp.core.add("Dark Seal", bp.player, bp.core.priority("Dark Seal"))
                            end

                            -- NETHER VOID.
                            if settings['nether void'] and bp.core.ready("Nether Void", 439) and bp.core.canAct() then
                                bp.core.add("Nether Void", bp.player, bp.core.priority("Nether Void"))
                            end
                            bp.core.add(absorb, target, bp.core.priority(absorb))

                        end

                    end

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

                                if drain == "Drain III" and settings['dark seal'] and bp.core.ready("Dark Seal", 345) and bp.core.canAct() then
                                    bp.core.add("Dark Seal", bp.player, bp.core.priority("Dark Seal"))
                                end                                
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