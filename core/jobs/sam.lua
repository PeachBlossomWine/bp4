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

        self:useItems()
        if bp.player.status == 1 then
            local target = bp.core.target() or windower.ffxi.get_mob_by_target('t') or false

            if settings.ja and bp.core.canAct() then

                -- SHIKIKOYO.
                if settings.shikikoyo and settings.shikikoyo.enabled and bp.core.ready("Shikikoyo") then
                    local target, tp = bp.core.getTarget(settings.shikikoyo.target), settings.shikikoyo.tp

                    if target and bp.cpre.vitals.tp >= tp and bp.__distance.get(target) <= bp.__queue.getRange("Shikikoyo") then
                        bp.core.add("Shikikoyo", target, bp.core.priority("Shikikoyo"))
                    end

                end

                -- MEDITATE.
                if settings.meditate and bp.core.ready("Meditate") and bp.core.vitals.tp < 1500 then
                    bp.core.add("Meditate", bp.player, bp.core.priority("Meditate"))
                end

                -- BLADE BASH.
                if settings["blade bash"] and bp.core.ready("Blade Bash") and target then
                    bp.core.add("Blade Bash", target, bp.core.priority("Blade Bash"))
                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- THIRD EYE.
                    if settings["third eye"] and bp.core.ready("Third Eye", 67) then
                        bp.core.add("Third Eye", bp.player, bp.core.priority("Third Eye"))
                    end

                    -- HASSO.
                    if settings.hasso and not settings.tank and bp.core.ready("Hasso", 353) then
                        bp.core.add("Hasso", bp.player, bp.core.priority("Hasso"))

                    -- SEIGAN.
                    elseif settings.seigan and not settings.tank and bp.core.ready("Seigan", 354) then
                        bp.core.add("Seigan", bp.player, bp.core.priority("Seigan"))

                    -- SEKKANOKI.
                    elseif settings.sekkanoki and not settings.tank and bp.core.ready("Sekkanoki", 408) then
                        bp.core.add("Sekkanoki", bp.player, bp.core.priority("Sekkanoki"))

                    -- KONZEN-ITTAI.
                    elseif settings["konzen-ittai"] and not settings.tank and bp.core.ready("Konzen-Ittai") then
                        bp.core.add("Konzen-Ittai", bp.player, bp.core.priority("Konzen-Ittai"))

                    -- SENGIKORI.
                    elseif settings.sengikori and not settings.tank and bp.core.ready("Sengikori", 440) then
                        bp.core.add("Sengikori", bp.player, bp.core.priority("Sengikori"))

                    -- HAMANOHA.
                    elseif settings.hamanoha and not settings.tank and bp.core.ready("Hamanoha", 465) then
                        bp.core.add("Hamanoha", bp.player, bp.core.priority("Hamanoha"))

                    -- HAGAKURE.
                    elseif settings.hagakure and not settings.tank and bp.core.ready("Hagakure", 483) then
                        bp.core.add("Hagakure", bp.player, bp.core.priority("Hagakure"))

                    end

                end

            end

        elseif bp.player.status == 0 then

            if settings.ja and bp.core.canAct() then

                -- SHIKIKOYO.
                if settings.shikikoyo and settings.shikikoyo.enabled and bp.core.ready("Shikikoyo") then
                    local target, tp = bp.core.getTarget(settings.shikikoyo.target), settings.shikikoyo.tp

                    if target and bp.cpre.vitals.tp >= tp and bp.__distance.get(target) <= bp.__queue.getRange("Shikikoyo") then
                        bp.core.add("Shikikoyo", target, bp.core.priority("Shikikoyo"))
                    end

                end

                -- MEDITATE.
                if settings.meditate and bp.core.ready("Meditate") and bp.core.vitals.tp < 1500 then
                    bp.core.add("Meditate", bp.player, bp.core.priority("Meditate"))
                end

                -- BLADE BASH.
                if settings["blade bash"] and bp.core.ready("Blade Bash") and target then
                    bp.core.add("Blade Bash", target, bp.core.priority("Blade Bash"))
                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- THIRD EYE.
                    if settings["third eye"] and bp.core.ready("Third Eye", 67) then
                        bp.core.add("Third Eye", bp.player, bp.core.priority("Third Eye"))
                    end

                    -- HASSO.
                    if settings.hasso and not settings.tank and bp.core.ready("Hasso", 353) then
                        bp.core.add("Hasso", bp.player, bp.core.priority("Hasso"))

                    -- SEIGAN.
                    elseif settings.seigan and not settings.tank and bp.core.ready("Seigan", 354) then
                        bp.core.add("Seigan", bp.player, bp.core.priority("Seigan"))

                    end

                end

            end

        end

        return self

    end
    
    return self

end
return job