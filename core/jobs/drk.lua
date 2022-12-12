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

                if bp.core.canCast() and bp.core.isReady(spell) and not bp.core.inQueue(spell) then
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

                -- LAST RESORT.
                if settings.tank and bp.core.isReady("Last Resort") and bp.core.inQueue("Last Resort") then
                    bp.core.add("Last Resort", bp.player, bp.core.priority("Last Resort"))
                    coroutine.schedule(function() windower.send_command("cancel last resort") end, 1)
                    self.__timers.hate = os.clock()

                -- SOULEATER
                elseif settings.tank and bp.core.isReady("Souleater") and bp.core.inQueue("Souleater") then
                    bp.core.add("Souleater", bp.player, bp.core.priority("Souleater"))
                    coroutine.schedule(function() windower.send_command("cancel souleater") end, 1)
                    self.__timers.hate = os.clock()

                end

                -- STUN.
                if settings.stun and bp.core.isReady("Stun") and not bp.core.inQueue("Stun") and bp.core.canCast() then
                    bp.core.add("Stun", target, bp.core.priority("Stun"))
                    self.__timers.hate = os.clock()

                end

            end

            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] then

                    if settings["blood weapon"] and bp.core.isReady("Blood Weapon") and not bp.core.inQueue("Blood Weapon") and not bp.core.buff(51) and target then
                        bp.core.add("Blood Weapon", bp.player, bp.core.priority("Blood Weapon"))
                    end
                    
                    if settings["soul enslavement"] and bp.core.isReady("Soul Enslavement") and not bp.core.inQueue("Soul Enslavement") and not bp.core.buff(497) and target then
                        bp.core.add("Soul Enslavement", bp.player, bp.core.priority("Soul Enslavement"))
                    end

                end

                -- WEAPON BASH.
                if settings['weapon bash'] and bp.core.isReady("Weapon Bash") and not bp.core.inQueue("Weapon Bash") and target then
                    bp.core.add("Weapon Bash", target, bp.core.priority("Weapon Bash"))
                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- CONSUME MANA.
                    if settings['consume mana'] and bp.core.isReady("Consume Mana") and not bp.core.inQueue("Consume Mana") and not bp.core.buff(599) and bp.core.vitals.tp >= settings.ws.tp and target then
                        bp.core.add("Consume Mana", bp.player, bp.core.priority("Consume Mana"))
                    end

                    -- LAST RESORT.
                    if not settings.tank and settings['last resort'] and bp.core.isReady("Last Resort") and not bp.core.inQueue("Last Resort") and not bp.core.buff(63) and target then
                        bp.core.add("Last Resort", bp.player, bp.core.priority("Last Resort"))

                    -- SOULEATER.
                    elseif not settings.tank and settings['souleater'] and bp.core.isReady("Souleater") and not bp.core.inQueue("Souleater") and not bp.core.buff(64) and target then
                        bp.core.add("Souleater", bp.player, bp.core.priority("Souleater"))

                    -- DIABOLIC EYE.
                    elseif settings['diabolic eye'] and bp.core.isReady("Diabolic Eye") and not bp.core.inQueue("Diabolic Eye") and not bp.core.buff(346) and target then
                        bp.core.add("Diabolic Eye", bp.player, bp.core.priority("Diabolic Eye"))

                    -- SCARLET DELIRIUM.
                    elseif settings['scarlet delirium'] and bp.core.isReady("Scarlet Delirium") and not bp.core.inQueue("Scarlet Delirium") and not bp.core.buff({479,480}) and target then
                        bp.core.add("Scarlet Delirium", bp.player, bp.core.priority("Scarlet Delirium"))

                    end

                    if bp.core.canCast() then

                        -- ENDARK.
                        if settings.endark and not bp.core.searchQueue({"Endark","Endark II"}) and target then

                            if bp.core.jp >= 100 then
                                
                                if bp.core.isReady("Endark II") and not bp.core.buff(288) then
                                    bp.core.add("Endark II", bp.player, bp.core.priority("Endark II"))
                                end

                            elseif bp.core.jp < 100 then
                                
                                if bp.core.isReady("Endark") and not bp.core.buff(288) then
                                    bp.core.add("Endark", bp.player, bp.core.priority("Endark"))
                                end

                            end

                        end

                        -- ABSORBS.
                        if settings.absorb and settings.absorb.enabled and target then
                            local absorb = settings.absorb.name

                            if absorb and bp.core.isReady(absorb) and not bp.core.inQueue(absorb) and (not bp.__buffs.hasAbsorb() or absorb == "Absorb-Attri" or absorb == "Absorb-TP") then

                                -- DARK SEAL.
                                if settings['dark seal'] and bp.core.isReady("Dark Seal") and not bp.core.inQueue("Dark Seal") and not bp.core.buff(345) and bp.core.canAct() then
                                    bp.core.add("Dark Seal", bp.player, bp.core.priority("Dark Seal"))
                                end

                                -- NETHER VOID.
                                if settings['nether void'] and bp.core.isReady("Nether Void") and not bp.core.inQueue("Nether Void") and not bp.core.buff(439) and bp.core.canAct() then
                                    bp.core.add("Nether Void", bp.player, bp.core.priority("Nether Void"))
                                end
                                bp.core.add(absorb, target, bp.core.priority(absorb))

                            end

                        end

                        -- SPIKES.
                        if settings.spikes and settings.spikes.enabled and not bp.__buffs.hasSpikes() then
                            local spikes = settings.spikes.name

                            if spikes and bp.core.isReady(spikes) and not bp.core.inQueue(spikes) then
                                bp.core.add(spikes, bp.player, bp.core.priority(spikes))
                            end

                        end

                        -- DRAINS.
                        if settings.drain and settings.drain.enabled and bp.core.vitals.hpp < settings.drain.hpp and target then

                            if bp.core.isReady("Drain III") and not bp.core.inQueue("Drain III") then

                                -- DARK SEAL.
                                if settings['dark seal'] and bp.core.isReady("Dark Seal") and not bp.core.inQueue("Dark Seal") and not bp.core.buff(345) and bp.core.canAct() then
                                    bp.core.add("Dark Seal", bp.player, bp.core.priority("Dark Seal"))
                                end
                                bp.core.add("Drain III", target, bp.core.priority("Drain III"))

                            elseif bp.core.isReady("Drain II") and not bp.core.inQueue("Drain II") then
                                bp.core.add("Drain II", target, bp.core.priority("Drain II"))

                            elseif bp.core.isReady("Drain") and not bp.core.inQueue("Drain") then
                                bp.core.add("Drain", target, bp.core.priority("Drain"))

                            end

                        end

                        -- ASPIRS.
                        if settings.aspir and settings.aspir.enabled and bp.core.vitals.mpp < settings.aspir.mpp and target then

                            if bp.core.isReady("Aspir III") and not bp.core.inQueue("Aspir III") then
                                bp.core.add("Aspir III", target, bp.core.priority("Aspir III"))

                            elseif bp.core.isReady("Aspir II") and not bp.core.inQueue("Aspir II") then
                                bp.core.add("Aspir II", target, bp.core.priority("Aspir II"))

                            elseif bp.core.isReady("Aspir") and not bp.core.inQueue("Aspir") then
                                bp.core.add("Aspir", target, bp.core.priority("Aspir"))

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

                -- LAST RESORT.
                if settings.tank and bp.core.isReady("Last Resort") and bp.core.inQueue("Last Resort") then
                    bp.core.add("Last Resort", bp.player, bp.core.priority("Last Resort"))
                    coroutine.schedule(function() windower.send_command("cancel last resort") end, 1)
                    self.__timers.hate = os.clock()

                -- SOULEATER
                elseif settings.tank and bp.core.isReady("Souleater") and bp.core.inQueue("Souleater") then
                    bp.core.add("Souleater", bp.player, bp.core.priority("Souleater"))
                    coroutine.schedule(function() windower.send_command("cancel souleater") end, 1)
                    self.__timers.hate = os.clock()

                end

                -- STUN.
                if settings.stun and bp.core.isReady("Stun") and not bp.core.inQueue("Stun") and bp.core.canCast() then
                    bp.core.add("Stun", target, bp.core.priority("Stun"))
                    self.__timers.hate = os.clock()

                end

            end

            if settings.ja and bp.core.canAct() then

                -- WEAPON BASH.
                if settings['weapon bash'] and bp.core.isReady("Weapon Bash") and not bp.core.inQueue("Weapon Bash") and target then
                    bp.core.add("Weapon Bash", target, bp.core.priority("Weapon Bash"))
                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- CONSUME MANA.
                    if settings['consume mana'] and bp.core.isReady("Consume Mana") and not bp.core.inQueue("Consume Mana") and not bp.core.buff(599) and bp.core.vitals.tp >= settings.ws.tp and target then
                        bp.core.add("Consume Mana", bp.player, bp.core.priority("Consume Mana"))
                    end

                    -- LAST RESORT.
                    if not settings.tank and settings['last resort'] and bp.core.isReady("Last Resort") and not bp.core.inQueue("Last Resort") and not bp.core.buff(63) and target then
                        bp.core.add("Last Resort", bp.player, bp.core.priority("Last Resort"))

                    -- SOULEATER.
                    elseif not settings.tank and settings['souleater'] and bp.core.isReady("Souleater") and not bp.core.inQueue("Souleater") and not bp.core.buff(64) and target then
                        bp.core.add("Souleater", bp.player, bp.core.priority("Souleater"))

                    -- DIABOLIC EYE.
                    elseif settings['diabolic eye'] and bp.core.isReady("Diabolic Eye") and not bp.core.inQueue("Diabolic Eye") and not bp.core.buff(346) and target then
                        bp.core.add("Diabolic Eye", bp.player, bp.core.priority("Diabolic Eye"))

                    -- SCARLET DELIRIUM.
                    elseif settings['scarlet delirium'] and bp.core.isReady("Scarlet Delirium") and not bp.core.inQueue("Scarlet Delirium") and not bp.core.buff({479,480}) and target then
                        bp.core.add("Scarlet Delirium", bp.player, bp.core.priority("Scarlet Delirium"))

                    end

                    if bp.core.canCast() then

                        -- ENDARK.
                        if settings.endark and not bp.core.searchQueue({"Endark","Endark II"}) and target then

                            if bp.core.jp >= 100 then
                                
                                if bp.core.isReady("Endark II") and not bp.core.buff(288) then
                                    bp.core.add("Endark II", bp.player, bp.core.priority("Endark II"))
                                end

                            elseif bp.core.jp < 100 then
                                
                                if bp.core.isReady("Endark") and not bp.core.buff(288) then
                                    bp.core.add("Endark", bp.player, bp.core.priority("Endark"))
                                end

                            end

                        end

                        -- ABSORBS.
                        if settings.absorb and settings.absorb.enabled and target then
                            local absorb = settings.absorb.name

                            if absorb and bp.core.isReady(absorb) and not bp.core.inQueue(absorb) and (not bp.__buffs.hasAbsorb() or absorb == "Absorb-Attri" or absorb == "Absorb-TP") then

                                -- DARK SEAL.
                                if settings['dark seal'] and bp.core.isReady("Dark Seal") and not bp.core.inQueue("Dark Seal") and not bp.core.buff(345) and bp.core.canAct() then
                                    bp.core.add("Dark Seal", bp.player, bp.core.priority("Dark Seal"))
                                end

                                -- NETHER VOID.
                                if settings['nether void'] and bp.core.isReady("Nether Void") and not bp.core.inQueue("Nether Void") and not bp.core.buff(439) and bp.core.canAct() then
                                    bp.core.add("Nether Void", bp.player, bp.core.priority("Nether Void"))
                                end
                                bp.core.add(absorb, target, bp.core.priority(absorb))

                            end

                        end

                        -- SPIKES.
                        if settings.spikes and settings.spikes.enabled and not bp.__buffs.hasSpikes() then
                            local spikes = settings.spikes.name

                            if spikes and bp.core.isReady(spikes) and not bp.core.inQueue(spikes) then
                                bp.core.add(spikes, bp.player, bp.core.priority(spikes))
                            end

                        end

                        -- DRAINS.
                        if settings.drain and settings.drain.enabled and bp.core.vitals.hpp < settings.drain.hpp and target then

                            if bp.core.isReady("Drain III") and not bp.core.inQueue("Drain III") then

                                -- DARK SEAL.
                                if settings['dark seal'] and bp.core.isReady("Dark Seal") and not bp.core.inQueue("Dark Seal") and not bp.core.buff(345) and bp.core.canAct() then
                                    bp.core.add("Dark Seal", bp.player, bp.core.priority("Dark Seal"))
                                end
                                bp.core.add("Drain III", target, bp.core.priority("Drain III"))

                            elseif bp.core.isReady("Drain II") and not bp.core.inQueue("Drain II") then
                                bp.core.add("Drain II", target, bp.core.priority("Drain II"))

                            elseif bp.core.isReady("Drain") and not bp.core.inQueue("Drain") then
                                bp.core.add("Drain", target, bp.core.priority("Drain"))

                            end

                        end

                        -- ASPIRS.
                        if settings.aspir and settings.aspir.enabled and bp.core.vitals.mpp < settings.aspir.mpp and target then

                            if bp.core.isReady("Aspir III") and not bp.core.inQueue("Aspir III") then
                                bp.core.add("Aspir III", target, bp.core.priority("Aspir III"))

                            elseif bp.core.isReady("Aspir II") and not bp.core.inQueue("Aspir II") then
                                bp.core.add("Aspir II", target, bp.core.priority("Aspir II"))

                            elseif bp.core.isReady("Aspir") and not bp.core.inQueue("Aspir") then
                                bp.core.add("Aspir", target, bp.core.priority("Aspir"))

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