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

        if self and self.__subjob and settings.food and settings.skillup and not settings.skillup.enabled and bp.core.canItem() then

        elseif bp.core.canItem() then

            if bp.player.status == 1 then

            elseif bp.player.status == 0 then

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

                -- FLASH.
                if settings.flash and bp.core.isReady("Flash") and not bp.core.inQueue("Flash") and bp.core.canCast() then
                    bp.core.add("Flash", target, bp.core.priority("Flash"))
                    self.__timers.hate = os.clock()

                end

            end

            -- JOB ABILITIES.
            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] and target then

                    if bp.core.isReady("Elemental Sforzo") and not bp.core.buff(522) then
                        bp.core.add("Elemental Sforzo", bp.player, bp.core.priority("Elemental Sforzo"))
                    end
                    
                    if bp.core.isReady("Odyllic Subterfuge") and not bp.core.buff(509) then
                        bp.core.add("Odyllic Subterfuge", target, bp.core.priority("Odyllic Subterfuge"))
                    end

                end

                -- VIVACIOUS PULSE.
                if settings["vivacious pulse"] and settings["vivacious pulse"].enabled and bp.core.isReady("Vivacious Pulse") and not bp.core.inQueue("Vivacious Pulse") then
                    local mpp, hpp = settings["vivacious pulse"].mpp, settings["vivacious pulse"].hpp

                    if bp.runes.get():contains("Tenebrae") then
                                
                        if (bp.core.vitals.hpp <= hpp and bp.core.vitals.mpp <= mpp) then
                            bp.core.add("Vivacious Pulse", bp.player, bp.core.priority("Vivacious Pulse"))
                        end

                    else

                        if bp.core.vitals.hpp <= hpp then
                            bp.core.add("Vivacious Pulse", bp.player, bp.core.priority("Vivacious Pulse"))
                        end

                    end
                    
                end

                -- RAYKE.
                if settings.rayke and bp.core.isReady("Rayke") and not bp.core.searchQueue("Gambit","Rayke") and bp.__runes.count() == 3 and not bp.core.buff({536,571}) and target then
                    bp.core.add("Rayke", target, bp.core.priority("Rayke"))

                -- GAMBIT.
                elseif settings.gambit and bp.core.isReady("Gambit") and not bp.core.searchQueue("Gambit","Rayke") and bp.__runes.count() == 3 and not bp.core.buff({536,571}) and target then
                    bp.core.add("Gambit", target, bp.core.priority("Gambit"))

                end

                -- SWIPE.
                if settings.rayke and bp.core.isReady("Rayke") and not bp.core.searchQueue("Gambit","Rayke") and bp.__runes.count() > 0 and not bp.core.buff({536,571}) and (not settings.mb or settings.mb and not settings.mb.enabled) and target then
                    bp.core.add("Rayke", target, bp.core.priority("Rayke"))

                -- LUNGE.
                elseif settings.gambit and bp.core.isReady("Gambit") and not bp.core.searchQueue("Gambit","Rayke") and bp.__runes.count() == 3 and not bp.core.buff({536,571}) and (not settings.mb or settings.mb and not settings.mb.enabled) and target then
                    bp.core.add("Gambit", target, bp.core.priority("Gambit"))

                end

            end

            if settings.buffs then

                -- RUNES.
                if settings.runes and bp.core.isReady("Ignis") and not bp.__queue.typeInQueue("Ignis") and bp.core.canAct() and bp.__runes.count() < bp.__runes.max() then
                    local runes = bp.runes.inactive()

                    if runes:length() > 0 then

                        for i=1, runes:length() do
                            bp.core.add(runes[i], bp.player, bp.core.priority(runes[i]))
                            break

                        end

                    end

                end

                -- SWORDPLAY.
                if settings.swordplay and bp.core.isReady("Swordplay") and not bp.core.inQueue("Swordplay") and not bp.core.buff(532) and bp.core.canAct() and target then
                    bp.core.add("Swordplay", bp.player, bp.core.priority("Swordplay"))
                end

                -- BATTUTA.
                if settings.battuta and bp.core.isReady("Battuta") and not bp.core.inQueue("Battuta") and not bp.core.buff(570) and bp.__runes.count() == 3 and bp.core.canAct() and target then
                    bp.core.add("Battuta", bp.player, bp.core.priority("Battuta"))
                end

                -- VALIANCE.
                if settings.valiance and bp.core.isReady("Valiance") and not bp.core.searchQueue({"Valiance","Liement"}) and not bp.core.buff({535,537}) and bp.__runes.count() == 3 and bp.core.canAct() and target then
                    bp.core.add("Valiance", bp.player, bp.core.priority("Valiance"))
                end

                -- VALLATION.
                if settings.vallation and bp.core.isReady("Vallation") and not bp.core.searchQueue({"Vallation","Liement"}) and not bp.core.buff({531,537}) and bp.__runes.count() == 3 and bp.core.canAct() and target then
                    bp.core.add("Vallation", bp.player, bp.core.priority("Vallation"))
                end

                -- LIEMENT.
                if settings.liement and bp.core.isReady("Liement") and not bp.core.searchQueue({"Valiance","Vallation","Liement"}) and not bp.core.buff({531,535,537}) and bp.__runes.count() == 3 and bp.core.canAct() and target then
                    bp.core.add("Liement", bp.player, bp.core.priority("Liement"))
                end

                -- PFLUG.
                if settings.pflug and bp.core.isReady("Pflug") and not bp.core.inQueue("Pflug") and not bp.core.buff(533) and bp.__runes.count() == 3 and bp.core.canAct() and target then
                    bp.core.add("Pflug", bp.player, bp.core.priority("Pflug"))
                end

                -- EMBOLDEN.
                if settings.embolden and settings.embolden.enabled and bp.core.isReady("Embolden") and not bp.core.inQueue("Embolden") and not bp.core.buff(534) and bp.core.canAct() and target then
                    local spell = settings.embolden.name

                    if spell and bp.core.isReady(spell) and bp.MA[spell] and not bp.core.buff(bp.MA[spell].status) and bp.core.canCast() then
                        bp.core.add("Embolden", bp.player, bp.core.priority("Embolden"))
                        bp.core.add(spell, bp.player, bp.core.priority(spell))

                    end

                end

                if bp.core.canCast() then

                    -- CRUSADE.
                    if bp.core.isReady("Crusade") and not bp.core.buff(289) and target then
                        bp.core.add("Crusade", bp.player, bp.core.priority("Crusade"))
                    end

                    -- TEMPER.
                    if settings.temper and bp.core.isReady("Temper") and not bp.core.buff(432) and target then
                        bp.core.add("Temper", bp.player, bp.core.priority("Temper"))
                    
                    -- PHALANX.
                    elseif settings.phalanx and bp.core.isReady("Phalanx") and not bp.core.buff(116) then
                        bp.core.add("Phalanx", bp.player, bp.core.priority("Phalanx"))
                        
                    -- REFRESH.
                    elseif settings.refresh and bp.core.isReady("Refresh") and not bp.core.buff({43,187,188}) then
                        bp.core.add("Refresh", bp.player, bp.core.priority("Refresh"))

                    elseif settings.regen and not bp.core.buff(42) then

                        if bp.core.mlevel >= 99 and bp.core.isReady("Regen IV") then
                            bp.core.add("Regen IV", bp.player, bp.core.priority("Regen IV"))

                        elseif bp.core.mlevel >= 70 and bp.core.mlevel < 99 and bp.core.isReady("Regen III") then
                            bp.core.add("Regen III", bp.player, bp.core.priority("Regen III"))

                        elseif bp.core.mlevel >= 48 and bp.core.mlevel < 70 and bp.core.isReady("Regen II") then
                            bp.core.add("Regen II", bp.player, bp.core.priority("Regen II"))

                        elseif bp.core.mlevel < 48 and bp.core.isReady("Regen") then
                            bp.core.add("Regen", bp.player, bp.core.priority("Regen"))

                        end

                    -- SPIKES.
                    elseif settings.spikes and settings.spikes.enabled and not bp.__buffs.hasSpikes() then
                        local spikes = settings.spikes.name

                        if spikes and bp.core.isReady(spikes) and not bp.core.inQueue(spikes) then
                            bp.core.add(spikes, bp.player, bp.core.priority(spikes))
                        end
                        
                    -- BLINK.
                    elseif settings.blink and bp.core.isReady("Blink") and not bp.core.buff(36) and not bp.__buffs.hasShadows() and target then
                        bp.core.add("Blink", bp.player, bp.core.priority("Blink"))

                    -- AQUAVEIL.
                    elseif settings.aquaveil and bp.core.isReady("Aquaveil") and not bp.core.buff(39) then
                        bp.core.add("Aquaveil", bp.player, bp.core.priority("Aquaveil"))

                    -- STONESKIN.
                    elseif settings.stoneskin and bp.core.isReady("Stoneskin") and not bp.core.buff(37) then
                        bp.core.add("Stoneskin", bp.player, bp.core.priority("Stoneskin"))
                        
                    end

                end

            end

        elseif bp.player.status == 0 then
            local target = bp.core.target()

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target then

                if settings.flash and bp.core.isReady("Flash") and not bp.core.inQueue("Flash") and bp.core.canCast() then
                    bp.core.add("Flash", target, bp.core.priority("Flash"))
                    __timers.hate = os.clock()

                end

            end

            -- JOB ABILITIES.
            if settings.ja and bp.core.canAct() then

                -- ONE-HOURS.
                if settings['1hr'] and target then

                    if bp.core.isReady("Elemental Sforzo") and not bp.core.buff(522) then
                        bp.core.add("Elemental Sforzo", bp.player, bp.core.priority("Elemental Sforzo"))
                    end
                    
                    if bp.core.isReady("Odyllic Subterfuge") and not bp.core.buff(509) then
                        bp.core.add("Odyllic Subterfuge", target, bp.core.priority("Odyllic Subterfuge"))
                    end

                end

                -- VIVACIOUS PULSE.
                if settings["vivacious pulse"] and settings["vivacious pulse"].enabled and bp.core.isReady("Vivacious Pulse") and not bp.core.inQueue("Vivacious Pulse") then
                    local mpp, hpp = settings["vivacious pulse"].mpp, settings["vivacious pulse"].hpp

                    if bp.runes.get():contains("Tenebrae") then
                                
                        if (bp.core.vitals.hpp <= hpp and bp.core.vitals.mpp <= mpp) then
                            bp.core.add("Vivacious Pulse", bp.player, bp.core.priority("Vivacious Pulse"))
                        end

                    else

                        if bp.core.vitals.hpp <= hpp then
                            bp.core.add("Vivacious Pulse", bp.player, bp.core.priority("Vivacious Pulse"))
                        end

                    end
                    
                end

                -- RAYKE.
                if settings.rayke and bp.core.isReady("Rayke") and not bp.core.searchQueue("Gambit","Rayke") and bp.__runes.count() == 3 and not bp.core.buff({536,571}) and target then
                    bp.core.add("Rayke", target, bp.core.priority("Rayke"))

                -- GAMBIT.
                elseif settings.gambit and bp.core.isReady("Gambit") and not bp.core.searchQueue("Gambit","Rayke") and bp.__runes.count() == 3 and not bp.core.buff({536,571}) and target then
                    bp.core.add("Gambit", target, bp.core.priority("Gambit"))

                end

                -- SWIPE.
                if settings.rayke and bp.core.isReady("Rayke") and not bp.core.searchQueue("Gambit","Rayke") and bp.__runes.count() > 0 and not bp.core.buff({536,571}) and (not settings.mb or settings.mb and not settings.mb.enabled) and target then
                    bp.core.add("Rayke", target, bp.core.priority("Rayke"))

                -- LUNGE.
                elseif settings.gambit and bp.core.isReady("Gambit") and not bp.core.searchQueue("Gambit","Rayke") and bp.__runes.count() == 3 and not bp.core.buff({536,571}) and (not settings.mb or settings.mb and not settings.mb.enabled) and target then
                    bp.core.add("Gambit", target, bp.core.priority("Gambit"))

                end

            end

            if settings.buffs then

                -- RUNES.
                if settings.runes and bp.core.isReady("Ignis") and not bp.__queue.typeInQueue("Ignis") and bp.core.canAct() and bp.__runes.count() < bp.__runes.max() then
                    local runes = bp.runes.inactive()

                    if runes:length() > 0 then

                        for i=1, runes:length() do
                            bp.core.add(runes[i], bp.player, bp.core.priority(runes[i]))
                            break

                        end

                    end

                end

                -- SWORDPLAY.
                if settings.swordplay and bp.core.isReady("Swordplay") and not bp.core.inQueue("Swordplay") and not bp.core.buff(532) and bp.core.canAct() and target then
                    bp.core.add("Swordplay", bp.player, bp.core.priority("Swordplay"))
                end

                -- BATTUTA.
                if settings.battuta and bp.core.isReady("Battuta") and not bp.core.inQueue("Battuta") and not bp.core.buff(570) and bp.__runes.count() == 3 and bp.core.canAct() and target then
                    bp.core.add("Battuta", bp.player, bp.core.priority("Battuta"))
                end

                -- VALIANCE.
                if settings.valiance and bp.core.isReady("Valiance") and not bp.core.searchQueue({"Valiance","Liement"}) and not bp.core.buff({535,537}) and bp.__runes.count() == 3 and bp.core.canAct() and target then
                    bp.core.add("Valiance", bp.player, bp.core.priority("Valiance"))
                end

                -- VALLATION.
                if settings.vallation and bp.core.isReady("Vallation") and not bp.core.searchQueue({"Vallation","Liement"}) and not bp.core.buff({531,537}) and bp.__runes.count() == 3 and bp.core.canAct() and target then
                    bp.core.add("Vallation", bp.player, bp.core.priority("Vallation"))
                end

                -- LIEMENT.
                if settings.liement and bp.core.isReady("Liement") and not bp.core.searchQueue({"Valiance","Vallation","Liement"}) and not bp.core.buff({531,535,537}) and bp.__runes.count() == 3 and bp.core.canAct() and target then
                    bp.core.add("Liement", bp.player, bp.core.priority("Liement"))
                end

                -- PFLUG.
                if settings.pflug and bp.core.isReady("Pflug") and not bp.core.inQueue("Pflug") and not bp.core.buff(533) and bp.__runes.count() == 3 and bp.core.canAct() and target then
                    bp.core.add("Pflug", bp.player, bp.core.priority("Pflug"))
                end

                -- EMBOLDEN.
                if settings.embolden and settings.embolden.enabled and bp.core.isReady("Embolden") and not bp.core.inQueue("Embolden") and not bp.core.buff(534) and bp.core.canAct() and target then
                    local spell = settings.embolden.name

                    if spell and bp.core.isReady(spell) and bp.MA[spell] and not bp.core.buff(bp.MA[spell].status) and bp.core.canCast() then
                        bp.core.add("Embolden", bp.player, bp.core.priority("Embolden"))
                        bp.core.add(spell, bp.player, bp.core.priority(spell))

                    end

                end

                if bp.core.canCast() then

                    -- CRUSADE.
                    if bp.core.isReady("Crusade") and not bp.core.buff(289) and target then
                        bp.core.add("Crusade", bp.player, bp.core.priority("Crusade"))
                    end

                    -- TEMPER.
                    if settings.temper and bp.core.isReady("Temper") and not bp.core.buff(432) and target then
                        bp.core.add("Temper", bp.player, bp.core.priority("Temper"))
                    
                    -- PHALANX.
                    elseif settings.phalanx and bp.core.isReady("Phalanx") and not bp.core.buff(116) then
                        bp.core.add("Phalanx", bp.player, bp.core.priority("Phalanx"))
                        
                    -- REFRESH.
                    elseif settings.refresh and bp.core.isReady("Refresh") and not bp.core.buff({43,187,188}) then
                        bp.core.add("Refresh", bp.player, bp.core.priority("Refresh"))

                    elseif settings.regen and not bp.core.buff(42) then

                        if bp.core.mlevel >= 99 and bp.core.isReady("Regen IV") then
                            bp.core.add("Regen IV", bp.player, bp.core.priority("Regen IV"))

                        elseif bp.core.mlevel >= 70 and bp.core.mlevel < 99 and bp.core.isReady("Regen III") then
                            bp.core.add("Regen III", bp.player, bp.core.priority("Regen III"))

                        elseif bp.core.mlevel >= 48 and bp.core.mlevel < 70 and bp.core.isReady("Regen II") then
                            bp.core.add("Regen II", bp.player, bp.core.priority("Regen II"))

                        elseif bp.core.mlevel < 48 and bp.core.isReady("Regen") then
                            bp.core.add("Regen", bp.player, bp.core.priority("Regen"))

                        end

                    -- SPIKES.
                    elseif settings.spikes and settings.spikes.enabled and not bp.__buffs.hasSpikes() then
                        local spikes = settings.spikes.name

                        if spikes and bp.core.isReady(spikes) and not bp.core.inQueue(spikes) then
                            bp.core.add(spikes, bp.player, bp.core.priority(spikes))
                        end
                        
                    -- BLINK.
                    elseif settings.blink and bp.core.isReady("Blink") and not bp.core.buff(36) and not bp.__buffs.hasShadows() and target then
                        bp.core.add("Blink", bp.player, bp.core.priority("Blink"))

                    -- AQUAVEIL.
                    elseif settings.aquaveil and bp.core.isReady("Aquaveil") and not bp.core.buff(39) then
                        bp.core.add("Aquaveil", bp.player, bp.core.priority("Aquaveil"))

                    -- STONESKIN.
                    elseif settings.stoneskin and bp.core.isReady("Stoneskin") and not bp.core.buff(37) then
                        bp.core.add("Stoneskin", bp.player, bp.core.priority("Stoneskin"))
                        
                    end

                end

            end

        end

        return self

    end
    
    return self

end
return job