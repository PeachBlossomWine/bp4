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
    self.__timers   = {hate=0}
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

        self:useItems()
        if bp.player.status == 1 then
            local target = bp.core.target() or windower.ffxi.get_mob_by_target('t') or false

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target then

                -- PROVOKE.
                if settings.provoke and bp.core.ready("Provoke") then
                    bp.core.add("Provoke", target, bp.core.priority("Provoke"))
                    self.__timers.hate = os.clock()

                end

            end

            -- JOB ABILITIES.
            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] then

                    if settings["mighty strikes"] and bp.core.ready("Mighty Strikes", 44) and target then
                        bp.core.add("Mighty Strikes", bp.player, bp.core.priority("Mighty Strikes"))
                    end
                    
                    if settings["brazen rush"] and bp.core.ready("Brazen Rush", 490) and target then
                        bp.core.add("Brazen Rush", bp.player, bp.core.priority("Brazen Rush"))
                    end

                end

                -- TOMAHAWK.
                if settings.tomahawk and bp.core.ready("Tomahawk") and bp.__inventory.canEquip("Throwing Tomahawk") and target then
                    bp.core.add("Tomahawk", target, bp.core.priority("Tomahawk"))
                end

            end

            -- BUFFS.
            if settings.buffs then

                if bp.core.canAct() then

                    -- WARRIOR'S CHARGE.
                    if settings["warrior's charge"] and bp.core.ready("Warrior's Charge", 340) and bp.core.vitals.tp >= settings.ws.tp then
                        bp.core.add("Warrior's Charge", bp.player, bp.core.priority("Warrior's Charge"))
                    end

                    -- BERSERK.
                    if settings.berserk and not settings.tank and bp.core.ready("Berserk", 56) then
                        bp.core.add("Berserk", bp.player, bp.core.priority("Berserk"))

                        if bp.core.buff(57) then
                            bp.__buffs.cancel(57)
                        end

                    -- DEFENDER.
                    elseif settings.defender and settings.tank and bp.core.ready("Defender", 57) then
                        bp.core.add("Defender", bp.player, bp.core.priority("Defender"))

                        if bp.core.buff(56) then
                            bp.__buffs.cancel(56)
                        end

                    -- AGGRESSOR.
                    elseif settings.aggressor and bp.core.ready("Aggressor", 58) then
                        bp.core.add("Aggressor", bp.player, bp.core.priority("Aggressor"))

                    -- WARCRY.
                    elseif settings.warcry and bp.core.ready("Warcry", 68) then
                        bp.core.add("Warcry", bp.player, bp.core.priority("Warcry"))

                    -- RETALIATION.
                    elseif settings.retaliation and bp.core.ready("Retaliation", 405) then
                        bp.core.add("Retaliation", bp.player, bp.core.priority("Retaliation"))

                    -- RESTRAINT.
                    elseif settings.restraint and bp.core.ready("Restraint", 435) then
                        bp.core.add("Restraint", bp.player, bp.core.priority("Restraint"))

                    -- BLOOD RAGE.
                    elseif settings["blood rage"] and bp.core.ready("Blood Rage", 460) then
                        bp.core.add("Blood Rage", bp.player, bp.core.priority("Blood Rage"))

                    end

                end

            end
            self:castNukes(target)

        elseif bp.player.status == 0 then

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target then

                -- PROVOKE.
                if settings.provoke and bp.core.ready("Provoke") then
                    bp.core.add("Provoke", target, bp.core.priority("Provoke"))
                    self.__timers.hate = os.clock()

                end

            end

            -- JOB ABILITIES.
            if settings.ja and bp.core.canAct() then

                -- TOMAHAWK.
                if settings.tomahawk and bp.core.ready("Tomahawk") and bp.__inventory.canEquip("Tomahawk") and target then
                    bp.core.add("Tomahawk", target, bp.core.priority("Tomahawk"))
                end

            end

            -- BUFFS.
            if settings.buffs then

                if bp.core.canAct() then

                    -- DEFENDER.
                    if settings.defender and settings.tank and bp.core.ready("Defender", 57) then
                        bp.core.add("Defender", bp.player, bp.core.priority("Defender"))

                        if bp.core.buff(56) then
                            bp.__buffs.cancel(56)
                        end

                    -- RETALIATION.
                    elseif settings.retaliation and bp.core.ready("Retaliation", 405) then
                        bp.core.add("Retaliation", bp.player, bp.core.priority("Retaliation"))

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