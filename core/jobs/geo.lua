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

        if target and not settings.mb then

            for spell in self.__nukes:it() do

                if bp.core.canCast() and bp.core.isReady(spell) and not bp.core.inQueue(spell) then

                    if settings['theurgic focus'] and bp.core.isReady("Theurgic Focus") and not bp.core.inQueue("Theurgic Focus") then
                        bp.core.add("Theurgic Focus", bp.player, bp.core.priority("Theurgic Focus"))

                    end
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

            -- NOT IN NUKE MODE.
            if not settings.nuke then
                local pet = bp.pet

                if settings.ja and bp.core.canAct() then

                    -- ONE-HOURS.
                    if settings['1hr'] then
                        
                        if bp.core.isReady("Bolster") and settings.geocolure then
                            bp.core.add("Bolster", bp.player, bp.core.priority("Bolster"))
                        end

                    end

                    if pet and not T{2,3}:contains(pet.status) then
                        
                        -- FULL CIRCLE.
                        if settings['full circle'] and settings['full circle'].enabled and bp.core.isReady("Full Circle") and not bp.core.inQueue("Full Circle") and bp.core.distance(pet) > settings['full circle'].distance then
                            bp.core.add("Full Circle", bp.player, bp.core.priority("Full Circle"))
                        end

                        -- ECLIPTIC / LASTING.
                        if settings['ecliptic attrition'] and bp.core.isReady("Ecliptic Attrition") and not bp.core.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp > 85 and not bp.core.buff({513,515,516}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) then
                            bp.core.add("Ecliptic Attrition", bp.player, bp.core.priority("Ecliptic Attrition"))

                        elseif settings['lasting emanation'] and bp.core.isReady("Lasting Emanation") and not bp.core.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp < 85 and not bp.core.buff({513,515,516}) then
                            bp.core.add("Lasting Emanation", bp.player, bp.core.priority("Lasting Emanation"))

                        end

                        -- RADIAL / MENDING.
                        if settings['radial arcana'] and settings['radial arcana'].enabled and bp.core.isReady("Radial Arcana") and not bp.core.searchQueue({"Radial Arcana","Mending Halation"}) and bp.core.vitals.mpp < settings['radial arcana'].mpp and not bp.core.buff({513,515,516,569}) then
                            bp.core.add("Radial Arcana", bp.player, bp.core.priority("Radial Arcana"))

                        elseif settings['mending halation'] and settings['mending halation'].enabled and bp.core.isReady("Mending Halation") and not bp.core.searchQueue({"Radial Arcana","Mending Halation"}) and bp.core.vitals.hpp < settings['mending halation'].hpp and not bp.core.buff({513,515,516,569}) then
                            bp.core.add("Mending Halation", bp.player, bp.core.priority("Mending Halation"))

                        end

                        -- LIFE CYCLE.
                        if settings['life cycle'] and bp.core.isReady("Life Cycle") and not bp.core.inQueue("Life Cycle") and pet.hpp < 55 and bp.core.vitals.hpp > 50 and (bp.core.inQueue("Bolster","Ecliptic Attrition") or bp.core.buff({513,515,516,569})) then
                            bp.core.add("Life Cycle", bp.player, bp.core.priority("Life Cycle"))
                        end

                        -- DEMATERIALIZE.
                        if settings.dematerialize and bp.core.isReady("Dematerialize") and not bp.core.inQueue("Dematerialize") and pet.hpp > 85 and bp.core.buff({513,569}) and (bp.core.inQueue("Bolster","Ecliptic Attrition") or bp.core.buff({513,515,516,569})) then
                            bp.core.add("Dematerialize", bp.player, bp.core.priority("Dematerialize"))
                        end

                    end

                end

                if settings.buffs then
                    local indicolure = bp.bubbles.getIndicolure()
                    local geocolure = bp.bubbles.getGeocolure()
                    local entrust = bp.bubbles.getEntrust()

                    if bp.core.canCast() then

                        if settings.bubbles and settings.bubbles.enabled then

                            -- INDICOLURE BUFFS.
                            if settings.indicolure and bp.core.isReady(indicolure) and not bp.core.inQueue(indicolure) and bp.MA[indicolure] and (not bp.__buffs.active(612) or bp.__bubbles.indiRecast()) then
                                bp.core.add(indicolure, bp.player, bp.core.priority(indicolure))

                            -- GEOCOLURE BUFFS.
                            elseif settings.geocolure and bp.core.isReady(geocolure) and not bp.core.inQueue(geocolure) and (not pet or bp.__bubbles.geoRecast()) and target then
                                local spell = bp.MA[geocolure]

                                if spell then
                                    local targets = T(spell.targets) 

                                    if targets:contains('Party') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, bp.__party.isMember(bp.bubbles.geocolureTarget()), bp.core.priority(geocolure))

                                    elseif targets:contains('Enemy') and bp.__target.isEnemy(target) then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, target, bp.core.priority(geocolure))

                                    elseif targets:contains('Enemy') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, target, bp.core.priority(geocolure))

                                    elseif targets:contains('Self') then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, bp.player, bp.core.priority(geocolure))

                                    end

                                end

                            -- ENTRUST BUFFS.
                            elseif settings.entrust and bp.core.canAct() and target then
                                local member = bp.__party.getMember(bp.bubbles.entrustTarget())

                                if member and entrust then
                                
                                    if bp.core.isReady("Entrust") and bp.core.isReady(entrust) and not bp.core.inQueue("Entrust") and not bp.core.inQueue(entrust) and not bp.core.hasBuff(member.id, 612) then
                                        bp.core.add("Entrust", bp.player, bp.core.priority("Entrust"))
                                        
                                    elseif bp.core.isReady(entrust) and not bp.core.inQueue(entrust) and not bp.core.hasBuff(member.id, 612) and bp.__buffs.active(584) then
                                        bp.core.add(entrust, member, bp.core.priority(entrust))

                                    end

                                end

                            end

                        end

                    end

                end

                if target and bp.core.canCast() then

                    if settings.drain and settings.drain.enabled and bp.core.vitals.hpp < settings.drain.hpp then

                        if bp.core.isReady("Drain II") and not bp.core.inQueue("Drain II") then
                            bp.core.add("Drain II", target, bp.core.priority("Drain II"))

                        elseif bp.core.isReady("Drain") and not bp.core.inQueue("Drain") then
                            bp.core.add("Drain", target, bp.core.priority("Drain"))

                        end

                    end

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

            -- NUKE MODE ENABLED.
            elseif settings.nuke then
                local pet = bp.pet

                if settings.ja and bp.core.canAct() then

                    -- ONE-HOURS.
                    if settings['1hr'] then
                        
                        if bp.core.isReady("Bolster") and settings.geocolure then
                            bp.core.add("Bolster", bp.player, bp.core.priority("Bolster"))
                        end

                    end

                    if pet and not T{2,3}:contains(pet.status) then
                        
                        -- FULL CIRCLE.
                        if settings['full circle'] and settings['full circle'].enabled and bp.core.isReady("Full Circle") and not bp.core.inQueue("Full Circle") and bp.core.distance(pet) > settings['full circle'].distance then
                            bp.core.add("Full Circle", bp.player, bp.core.priority("Full Circle"))
                        end

                        -- ECLIPTIC / LASTING.
                        if settings['ecliptic attrition'] and bp.core.isReady("Ecliptic Attrition") and not bp.core.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp > 85 and not bp.core.buff({513,515,516}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) then
                            bp.core.add("Ecliptic Attrition", bp.player, bp.core.priority("Ecliptic Attrition"))

                        elseif settings['lasting emanation'] and bp.core.isReady("Lasting Emanation") and not bp.core.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp < 85 and not bp.core.buff({513,515,516}) then
                            bp.core.add("Lasting Emanation", bp.player, bp.core.priority("Lasting Emanation"))

                        end

                        -- RADIAL / MENDING.
                        if settings['radial arcana'] and settings['radial arcana'].enabled and bp.core.isReady("Radial Arcana") and not bp.core.searchQueue({"Radial Arcana","Mending Halation"}) and bp.core.vitals.mpp < settings['radial arcana'].mpp and not bp.core.buff({513,515,516,569}) then
                            bp.core.add("Radial Arcana", bp.player, bp.core.priority("Radial Arcana"))

                        elseif settings['mending halation'] and settings['mending halation'].enabled and bp.core.isReady("Mending Halation") and not bp.core.searchQueue({"Radial Arcana","Mending Halation"}) and bp.core.vitals.hpp < settings['mending halation'].hpp and not bp.core.buff({513,515,516,569}) then
                            bp.core.add("Mending Halation", bp.player, bp.core.priority("Mending Halation"))

                        end

                        -- LIFE CYCLE.
                        if settings['life cycle'] and bp.core.isReady("Life Cycle") and not bp.core.inQueue("Life Cycle") and pet.hpp < 55 and bp.core.vitals.hpp > 50 and (bp.core.inQueue("Bolster","Ecliptic Attrition") or bp.core.buff({513,515,516,569})) then
                            bp.core.add("Life Cycle", bp.player, bp.core.priority("Life Cycle"))
                        end

                        -- DEMATERIALIZE.
                        if settings.dematerialize and bp.core.isReady("Dematerialize") and not bp.core.inQueue("Dematerialize") and pet.hpp > 85 and bp.core.buff({513,569}) and (bp.core.inQueue("Bolster","Ecliptic Attrition") or bp.core.buff({513,515,516,569})) then
                            bp.core.add("Dematerialize", bp.player, bp.core.priority("Dematerialize"))
                        end

                    end

                end

                if settings.buffs then
                    local indicolure = bp.bubbles.getIndicolure()
                    local geocolure = bp.bubbles.getGeocolure()
                    local entrust = bp.bubbles.getEntrust()

                    if bp.core.canCast() then

                        if settings.bubbles and settings.bubbles.enabled then

                            -- INDICOLURE BUFFS.
                            if settings.indicolure and bp.core.ready(indicolure) and bp.MA[indicolure] and (not bp.__buffs.active(612) or bp.__bubbles.indiRecast()) then
                                bp.core.add(indicolure, bp.player, bp.core.priority(indicolure))

                            -- GEOCOLURE BUFFS.
                            elseif settings.geocolure and bp.core.isReady(geocolure) and not bp.core.inQueue(geocolure) and (not pet or bp.__bubbles.geoRecast()) and target then
                                local spell = bp.MA[geocolure]

                                if spell then
                                    local targets = T(spell.targets) 

                                    if targets:contains('Party') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, bp.__party.isMember(bp.bubbles.geocolureTarget()), bp.core.priority(geocolure))

                                    elseif targets:contains('Enemy') and bp.__target.isEnemy(target) then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, target, bp.core.priority(geocolure))

                                    elseif targets:contains('Enemy') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, target, bp.core.priority(geocolure))

                                    elseif targets:contains('Self') then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, bp.player, bp.core.priority(geocolure))

                                    end

                                end

                            -- ENTRUST BUFFS.
                            elseif settings.entrust and bp.core.canAct() and target then
                                local member = bp.__party.getMember(bp.bubbles.entrustTarget())

                                if member and entrust then
                                
                                    if bp.core.isReady("Entrust") and bp.core.isReady(entrust) and not bp.core.inQueue("Entrust") and not bp.core.inQueue(entrust) and not bp.core.hasBuff(member.id, 612) then
                                        bp.core.add("Entrust", bp.player, bp.core.priority("Entrust"))
                                        
                                    elseif bp.core.isReady(entrust) and not bp.core.inQueue(entrust) and not bp.core.hasBuff(member.id, 612) and bp.__buffs.active(584) then
                                        bp.core.add(entrust, member, bp.core.priority(entrust))

                                    end

                                end

                            end

                        end

                    end

                end

                if target and bp.core.canCast() then

                    if settings.drain and settings.drain.enabled and bp.core.vitals.hpp < settings.drain.hpp then

                        if bp.core.isReady("Drain II") and not bp.core.inQueue("Drain II") then
                            bp.core.add("Drain II", target, bp.core.priority("Drain II"))

                        elseif bp.core.isReady("Drain") and not bp.core.inQueue("Drain") then
                            bp.core.add("Drain", target, bp.core.priority("Drain"))

                        end

                    end

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

        elseif bp.player.status == 0 then
            local target = bp.core.target()

            -- NOT IN NUKE MODE.
            if not settings.nuke then
                local pet = bp.pet

                if settings.ja and bp.core.canAct() then

                    -- ONE-HOURS.
                    if settings['1hr'] then
                        
                        if bp.core.isReady("Bolster") and settings.geocolure then
                            bp.core.add("Bolster", bp.player, bp.core.priority("Bolster"))
                        end

                    end

                    if pet and not T{2,3}:contains(pet.status) then
                        
                        -- FULL CIRCLE.
                        if settings['full circle'] and settings['full circle'].enabled and bp.core.isReady("Full Circle") and not bp.core.inQueue("Full Circle") and bp.core.distance(pet) > settings['full circle'].distance then
                            bp.core.add("Full Circle", bp.player, bp.core.priority("Full Circle"))
                        end

                        -- ECLIPTIC / LASTING.
                        if settings['ecliptic attrition'] and bp.core.isReady("Ecliptic Attrition") and not bp.core.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp > 85 and not bp.core.buff({513,515,516}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) then
                            bp.core.add("Ecliptic Attrition", bp.player, bp.core.priority("Ecliptic Attrition"))

                        elseif settings['lasting emanation'] and bp.core.isReady("Lasting Emanation") and not bp.core.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp < 85 and not bp.core.buff({513,515,516}) then
                            bp.core.add("Lasting Emanation", bp.player, bp.core.priority("Lasting Emanation"))

                        end

                        -- RADIAL / MENDING.
                        if settings['radial arcana'] and settings['radial arcana'].enabled and bp.core.isReady("Radial Arcana") and not bp.core.searchQueue({"Radial Arcana","Mending Halation"}) and bp.core.vitals.mpp < settings['radial arcana'].mpp and not bp.core.buff({513,515,516,569}) then
                            bp.core.add("Radial Arcana", bp.player, bp.core.priority("Radial Arcana"))

                        elseif settings['mending halation'] and settings['mending halation'].enabled and bp.core.isReady("Mending Halation") and not bp.core.searchQueue({"Radial Arcana","Mending Halation"}) and bp.core.vitals.hpp < settings['mending halation'].hpp and not bp.core.buff({513,515,516,569}) then
                            bp.core.add("Mending Halation", bp.player, bp.core.priority("Mending Halation"))

                        end

                        -- LIFE CYCLE.
                        if settings['life cycle'] and bp.core.isReady("Life Cycle") and not bp.core.inQueue("Life Cycle") and pet.hpp < 55 and bp.core.vitals.hpp > 50 and (bp.core.inQueue("Bolster","Ecliptic Attrition") or bp.core.buff({513,515,516,569})) then
                            bp.core.add("Life Cycle", bp.player, bp.core.priority("Life Cycle"))
                        end

                        -- DEMATERIALIZE.
                        if settings.dematerialize and bp.core.isReady("Dematerialize") and not bp.core.inQueue("Dematerialize") and pet.hpp > 85 and bp.core.buff({513,569}) and (bp.core.inQueue("Bolster","Ecliptic Attrition") or bp.core.buff({513,515,516,569})) then
                            bp.core.add("Dematerialize", bp.player, bp.core.priority("Dematerialize"))
                        end

                    end

                end

                if settings.buffs then
                    local indicolure = bp.bubbles.getIndicolure()
                    local geocolure = bp.bubbles.getGeocolure()
                    local entrust = bp.bubbles.getEntrust()

                    if bp.core.canCast() then

                        if settings.bubbles and settings.bubbles.enabled then

                            -- INDICOLURE BUFFS.
                            if settings.indicolure and bp.core.ready(indicolure) and bp.MA[indicolure] and (not bp.__buffs.active(612) or bp.__bubbles.indiRecast()) then
                                bp.core.add(indicolure, bp.player, bp.core.priority(indicolure))

                            -- GEOCOLURE BUFFS.
                            elseif settings.geocolure and bp.core.isReady(geocolure) and not bp.core.inQueue(geocolure) and (not pet or bp.__bubbles.geoRecast()) and target then
                                local spell = bp.MA[geocolure]

                                if spell then
                                    local targets = T(spell.targets)

                                    if targets:contains('Party') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, bp.__party.isMember(bp.bubbles.geocolureTarget()), bp.core.priority(geocolure))

                                    elseif targets:contains('Enemy') and bp.__target.isEnemy(target) then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, target, bp.core.priority(geocolure))

                                    elseif targets:contains('Enemy') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, target, bp.core.priority(geocolure))

                                    elseif targets:contains('Self') then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, bp.player, bp.core.priority(geocolure))

                                    end

                                end

                            -- ENTRUST BUFFS.
                            elseif settings.entrust and bp.core.canAct() and target then
                                local member = bp.__party.getMember(bp.bubbles.entrustTarget())

                                if member and entrust then
                                
                                    if bp.core.isReady("Entrust") and bp.core.isReady(entrust) and not bp.core.inQueue("Entrust") and not bp.core.inQueue(entrust) and not bp.core.hasBuff(member.id, 612) then
                                        bp.core.add("Entrust", bp.player, bp.core.priority("Entrust"))
                                        
                                    elseif bp.core.isReady(entrust) and not bp.core.inQueue(entrust) and not bp.core.hasBuff(member.id, 612) and bp.__buffs.active(584) then
                                        bp.core.add(entrust, member, bp.core.priority(entrust))

                                    end

                                end

                            end

                        end

                    end

                end

                if target and bp.core.canCast() then

                    if settings.drain and settings.drain.enabled and bp.core.vitals.hpp < settings.drain.hpp then

                        if bp.core.isReady("Drain II") and not bp.core.inQueue("Drain II") then
                            bp.core.add("Drain II", target, bp.core.priority("Drain II"))

                        elseif bp.core.isReady("Drain") and not bp.core.inQueue("Drain") then
                            bp.core.add("Drain", target, bp.core.priority("Drain"))

                        end

                    end

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

            -- NUKE MODE ENABLED.
            elseif settings.nuke then
                local pet = bp.pet

                if settings.ja and bp.core.canAct() then

                    -- ONE-HOURS.
                    if settings['1hr'] then
                        
                        if bp.core.isReady("Bolster") and settings.geocolure then
                            bp.core.add("Bolster", bp.player, bp.core.priority("Bolster"))
                        end

                    end

                    if pet and not T{2,3}:contains(pet.status) then
                        
                        -- FULL CIRCLE.
                        if settings['full circle'] and settings['full circle'].enabled and bp.core.isReady("Full Circle") and not bp.core.inQueue("Full Circle") and bp.core.distance(pet) > settings['full circle'].distance then
                            bp.core.add("Full Circle", bp.player, bp.core.priority("Full Circle"))
                        end

                        -- ECLIPTIC / LASTING.
                        if settings['ecliptic attrition'] and bp.core.isReady("Ecliptic Attrition") and not bp.core.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp > 85 and not bp.core.buff({513,515,516}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) then
                            bp.core.add("Ecliptic Attrition", bp.player, bp.core.priority("Ecliptic Attrition"))

                        elseif settings['lasting emanation'] and bp.core.isReady("Lasting Emanation") and not bp.core.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp < 85 and not bp.core.buff({513,515,516}) then
                            bp.core.add("Lasting Emanation", bp.player, bp.core.priority("Lasting Emanation"))

                        end

                        -- RADIAL / MENDING.
                        if settings['radial arcana'] and settings['radial arcana'].enabled and bp.core.isReady("Radial Arcana") and not bp.core.searchQueue({"Radial Arcana","Mending Halation"}) and bp.core.vitals.mpp < settings['radial arcana'].mpp and not bp.core.buff({513,515,516,569}) then
                            bp.core.add("Radial Arcana", bp.player, bp.core.priority("Radial Arcana"))

                        elseif settings['mending halation'] and settings['mending halation'].enabled and bp.core.isReady("Mending Halation") and not bp.core.searchQueue({"Radial Arcana","Mending Halation"}) and bp.core.vitals.hpp < settings['mending halation'].hpp and not bp.core.buff({513,515,516,569}) then
                            bp.core.add("Mending Halation", bp.player, bp.core.priority("Mending Halation"))

                        end

                        -- LIFE CYCLE.
                        if settings['life cycle'] and bp.core.isReady("Life Cycle") and not bp.core.inQueue("Life Cycle") and pet.hpp < 55 and bp.core.vitals.hpp > 50 and (bp.core.inQueue("Bolster","Ecliptic Attrition") or bp.core.buff({513,515,516,569})) then
                            bp.core.add("Life Cycle", bp.player, bp.core.priority("Life Cycle"))
                        end

                        -- DEMATERIALIZE.
                        if settings.dematerialize and bp.core.isReady("Dematerialize") and not bp.core.inQueue("Dematerialize") and pet.hpp > 85 and bp.core.buff({513,569}) and (bp.core.inQueue("Bolster","Ecliptic Attrition") or bp.core.buff({513,515,516,569})) then
                            bp.core.add("Dematerialize", bp.player, bp.core.priority("Dematerialize"))
                        end

                    end

                end

                if settings.buffs then
                    local indicolure = bp.bubbles.getIndicolure()
                    local geocolure = bp.bubbles.getGeocolure()
                    local entrust = bp.bubbles.getEntrust()

                    if bp.core.canCast() then

                        if settings.bubbles and settings.bubbles.enabled then

                            -- INDICOLURE BUFFS.
                            if settings.indicolure and bp.core.isReady(indicolure) and not bp.core.inQueue(indicolure) and bp.MA[indicolure] and (not bp.__buffs.active(612) or bp.__bubbles.indiRecast()) then
                                bp.core.add(indicolure, bp.player, bp.core.priority(indicolure))

                            -- GEOCOLURE BUFFS.
                            elseif settings.geocolure and bp.core.isReady(geocolure) and not bp.core.inQueue(geocolure) and (not pet or bp.__bubbles.geoRecast()) and target then
                                local spell = bp.MA[geocolure]

                                if spell then
                                    local targets = T(spell.targets) 

                                    if targets:contains('Party') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, bp.__party.isMember(bp.bubbles.geocolureTarget()), bp.core.priority(geocolure))

                                    elseif targets:contains('Enemy') and bp.__target.isEnemy(target) then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, target, bp.core.priority(geocolure))

                                    elseif targets:contains('Enemy') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, target, bp.core.priority(geocolure))

                                    elseif targets:contains('Self') then

                                        if not pet and settings.ja and settings['blaze of glory'] and bp.core.isReady("Blaze of Glory") and not bp.core.searchQueue({"Bolster","Blaze of Glory"}) and not bp.core.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not bp.core.isReady("Bolster")) and bp.core.canAct() then
                                            bp.core.add("Blaze of Glory", bp.player, bp.core.priority("Blaze of Glory"))
                                        end
                                        bp.core.add(geocolure, bp.player, bp.core.priority(geocolure))

                                    end

                                end

                            -- ENTRUST BUFFS.
                            elseif settings.entrust and bp.core.canAct() and target then
                                local member = bp.__party.getMember(bp.bubbles.entrustTarget())

                                if member and entrust then
                                
                                    if bp.core.isReady("Entrust") and bp.core.isReady(entrust) and not bp.core.inQueue("Entrust") and not bp.core.inQueue(entrust) and not bp.core.hasBuff(member.id, 612) then
                                        bp.core.add("Entrust", bp.player, bp.core.priority("Entrust"))
                                        
                                    elseif bp.core.isReady(entrust) and not bp.core.inQueue(entrust) and not bp.core.hasBuff(member.id, 612) and bp.__buffs.active(584) then
                                        bp.core.add(entrust, member, bp.core.priority(entrust))

                                    end

                                end

                            end

                        end

                    end

                end

                if target and bp.core.canCast() then

                    if settings.drain and settings.drain.enabled and bp.core.vitals.hpp < settings.drain.hpp then

                        if bp.core.isReady("Drain II") and not bp.core.inQueue("Drain II") then
                            bp.core.add("Drain II", target, bp.core.priority("Drain II"))

                        elseif bp.core.isReady("Drain") and not bp.core.inQueue("Drain") then
                            bp.core.add("Drain", target, bp.core.priority("Drain"))

                        end

                    end

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

        end

        return self

    end
    
    return self

end
return job