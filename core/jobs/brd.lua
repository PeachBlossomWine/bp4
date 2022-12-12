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

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target then

            end

            if settings.ja and bp.core.canAct() then

            end

            if settings.buffs then

            end

            if target and bp.core.canCast() then

            end
            self:castNukes(target)

        elseif bp.player.status == 0 then

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target then

            end

            if settings.ja and bp.core.canAct() then

            end

            if settings.buffs then

            end

            if target and bp.core.canCast() then

                -- DRAINS.
                if settings.drain and settings.drain.enabled and bp.core.vitals.hpp < settings.drain.hpp then

                    if bp.core.isReady("Drain III") and not bp.core.inQueue("Drain III") then
                        bp.core.add("Drain III", target, bp.core.priority("Drain III"))

                    elseif bp.core.isReady("Drain II") and not bp.core.inQueue("Drain II") then
                        bp.core.add("Drain II", target, bp.core.priority("Drain II"))

                    elseif bp.core.isReady("Drain") and not bp.core.inQueue("Drain") then
                        bp.core.add("Drain", target, bp.core.priority("Drain"))

                    end

                end

                -- ASPIRS.
                if settings.aspir and settings.aspir.enabled and bp.core.vitals.mpp < settings.aspir.mpp then

                    if bp.core.isReady("Aspir III") and not bp.core.inQueue("Aspir III") then
                        bp.core.add("Aspir III", target, bp.core.priority("Aspir III"))

                    elseif bp.core.isReady("Aspir II") and not bp.core.inQueue("Aspir II") then
                        bp.core.add("Aspir II", target, bp.core.priority("Aspir II"))

                    elseif bp.core.isReady("Aspir") and not bp.core.inQueue("Aspir") then
                        bp.core.add("Aspir", target, bp.core.priority("Aspir"))

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