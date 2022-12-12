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

                    if settings.cascade and settings.cascade.enabled and bp.core.vitals.tp >= settings.cascade.tp and bp.core.isReady("Cascade") and not bp.core.inQueue("Cascade") and not bp.core.buff(598) and bp.core.canAct() then
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
                if settings.stun and bp.core.isReady("Stun") and not bp.core.inQueue("Stun") then
                    bp.core.add("Stun", target, bp.core.priority("Stun"))
                    self.__timers.hate = os.clock()

                end

            end

            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] then

                    if settings.manafont and bp.core.isReady("Manafont") and not bp.core.inQueue("Manafont") and not bp.core.buff(47) and target then
                        bp.core.add("Manafont", bp.player, bp.core.priority("Manafont"))
                    end
                    
                    if settings["subtle sorcery"] and bp.core.isReady("Subtle Sorcery") and not bp.core.inQueue("Subtle Sorcery") and not bp.core.buff(490) and target then
                        bp.core.add("Subtle Sorcery", bp.player, bp.core.priority("Subtle Sorcery"))
                    end

                end

                -- TOMAHAWK.
                if settings.tomahawk and bp.core.isReady("Tomahawk") and not bp.core.inQueue("Tomahawk") and bp.__inventory.canEquip("Tomahawk") then
                    bp.core.add("Tomahawk", target, bp.core.priority("Tomahawk"))
                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- ELEMENTAL SEAL.
                    if settings["elemental seal"] and (settings.nuke or settings.debuffs) and bp.core.isReady("Elemental Seal") and not bp.core.inQueue("Elemental Seal") and not bp.core.buff(79) then
                        bp.core.add("Elemental Seal", bp.player, bp.core.priority("Elemental Seal"))
                    end

                    -- MANA WALL.
                    if settings["mana wall"] and bp.core.isReady("Mana Wall") and not bp.core.inQueue("Mana Wall") and not bp.core.buff(437) then
                        local enmity = bp.__enmity.hasEnmity()

                        if enmity and enmity.id == bp.player.id then
                            bp.core.add("Mana Wall", bp.player, bp.core.priority("Mana Wall"))
                        end

                    end

                    -- ENMITY DOUSE.
                    if settings["enmity douse"] and bp.core.isReady("Enmity Douse") and not bp.core.inQueue("Enmity Douse") then
                        local enmity = bp.__enmity.hasEnmity()

                        if enmity and enmity.id == bp.player.id then
                            bp.core.add("Enmity Douse", bp.player, bp.core.priority("Enmity Douse"))
                        end

                    end

                    -- MANAWELL.
                    if settings.manawell (settings.nuke or (settings.mb and settings.mb.enabled)) and bp.core.isReady("Manawell") and not bp.core.inQueue("Manawell") and not bp.core.buff(229) then
                        bp.core.add("Manawell", bp.player, bp.core.priority("Manawell"))
                    end

                end

                if bp.core.canCast() then

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
            self:castNukes(target)

        elseif bp.player.status == 0 then
            local target = bp.core.target()

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target then

                -- STUN.
                if settings.stun and bp.core.isReady("Stun") and not bp.core.inQueue("Stun") then
                    bp.core.add("Stun", target, bp.core.priority("Stun"))
                    self.__timers.hate = os.clock()

                end

            end

            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] then

                    if settings.manafont and bp.core.isReady("Manafont") and not bp.core.inQueue("Manafont") and not bp.core.buff(47) and target then
                        bp.core.add("Manafont", bp.player, bp.core.priority("Manafont"))
                    end
                    
                    if settings["subtle sorcery"] and bp.core.isReady("Subtle Sorcery") and not bp.core.inQueue("Subtle Sorcery") and not bp.core.buff(490) and target then
                        bp.core.add("Subtle Sorcery", bp.player, bp.core.priority("Subtle Sorcery"))
                    end

                end

                -- TOMAHAWK.
                if settings.tomahawk and bp.core.isReady("Tomahawk") and not bp.core.inQueue("Tomahawk") and bp.__inventory.canEquip("Tomahawk") then
                    bp.core.add("Tomahawk", target, bp.core.priority("Tomahawk"))
                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- ELEMENTAL SEAL.
                    if settings["elemental seal"] and (settings.nuke or settings.debuffs) and bp.core.isReady("Elemental Seal") and not bp.core.inQueue("Elemental Seal") and not bp.core.buff(79) then
                        bp.core.add("Elemental Seal", bp.player, bp.core.priority("Elemental Seal"))
                    end

                    -- MANA WALL.
                    if settings["mana wall"] and bp.core.isReady("Mana Wall") and not bp.core.inQueue("Mana Wall") and not bp.core.buff(437) then
                        local enmity = bp.__enmity.hasEnmity()

                        if enmity and enmity.id == bp.player.id then
                            bp.core.add("Mana Wall", bp.player, bp.core.priority("Mana Wall"))
                        end

                    end

                    -- ENMITY DOUSE.
                    if settings["enmity douse"] and bp.core.isReady("Enmity Douse") and not bp.core.inQueue("Enmity Douse") then
                        local enmity = bp.__enmity.hasEnmity()

                        if enmity and enmity.id == bp.player.id then
                            bp.core.add("Enmity Douse", bp.player, bp.core.priority("Enmity Douse"))
                        end

                    end

                    -- MANAWELL.
                    if settings.manawell (settings.nuke or (settings.mb and settings.mb.enabled)) and bp.core.isReady("Manawell") and not bp.core.inQueue("Manawell") and not bp.core.buff(229) then
                        bp.core.add("Manawell", bp.player, bp.core.priority("Manawell"))
                    end

                end

                if bp.core.canCast() then

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
            self:castNukes(target)

        end

        return self

    end
    
    return self

end
return job