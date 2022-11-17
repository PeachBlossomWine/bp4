local job = {}
function job.get(bp)
    local self = {}

    if not bp then
        print('ERROR LOADING CORE! PLEASE POST AN ISSUE ON OUR GITHUB!')
        return
    end

    -- Private Variables.
    local bp        = bp
    local private   = {events={}}
    local timers    = {tickle=0}
    local flags     = {}

    do
        private.nukes = {'Searing Tempest','Blinding Fulgor','Spectral Floe','Scouring Spate','Anvil Lightning','Silent Storm','Entomb','Tenebral Crush','Subduction'}

    end

    self.getFlags = function()
        return flags
    end

    self.automate = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = bp.core.get

        do
            private.items()
            if bp and bp.player and bp.player.status == 1 then
                local target    = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
                local current   = T(windower.ffxi.get_mjob_data().spells)
                local _act      = helpers['actions'].canAct()
                local _cast     = helpers['actions'].canCast()

                if not get('nuke') then

                    if get('hate').enabled and _cast then

                        -- JETTATURA.
                        if isReady('MA', "Jettatura") and current:contains(bp.MA["Jettatura"].id) then
                            add(bp.MA["Jettatura"], target)
                            
                        -- BLANK GAZE.
                        elseif isReady('MA', "Blank Gaze") and current:contains(bp.MA["Blank Gaze"].id) then
                            add(bp.MA["Blank Gaze"], target)
                            
                        end
                        
                        if get('hate').aoe and (os.clock()-timers.hate) > get('hate').delay then
                            
                            -- SOPORIFIC.
                            if isReady('MA', "Soporific") and current:contains(bp.MA["Soporific"].id) then
                                add(bp.MA["Soporific"], target)
                                timers.hate = os.clock()
                            
                            -- GEIST WALL.
                            elseif isReady('MA', "Geist Wall") and current:contains(bp.MA["Geist Wall"].id) then
                                add(bp.MA["Geist Wall"], target)
                                timers.hate = os.clock()
                            
                            -- SHEEP SONG.
                            elseif isReady('MA', "Sheep Song") and current:contains(bp.MA["Sheep Song"].id) then
                                add(bp.MA["Sheep Song"], target)
                                timers.hate = os.clock()
        
                            -- STINKING GAS.
                            elseif isReady('MA', "Stinking Gas") and current:contains(bp.MA["Stinking Gas"].id) then
                                add(bp.MA["Stinking Gas"], target)
                                timers.hate = os.clock()
                            
                            end
                            
                        end
        
                    end
        
                    if get('buffs') and _cast then

                        -- MIGHTY GUARD.
                        if get('unbridled learning') and isReady('JA', "Unbridled Learning") and not buff(485) and _act then

                            if get('diffusion') and isReady('MA', "Mighty Guard") and current:contains(bp.MA["Mighty Guard"].id) and not buff(604) then
                                add(bp.JA["Unbridled Learning"], player)
                                add(bp.JA["Diffusion"], player)
                                add(bp.MA["Mighty Guard"], player)

                            end
                            
                        end

                        -- HASTE.
                        if not buff(33) then

                            if player.main_job_level >= 99 and isReady('MA', "Erratic Flutter") and current:contains(bp.MA["Erratic Flutter"].id) then
                                add(bp.MA["Erratic Flutter"], player)

                            elseif player.main_job_level >= 99 and isReady('MA', "Animating Wail") and current:contains(bp.MA["Animating Wail"].id) then
                                add(bp.MA["Animating Wail"], player)

                            elseif player.main_job_level <= 48 and isReady('MA', "Refueling") and current:contains(bp.MA["Refueling"].id) then
                                add(bp.MA["Refueling"], player)

                            end

                        end

                        -- COCOON.
                        if isReady('MA', "Cocoon") and current:contains(bp.MA["Cocoon"].id) and not buff(93) then
                            add(bp.MA["Cocoon"], player)

                        -- NATURES MEDITATION.
                        elseif isReady('MA', "Nature's Meditation") and current:contains(bp.MA["Nature's Meditation"].id) and not buff(91) then
                            add(bp.MA["Nature's Meditation"], player)

                        -- MAGIC BARRIER.
                        elseif isReady('MA', "Magic Barrier") and current:contains(bp.MA["Magic Barrier"].id) and not buff(152) then
                            add(bp.MA["Magic Barrier"], player)

                        -- SALINE COAT.
                        elseif isReady('MA', "Saline Coat") and current:contains(bp.MA["Saline Coat"].id) and not buff(191) then
                            add(bp.MA["Saline Coat"], player)

                        -- OCCULTATION.
                        elseif isReady('MA', "Occultation") and current:contains(bp.MA["Occultation"].id) and not buff(36) and not bp.core.hasShadows() then
                            add(bp.MA["Occultation"], player)

                        end
                        helpers['buffs'].cast()
        
                    end

                    -- TICKLE.
                    if get('tickle').enabled and (os.clock()-timers.tickle) > get('tickle').delay then

                        if isReady('MA', "Feather Tickle") and current:contains(bp.MA["Feather Tickle"].id) then
                            add(bp.MA["Feather Tickle"], player)
                            timers.tickle = os.clock()

                        elseif isReady('MA', "Reaving Wind") and current:contains(bp.MA["Reaving Wind"].id) then
                            add(bp.MA["Reaving Wind"], player)
                            timers.tickle = os.clock()

                        end

                    end

                    -- MAGIC HAMMER.
                    if get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Magic Hammer") and current:contains(bp.MA["Magic Hammer"].id) then
                        add(bp.MA["Magic Hammer"], target)
                    end

                    -- WINDS OF PROMY.
                    if get('winds of promy.') and isReady('MA', "Winds of Promy.") and current:contains(bp.MA["Winds of Promy."].id) and helpers['status'].windsRemoval() then
                        add(bp.MA["Winds of Promy"], player)
                    end

                    -- DEBUFFS.
                    if get('debuffs') then
                        helpers['debuffs'].cast()

                    end

                elseif get('nuke') then

                    if get('hate').enabled and _cast then

                        -- JETTATURA.
                        if isReady('MA', "Jettatura") and current:contains(bp.MA["Jettatura"].id) then
                            add(bp.MA["Jettatura"], target)
                            
                        -- BLANK GAZE.
                        elseif isReady('MA', "Blank Gaze") and current:contains(bp.MA["Blank Gaze"].id) then
                            add(bp.MA["Blank Gaze"], target)

                        -- BLANK GAZE.
                        elseif isReady('MA', "Blank Gaze") and current:contains(bp.MA["Blank Gaze"].id) then
                            add(bp.MA["Blank Gaze"], target)
                            
                        end
                        
                        if get('hate').aoe and (os.clock()-timers.hate) > get('hate').delay then
                            
                            -- SOPORIFIC.
                            if isReady('MA', "Soporific") and current:contains(bp.MA["Soporific"].id) then
                                add(bp.MA["Soporific"], target)
                                timers.hate = os.clock()
                            
                            -- GEIST WALL.
                            elseif isReady('MA', "Geist Wall") and current:contains(bp.MA["Geist Wall"].id) then
                                add(bp.MA["Geist Wall"], target)
                                timers.hate = os.clock()
                            
                            -- SHEEP SONG.
                            elseif isReady('MA', "Sheep Song") and current:contains(bp.MA["Sheep Song"].id) then
                                add(bp.MA["Sheep Song"], target)
                                timers.hate = os.clock()
        
                            -- STINKING GAS.
                            elseif isReady('MA', "Stinking Gas") and current:contains(bp.MA["Stinking Gas"].id) then
                                add(bp.MA["Stinking Gas"], target)
                                timers.hate = os.clock()

                            -- ACTINIC BURST.
                            elseif isReady('MA', "Actinic Burst") and current:contains(bp.MA["Actinic Burst"].id) then
                                add(bp.MA["Actinic Burst"], target)
                                timers.hate = os.clock()
                            
                            end
                            
                        end
        
                    end
        
                    if get('buffs') and _cast then

                        -- MIGHTY GUARD.
                        if get('unbridled learning') and isReady('JA', "Unbridled Learning") and not buff(485) and _act then

                            if get('diffusion') and isReady('MA', "Mighty Guard") and current:contains(bp.MA["Mighty Guard"].id) and not buff(604) then
                                add(bp.JA["Unbridled Learning"], player)
                                add(bp.JA["Diffusion"], player)
                                add(bp.MA["Mighty Guard"], player)

                            end
                            
                        end

                        -- HASTE.
                        if not buff(33) then

                            if player.main_job_level >= 99 and isReady('MA', "Erratic Flutter") and current:contains(bp.MA["Erratic Flutter"].id) then
                                add(bp.MA["Erratic Flutter"], player)

                            elseif player.main_job_level >= 99 and isReady('MA', "Animating Wail") and current:contains(bp.MA["Animating Wail"].id) then
                                add(bp.MA["Animating Wail"], player)

                            elseif player.main_job_level <= 48 and isReady('MA', "Refueling") and current:contains(bp.MA["Refueling"].id) then
                                add(bp.MA["Refueling"], player)

                            end

                        end

                        -- COCOON.
                        if isReady('MA', "Cocoon") and current:contains(bp.MA["Cocoon"].id) and not buff(93) then
                            add(bp.MA["Cocoon"], player)

                        -- MOMENTO MORI.
                        elseif isReady('MA', "Momento Mori") and current:contains(bp.MA["Momento Mori"].id) and not buff(91) then
                            add(bp.MA["Nature's Meditation"], player)

                        -- MAGIC BARRIER.
                        elseif isReady('MA', "Magic Barrier") and current:contains(bp.MA["Magic Barrier"].id) and not buff(152) then
                            add(bp.MA["Magic Barrier"], player)

                        -- SALINE COAT.
                        elseif isReady('MA', "Saline Coat") and current:contains(bp.MA["Saline Coat"].id) and not buff(191) then
                            add(bp.MA["Saline Coat"], player)

                        -- OCCULTATION.
                        elseif isReady('MA', "Occultation") and current:contains(bp.MA["Occultation"].id) and not buff(36) and not bp.core.hasShadows() then
                            add(bp.MA["Occultation"], player)

                        end
                        helpers['buffs'].cast()
        
                    end

                    -- MAGIC HAMMER.
                    if get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Magic Hammer") and current:contains(bp.MA["Magic Hammer"].id) then
                        add(bp.MA["Magic Hammer"], target)
                    end

                    -- WINDS OF PROMY.
                    if get('winds of promy.') and isReady('MA', "Winds of Promy.") and current:contains(bp.MA["Winds of Promy."].id) and helpers['status'].windsRemoval() then
                        add(bp.MA["Winds of Promy"], player)
                    end

                    -- DEBUFFS.
                    if get('debuffs') then
                        helpers['debuffs'].cast()
                        
                    end

                    -- HANDLE NUKING.
                    if target and _cast then
                        
                        for nuke in T(private.nukes):it() do
                            
                            if isReady('MA', nuke) and current:contains(bp.MA[nuke].id) then
                                add(bp.MA[nuke], target)
                                break

                            end

                        end

                    end

                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target    = helpers['target'].getTarget() or false
                local current   = T(windower.ffxi.get_mjob_data().spells)
                local _act      = helpers['actions'].canAct()
                local _cast     = helpers['actions'].canCast()

                if not get('nuke') then

                    if target and get('hate').enabled and _cast then

                        -- JETTATURA.
                        if isReady('MA', "Jettatura") and current:contains(bp.MA["Jettatura"].id) then
                            add(bp.MA["Jettatura"], target)
                            
                        -- BLANK GAZE.
                        elseif isReady('MA', "Blank Gaze") and current:contains(bp.MA["Blank Gaze"].id) then
                            add(bp.MA["Blank Gaze"], target)
                            
                        end
                        
                        if get('hate').aoe and (os.clock()-timers.hate) > get('hate').delay then
                            
                            -- SOPORIFIC.
                            if isReady('MA', "Soporific") and current:contains(bp.MA["Soporific"].id) then
                                add(bp.MA["Soporific"], target)
                                timers.hate = os.clock()
                            
                            -- GEIST WALL.
                            elseif isReady('MA', "Geist Wall") and current:contains(bp.MA["Geist Wall"].id) then
                                add(bp.MA["Geist Wall"], target)
                                timers.hate = os.clock()
                            
                            -- SHEEP SONG.
                            elseif isReady('MA', "Sheep Song") and current:contains(bp.MA["Sheep Song"].id) then
                                add(bp.MA["Sheep Song"], target)
                                timers.hate = os.clock()
        
                            -- STINKING GAS.
                            elseif isReady('MA', "Stinking Gas") and current:contains(bp.MA["Stinking Gas"].id) then
                                add(bp.MA["Stinking Gas"], target)
                                timers.hate = os.clock()
                            
                            end
                            
                        end
        
                    end
        
                    if get('buffs') and _cast then

                        -- MIGHTY GUARD.
                        if target and get('unbridled learning') and isReady('JA', "Unbridled Learning") and not buff(485) and _act then

                            if get('diffusion') and isReady('MA', "Mighty Guard") and current:contains(bp.MA["Mighty Guard"].id) and not buff(604) then
                                add(bp.JA["Unbridled Learning"], player)
                                add(bp.JA["Diffusion"], player)
                                add(bp.MA["Mighty Guard"], player)

                            end
                            
                        end

                        -- HASTE.
                        if not buff(33) then

                            if player.main_job_level >= 99 and isReady('MA', "Erratic Flutter") and current:contains(bp.MA["Erratic Flutter"].id) then
                                add(bp.MA["Erratic Flutter"], player)

                            elseif player.main_job_level >= 99 and isReady('MA', "Animating Wail") and current:contains(bp.MA["Animating Wail"].id) then
                                add(bp.MA["Animating Wail"], player)

                            elseif player.main_job_level <= 48 and isReady('MA', "Refueling") and current:contains(bp.MA["Refueling"].id) then
                                add(bp.MA["Refueling"], player)

                            end

                        end

                        -- COCOON.
                        if isReady('MA', "Cocoon") and not buff(93) then
                            add(bp.MA["Cocoon"], player)

                        -- NATURES MEDITATION.
                        elseif target and isReady('MA', "Nature's Meditation") and current:contains(bp.MA["Nature's Meditation"].id) and not buff(91) then
                            add(bp.MA["Nature's Meditation"], player)

                        -- MAGIC BARRIER.
                        elseif isReady('MA', "Magic Barrier") and current:contains(bp.MA["Magic Barrier"].id) and not buff(152) then
                            add(bp.MA["Magic Barrier"], player)

                        -- SALINE COAT.
                        elseif isReady('MA', "Saline Coat") and current:contains(bp.MA["Saline Coat"].id) and not buff(191) then
                            add(bp.MA["Saline Coat"], player)

                        -- OCCULTATION.
                        elseif target and isReady('MA', "Occultation") and current:contains(bp.MA["Occultation"].id) and not buff(36) and not bp.core.hasShadows() then
                            add(bp.MA["Occultation"], player)

                        end
        
                    end

                    -- TICKLE.
                    if get('tickle').enabled and (os.clock()-timers.tickle) > get('tickle').delay then

                        if isReady('MA', "Feather Tickle") and current:contains(bp.MA["Feather Tickle"].id) then
                            add(bp.MA["Feather Tickle"], player)
                            timers.tickle = os.clock()

                        elseif isReady('MA', "Reaving Wind") and current:contains(bp.MA["Reaving Wind"].id) then
                            add(bp.MA["Reaving Wind"], player)
                            timers.tickle = os.clock()

                        end

                    end

                    -- MAGIC HAMMER.
                    if target and get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Magic Hammer") and current:contains(bp.MA["Magic Hammer"].id) then
                        add(bp.MA["Magic Hammer"], target)
                    end

                    -- WINDS OF PROMY.
                    if get('winds of promy.') and isReady('MA', "Winds of Promy.") and current:contains(bp.MA["Winds of Promy."].id) and helpers['status'].windsRemoval() then
                        add(bp.MA["Winds of Promy"], player)
                    end

                elseif get('nuke') then

                    if target and get('hate').enabled and _cast then

                        -- JETTATURA.
                        if isReady('MA', "Jettatura") and current:contains(bp.MA["Jettatura"].id) then
                            add(bp.MA["Jettatura"], target)
                            
                        -- BLANK GAZE.
                        elseif isReady('MA', "Blank Gaze") and current:contains(bp.MA["Blank Gaze"].id) then
                            add(bp.MA["Blank Gaze"], target)
                            
                        end
                        
                        if get('hate').aoe and (os.clock()-timers.hate) > get('hate').delay then
                            
                            -- SOPORIFIC.
                            if isReady('MA', "Soporific") and current:contains(bp.MA["Soporific"].id) then
                                add(bp.MA["Soporific"], target)
                                timers.hate = os.clock()
                            
                            -- GEIST WALL.
                            elseif isReady('MA', "Geist Wall") and current:contains(bp.MA["Geist Wall"].id) then
                                add(bp.MA["Geist Wall"], target)
                                timers.hate = os.clock()
                            
                            -- SHEEP SONG.
                            elseif isReady('MA', "Sheep Song") and current:contains(bp.MA["Sheep Song"].id) then
                                add(bp.MA["Sheep Song"], target)
                                timers.hate = os.clock()
        
                            -- STINKING GAS.
                            elseif isReady('MA', "Stinking Gas") and current:contains(bp.MA["Stinking Gas"].id) then
                                add(bp.MA["Stinking Gas"], target)
                                timers.hate = os.clock()
                            
                            end
                            
                        end
        
                    end
        
                    if get('buffs') and _cast then

                        -- MIGHTY GUARD.
                        if target and get('unbridled learning') and isReady('JA', "Unbridled Learning") and not buff(485) and _act then

                            if get('diffusion') and isReady('MA', "Mighty Guard") and current:contains(bp.MA["Mighty Guard"].id) and not buff(604) then
                                add(bp.JA["Unbridled Learning"], player)
                                add(bp.JA["Diffusion"], player)
                                add(bp.MA["Mighty Guard"], player)

                            end
                            
                        end

                        -- HASTE.
                        if not buff(33) then

                            if player.main_job_level >= 99 and isReady('MA', "Erratic Flutter") and current:contains(bp.MA["Erratic Flutter"].id) then
                                add(bp.MA["Erratic Flutter"], player)

                            elseif player.main_job_level >= 99 and isReady('MA', "Animating Wail") and current:contains(bp.MA["Animating Wail"].id) then
                                add(bp.MA["Animating Wail"], player)

                            elseif player.main_job_level <= 48 and isReady('MA', "Refueling") and current:contains(bp.MA["Refueling"].id) then
                                add(bp.MA["Refueling"], player)

                            end

                        end

                        -- COCOON.
                        if isReady('MA', "Cocoon") and not buff(93) then
                            add(bp.MA["Cocoon"], player)

                        -- MOMENTO MORI.
                        elseif target and isReady('MA', "Momento Mori") and current:contains(bp.MA["Momento Mori"].id) and not buff(91) then
                            add(bp.MA["Nature's Meditation"], player)

                        -- MAGIC BARRIER.
                        elseif isReady('MA', "Magic Barrier") and current:contains(bp.MA["Magic Barrier"].id) and not buff(152) then
                            add(bp.MA["Magic Barrier"], player)

                        -- SALINE COAT.
                        elseif isReady('MA', "Saline Coat") and current:contains(bp.MA["Saline Coat"].id) and not buff(191) then
                            add(bp.MA["Saline Coat"], player)

                        -- OCCULTATION.
                        elseif target and isReady('MA', "Occultation") and current:contains(bp.MA["Occultation"].id) and not buff(36) and not bp.core.hasShadows() then
                            add(bp.MA["Occultation"], player)

                        end
        
                    end

                    -- MAGIC HAMMER.
                    if target and get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Magic Hammer") and current:contains(bp.MA["Magic Hammer"].id) and _cast then
                        add(bp.MA["Magic Hammer"], target)
                    end

                    -- WINDS OF PROMY.
                    if get('winds of promy.') and isReady('MA', "Winds of Promy.") and current:contains(bp.MA["Winds of Promy."].id) and helpers['status'].windsRemoval() and _cast then
                        add(bp.MA["Winds of Promy"], player)
                    end

                    -- DEBUFFS.
                    if target and get('debuffs') then
                        helpers['debuffs'].cast()
                        
                    end

                    -- HANDLE NUKING.
                    if target and _cast then
                        
                        for nuke in T(private.nukes):it() do
                            
                            if isReady('MA', nuke) and current:contains(bp.MA[nuke].id) then
                                add(bp.MA[nuke], target)
                                break

                            end

                        end

                    end

                end

            end

        end
        
    end

    private.items = function()

    end

    return self

end
return job