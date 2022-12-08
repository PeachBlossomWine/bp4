local job = {}
function job:init(bp, settings)

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return
    end

    -- Private Variables.
    local __events    = {}
    local __nukes     = T{}
    local __sublogic  = bp.libs.__core.getSubjob(bp.player.sub_job)

    -- Public Variables.
    self.__flags     = {}
    self.__timers    = {}

    -- Public Methods.
    self.unloadEvents = function()

        for _,id in pairs(__events) do
            windower.unregister_event(id)
        end

    end

    function self:useItems()

        if settings.food and settings.skillup and not settings.skillup.enabled and self.canItem() then

        elseif self.canItem() then

            if bp.player.status == 1 then

            elseif bp.player.status == 0 then

            end

        end

    end

    function self:castNukes(target)

        if target and not settings.mb then

            for spell in __nukes:it() do

                if self.canCast() and self.isReady(spell) and not self.inQueue(spell) then

                    if settings['theurgic focus'] and self.isReady("Theurgic Focus") and not self.inQueue("Theurgic Focus") then
                        self.add("Theurgic Focus", bp.player, self.priority("Theurgic Focus"))

                    end
                    self.add(spell, target, self.priority(spell))

                end

            end

        end

    end

    function self:automate()
        local target = self.target()

        self:useItems()
        if self and bp.player.status == 1 then
            local target = self.target() or windower.ffxi.get_mob_by_target('t') or false

            -- NOT IN NUKE MODE.
            if not settings.nuke then
                local pet = bp.pet

                if target and settings.hate then
                    __sublogic.hate(bp, settings, self)
                end

                if settings.ja and self.canAct() then

                    -- ONE-HOURS.
                    if settings['1hr'] then
                        
                        if self.isReady("Bolster") and settings.geocolure then
                            self.add("Bolster", bp.player, self.priority("Bolster"))
                        end

                    end

                    if pet and not T{2,3}:contains(pet.status) then
                        
                        -- FULL CIRCLE.
                        if settings['full circle'] and settings['full circle'].enabled and self.isReady("Full Circle") and not self.inQueue("Full Circle") and self.distance(pet) > settings['full circle'].distance then
                            self.add("Full Circle", bp.player, self.priority("Full Circle"))
                        end

                        -- ECLIPTIC / LASTING.
                        if settings['ecliptic attrition'] and self.isReady("Ecliptic Attrition") and not self.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp > 85 and not self.buff({513,515,516}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) then
                            self.add("Ecliptic Attrition", bp.player, self.priority("Ecliptic Attrition"))

                        elseif settings['lasting emanation'] and self.isReady("Lasting Emanation") and not self.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp < 85 and not self.buff({513,515,516}) then
                            self.add("Lasting Emanation", bp.player, self.priority("Lasting Emanation"))

                        end

                        -- RADIAL / MENDING.
                        if settings['radial arcana'] and settings['radial arcana'].enabled and self.isReady("Radial Arcana") and not self.searchQueue({"Radial Arcana","Mending Halation"}) and self.vitals.mpp < settings['radial arcana'].mpp and not self.buff({513,515,516,569}) then
                            self.add("Radial Arcana", bp.player, self.priority("Radial Arcana"))

                        elseif settings['mending halation'] and settings['mending halation'].enabled and self.isReady("Mending Halation") and not self.searchQueue({"Radial Arcana","Mending Halation"}) and self.vitals.hpp < settings['mending halation'].hpp and not self.buff({513,515,516,569}) then
                            self.add("Mending Halation", bp.player, self.priority("Mending Halation"))

                        end

                        -- LIFE CYCLE.
                        if settings['life cycle'] and self.isReady("Life Cycle") and not self.inQueue("Life Cycle") and pet.hpp < 55 and self.vitals.hpp > 50 and (self.inQueue("Bolster","Ecliptic Attrition") or self.buff({513,515,516,569})) then
                            self.add("Life Cycle", bp.player, self.priority("Life Cycle"))
                        end

                        -- DEMATERIALIZE.
                        if settings.dematerialize and self.isReady("Dematerialize") and not self.inQueue("Dematerialize") and pet.hpp > 85 and self.buff({513,569}) and (self.inQueue("Bolster","Ecliptic Attrition") or self.buff({513,515,516,569})) then
                            self.add("Dematerialize", bp.player, self.priority("Dematerialize"))
                        end

                    end
                    __sublogic.ja(bp, settings, self)

                end

                if settings.buffs then
                    local indicolure = bp.bubbles.getIndicolure()
                    local geocolure = bp.bubbles.getGeocolure()
                    local entrust = bp.bubbles.getEntrust()

                    if self.canCast() then

                        -- INDICOLURE BUFFS.
                        if settings.indicolure and self.isReady(indicolure) and not self.inQueue(indicolure) and bp.MA[indicolure] and (not bp.__buffs.active(612) or bp.bubbles.indiRecast()) then
                            self.add(indicolure, bp.player, self.priority(indicolure))

                        -- GEOCOLURE BUFFS.
                        elseif settings.geocolure and self.isReady(geocolure) and not self.inQueue(geocolure) and (not pet or bp.bubbles.geoRecast()) and target then
                            local spell = bp.MA[geocolure]

                            if spell then
                                local targets = T(spell.targets) 

                                if targets:contains('Party') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, bp.__party.isMember(bp.bubbles.geocolureTarget()), self.priority(geocolure))

                                elseif targets:contains('Enemy') and bp.__target.isEnemy(target) then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, target, self.priority(geocolure))

                                elseif targets:contains('Enemy') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, target, self.priority(geocolure))

                                elseif targets:contains('Self') then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, bp.player, self.priority(geocolure))

                                end

                            end

                        -- ENTRUST BUFFS.
                        elseif settings.entrust and self.isReady("Entrust") and self.isReady(entrust) and not self.inQueue("Entrust") and not self.inQueue(entrust) and self.canAct() and target then
                            local member = bp.__party.isMember(bp.bubbles.entrustTarget())

                            if spell and member and not self.hasBuff(612, member.id) then
                                self.add("Entrust", bp.player, self.priority("Entrust"))
                                self.add(entrust, member, self.priority(entrust))

                            end

                        end

                    end
                    __sublogic.buffs(bp, settings, self)
                    bp.buffs.cast()

                end

                if settings.debuffs and self.canCast() then
                    __sublogic.debuffs(bp, settings, self)

                end

                if target and self.canCast() then

                    if settings.drain and settings.drain.enabled and self.vitals.hpp < settings.drain.hpp then

                        if self.isReady("Drain II") and not self.inQueue("Drain II") then
                            self.add("Drain II", target, self.priority("Drain II"))

                        elseif self.isReady("Drain") and not self.inQueue("Drain") then
                            self.add("Drain", target, self.priority("Drain"))

                        end

                    end

                    if settings.aspir and settings.aspir.enabled and self.vitals.mpp < settings.aspir.mpp then

                        if self.isReady("Aspir III") and not self.inQueue("Aspir III") then
                            self.add("Aspir III", target, self.priority("Aspir III"))

                        elseif self.isReady("Aspir II") and not self.inQueue("Aspir II") then
                            self.add("Aspir II", target, self.priority("Aspir II"))

                        elseif self.isReady("Aspir") and not self.inQueue("Aspir") then
                            self.add("Aspir", target, self.priority("Aspir"))

                        end

                    end

                end

            -- NUKE MODE ENABLED.
            elseif settings.nuke then
                local pet = bp.pet

                if target and settings.hate then
                    __sublogic.hate(bp, settings, self)
                end

                if settings.ja and self.canAct() then

                    -- ONE-HOURS.
                    if settings['1hr'] then
                        
                        if self.isReady("Bolster") and settings.geocolure then
                            self.add("Bolster", bp.player, self.priority("Bolster"))
                        end

                    end

                    if pet and not T{2,3}:contains(pet.status) then
                        
                        -- FULL CIRCLE.
                        if settings['full circle'] and settings['full circle'].enabled and self.isReady("Full Circle") and not self.inQueue("Full Circle") and self.distance(pet) > settings['full circle'].distance then
                            self.add("Full Circle", bp.player, self.priority("Full Circle"))
                        end

                        -- ECLIPTIC / LASTING.
                        if settings['ecliptic attrition'] and self.isReady("Ecliptic Attrition") and not self.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp > 85 and not self.buff({513,515,516}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) then
                            self.add("Ecliptic Attrition", bp.player, self.priority("Ecliptic Attrition"))

                        elseif settings['lasting emanation'] and self.isReady("Lasting Emanation") and not self.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp < 85 and not self.buff({513,515,516}) then
                            self.add("Lasting Emanation", bp.player, self.priority("Lasting Emanation"))

                        end

                        -- RADIAL / MENDING.
                        if settings['radial arcana'] and settings['radial arcana'].enabled and self.isReady("Radial Arcana") and not self.searchQueue({"Radial Arcana","Mending Halation"}) and self.vitals.mpp < settings['radial arcana'].mpp and not self.buff({513,515,516,569}) then
                            self.add("Radial Arcana", bp.player, self.priority("Radial Arcana"))

                        elseif settings['mending halation'] and settings['mending halation'].enabled and self.isReady("Mending Halation") and not self.searchQueue({"Radial Arcana","Mending Halation"}) and self.vitals.hpp < settings['mending halation'].hpp and not self.buff({513,515,516,569}) then
                            self.add("Mending Halation", bp.player, self.priority("Mending Halation"))

                        end

                        -- LIFE CYCLE.
                        if settings['life cycle'] and self.isReady("Life Cycle") and not self.inQueue("Life Cycle") and pet.hpp < 55 and self.vitals.hpp > 50 and (self.inQueue("Bolster","Ecliptic Attrition") or self.buff({513,515,516,569})) then
                            self.add("Life Cycle", bp.player, self.priority("Life Cycle"))
                        end

                        -- DEMATERIALIZE.
                        if settings.dematerialize and self.isReady("Dematerialize") and not self.inQueue("Dematerialize") and pet.hpp > 85 and self.buff({513,569}) and (self.inQueue("Bolster","Ecliptic Attrition") or self.buff({513,515,516,569})) then
                            self.add("Dematerialize", bp.player, self.priority("Dematerialize"))
                        end

                    end
                    __sublogic.ja(bp, settings, self)

                end

                if settings.buffs then
                    local indicolure = bp.bubbles.getIndicolure()
                    local geocolure = bp.bubbles.getGeocolure()
                    local entrust = bp.bubbles.getEntrust()

                    if self.canCast() then

                        -- INDICOLURE BUFFS.
                        if settings.indicolure and self.isReady(indicolure) and not self.inQueue(indicolure) and bp.MA[indicolure] and (not bp.__buffs.active(612) or bp.bubbles.indiRecast()) then
                            self.add(indicolure, bp.player, self.priority(indicolure))

                        -- GEOCOLURE BUFFS.
                        elseif settings.geocolure and self.isReady(geocolure) and not self.inQueue(geocolure) and (not pet or bp.bubbles.geoRecast()) and target then
                            local spell = bp.MA[geocolure]

                            if spell then
                                local targets = T(spell.targets) 

                                if targets:contains('Party') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, bp.__party.isMember(bp.bubbles.geocolureTarget()), self.priority(geocolure))

                                elseif targets:contains('Enemy') and bp.__target.isEnemy(target) then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, target, self.priority(geocolure))

                                elseif targets:contains('Enemy') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, target, self.priority(geocolure))

                                elseif targets:contains('Self') then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, bp.player, self.priority(geocolure))

                                end

                            end

                        -- ENTRUST BUFFS.
                        elseif settings.entrust and self.isReady("Entrust") and self.isReady(entrust) and not self.inQueue("Entrust") and not self.inQueue(entrust) and self.canAct() and target then
                            local member = bp.__party.isMember(bp.bubbles.entrustTarget())

                            if spell and member and not self.hasBuff(612, member.id) then
                                self.add("Entrust", bp.player, self.priority("Entrust"))
                                self.add(entrust, member, self.priority(entrust))

                            end

                        end

                    end
                    __sublogic.buffs(bp, settings, self)
                    bp.buffs.cast()

                end

                if settings.debuffs and self.canCast() then
                    __sublogic.debuffs(bp, settings, self)
                    
                end

                if target and self.canCast() then

                    if settings.drain and settings.drain.enabled and self.vitals.hpp < settings.drain.hpp then

                        if self.isReady("Drain II") and not self.inQueue("Drain II") then
                            self.add("Drain II", target, self.priority("Drain II"))

                        elseif self.isReady("Drain") and not self.inQueue("Drain") then
                            self.add("Drain", target, self.priority("Drain"))

                        end

                    end

                    if settings.aspir and settings.aspir.enabled and self.vitals.mpp < settings.aspir.mpp then

                        if self.isReady("Aspir III") and not self.inQueue("Aspir III") then
                            self.add("Aspir III", target, self.priority("Aspir III"))

                        elseif self.isReady("Aspir II") and not self.inQueue("Aspir II") then
                            self.add("Aspir II", target, self.priority("Aspir II"))

                        elseif self.isReady("Aspir") and not self.inQueue("Aspir") then
                            self.add("Aspir", target, self.priority("Aspir"))

                        end

                    end

                end
                self:castNukes(target)

            end

        elseif self and bp.player.status == 0 then
            local target = self.target()

            -- NOT IN NUKE MODE.
            if not settings.nuke then
                local pet = bp.pet

                if target and settings.hate then
                    __sublogic.hate(bp, settings, self)
                end

                if settings.ja and self.canAct() then

                    -- ONE-HOURS.
                    if settings['1hr'] then
                        
                        if self.isReady("Bolster") and settings.geocolure then
                            self.add("Bolster", bp.player, self.priority("Bolster"))
                        end

                    end

                    if pet and not T{2,3}:contains(pet.status) then
                        
                        -- FULL CIRCLE.
                        if settings['full circle'] and settings['full circle'].enabled and self.isReady("Full Circle") and not self.inQueue("Full Circle") and self.distance(pet) > settings['full circle'].distance then
                            self.add("Full Circle", bp.player, self.priority("Full Circle"))
                        end

                        -- ECLIPTIC / LASTING.
                        if settings['ecliptic attrition'] and self.isReady("Ecliptic Attrition") and not self.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp > 85 and not self.buff({513,515,516}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) then
                            self.add("Ecliptic Attrition", bp.player, self.priority("Ecliptic Attrition"))

                        elseif settings['lasting emanation'] and self.isReady("Lasting Emanation") and not self.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp < 85 and not self.buff({513,515,516}) then
                            self.add("Lasting Emanation", bp.player, self.priority("Lasting Emanation"))

                        end

                        -- RADIAL / MENDING.
                        if settings['radial arcana'] and settings['radial arcana'].enabled and self.isReady("Radial Arcana") and not self.searchQueue({"Radial Arcana","Mending Halation"}) and self.vitals.mpp < settings['radial arcana'].mpp and not self.buff({513,515,516,569}) then
                            self.add("Radial Arcana", bp.player, self.priority("Radial Arcana"))

                        elseif settings['mending halation'] and settings['mending halation'].enabled and self.isReady("Mending Halation") and not self.searchQueue({"Radial Arcana","Mending Halation"}) and self.vitals.hpp < settings['mending halation'].hpp and not self.buff({513,515,516,569}) then
                            self.add("Mending Halation", bp.player, self.priority("Mending Halation"))

                        end

                        -- LIFE CYCLE.
                        if settings['life cycle'] and self.isReady("Life Cycle") and not self.inQueue("Life Cycle") and pet.hpp < 55 and self.vitals.hpp > 50 and (self.inQueue("Bolster","Ecliptic Attrition") or self.buff({513,515,516,569})) then
                            self.add("Life Cycle", bp.player, self.priority("Life Cycle"))
                        end

                        -- DEMATERIALIZE.
                        if settings.dematerialize and self.isReady("Dematerialize") and not self.inQueue("Dematerialize") and pet.hpp > 85 and self.buff({513,569}) and (self.inQueue("Bolster","Ecliptic Attrition") or self.buff({513,515,516,569})) then
                            self.add("Dematerialize", bp.player, self.priority("Dematerialize"))
                        end

                    end
                    __sublogic.ja(bp, settings, self)

                end

                if settings.buffs then
                    local indicolure = bp.bubbles.getIndicolure()
                    local geocolure = bp.bubbles.getGeocolure()
                    local entrust = bp.bubbles.getEntrust()

                    if self.canCast() then

                        -- INDICOLURE BUFFS.
                        if settings.indicolure and self.isReady(indicolure) and not self.inQueue(indicolure) and bp.MA[indicolure] and (not bp.__buffs.active(612) or bp.bubbles.indiRecast()) then
                            self.add(indicolure, bp.player, self.priority(indicolure))

                        -- GEOCOLURE BUFFS.
                        elseif settings.geocolure and self.isReady(geocolure) and not self.inQueue(geocolure) and (not pet or bp.bubbles.geoRecast()) and target then
                            local spell = bp.MA[geocolure]

                            if spell then
                                local targets = T(spell.targets) 

                                if targets:contains('Party') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, bp.__party.isMember(bp.bubbles.geocolureTarget()), self.priority(geocolure))

                                elseif targets:contains('Enemy') and bp.__target.isEnemy(target) then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, target, self.priority(geocolure))

                                elseif targets:contains('Enemy') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, target, self.priority(geocolure))

                                elseif targets:contains('Self') then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, bp.player, self.priority(geocolure))

                                end

                            end

                        -- ENTRUST BUFFS.
                        elseif settings.entrust and self.isReady("Entrust") and self.isReady(entrust) and not self.inQueue("Entrust") and not self.inQueue(entrust) and self.canAct() and target then
                            local member = bp.__party.isMember(bp.bubbles.entrustTarget())

                            if spell and member and not self.hasBuff(612, member.id) then
                                self.add("Entrust", bp.player, self.priority("Entrust"))
                                self.add(entrust, member, self.priority(entrust))

                            end

                        end

                    end
                    __sublogic.buffs(bp, settings, self)
                    bp.buffs.cast()

                end

                if settings.debuffs and self.canCast() then
                    __sublogic.debuffs(bp, settings, self)

                end

                if target and self.canCast() then

                    if settings.drain and settings.drain.enabled and self.vitals.hpp < settings.drain.hpp then

                        if self.isReady("Drain II") and not self.inQueue("Drain II") then
                            self.add("Drain II", target, self.priority("Drain II"))

                        elseif self.isReady("Drain") and not self.inQueue("Drain") then
                            self.add("Drain", target, self.priority("Drain"))

                        end

                    end

                    if settings.aspir and settings.aspir.enabled and self.vitals.mpp < settings.aspir.mpp then

                        if self.isReady("Aspir III") and not self.inQueue("Aspir III") then
                            self.add("Aspir III", target, self.priority("Aspir III"))

                        elseif self.isReady("Aspir II") and not self.inQueue("Aspir II") then
                            self.add("Aspir II", target, self.priority("Aspir II"))

                        elseif self.isReady("Aspir") and not self.inQueue("Aspir") then
                            self.add("Aspir", target, self.priority("Aspir"))

                        end

                    end

                end

            -- NUKE MODE ENABLED.
            elseif settings.nuke then
                local pet = bp.pet

                if target and settings.hate then
                    __sublogic.hate(bp, settings, self)
                end

                if settings.ja and self.canAct() then

                    -- ONE-HOURS.
                    if settings['1hr'] then
                        
                        if self.isReady("Bolster") and settings.geocolure then
                            self.add("Bolster", bp.player, self.priority("Bolster"))
                        end

                    end

                    if pet and not T{2,3}:contains(pet.status) then
                        
                        -- FULL CIRCLE.
                        if settings['full circle'] and settings['full circle'].enabled and self.isReady("Full Circle") and not self.inQueue("Full Circle") and self.distance(pet) > settings['full circle'].distance then
                            self.add("Full Circle", bp.player, self.priority("Full Circle"))
                        end

                        -- ECLIPTIC / LASTING.
                        if settings['ecliptic attrition'] and self.isReady("Ecliptic Attrition") and not self.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp > 85 and not self.buff({513,515,516}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) then
                            self.add("Ecliptic Attrition", bp.player, self.priority("Ecliptic Attrition"))

                        elseif settings['lasting emanation'] and self.isReady("Lasting Emanation") and not self.searchQueue({"Ecliptic Attrition","Lasting Emanation"}) and pet.hpp < 85 and not self.buff({513,515,516}) then
                            self.add("Lasting Emanation", bp.player, self.priority("Lasting Emanation"))

                        end

                        -- RADIAL / MENDING.
                        if settings['radial arcana'] and settings['radial arcana'].enabled and self.isReady("Radial Arcana") and not self.searchQueue({"Radial Arcana","Mending Halation"}) and self.vitals.mpp < settings['radial arcana'].mpp and not self.buff({513,515,516,569}) then
                            self.add("Radial Arcana", bp.player, self.priority("Radial Arcana"))

                        elseif settings['mending halation'] and settings['mending halation'].enabled and self.isReady("Mending Halation") and not self.searchQueue({"Radial Arcana","Mending Halation"}) and self.vitals.hpp < settings['mending halation'].hpp and not self.buff({513,515,516,569}) then
                            self.add("Mending Halation", bp.player, self.priority("Mending Halation"))

                        end

                        -- LIFE CYCLE.
                        if settings['life cycle'] and self.isReady("Life Cycle") and not self.inQueue("Life Cycle") and pet.hpp < 55 and self.vitals.hpp > 50 and (self.inQueue("Bolster","Ecliptic Attrition") or self.buff({513,515,516,569})) then
                            self.add("Life Cycle", bp.player, self.priority("Life Cycle"))
                        end

                        -- DEMATERIALIZE.
                        if settings.dematerialize and self.isReady("Dematerialize") and not self.inQueue("Dematerialize") and pet.hpp > 85 and self.buff({513,569}) and (self.inQueue("Bolster","Ecliptic Attrition") or self.buff({513,515,516,569})) then
                            self.add("Dematerialize", bp.player, self.priority("Dematerialize"))
                        end

                    end
                    __sublogic.ja(bp, settings, self)

                end

                if settings.buffs then
                    local indicolure = bp.bubbles.getIndicolure()
                    local geocolure = bp.bubbles.getGeocolure()
                    local entrust = bp.bubbles.getEntrust()

                    if self.canCast() then

                        -- INDICOLURE BUFFS.
                        if settings.indicolure and self.isReady(indicolure) and not self.inQueue(indicolure) and bp.MA[indicolure] and (not bp.__buffs.active(612) or bp.bubbles.indiRecast()) then
                            self.add(indicolure, bp.player, self.priority(indicolure))

                        -- GEOCOLURE BUFFS.
                        elseif settings.geocolure and self.isReady(geocolure) and not self.inQueue(geocolure) and (not pet or bp.bubbles.geoRecast()) and target then
                            local spell = bp.MA[geocolure]

                            if spell then
                                local targets = T(spell.targets) 

                                if targets:contains('Party') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, bp.__party.isMember(bp.bubbles.geocolureTarget()), self.priority(geocolure))

                                elseif targets:contains('Enemy') and bp.__target.isEnemy(target) then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, target, self.priority(geocolure))

                                elseif targets:contains('Enemy') and bp.__party.isMember(bp.bubbles.geocolureTarget()) then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, target, self.priority(geocolure))

                                elseif targets:contains('Self') then

                                    if not pet and settings.ja and settings['blaze of glory'] and self.isReady("Blaze of Glory") and not self.searchQueue({"Bolster","Blaze of Glory"}) and not self.buff({513,569}) and (not settings['1hr'] or settings['1hr'] and not self.isReady("Bolster")) and self.canAct() then
                                        self.add("Blaze of Glory", bp.player, self.priority("Blaze of Glory"))
                                    end
                                    self.add(geocolure, bp.player, self.priority(geocolure))

                                end

                            end

                        -- ENTRUST BUFFS.
                        elseif settings.entrust and self.isReady("Entrust") and self.isReady(entrust) and not self.inQueue("Entrust") and not self.inQueue(entrust) and self.canAct() and target then
                            local member = bp.__party.isMember(bp.bubbles.entrustTarget())

                            if spell and member and not self.hasBuff(612, member.id) then
                                self.add("Entrust", bp.player, self.priority("Entrust"))
                                self.add(entrust, member, self.priority(entrust))

                            end

                        end

                    end
                    __sublogic.buffs(bp, settings, self)
                    bp.buffs.cast()

                end

                if settings.debuffs and self.canCast() then
                    __sublogic.debuffs(bp, settings, self)
                    
                end

                if target and self.canCast() then

                    if settings.drain and settings.drain.enabled and self.vitals.hpp < settings.drain.hpp then

                        if self.isReady("Drain II") and not self.inQueue("Drain II") then
                            self.add("Drain II", target, self.priority("Drain II"))

                        elseif self.isReady("Drain") and not self.inQueue("Drain") then
                            self.add("Drain", target, self.priority("Drain"))

                        end

                    end

                    if settings.aspir and settings.aspir.enabled and self.vitals.mpp < settings.aspir.mpp then

                        if self.isReady("Aspir III") and not self.inQueue("Aspir III") then
                            self.add("Aspir III", target, self.priority("Aspir III"))

                        elseif self.isReady("Aspir II") and not self.inQueue("Aspir II") then
                            self.add("Aspir II", target, self.priority("Aspir II"))

                        elseif self.isReady("Aspir") and not self.inQueue("Aspir") then
                            self.add("Aspir", target, self.priority("Aspir"))

                        end

                    end

                end
                self:castNukes(target)

            end

        end

    end

    -- Private Events.
    __events.jobchange = windower.register_event('job change', self.unloadEvents)
    __events.commands = windower.register_event('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)
        
        if bp and command and command:lower() == 'core' and #commands > 0 then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if ("nukes"):startswith(command) then
                local option = commands[1] and table.remove(commands, 1):lower() or false

                if option == '+' and #commands > 0 then
                    bp.core.addNuke(__nukes, commands)

                elseif option == '-' and #commands > 0 then
                    bp.core.deleteNuke(__nukes, commands)

                elseif option == 'clear' then
                    bp.core.clearNukes(__nukes)

                end

            end

        end

    end)
    
    return self

end
return job