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
                    local tools = bp.__inventory.findByName(bp.__tools.get(spell).cast, 0)

                    if tools and tools[1] then
                        local index, count = table.unpack(tools[2] and tools[2] or tools[1])

                        if count > 0 then

                            if count > 1 and settings.futae and bp.core.ready("Futae", 441) then
                                bp.core.add("Futae", target, bp.core.priority("Futae"))
                            end
                            bp.core.add(spell, target, bp.core.priority(spell))

                        end

                    end

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

                -- ONE-HOURS.
                if settings['1hr'] then

                    -- MIKAGE.
                    if settings.mikage and bp.core.ready("Mikage", 502) and target then
                        bp.core.add("Mikage", bp.player, bp.core.priority("Mikage"))
                    end

                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- YONIN.
                    if settings.yonin and bp.core.ready("Yonin", 420) and bp.__actions.isFacing(target) then
                        bp.core.add("Yonin", bp.player, bp.core.priority("Yonin"))

                    -- INNIN.
                    elseif settings.innin and bp.core.ready("Innin", 421) and bp.__actions.isBehind(target) then
                        bp.core.add("Innin", bp.player, bp.core.priority("Innin"))

                    -- SANGE.
                    elseif settings.sange and bp.core.ready("Sange", 352) then
                        bp.core.add("Sange", bp.player, bp.core.priority("Sange"))

                    -- ISSEKIGAN.
                    elseif settings.issekigan and bp.core.ready("Issekigan", 484) then
                        bp.core.add("Issekigan", bp.player, bp.core.priority("Issekigan"))

                    end

                end

                if bp.core.canCast() then

                    -- UTSUSEMI.
                    if settings.utsusemi then
                        local tools = bp.__inventory.findByName(bp.__tools.get("Utsu").cast, 0)

                        if tools and tools[1] then
                            local index, count = table.unpack(tools[2] and tools[2] or tools[1])

                            if index and count and count > 0 and not bp.__buffs.hasShadows() and not bp.core.searchQueue('Utsusemi') then
                                
                                if bp.core.isReady("Utsusemi: San") then
                                    bp.core.add("Utsusemi: San", bp.player, bp.core.priority("Utsusemi: San"))
            
                                elseif bp.core.isReady("Utsusemi: Ni") then
                                    bp.core.add("Utsusemi: Ni", bp.player, bp.core.priority("Utsusemi: Ni"))
                                        
                                elseif bp.core.isReady("Utsusemi: Ichi") then
                                    bp.core.add("Utsusemi: Ichi", bp.player, bp.core.priority("Utsusemi: Ichi"))
                                        
                                end

                            end

                        elseif settings.items and (not tools or not tools[1]) then
                            local toolbags = bp.__inventory.findByName(bp.__tools.get("Utsu").toolbags, 0) or false

                            if toolbags and toolbags[1] then
                                local index, count, id = table.unpack(toolbags[2] and toolbags[2] or toolbags[1])

                                if index and count and id and count > 0 and bp.res.items[id] and not bp.core.inQueue(bp.res.items[id], bp.player) then
                                    bp.core.add(bp.res.items[id], bp.player, bp.core.priority(bp.res.items[id].en))
                                end

                            end

                        end

                    end

                end

            end
            self:castNukes(target)

        elseif bp.player.status == 0 then

            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] then

                    -- MIKAGE.
                    if settings.mikage and bp.core.ready("Mikage", 502) and target then
                        bp.core.add("Mikage", bp.player, bp.core.priority("Mikage"))
                    end

                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- YONIN.
                    if settings.yonin and bp.core.ready("Yonin", 420) and bp.__actions.isFacing(target) then
                        bp.core.add("Yonin", bp.player, bp.core.priority("Yonin"))

                    -- ISSEKIGAN.
                    elseif settings.issekigan and bp.core.ready("Issekigan", 484) then
                        bp.core.add("Issekigan", bp.player, bp.core.priority("Issekigan"))

                    end

                end

                if bp.core.canCast() then

                    -- UTSUSEMI.
                    if settings.utsusemi then
                        local tools = bp.__inventory.findByName(bp.__tools.get("Utsu").cast, 0)

                        if tools and tools[1] then
                            local index, count = table.unpack(tools[2] and tools[2] or tools[1])

                            if index and count and count > 0 and not bp.__buffs.hasShadows() and not bp.core.searchQueue('Utsusemi') then
                                
                                if bp.core.isReady("Utsusemi: San") then
                                    bp.core.add("Utsusemi: San", bp.player, bp.core.priority("Utsusemi: San"))
            
                                elseif bp.core.isReady("Utsusemi: Ni") then
                                    bp.core.add("Utsusemi: Ni", bp.player, bp.core.priority("Utsusemi: Ni"))
                                        
                                elseif bp.core.isReady("Utsusemi: Ichi") then
                                    bp.core.add("Utsusemi: Ichi", bp.player, bp.core.priority("Utsusemi: Ichi"))
                                        
                                end

                            end

                        elseif settings.items and (not tools or not tools[1]) then
                            local toolbags = bp.__inventory.findByName(bp.__tools.get("Utsu").toolbags, 0) or false

                            if toolbags and toolbags[1] then
                                local index, count, id = table.unpack(toolbags[2] and toolbags[2] or toolbags[1])

                                if index and count and id and count > 0 and bp.res.items[id] and not bp.core.inQueue(bp.res.items[id], bp.player) then
                                    bp.core.add(bp.res.items[id], bp.player, bp.core.priority(bp.res.items[id].en))
                                end

                            end

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