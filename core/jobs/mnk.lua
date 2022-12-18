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
        local target = bp.core.target()

        self:useItems()
        if bp.player.status == 1 then
            local target = bp.core.target() or windower.ffxi.get_mob_by_target('t') or false

            -- JOB ABILITIES.
            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] then

                    -- HUNDRED FISTS.
                    if settings["hundred fists"] and bp.core.ready("Hundred Fists", 46) and target then
                        bp.core.add("Hundred Fists", bp.player, bp.core.priority("Hundred Fists"))
                    end
                    
                    -- INNER STRENGTH.
                    if settings["inner strength"] and bp.core.ready("Inner Strength", 491) and target then
                        bp.core.add("Inner Strength", bp.player, bp.core.priority("Inner Strength"))
                    end

                end

                -- CHI BLAST.
                if settings["chi blast"] and bp.core.ready("Chi Blast") then
                    bp.core.add("Chi Blast", bp.player, bp.core.priority("Chi Blast"))
                end

            end

            -- BUFFS.
            if settings.buffs then

                if bp.core.canAct() and target then

                    -- MANTRA.
                    if settings["mantra"] and bp.core.ready("Mantra") then
                        bp.core.add("Mantra", bp.player, bp.core.priority("Mantra"))
                    end

                    -- DODGE.
                    if settings.dodge and bp.core.ready("Dodge", 60) then
                        bp.core.add("Dodge", bp.player, bp.core.priority("Dodge"))

                    -- FOCUS.
                    elseif settings.focus and bp.core.ready("Focus", 59) then
                        bp.core.add("Focus", bp.player, bp.core.priority("Focus"))

                    -- IMPETUS.
                    elseif settings.impetus and bp.core.ready("Impetus", 461) then
                        bp.core.add("Impetus", bp.player, bp.core.priority("Impetus"))

                    -- FOOTWORK.
                    elseif settings.footwork and bp.core.ready("Footwork", 406) then
                        bp.core.add("Footwork", bp.player, bp.core.priority("Footwork"))

                    -- FORMLESS STRIKES.
                    elseif settings["formless strikes"] and bp.core.ready("Formless Strikes", 341) then
                        bp.core.add("Formless Strikes", bp.player, bp.core.priority("Formless Strikes"))

                    -- COUNTERSTANCE.
                    elseif settings.counterstance and bp.core.ready("Counterstance", 61) then
                        bp.core.add("Counterstance", bp.player, bp.core.priority("Counterstance"))

                    -- PERFECT COUNTER.
                    elseif settings["perfect counter"] and bp.core.ready("Perfect Counter", 436) then
                        bp.core.add("Perfect Counter", bp.player, bp.core.priority("Perfect Counter"))

                    end

                end

            end

        elseif bp.player.status == 0 then

            -- JOB ABILITIES.
            if settings.ja and bp.core.canAct() then

                -- CHI BLAST.
                if settings["chi blast"] and bp.core.ready("Chi Blast") then
                    bp.core.add("Chi Blast", bp.player, bp.core.priority("Chi Blast"))
                end

            end

            -- BUFFS.
            if settings.buffs then

                if bp.core.canAct() and target then

                    -- MANTRA.
                    if settings["mantra"] and bp.core.ready("Mantra") then
                        bp.core.add("Mantra", bp.player, bp.core.priority("Mantra"))
                    end

                    -- DODGE.
                    if settings.dodge and bp.core.ready("Dodge", 60) then
                        bp.core.add("Dodge", bp.player, bp.core.priority("Dodge"))

                    -- COUNTERSTANCE.
                    elseif settings.counterstance and bp.core.ready("Counterstance", 61) then
                        bp.core.add("Counterstance", bp.player, bp.core.priority("Counterstance"))

                    -- PERFECT COUNTER.
                    elseif settings["perfect counter"] and bp.core.ready("Perfect Counter", 436) then
                        bp.core.add("Perfect Counter", bp.player, bp.core.priority("Perfect Counter"))

                    end

                end

            end

        end

        return self

    end
    
    return self

end
return job