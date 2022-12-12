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

            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] and target then

                    if bp.core.isReady("Chainspell") and not bp.core.inQueue("Chainspell") and not bp.core.buff(48) then
                        bp.core.add("Chainspell", bp.player, bp.core.priority("Chainspell"))
                    end
                    
                    if bp.core.isReady("Stymie") and not bp.core.inQueue("Stymie") and not bp.core.buff(494) then
                        bp.core.add("Stymie", bp.player, bp.core.priority("Stymie"))
                    end

                end

                -- CONVERT.
                if settings.convert and settings.convert.enabled and bp.core.vitals.hpp >= settings.convert.hpp and bp.core.vitals.mpp <= settings.convert.mpp then
                    local mpp, hpp = settings.convert.mpp, settings.convert.hpp
                                
                    if bp.core.vitals.hpp >= hpp and bp.core.vitals.mpp <= mpp and bp.core.isReady("Convert") and not bp.core.inQueue("Convert") then
                        bp.core.add("Convert", bp.player, bp.core.priority("Convert"))
                    end
                    
                end

                -- SABOTEUR.
                if settings.debuffs and settings.saboteur and bp.core.isReady("Saboteur") and not bp.core.inQueue("Saboteur") and not bp.core.buff(454) and target then
                    bp.core.add("Saboteur", bp.player, bp.core.priority("Saboteur"))
                end

            end

            if settings.buffs then

                -- COMPOSURE.
                if settings.composure and bp.core.isReady("Composure") and not bp.core.inQueue("Composure") and not bp.core.buff(419) and bp.core.canAct() then
                    bp.core.add("Composure", bp.player, bp.core.priority("Composure"))

                elseif (not settings.composure or bp.core.buff(419) or not bp.____actions.isAvailable("Composure")) and bp.core.canCast() then
                
                    -- HASTE.
                    if settings.haste and not bp.core.buff(33) and bp.core.mlevel >= 48 then
                        
                        if bp.core.mlevel >= 96 and bp.core.isReady("Haste II") and not bp.core.inQueue("Haste II") then
                            bp.core.add("Haste II", bp.player, bp.core.priority("Haste II"))

                        elseif bp.core.mlevel < 96 and bp.core.isReady("Haste") and not bp.core.inQueue("Haste") then
                            bp.core.add("Haste", bp.player, bp.core.priority("Haste"))

                        end
                    
                    end

                    -- TEMPER.
                    if settings.temper and not bp.core.buff(432) and bp.core.mlevel >= 95 and target then

                        if bp.core.jp >= 1200 and bp.core.isReady("Temper II") and not bp.core.inQueue("Temper II") then
                            bp.core.add("Temper II", bp.player, bp.core.priority("Temper II"))

                        elseif bp.core.jp < 1200 and bp.core.isReady("Temper") and not bp.core.inQueue("Temper") then
                            bp.core.add("Temper", bp.player, bp.core.priority("Temper"))

                        end

                    end

                    -- GAINS.
                    if settings.gain and settings.gain.enabled and not bp.__buffs.hasWHMBoost() and bp.core.isReady(settings.gain.name) then
                        bp.core.add(settings.gain.name, bp.player, bp.core.priority(settings.gain.name))
                    end
                    
                    -- PHALANX.
                    if settings.phalanx and bp.core.isReady("Phalanx") and not bp.core.inQueue("Phalanx") and not bp.core.buff(116) then
                        bp.core.add("Phalanx", bp.player, bp.core.priority("Phalanx"))
                        
                    -- REFRESH.
                    elseif settings.refresh and not bp.core.buff({43,187,188}) then

                        if bp.core.jp >= 1200 and bp.core.isReady("Refresh III") and not bp.core.inQueue("Refresh III") then
                            bp.core.add("Refresh III", bp.player, bp.core.priority("Refresh III"))

                        elseif bp.core.mlevel >= 82 and bp.core.isReady("Refresh II") and not bp.core.inQueue("Refresh II") then
                            bp.core.add("Refresh II", bp.player, bp.core.priority("Refresh II"))

                        elseif bp.core.mlevel < 82 and bp.core.isReady("Refresh") and not bp.core.inQueue("Refresh") then
                            bp.core.add("Refresh", bp.player, bp.core.priority("Refresh"))
                        
                        end
    
                    -- ENSPELLS.
                    elseif settings.en and settings.en.enabled and bp.core.isReady(settings.en.name) and not bp.core.inQueue(settings.en.name) and not bp.__buffs.hasEnspell() and target then
                        bp.core.add(settings.en.name, bp.player, bp.core.priority(settings.en.name))

                    -- SPIKES.
                    elseif settings.spikes and settings.spikes.enabled and not bp.__buffs.hasSpikes() then
                        local spikes = settings.spikes.name

                        if spikes and bp.core.isReady(spikes) and not bp.core.inQueue(spikes) then
                            bp.core.add(spikes, bp.player, bp.core.priority(spikes))
                        end
                        
                    -- BLINK.
                    elseif settings.blink and not bp.__buffs.hasShadows() and bp.core.isReady("Blink") and not bp.core.inQueue("Blink") and not bp.core.buff(36) then
                        bp.core.add("Blink", bp.player, bp.core.priority("Blink"))

                    -- AQUAVEIL.
                    elseif settings.aquaveil and bp.core.isReady("Aquaveil") and not bp.core.inQueue("Aquaveil") and not bp.core.buff(39) then
                        bp.core.add("Aquaveil", bp.player, bp.core.priority("Aquaveil"))

                    -- STONESKIN.
                    elseif settings.stoneskin and bp.core.isReady("Stoneskin") and not bp.core.inQueue("Stoneskin") and not bp.core.buff(37) then
                        bp.core.add("Stoneskin", bp.player, bp.core.priority("Stoneskin"))
                        
                    end

                end

            end
            self:castNukes(target)

        elseif bp.player.status == 0 then

            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] and target then

                    if bp.core.isReady("Chainspell") and not bp.core.inQueue("Chainspell") and not bp.core.buff(48) then
                        bp.core.add("Chainspell", bp.player, bp.core.priority("Chainspell"))
                    end
                    
                    if bp.core.isReady("Stymie") and not bp.core.inQueue("Stymie") and not bp.core.buff(494) then
                        bp.core.add("Stymie", bp.player, bp.core.priority("Stymie"))
                    end

                end

                -- CONVERT.
                if settings.convert and settings.convert.enabled and bp.core.vitals.hpp >= settings.convert.hpp and bp.core.vitals.mpp <= settings.convert.mpp then
                    local mpp, hpp = settings.convert.mpp, settings.convert.hpp
                                
                    if bp.core.vitals.hpp >= hpp and bp.core.vitals.mpp <= mpp and bp.core.isReady("Convert") and not bp.core.inQueue("Convert") then
                        bp.core.add("Convert", bp.player, bp.core.priority("Convert"))
                    end
                    
                end

                -- SABOTEUR.
                if settings.debuffs and settings.saboteur and bp.core.isReady("Saboteur") and not bp.core.inQueue("Saboteur") and not bp.core.buff(454) and target then
                    bp.core.add("Saboteur", bp.player, bp.core.priority("Saboteur"))
                end

            end

            if settings.buffs then

                -- COMPOSURE.
                if settings.composure and bp.core.isReady("Composure") and not bp.core.inQueue("Composure") and not bp.core.buff(419) and bp.core.canAct() then
                    bp.core.add("Composure", bp.player, bp.core.priority("Composure"))

                elseif (not settings.composure or bp.core.buff(419)) and bp.core.canCast() then
                
                    -- HASTE.
                    if settings.haste and not bp.core.buff(33) and bp.core.mlevel >= 48 then
                        
                        if bp.core.mlevel >= 96 and bp.core.isReady("Haste II") and not bp.core.inQueue("Haste II") then
                            bp.core.add("Haste II", bp.player, bp.core.priority("Haste II"))

                        elseif bp.core.mlevel < 96 and bp.core.isReady("Haste") and not bp.core.inQueue("Haste") then
                            bp.core.add("Haste", bp.player, bp.core.priority("Haste"))

                        end
                    
                    end

                    -- TEMPER.
                    if settings.temper and not bp.core.buff(432) and bp.core.mlevel >= 95 and target then

                        if bp.core.jp >= 1200 and bp.core.isReady("Temper II") and not bp.core.inQueue("Temper II") then
                            bp.core.add("Temper II", bp.player, bp.core.priority("Temper II"))

                        elseif bp.core.jp < 1200 and bp.core.isReady("Temper") and not bp.core.inQueue("Temper") then
                            bp.core.add("Temper", bp.player, bp.core.priority("Temper"))

                        end

                    end

                    -- GAINS.
                    if settings.gain and settings.gain.enabled and not bp.__buffs.hasWHMBoost() and bp.core.isReady(settings.gain.name) then
                        bp.core.add(settings.gain.name, bp.player, bp.core.priority(settings.gain.name))
                    end
                    
                    -- PHALANX.
                    if settings.phalanx and bp.core.isReady("Phalanx") and not bp.core.inQueue("Phalanx") and not bp.core.buff(116) then
                        bp.core.add("Phalanx", bp.player, bp.core.priority("Phalanx"))
                        
                    -- REFRESH.
                    elseif settings.refresh and not bp.core.buff({43,187,188}) then

                        if bp.core.jp >= 1200 and bp.core.isReady("Refresh III") and not bp.core.inQueue("Refresh III") then
                            bp.core.add("Refresh III", bp.player, bp.core.priority("Refresh III"))

                        elseif bp.core.mlevel >= 82 and bp.core.isReady("Refresh II") and not bp.core.inQueue("Refresh II") then
                            bp.core.add("Refresh II", bp.player, bp.core.priority("Refresh II"))

                        elseif bp.core.mlevel < 82 and bp.core.isReady("Refresh") and not bp.core.inQueue("Refresh") then
                            bp.core.add("Refresh", bp.player, bp.core.priority("Refresh"))
                        
                        end
    
                    -- ENSPELLS.
                    elseif settings.en and settings.en.enabled and bp.core.isReady(settings.en.name) and not bp.core.inQueue(settings.en.name) and not bp.__buffs.hasEnspell() and target then
                        bp.core.add(settings.en.name, bp.player, bp.core.priority(settings.en.name))

                    -- SPIKES.
                    elseif settings.spikes and settings.spikes.enabled and not bp.__buffs.hasSpikes() then
                        local spikes = settings.spikes.name

                        if spikes and bp.core.isReady(spikes) and not bp.core.inQueue(spikes) then
                            bp.core.add(spikes, bp.player, bp.core.priority(spikes))
                        end
                        
                    -- BLINK.
                    elseif settings.blink and not bp.__buffs.hasShadows() and bp.core.isReady("Blink") and not bp.core.inQueue("Blink") and not bp.core.buff(36) then
                        bp.core.add("Blink", bp.player, bp.core.priority("Blink"))

                    -- AQUAVEIL.
                    elseif settings.aquaveil and bp.core.isReady("Aquaveil") and not bp.core.inQueue("Aquaveil") and not bp.core.buff(39) then
                        bp.core.add("Aquaveil", bp.player, bp.core.priority("Aquaveil"))

                    -- STONESKIN.
                    elseif settings.stoneskin and bp.core.isReady("Stoneskin") and not bp.core.inQueue("Stoneskin") and not bp.core.buff(37) then
                        bp.core.add("Stoneskin", bp.player, bp.core.priority("Stoneskin"))
                        
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