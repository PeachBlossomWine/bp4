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

                if not pet then

                    -- ACTIVATE.
                    if settings.activate and not bp.core.searchQueue({"Activate","Deus Ex"}) then

                        if bp.core.ready("Activate") then
                            bp.core.add("Activate", bp.player, bp.core.priority("Activate"))

                        elseif bp.core.ready("Deus Ex Automata") then
                            bp.core.add("Deus Ex Automata", bp.player, bp.core.priority("Deus Ex Automata"))

                        end

                    end

                elseif pet and not T{2,3}:contains(pet.status) then

                    -- REPAIR.
                    if settings.repair and settings.repair.enabled and bp.core.ready("Repair") and pet.hpp < settings.repair.hpp and target then
                        local oil = bp.__equipment.get(3)

                        if oil.index > 0 and bp.res.items[bp.__inventory.getByIndex(oil.bag, oil.index).id].en:startswith("Automat") then
                            bp.core.add("Repair", bp.player, bp.core.priority("Repair"))
                        end

                    end

                    -- MANEUVERS.
                    if settings.maneuvers and settings.maneuvers.enabled and bp.core.ready("Fire Maneuver", 299) then
                        local current = bp.__maneuvers.active()

                        if #current < 3 then
                            local maneuvers = bp.__maneuvers.getMissing(T(settings.maneuvers.list):copy())

                            if maneuvers:length() > 0 and not bp.core.searchQueue(maneuvers[1]) then
                                bp.core.add(maneuvers[1], bp.player, bp.core.priority(maneuvers[1]))
                            end

                        end

                    end

                    -- COOLDOWN.
                    if settings.cooldown and bp.core.ready("Cooldown") then
                        bp.core.add("Cooldown", bp.player, bp.core.priority("Cooldown"))
                    end

                    if pet.status == 0 then

                        -- DEPLOY.
                        if settings.deploy and bp.core.ready("Deploy") and target then
                            bp.core.add("Deploy", target, bp.core.priority("Deploy"))
                        end

                    elseif pet.status == 1 then

                        -- RETRIEVE.
                        if not settings.deploy and bp.core.ready("Retrieve") then
                            bp.core.add("Retrieve", bp.player, bp.core.priority("Retrieve"))
                        end

                    end

                end

            end

        elseif bp.player.status == 0 then

            if settings.ja and bp.core.canAct() then

                if not pet then

                    -- ACTIVATE.
                    if settings.activate and not bp.core.searchQueue({"Activate","Deus Ex"}) then

                        if bp.core.ready("Activate") then
                            bp.core.add("Activate", bp.player, bp.core.priority("Activate"))

                        elseif bp.core.ready("Deus Ex Automata") then
                            bp.core.add("Deus Ex Automata", bp.player, bp.core.priority("Deus Ex Automata"))

                        end

                    end

                elseif pet and not T{2,3}:contains(pet.status) then

                    -- REPAIR.
                    if settings.repair and settings.repair.enabled and bp.core.ready("Repair") and pet.hpp < settings.repair.hpp and target then
                        local oil = bp.__equipment.get(3)

                        if oil.index > 0 and bp.res.items[bp.__inventory.getByIndex(oil.bag, oil.index).id].en:startswith("Automat") then
                            bp.core.add("Repair", bp.player, bp.core.priority("Repair"))
                        end

                    end

                    -- MANEUVERS.
                    if settings.maneuvers and settings.maneuvers.enabled and bp.core.ready("Fire Maneuver", 299) then
                        local current = bp.__maneuvers.active()

                        if #current < 3 then
                            local maneuvers = bp.__maneuvers.getMissing(T(settings.maneuvers.list):copy())

                            if maneuvers:length() > 0 and not bp.core.searchQueue(maneuvers[1]) then
                                bp.core.add(maneuvers[1], bp.player, bp.core.priority(maneuvers[1]))
                            end

                        end

                    end

                    -- COOLDOWN.
                    if settings.cooldown and bp.core.ready("Cooldown") then
                        bp.core.add("Cooldown", bp.player, bp.core.priority("Cooldown"))
                    end

                    if pet.status == 0 then

                        -- DEPLOY.
                        if settings.deploy and bp.core.ready("Deploy") and target then
                            bp.core.add("Deploy", target, bp.core.priority("Deploy"))
                        end

                    elseif pet.status == 1 then

                        -- RETRIEVE.
                        if not settings.deploy and bp.core.ready("Retrieve") then
                            bp.core.add("Retrieve", bp.player, bp.core.priority("Retrieve"))
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