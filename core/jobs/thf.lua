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

                -- BULLY.
                if settings.bully and bp.core.ready("Bully") and target then
                    bp.core.add("Bully", target, bp.core.priority("Bully"))
                end

                -- STEAL.
                if settings.steal and bp.core.ready("Steal") then
                    bp.core.add("Steal", target, bp.core.priority("Steal"))

                -- MUG.
                elseif settings.mug and bp.core.ready("Mug") then
                    bp.core.add("Mug", target, bp.core.priority("Mug"))

                -- DESPOIL.
                elseif settings.despoil and bp.core.ready("Despoil") then
                    bp.core.add("Despoil", target, bp.core.priority("Despoil"))

                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- CONSPIRATOR.
                    if settings.feint and bp.core.ready("Conspirator", 462) then
                        bp.core.add("Conspirator", bp.player, bp.core.priority("Conspirator"))
                    end

                    -- FEINT.
                    if settings.feint and bp.core.ready("Feint", 343) then
                        bp.core.add("Feint", bp.player, bp.core.priority("Feint"))
                    end

                    -- ASSASINS CHARGE.
                    if settings["assassin's charge"] and bp.core.ready("Assassin's Charge", 342) then
                        bp.core.add("Assassin's Charge", bp.player, bp.core.priority("Assassin's Charge"))
                    end

                    -- SNEAK ATTACK.
                    if settings["sneak attack"] and bp.core.ready("Sneak Attck", 65) and bp.__actions.isBehind(target) then
                        bp.core.add("Sneak Attck", bp.player, bp.core.priority("Sneak Attck"))
                    end

                    -- TRICK ATTACK.
                    if settings["trick attack"] and bp.core.ready("Trick Attack", 87) and bp.__actions.isFacing(target) then
                        bp.core.add("Trick Attack", bp.player, bp.core.priority("Trick Attack"))
                    end

                end

            end

        elseif bp.player.status == 0 then

            if settings.ja and bp.core.canAct() then

                -- BULLY.
                if settings.bully and bp.core.ready("Bully") and target then
                    bp.core.add("Bully", target, bp.core.priority("Bully"))
                end

                -- STEAL.
                if settings.steal and bp.core.ready("Steal") then
                    bp.core.add("Steal", target, bp.core.priority("Steal"))

                -- MUG.
                elseif settings.mug and bp.core.ready("Mug") then
                    bp.core.add("Mug", target, bp.core.priority("Mug"))

                -- DESPOIL.
                elseif settings.despoil and bp.core.ready("Despoil") then
                    bp.core.add("Despoil", target, bp.core.priority("Despoil"))

                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- CONSPIRATOR.
                    if settings.feint and bp.core.ready("Conspirator", 462) then
                        bp.core.add("Conspirator", bp.player, bp.core.priority("Conspirator"))
                    end

                    -- FEINT.
                    if settings.feint and bp.core.ready("Feint", 343) then
                        bp.core.add("Feint", bp.player, bp.core.priority("Feint"))
                    end

                    -- ASSASINS CHARGE.
                    if settings["assassin's charge"] and bp.core.ready("Assassin's Charge", 342) then
                        bp.core.add("Assassin's Charge", bp.player, bp.core.priority("Assassin's Charge"))
                    end

                    -- SNEAK ATTACK.
                    if settings["sneak attack"] and bp.core.ready("Sneak Attck", 65) and bp.__actions.isBehind(target) then
                        bp.core.add("Sneak Attck", bp.player, bp.core.priority("Sneak Attck"))
                    end

                    -- TRICK ATTACK.
                    if settings["trick attack"] and bp.core.ready("Trick Attack", 87) and bp.__actions.isFacing(target) then
                        bp.core.add("Trick Attack", bp.player, bp.core.priority("Trick Attack"))
                    end

                end

            end

        end

        return self

    end
    
    return self

end
return job