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

                -- QUICK DRAW.
                if settings["quick draw"] and bp.core.ready("Quick Draw") and target and bp.__inventory.getCount("Trump Card") > 0 then
                    bp.core.add("Quick Draw", target, bp.core.priority("Quick Draw"))
                end

                -- RANDOM DEAL.
                if settings["random deal"] and bp.core.ready("Random Deal") and target then
                    bp.core.add("Random Deal", bp.player, bp.core.priority("Random Deal"))
                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- TRIPLE SHOT
                    if settings["triple shot"] and bp.core.ready("Triple Shot", 467) and target then
                        bp.core.add("Triple Shot", bp.player, bp.core.priority("Triple Shot"))
                    end

                    -- ROLLS.
                    if settings.rolls and settings.rolls.enabled and bp.core.ready("Phantom Roll") then

                        if bp.core.buff(309) and bp.core.ready("Fold") then
                            bp.core.add("Fold", bp.player, bp.core.priority("Fold"))

                        else

                            if bp.__rolls.getMidroll() and bp.core.ready("Double-Up") then
                                local rolling = bp.__rolls.getRolling()

                                if rolling then

                                    if rolling.number < bp.rolls.getStop() then
                                        bp.core.add("Double-Up", bp.player, bp.core.priority("Double-Up"))

                                    elseif bp.core.ready("Snake Eye", 357) and rolling.number >= bp.rolls.getStop() and rolling.number < 11 then
                                        bp.core.add("Snake Eye", bp.player, bp.core.priority("Snake Eye"))

                                    elseif bp.core.buff(357) then
                                        bp.core.add("Double-Up", bp.player, bp.core.priority("Double-Up"))

                                    end

                                end

                            elseif bp.__rolls.active():length() < 2 then
                                local roll = bp.__rolls.getMissing()[1]

                                if roll and bp.core.ready(roll) then

                                    -- CROOKED CARDS.
                                    if bp.__rolls.active():length() == 0 and settings["crooked cards"] and bp.core.ready("Crooked Cards", 601) then
                                        bp.core.add("Crooked Cards", bp.player, bp.core.priority("Crooked Cards"))

                                    end
                                    bp.core.add(roll, bp.player, bp.core.priority(roll))

                                end

                            end

                        end

                    end

                end

            end

        elseif bp.player.status == 0 then

            if settings.ja and bp.core.canAct() then

                -- QUICK DRAW.
                if settings["quick draw"] and bp.core.ready("Quick Draw") and target and bp.__inventory.getCount("Trump Card") > 0 then
                    bp.core.add("Quick Draw", target, bp.core.priority("Quick Draw"))
                end

                -- RANDOM DEAL.
                if settings["random deal"] and bp.core.ready("Random Deal") and target then
                    bp.core.add("Random Deal", bp.player, bp.core.priority("Random Deal"))
                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- TRIPLE SHOT
                    if settings["triple shot"] and bp.core.ready("Triple Shot", 467) and target then
                        bp.core.add("Triple Shot", bp.player, bp.core.priority("Triple Shot"))
                    end

                    -- ROLLS.
                    if settings.rolls and settings.rolls.enabled and bp.core.ready("Phantom Roll") then

                        if bp.core.buff(309) and bp.core.ready("Fold") then
                            bp.core.add("Fold", bp.player, bp.core.priority("Fold"))

                        else

                            if bp.__rolls.getMidroll() and bp.core.ready("Double-Up") then
                                local rolling = bp.__rolls.getRolling()

                                if rolling then

                                    if rolling.number < bp.rolls.getStop() then
                                        bp.core.add("Double-Up", bp.player, bp.core.priority("Double-Up"))

                                    elseif bp.core.ready("Snake Eye", 357) and rolling.number >= bp.rolls.getStop() and rolling.number < 11 then
                                        bp.core.add("Snake Eye", bp.player, bp.core.priority("Snake Eye"))

                                    elseif bp.core.buff(357) then
                                        bp.core.add("Double-Up", bp.player, bp.core.priority("Double-Up"))

                                    end

                                end

                            elseif bp.__rolls.active():length() < 2 then
                                local roll = bp.__rolls.getMissing()[1]

                                if roll and bp.core.ready(roll) then

                                    -- CROOKED CARDS.
                                    if bp.__rolls.active():length() == 0 and settings["crooked cards"] and bp.core.ready("Crooked Cards", 601) then
                                        bp.core.add("Crooked Cards", bp.player, bp.core.priority("Crooked Cards"))

                                    end
                                    bp.core.add(roll, bp.player, bp.core.priority(roll))

                                end

                            end

                        end

                    end

                end

            end

        end

        return self

    end
    
    return self

end
return job