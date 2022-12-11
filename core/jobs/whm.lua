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

                -- FLASH.
                if settings.flash and bp.core.isReady("Flash") and not bp.core.inQueue("Flash") and bp.core.canCast() then
                    bp.core.add("Flash", target, bp.core.priority("Flash"))
                    self.__timers.hate = os.clock()

                end

            end

            if settings.ja and bp.core.canAct() then

                -- MARTYR.
                if settings.martyr and settings.martyr.enabled and bp.core.isReady("Martyr") and not bp.core.inQueue("Martyr") then
                    local target, hpp = bp.core.getTarget(settings.martyr.target), settings.martyr.hpp

                    if target and bp.core.vitals.hpp >= 50 and target.hpp <= hpp and bp.__party.isMember(target) then
                        bp.core.add("Martyr", target, bp.core.priority("Martyr"))
                    end

                end

                -- DEVOTION.
                if settings.devotion and saettings.devotion.enabled and bp.core.isReady("Devotion") and not bp.core.inQueue("Devotion") then
                    local target, mpp = bp.core.getTarget(settings.devotion.enabled), settings.devotion.mpp

                    if target and bp.core.vitals.hpp >= 50 and target.mpp <= mpp and bp.__party.isMember(target) then
                        bp.core.add("Devotion", target, bp.core.priority("Devotion"))
                    end

                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- AFFLATUS SOLACE.
                    if settings.solace and bp.core.isReady("Afflatus Solace") and not bp.core.inQueue("Afflatus Solace") and not bp.core.buff(417) then
                        bp.core.add("Afflatus Solace", bp.player, bp.core.priority("Afflatus Solace"))

                    -- AFFLATUS MISEERY.
                    elseif settings.misery and bp.core.isReady("Afflatus Misery") and not bp.core.inQueue("Afflatus Misery") and not bp.core.buff({417,418}) then
                        bp.core.add("Afflatus Misery", bp.player, bp.core.priority("Afflatus Misery"))

                    -- SACROSANCTITY.
                    elseif settings.sacrosanctity and bp.core.isReady("Sacrosanctity") and not bp.core.inQueue("Sacrosanctity") and not bp.core.buff(477) then
                        bp.core.add("Sacrosanctity", bp.player, bp.core.priority("Sacrosanctity"))

                    end

                end

                if bp.core.canCast() then

                    -- PROTECT.
                    if settings.protect and (not bp.core.buff(40) or not bp.__buffs.isProtected()) then

                        if (bp.core.main == 'WHM' and bp.core.mlevel >= 75) or (bp.core.sub == 'WHM' and bp.core.slevel >= 75) then
                            
                            if bp.core.isReady("Protectra V") and not bp.core.inQueue("Protectra V") then
                                bp.core.add("Protectra V", bp.player, bp.core.priority("Protectra V"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 63 and bp.core.mlevel < 75) or (bp.core.sub == 'WHM' and bp.core.slevel >= 63 and bp.core.slevel < 75) then

                            if bp.core.isReady("Protectra IV") and not bp.core.inQueue("Protectra IV") then
                                bp.core.add("Protectra IV", bp.player, bp.core.priority("Protectra IV"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 47 and bp.core.mlevel < 63) or (bp.core.sub == 'WHM' and bp.core.slevel >= 47 and bp.core.slevel < 63) then

                            if bp.core.isReady("Protectra III") and not bp.core.inQueue("Protectra III") then
                                bp.core.add("Protectra III", bp.player, bp.core.priority("Protectra III"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 27 and bp.core.mlevel < 47) or (bp.core.sub == 'WHM' and bp.core.slevel >= 27 and bp.core.slevel < 47) then

                            if bp.core.isReady("Protectra II") and not bp.core.inQueue("Protectra II") then
                                bp.core.add("Protectra II", bp.player, bp.core.priority("Protectra II"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 07 and bp.core.mlevel < 27) or (bp.core.sub == 'WHM' and bp.core.slevel >= 07 and bp.core.slevel < 27) then

                            if bp.core.isReady("Protectra") and not bp.core.inQueue("Protectra") then
                                bp.core.add("Protectra", bp.player, bp.core.priority("Protectra"))
                            end

                        end

                    -- SHELL.
                    elseif settings.shell and (not bp.core.buff(41) or not bp.__buffs.isShelled()) then

                        if (bp.core.main == 'WHM' and bp.core.mlevel >= 75) or (bp.core.sub == 'WHM' and bp.core.slevel >= 75) then
                            
                            if bp.core.isReady("Shellra V") and not bp.core.inQueue("Shellra V") then
                                bp.core.add("Shellra V", bp.player, bp.core.priority("Shellra V"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 68 and bp.core.mlevel < 75) or (bp.core.sub == 'WHM' and bp.core.slevel >= 68 and bp.core.slevel < 75) then

                            if bp.core.isReady("Shellra IV") and not bp.core.inQueue("Shellra IV") then
                                bp.core.add("Shellra IV", bp.player, bp.core.priority("Shellra IV"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 57 and bp.core.mlevel < 68) or (bp.core.sub == 'WHM' and bp.core.slevel >= 57 and bp.core.slevel < 68) then

                            if bp.core.isReady("Shellra III") and not bp.core.inQueue("Shellra III") then
                                bp.core.add("Shellra III", bp.player, bp.core.priority("Shellra III"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 37 and bp.core.mlevel < 57) or (bp.core.sub == 'WHM' and bp.core.slevel >= 37 and bp.core.slevel < 57) then

                            if bp.core.isReady("Shellra II") and not bp.core.inQueue("Shellra II") then
                                bp.core.add("Shellra II", bp.player, bp.core.priority("Shellra II"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 17 and bp.core.mlevel < 37) or (bp.core.sub == 'WHM' and bp.core.slevel >= 17 and bp.core.slevel < 37) then

                            if bp.core.isReady("Shellra") and not bp.core.inQueue("Shellra") then
                                bp.core.add("Shellra", bp.player, bp.core.priority("Shellra"))
                            end

                        end

                    end

                    -- HASTE.
                    if settings.haste and bp.core.isReady("Haste") and not bp.core.inQueue("Haste") and not bp.core.buff(33) then
                        bp.core.add("Haste", bp.player, bp.core.priority("Haste"))                    
                    end

                    -- BOOST.
                    if settings.boost and settings.boost.enabled and bp.core.isReady(settings.boost.name) and not bp.__buffs.hasWHMBoost() then
                        bp.core.add(settings.boost.name, bp.player, bp.core.priority(settings.boost.name))

                    -- AUSPICE.
                    elseif settings.auspice and bp.core.isReady("Auspice") and not bp.core.inQueue("Auspice") and not bp.core.buff(275) then
                        bp.core.add("Auspice", bp.player, bp.core.priority("Auspice"))
                        
                    -- BLINK.
                    elseif settings.blink and bp.core.isReady("Blink") and not bp.core.inQueue("Blink") and not bp.core.buff(36) and not bp.__buffs.hasShadows() then
                        bp.core.add("Blink", bp.player, bp.core.priority("Blink"))

                    -- AQUAVEIL.
                    elseif settings.aquaveil and bp.core.isReady("Aquaveil") and not bp.core.inQueue("Aquaveil") and not bp.core.buff(39) then
                        bp.core.add("Aquaveil", bp.player, bp.core.priority("Aquaveil"))

                    -- STONESKIN.
                    elseif settings.stoneskin and bp.core.isReady("Stoneskin") and not bp.core.inQueue("Stoneskin") and not bp.core.buff(37) then
                        bp.core.add("Stoneskin", bp.player, bp.core.priority("Stoneskin"))

                    -- REGEN.
                    elseif settings.regen and not bp.core.buff(42) then

                        if bp.core.mlevel >= 86 and bp.core.isReady("Regen IV") then
                            bp.core.add("Regen IV", bp.player, bp.core.priority("Regen IV"))

                        elseif bp.core.mlevel >= 66 and bp.core.mlevel < 86 and bp.core.isReady("Regen III") then
                            bp.core.add("Regen III", bp.player, bp.core.priority("Regen III"))

                        elseif bp.core.mlevel >= 44 and bp.core.mlevel < 66 and bp.core.isReady("Regen II") then
                            bp.core.add("Regen II", bp.player, bp.core.priority("Regen II"))

                        elseif bp.core.mlevel >= 21 and bp.core.mlevel < 44 and bp.core.isReady("Regen") then
                            bp.core.add("Regen", bp.player, bp.core.priority("Regen"))

                        end
                        
                    end

                end

            end
            self:castNukes(target)

        elseif bp.player.status == 0 then

            -- HATE GENERATION.
            if settings.hate and settings.hate.enabled and (os.clock()-self.__timers.hate) >= settings.hate.delay and target then

                -- FLASH.
                if settings.flash and bp.core.isReady("Flash") and not bp.core.inQueue("Flash") and bp.core.canCast() then
                    bp.core.add("Flash", target, bp.core.priority("Flash"))
                    self.__timers.hate = os.clock()

                end

            end

            if settings.ja and bp.core.canAct() then

                -- MARTYR.
                if settings.martyr and settings.martyr.enabled and bp.core.isReady("Martyr") and not bp.core.inQueue("Martyr") then
                    local target, hpp = bp.core.getTarget(settings.martyr.target), settings.martyr.hpp

                    if target and bp.core.vitals.hpp >= 50 and target.hpp <= hpp and bp.__party.isMember(target) then
                        bp.core.add("Martyr", target, bp.core.priority("Martyr"))
                    end

                end

                -- DEVOTION.
                if settings.devotion and saettings.devotion.enabled and bp.core.isReady("Devotion") and not bp.core.inQueue("Devotion") then
                    local target, mpp = bp.core.getTarget(settings.devotion.enabled), settings.devotion.mpp

                    if target and bp.core.vitals.hpp >= 50 and target.mpp <= mpp and bp.__party.isMember(target) then
                        bp.core.add("Devotion", target, bp.core.priority("Devotion"))
                    end

                end

            end

            if settings.buffs then

                if bp.core.canAct() then

                    -- AFFLATUS SOLACE.
                    if settings.solace and bp.core.isReady("Afflatus Solace") and not bp.core.inQueue("Afflatus Solace") and not bp.core.buff(417) then
                        bp.core.add("Afflatus Solace", bp.player, bp.core.priority("Afflatus Solace"))

                    -- AFFLATUS MISEERY.
                    elseif settings.misery and bp.core.isReady("Afflatus Misery") and not bp.core.inQueue("Afflatus Misery") and not bp.core.buff({417,418}) then
                        bp.core.add("Afflatus Misery", bp.player, bp.core.priority("Afflatus Misery"))

                    -- SACROSANCTITY.
                    elseif settings.sacrosanctity and bp.core.isReady("Sacrosanctity") and not bp.core.inQueue("Sacrosanctity") and not bp.core.buff(477) then
                        bp.core.add("Sacrosanctity", bp.player, bp.core.priority("Sacrosanctity"))

                    end

                end

                if bp.core.canCast() then

                    -- PROTECT.
                    if settings.protect and (not bp.core.buff(40) or not bp.__buffs.isProtected()) then

                        if (bp.core.main == 'WHM' and bp.core.mlevel >= 75) or (bp.core.sub == 'WHM' and bp.core.slevel >= 75) then
                            
                            if bp.core.isReady("Protectra V") and not bp.core.inQueue("Protectra V") then
                                bp.core.add("Protectra V", bp.player, bp.core.priority("Protectra V"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 63 and bp.core.mlevel < 75) or (bp.core.sub == 'WHM' and bp.core.slevel >= 63 and bp.core.slevel < 75) then

                            if bp.core.isReady("Protectra IV") and not bp.core.inQueue("Protectra IV") then
                                bp.core.add("Protectra IV", bp.player, bp.core.priority("Protectra IV"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 47 and bp.core.mlevel < 63) or (bp.core.sub == 'WHM' and bp.core.slevel >= 47 and bp.core.slevel < 63) then

                            if bp.core.isReady("Protectra III") and not bp.core.inQueue("Protectra III") then
                                bp.core.add("Protectra III", bp.player, bp.core.priority("Protectra III"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 27 and bp.core.mlevel < 47) or (bp.core.sub == 'WHM' and bp.core.slevel >= 27 and bp.core.slevel < 47) then

                            if bp.core.isReady("Protectra II") and not bp.core.inQueue("Protectra II") then
                                bp.core.add("Protectra II", bp.player, bp.core.priority("Protectra II"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 07 and bp.core.mlevel < 27) or (bp.core.sub == 'WHM' and bp.core.slevel >= 07 and bp.core.slevel < 27) then

                            if bp.core.isReady("Protectra") and not bp.core.inQueue("Protectra") then
                                bp.core.add("Protectra", bp.player, bp.core.priority("Protectra"))
                            end

                        end

                    -- SHELL.
                    elseif settings.shell and (not bp.core.buff(41) or not bp.__buffs.isShelled()) then

                        if (bp.core.main == 'WHM' and bp.core.mlevel >= 75) or (bp.core.sub == 'WHM' and bp.core.slevel >= 75) then
                            
                            if bp.core.isReady("Shellra V") and not bp.core.inQueue("Shellra V") then
                                bp.core.add("Shellra V", bp.player, bp.core.priority("Shellra V"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 68 and bp.core.mlevel < 75) or (bp.core.sub == 'WHM' and bp.core.slevel >= 68 and bp.core.slevel < 75) then

                            if bp.core.isReady("Shellra IV") and not bp.core.inQueue("Shellra IV") then
                                bp.core.add("Shellra IV", bp.player, bp.core.priority("Shellra IV"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 57 and bp.core.mlevel < 68) or (bp.core.sub == 'WHM' and bp.core.slevel >= 57 and bp.core.slevel < 68) then

                            if bp.core.isReady("Shellra III") and not bp.core.inQueue("Shellra III") then
                                bp.core.add("Shellra III", bp.player, bp.core.priority("Shellra III"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 37 and bp.core.mlevel < 57) or (bp.core.sub == 'WHM' and bp.core.slevel >= 37 and bp.core.slevel < 57) then

                            if bp.core.isReady("Shellra II") and not bp.core.inQueue("Shellra II") then
                                bp.core.add("Shellra II", bp.player, bp.core.priority("Shellra II"))
                            end

                        elseif (bp.core.main == 'WHM' and bp.core.mlevel >= 17 and bp.core.mlevel < 37) or (bp.core.sub == 'WHM' and bp.core.slevel >= 17 and bp.core.slevel < 37) then

                            if bp.core.isReady("Shellra") and not bp.core.inQueue("Shellra") then
                                bp.core.add("Shellra", bp.player, bp.core.priority("Shellra"))
                            end

                        end

                    end

                    -- HASTE.
                    if settings.haste and bp.core.isReady("Haste") and not bp.core.inQueue("Haste") and not bp.core.buff(33) then
                        bp.core.add("Haste", bp.player, bp.core.priority("Haste"))                    
                    end

                    -- BOOST.
                    if settings.boost and settings.boost.enabled and bp.core.isReady(settings.boost.name) and not bp.__buffs.hasWHMBoost() then
                        bp.core.add(settings.boost.name, bp.player, bp.core.priority(settings.boost.name))

                    -- AUSPICE.
                    elseif settings.auspice and bp.core.isReady("Auspice") and not bp.core.inQueue("Auspice") and not bp.core.buff(275) then
                        bp.core.add("Auspice", bp.player, bp.core.priority("Auspice"))
                        
                    -- BLINK.
                    elseif settings.blink and bp.core.isReady("Blink") and not bp.core.inQueue("Blink") and not bp.core.buff(36) and not bp.__buffs.hasShadows() then
                        bp.core.add("Blink", bp.player, bp.core.priority("Blink"))

                    -- AQUAVEIL.
                    elseif settings.aquaveil and bp.core.isReady("Aquaveil") and not bp.core.inQueue("Aquaveil") and not bp.core.buff(39) then
                        bp.core.add("Aquaveil", bp.player, bp.core.priority("Aquaveil"))

                    -- STONESKIN.
                    elseif settings.stoneskin and bp.core.isReady("Stoneskin") and not bp.core.inQueue("Stoneskin") and not bp.core.buff(37) then
                        bp.core.add("Stoneskin", bp.player, bp.core.priority("Stoneskin"))

                    -- REGEN.
                    elseif settings.regen and not bp.core.buff(42) then

                        if bp.core.mlevel >= 86 and bp.core.isReady("Regen IV") then
                            bp.core.add("Regen IV", bp.player, bp.core.priority("Regen IV"))

                        elseif bp.core.mlevel >= 66 and bp.core.mlevel < 86 and bp.core.isReady("Regen III") then
                            bp.core.add("Regen III", bp.player, bp.core.priority("Regen III"))

                        elseif bp.core.mlevel >= 44 and bp.core.mlevel < 66 and bp.core.isReady("Regen II") then
                            bp.core.add("Regen II", bp.player, bp.core.priority("Regen II"))

                        elseif bp.core.mlevel >= 21 and bp.core.mlevel < 44 and bp.core.isReady("Regen") then
                            bp.core.add("Regen", bp.player, bp.core.priority("Regen"))

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