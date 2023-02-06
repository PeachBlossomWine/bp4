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

        if self and self.__subjob and settings.food and settings.skillup and not settings.skillup.enabled and bp.core.canItem() then

        elseif bp.core.canItem() then

            if bp.player.status == 1 then

            elseif bp.player.status == 0 then

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

                if bp.core.canAct() then

                    -- SHIELD BASH.
                    if settings["shield bash"] and bp.core.ready("Shield Bash") then
                        bp.core.add("Shield Bash", target, bp.core.priority("Shield Bash"))
                        self.__timers.hate = os.clock()

                    end

                end

                if bp.core.canCast() then

                    -- FLASH.
                    if settings.flash and bp.core.ready("Flash") then

                        -- DIVINE EMBLEM.
                        if settings["divine emblem"] and bp.core.ready("Divine Emblem", 438) then
                            bp.core.add("Divine Emblem", target, bp.core.priority("Divine Emblem") + 1)
                        
                        end
                        bp.core.add("Flash", target, bp.core.priority("Flash"))
                        self.__timers.hate = os.clock()

                    end

                end

            end

            -- JOB ABILITIES.
            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] then

                    if settings.invincible and bp.core.ready("Invincible", 50) and target then
                        bp.core.add("Invincible", bp.player, bp.core.priority("Invincible"))
                    end
                    
                    if settings.intervene and bp.core.ready("Intervene", 496) and target then
                        bp.core.add("Intervene", target, bp.core.priority("Intervene"))
                    end

                end

                -- CHIVALRY.
                if settings.chivalry and settings.chivalry.enabled and bp.core.ready("Chivalry") then
                    local mpp, tp = settings.chivalry.mpp, settings.chivalry.tp

                    if bp.core.vitals.mpp <= mpp and bp.core.vitals.tp >= tp then
                        bp.core.add("Chivalry", bp.player, bp.core.priority("Chivalry"))
                    end

                -- COVER.
                elseif settings.cover and settings.cover.enabled and bp.core.ready("Cover", 114) then
                    local target = bp.core.getTarget(settings.cover.target)

                    if target and bp.__distance.get(target) <= 4 then
                        bp.core.add("Cover", target, bp.core.priority("Cover"))
                    end

                end

            end

            -- BUFFS.
            if settings.buffs then

                if bp.core.canAct() then

                    -- MAJESTY.
                    if settings.majesty and bp.core.ready("Majesty", 621) then
                        bp.core.add("Majesty", bp.player, bp.core.priority("Majesty"))
                    end

                    -- SENTINEL.
                    if settings.sentinel and bp.core.ready("Sentinel", 62) then
                        bp.core.add("Sentinel", bp.player, bp.core.priority("Sentinel"))

                    -- RAMPART.
                    elseif settings.rampart and bp.core.ready("Rampart", 623) then
                        bp.core.add("Rampart", bp.player, bp.core.priority("Rampart"))

                    -- FEALTY.
                    elseif settings.fealty and bp.core.ready("Fealty", 344) then
                        bp.core.add("Fealty", bp.player, bp.core.priority("Fealty"))

                    -- PALISADE.
                    elseif settings.palisade and bp.core.ready("Palisade", 478) then
                        bp.core.add("Palisade", bp.player, bp.core.priority("Palisade"))

                    end

                end

                if bp.core.canCast() then

                    -- CRUSADE.
                    if settings.crusade and bp.core.ready("Crusade", 289) then
                        bp.core.add("Crusade", bp.player, bp.core.priority("Crusade"))
                    end

                    -- REPRISAL.
                    if settings.reprisal and bp.core.ready("Reprisal", 403) then
                        bp.core.add("Majesty", bp.player, bp.core.priority("Majesty"))

                    -- PHALANX.
                    elseif settings.phalanx and bp.core.ready("Phalanx", 116) then
                        bp.core.add("Phalanx", bp.player, bp.core.priority("Phalanx"))

                    -- ENLIGHT.
                    elseif settings.enlight then

                        if bp.core.jp >= 100 then

                            if bp.core.ready("Enlight II", 274) then
                                bp.core.add("Enlight II", bp.player, bp.core.priority("Enlight II"))
                            end

                        elseif bp.core.mlevel >= 85 then

                            if bp.core.ready("Enlight", 274) then
                                bp.core.add("Enlight", bp.player, bp.core.priority("Enlight"))
                            end

                        end

                    end

                end

            end

        elseif bp.player.status == 0 then
            local target = bp.core.target()

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target then

                if bp.core.canAct() then

                    -- SHIELD BASH.
                    if settings["shield bash"] and bp.core.ready("Shield Bash") then
                        bp.core.add("Shield Bash", target, bp.core.priority("Shield Bash"))
                        self.__timers.hate = os.clock()

                    end

                end

                if bp.core.canCast() then

                    -- FLASH.
                    if settings.flash and bp.core.ready("Flash") then

                        -- DIVINE EMBLEM.
                        if settings["divine emblem"] and bp.core.ready("Divine Emblem", 438) then
                            bp.core.add("Divine Emblem", target, bp.core.priority("Divine Emblem") + 1)
                        
                        end
                        bp.core.add("Flash", target, bp.core.priority("Flash"))
                        self.__timers.hate = os.clock()

                    end

                end

            end

            -- JOB ABILITIES.
            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] then

                    if settings.invincible and bp.core.ready("Invincible", 50) and target then
                        bp.core.add("Invincible", bp.player, bp.core.priority("Invincible"))
                    end
                    
                    if settings.intervene and bp.core.ready("Intervene", 496) and target then
                        bp.core.add("Intervene", target, bp.core.priority("Intervene"))
                    end

                end

                -- CHIVALRY.
                if settings.chivalry and settings.chivalry.enabled and bp.core.ready("Chivalry") then
                    local mpp, tp = settings.chivalry.mpp, settings.chivalry.tp

                    if bp.core.vitals.mpp <= mpp and bp.core.vitals.tp >= tp then
                        bp.core.add("Chivalry", bp.player, bp.core.priority("Chivalry"))
                    end

                -- COVER.
                elseif settings.cover and settings.cover.enabled and bp.core.ready("Cover", 114) then
                    local target = bp.core.getTarget(settings.cover.target)

                    if target and bp.__distance.get(target) <= 4 then
                        bp.core.add("Cover", target, bp.core.priority("Cover"))
                    end

                end

            end

            -- BUFFS.
            if settings.buffs then

                if bp.core.canAct() then

                    -- MAJESTY.
                    if settings.majesty and bp.core.ready("Majesty", 621) then
                        bp.core.add("Majesty", bp.player, bp.core.priority("Majesty"))
                    end

                    -- SENTINEL.
                    if settings.sentinel and bp.core.ready("Sentinel", 62) then
                        bp.core.add("Sentinel", bp.player, bp.core.priority("Sentinel"))

                    -- RAMPART.
                    elseif settings.rampart and bp.core.ready("Rampart", 623) then
                        bp.core.add("Rampart", bp.player, bp.core.priority("Rampart"))

                    -- FEALTY.
                    elseif settings.fealty and bp.core.ready("Fealty", 344) then
                        bp.core.add("Fealty", bp.player, bp.core.priority("Fealty"))

                    -- PALISADE.
                    elseif settings.palisade and bp.core.ready("Palisade", 478) then
                        bp.core.add("Palisade", bp.player, bp.core.priority("Palisade"))

                    end

                end

                if bp.core.canCast() then

                    -- CRUSADE.
                    if settings.crusade and bp.core.ready("Crusade", 289) then
                        bp.core.add("Crusade", bp.player, bp.core.priority("Crusade"))
                    end

                    -- REPRISAL.
                    if settings.reprisal and bp.core.ready("Reprisal", 403) then
                        bp.core.add("Majesty", bp.player, bp.core.priority("Majesty"))

                    -- PHALANX.
                    elseif settings.phalanx and bp.core.ready("Phalanx", 116) then
                        bp.core.add("Phalanx", bp.player, bp.core.priority("Phalanx"))

                    end

                end

            end

        end

        return self

    end
    
    return self

end
return job