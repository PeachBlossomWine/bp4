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
        local target = bp.core.target()
        local pet = windower.ffxi.get_mob_by_target('pet')

        self:useItems()
        if bp.player.status == 1 then
            local target = bp.core.target() or windower.ffxi.get_mob_by_target('t') or false

            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] then

                    if settings["spirit surge"] and bp.core.ready("Spirit Surge", 126) and target and pet then
                        bp.core.add("Spirit Surge", bp.player, bp.core.priority("Spirit Surge"))
                    end
                    
                    if settings["fly high"] and bp.core.ready("Fly High", 503) and target then
                        bp.core.add("Fly High", bp.player, bp.core.priority("Fly High"))
                    end

                end

                -- CALL WYVERN.
                if settings["call wyvern"] and not pet and bp.core.ready("Call Wyvern") then
                    bp.core.add("Call Wyvern", bp.player, bp.core.priority("Call Wyvern"))
                end

                -- ANGON.
                if settings.angon and bp.core.ready("Angon") and bp.__inventory.canEquip("Angon") and target then
                    bp.core.add("Angon", target, bp.core.priority("Angon"))
                end

                -- JUMP.
                if settings.jump and bp.core.ready("Jump") and target then
                    bp.core.add("Jump", target, bp.core.priority("Jump"))

                -- HIGH JUMP.
                elseif settings["high jump"] and bp.core.ready("High Jump") and target then
                    bp.core.add("High Jump", target, bp.core.priority("High Jump"))

                -- SUPER JUMP.
                elseif settings["super jump"] and bp.core.ready("Super Jump") and target then
                    bp.core.add("Super Jump", target, bp.core.priority("Super Jump"))

                -- SPIRIT JUMP.
                elseif settings["spirit jump"] and bp.core.ready("Spirit Jump") and target then
                    bp.core.add("Spirit Jump", target, bp.core.priority("Spirit Jump"))

                -- SOUL JUMP.
                elseif settings["soul jump"] and bp.core.ready("Soul Jump") and target then
                    bp.core.add("Soul Jump", target, bp.core.priority("Soul Jump"))

                end

                if pet then

                    -- SMITING BREATH.
                    if settings["smiting breath"] and bp.core.ready("Smiting Breath") and target then

                        if settings["deep breathing"] and bp.core.ready("Deep Breathing") then
                            bp.core.add("Deep Breathing", bp.player, bp.core.priority("Deep Breathing"))
                        end
                        bp.core.add("Smiting Breath", target, bp.core.priority("Smiting Breath"))

                    -- RESTORING BREATH.
                    elseif settings["restoring breath"] and bp.core.ready("Restoring Breath") then

                        if settings["deep breathing"] and bp.core.ready("Deep Breathing") then
                            bp.core.add("Deep Breathing", bp.player, bp.core.priority("Deep Breathing"))
                        end
                        bp.core.add("Restoring Breath", bp.player, bp.core.priority("Restoring Breath"))

                    -- STEADY WING.
                    elseif settings["steady wing"] and bp.core.ready("Steady Wing") then
                        bp.core.add("Steady Wing", bp.player, bp.core.priority("Steady Wing"))

                    end

                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                end

                if bp.core.canCast() then

                end

            end

        elseif bp.player.status == 0 then

            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] then

                    if settings["spirit surge"] and bp.core.ready("Spirit Surge", 126) and target and pet then
                        bp.core.add("Spirit Surge", bp.player, bp.core.priority("Spirit Surge"))
                    end
                    
                    if settings["fly high"] and bp.core.ready("Fly High", 503) and target then
                        bp.core.add("Fly High", bp.player, bp.core.priority("Fly High"))
                    end

                end

                -- CALL WYVERN.
                if settings["call wyvern"] and not pet and bp.core.ready("Call Wyvern") then
                    bp.core.add("Call Wyvern", bp.player, bp.core.priority("Call Wyvern"))
                end

                -- ANGON.
                if settings.angon and bp.core.ready("Angon") and bp.__inventory.canEquip("Angon") and target then
                    bp.core.add("Angon", target, bp.core.priority("Angon"))
                end

                -- JUMP.
                if settings.jump and bp.core.ready("Jump") and target then
                    bp.core.add("Jump", target, bp.core.priority("Jump"))

                -- HIGH JUMP.
                elseif settings["high jump"] and bp.core.ready("High Jump") and target then
                    bp.core.add("High Jump", target, bp.core.priority("High Jump"))

                -- SUPER JUMP.
                elseif settings["super jump"] and bp.core.ready("Super Jump") and target then
                    bp.core.add("Super Jump", target, bp.core.priority("Super Jump"))

                -- SPIRIT JUMP.
                elseif settings["spirit jump"] and bp.core.ready("Spirit Jump") and target then
                    bp.core.add("Spirit Jump", target, bp.core.priority("Spirit Jump"))

                -- SOUL JUMP.
                elseif settings["soul jump"] and bp.core.ready("Soul Jump") and target then
                    bp.core.add("Soul Jump", target, bp.core.priority("Soul Jump"))

                end

                if pet then

                    -- SMITING BREATH.
                    if settings["smiting breath"] and bp.core.ready("Smiting Breath") and target then

                        if settings["deep breathing"] and bp.core.ready("Deep Breathing") then
                            bp.core.add("Deep Breathing", bp.player, bp.core.priority("Deep Breathing"))
                        end
                        bp.core.add("Smiting Breath", target, bp.core.priority("Smiting Breath"))

                    -- RESTORING BREATH.
                    elseif settings["restoring breath"] and bp.core.ready("Restoring Breath") then

                        if settings["deep breathing"] and bp.core.ready("Deep Breathing") then
                            bp.core.add("Deep Breathing", bp.player, bp.core.priority("Deep Breathing"))
                        end
                        bp.core.add("Restoring Breath", bp.player, bp.core.priority("Restoring Breath"))

                    -- STEADY WING.
                    elseif settings["steady wing"] and bp.core.ready("Steady Wing") then
                        bp.core.add("Steady Wing", bp.player, bp.core.priority("Steady Wing"))

                    end

                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                end

                if bp.core.canCast() then

                end

            end

        end

        return self

    end
    
    return self

end
return job