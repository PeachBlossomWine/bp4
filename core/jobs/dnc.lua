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

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target then

                -- FAN DANCE.
                if settings["fan dance"] and bp.core.ready("Fan Dance", {410,411}) then
                    bp.core.add("Fan Dance", bp.player, bp.core.priority("Fan Dance"))
                end

                if (bp.__buffs.getFinishingMoves() > 0 or bp.core.buff(507)) then

                    -- ANIMATED FLOURISH.
                    if settings["animated flourish"] and bp.core.ready("Animated Flourish") then
                        bp.core.add("Animated Flourish", target, bp.core.priority("Animated Flourish"))
                    end

                end

            end

            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] and target then

                    -- TRANCE.
                    if settings.trance and bp.core.ready("Trance", 376) then
                        bp.core.add("Trance", bp.player, bp.core.priority("Trance"))
                    end
                    
                    -- GRAND PAS.
                    if settings["grand pas"] and bp.core.ready("Grand Pas", 507) then
                        bp.core.add("Grand Pas", bp.player, bp.core.priority("Grand Pas"))
                    end

                end

                -- NO FOOT RISE.
                if settings["no foot rise"] and bp.core.ready("No Foot Rise") then
                    local level = bp.player.merits['no_foot_rise']

                    if (6-bp.__buffs.getFinishingMoves()) <= level then
                        bp.core.add("No Foot Rise", bp.player, bp.core.priority("No Foot Rise"))
                    end

                end

                -- CONTRADANCE.
                if settings.cures and settings.contradance and bp.core.ready("Contradance", 582) then
                    bp.core.add("Contradance", bp.player, bp.core.priority("Contradance"))
                end

                -- STEPS.
                if settings.steps and settings.steps.enabled and bp.core.ready(settings.steps.name) then

                    -- PRESTO.
                    if settings.presto and bp.core.ready("Presto") and bp.__buffs.getFinishingMoves() == 0 then
                        bp.core.add("Presto", bp.player, bp.core.priority("Presto"))

                    end
                    bp.core.add(settings.steps.name, target, bp.core.priority(settings.steps.name))

                end

                if (bp.__buffs.getFinishingMoves() > 0 or bp.core.buff(507)) then

                    -- VIOLENT FLOURISH.
                    if settings["violent flourish"] and bp.core.ready("Violent Flourish") then
                        bp.core.add("Violent Flourish", target, bp.core.priority("Violent Flourish"))
                    end

                    -- REVERSE FLOURISH.
                    if settings["reverse flourish"] and bp.core.ready("Reverse Flourish") then
                        bp.core.add("Reverse Flourish", bp.player, bp.core.priority("Reverse Flourish"))
                    end

                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- SABER DANCE.
                    if settings["saber dance"] and bp.core.ready("Saber Dance", {410,411}) then
                        bp.core.add("Saber Dance", bp.player, bp.core.priority("Saber Dance"))
                    end

                    -- SAMBAS.
                    if settings.sambas and settings.sambas.enabled and target and not bp.core.buff(411) then
                        local samba = settings.sambas.name

                        if samba and bp.JA[samba] then
                            local mlevel, slevel = bp.core.mlevel, bp.core.slevel

                            if samba == "Drain Samba" then

                                if bp.core.ready("Drain Samba III", 368) then
                                    bp.core.add("Drain Samba III", bp.player, bp.core.priority("Drain Samba III"))

                                elseif bp.core.ready("Drain Samba II", 368) then
                                    bp.core.add("Drain Samba II", bp.player, bp.core.priority("Drain Samba II"))

                                elseif bp.core.ready("Drain Samba", 368) then
                                    bp.core.add("Drain Samba", bp.player, bp.core.priority("Drain Samba"))

                                end

                            elseif samba == "Aspir Samba" then

                                if bp.core.ready("Aspir Samba II", 369) then
                                    bp.core.add("Aspir Samba II", bp.player, bp.core.priority("Aspir Samba II"))

                                elseif bp.core.ready("Aspir Samba", 369) then
                                    bp.core.add("Aspir Samba", bp.player, bp.core.priority("Aspir Samba"))

                                end

                            elseif samba == "Haste Samba" and bp.core.ready("Haste Samba", 370) then
                                bp.core.add("Haste Samba", bp.player, bp.core.priority("Haste Samba"))

                            end

                        end

                    end

                    if (bp.__buffs.getFinishingMoves() > 0 or bp.core.buff(507)) then

                        if settings.ws and settings.ws.enabled and bp.core.vitals.tp >= settings.ws.tp then

                            -- CLIMACTIC FLOURISH.
                            if settings["climactic flourish"] and bp.core.ready("Climactic Flourish", 443) then
                                bp.core.add("Climactic Flourish", bp.player, bp.core.priority("Climactic Flourish"))
                            end

                            -- STRIKING FLOURISH.
                            if settings["striking flourish"] and bp.core.ready("Striking Flourish", 468) and (bp.__buffs.getFinishingMoves() > 1 or bp.core.buff(507)) then
                                bp.core.add("Striking Flourish", bp.player, bp.core.priority("Striking Flourish"))
                            end

                            -- TERNARY FLOURISH.
                            if settings["ternary flourish"] and bp.core.ready("Ternary Flourish", 472) and (bp.__buffs.getFinishingMoves() > 2 or bp.core.buff(507)) then
                                bp.core.add("Ternary Flourish", bp.player, bp.core.priority("Ternary Flourish"))
                            end

                        else

                            -- BUILDING FLOURISH.
                            if settings["building flourish"] and bp.core.ready("Building Flourish", 375) then
                                bp.core.add("Building Flourish", bp.player, bp.core.priority("Building Flourish"))
                            end

                            -- WILD FLOURISH.
                            if settings["wild flourish"] and bp.core.ready("Wild Flourish") and (bp.__buffs.getFinishingMoves() > 1 or bp.core.buff(507)) then
                                bp.core.add("Wild Flourish", target, bp.core.priority("Wild Flourish"))
                            end

                        end

                    end
                    

                end

            end

        elseif bp.player.status == 0 then

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target then

                -- FAN DANCE.
                if settings["fan dance"] and bp.core.ready("Fan Dance", {410,411}) then
                    bp.core.add("Fan Dance", bp.player, bp.core.priority("Fan Dance"))
                end

                if (bp.__buffs.getFinishingMoves() > 0 or bp.core.buff(507)) then

                    -- ANIMATED FLOURISH.
                    if settings["animated flourish"] and bp.core.ready("Animated Flourish") then
                        bp.core.add("Animated Flourish", target, bp.core.priority("Animated Flourish"))
                    end

                end

            end

            if settings.ja and bp.core.canAct() then

                -- NO FOOT RISE.
                if settings["no foot rise"] and bp.core.ready("No Foot Rise") then
                    local level = bp.player.merits['no_foot_rise']

                    if (6-bp.__buffs.getFinishingMoves()) <= level then
                        bp.core.add("No Foot Rise", bp.player, bp.core.priority("No Foot Rise"))
                    end

                end

                -- CONTRADANCE.
                if settings.cures and settings.contradance and bp.core.ready("Contradance", 582) then
                    bp.core.add("Contradance", bp.player, bp.core.priority("Contradance"))
                end

                -- STEPS.
                if settings.steps and settings.steps.enabled and bp.core.ready(settings.steps.name) then

                    -- PRESTO.
                    if settings.presto and bp.core.ready("Presto") and bp.__buffs.getFinishingMoves() == 0 then
                        bp.core.add("Presto", bp.player, bp.core.priority("Presto"))

                    end
                    bp.core.add(settings.steps.name, target, bp.core.priority(settings.steps.name))

                end

            end

        end

        return self

    end
    
    return self

end
return job