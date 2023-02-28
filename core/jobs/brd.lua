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
    self.__timers   = {hate=0, aoehate=0, lullaby=0}
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

            if settings.buffs then

                -- HANDLE SONGS.
                if bp.core.canCast() then
                    bp.songs.handleSongs()
                end

            end

            if settings.debuffs and bp.core.canCast() then

                -- HANDLE HORDE LULLABIES.
                if settings.lullaby and (os.time()-self.__timers.lullaby) > 12 then

                    if bp.__aggro.getCount() > 3 then
                        local sleep = bp.__aggro.getAggro()[1]

                        if sleep and bp.core.ready("Horde Lullaby II") then
                            bp.core.add("Horde Lullaby II", sleep, bp.core.priority("Horde Lullaby II"))
                            self.__timers.lullaby = os.time()

                        elseif sleep and bp.core.ready("Horde Lullaby") then
                            bp.core.add("Horde Lullaby", sleep, bp.core.priority("Horde Lullaby"))
                            self.__timers.lullaby = os.time()

                        end

                    end

                end

            end

        elseif bp.player.status == 0 then

            if settings.buffs then

                -- HANDLE SONGS.
                if bp.core.canCast() then
                    bp.songs.handleSongs()
                end

            end

            if settings.debuffs and bp.core.canCast() then

                -- HANDLE HORDE LULLABIES.
                if settings.lullaby and (os.time()-self.__timers.lullaby) > 12 then

                    if bp.__aggro.getCount() > 3 then
                        local sleep = bp.__aggro.getAggro()[1]

                        if sleep and bp.core.ready("Horde Lullaby II") then
                            bp.core.add("Horde Lullaby II", sleep, bp.core.priority("Horde Lullaby II"))
                            self.__timers.lullaby = os.time()

                        elseif sleep and bp.core.ready("Horde Lullaby") then
                            bp.core.add("Horde Lullaby", sleep, bp.core.priority("Horde Lullaby"))
                            self.__timers.lullaby = os.time()

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