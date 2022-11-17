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
    local timers    = {}
    local flags     = {}

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
                local target  = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
                local _act    = helpers['actions'].canAct()
                local _cast   = helpers['actions'].canCast()

                -- RERAISE.
                if not buff(113) and _cast then

                    if player.job_points['whm'].jp_spent >= 100 and isReady('MA', "Reraise IV") then
                        add(bp.MA["Reraise IV"], player)

                    elseif player.job_points['whm'].jp_spent < 100 then

                        if isReady('MA', "Reraise III") then
                            add(bp.MA["Reraise III"], player)

                        elseif isReady('MA', "Reraise II") then
                            add(bp.MA["Reraise II"], player)

                        elseif isReady('MA', "Reraise") then
                            add(bp.MA["Reraise"], player)

                        end

                    end

                end

                if get('ja') and _act then

                    -- MARTYR.
                    if get('martyr').enabled and get('martyr').target ~= "" and isReady('JA', "Martyr") then
                        local target = windower.ffxi.get_mob_by_name(get('martyr').target)

                        if target and helpers['party'].isInParty(target) and target.hpp <= get('martyr').hpp and player['vitals'].hpp > 30 then
                            add(bp.JA["Martyr"], target)
                        end

                    end

                    -- DEVOTION.
                    if get('devotion').enabled and get('devotion').target ~= "" and isReady('JA', "Devotion") then
                        local target = windower.ffxi.get_mob_by_name(get('devotion').target)

                        if target and helpers['party'].isInParty(target) and target.mpp <= get('devotion').mpp and player['vitals'].hpp > 30 then
                            add(bp.JA["Devotion"], target)
                        end

                    end

                end

                if get('buffs') then

                    if not buff(417) and not buff(418) and _act then

                        -- AFFLATUS.
                        if not get('misery') and isReady('JA', "Afflatus Solace") then
                            add(bp.JA["Afflatus Solace"], player)

                        elseif get('misery') and isReady('JA', "Afflatus Misery") then
                            add(bp.JA["Afflatus Misery"], player)

                        end

                    else

                        if _cast then

                            -- BOOSTS.
                            if get('boost').enabled and not bp.core.hasBoost() and isReady('MA', get('boost').name) then
                                add(bp.MA[get('boost').name], player)

                            -- STONESKIN.
                            elseif get('stoneskin') and not helpers['buffs'].buffActive(37) and isReady('MA', "Stoneskin") then
                                add(bp.MA["Stoneskin"], player)
            
                            -- BLNK.
                            elseif get('blink') and not get('utsusemi') and not helpers['buffs'].buffActive(36) and isReady('MA', "Blink") then
                                add(bp.MA["Blink"], player)
            
                            -- AQUAVEIL.
                            elseif get('aquaveil') and isReady('MA', "Aquaveil") and not buff(39) then
                                add(bp.MA["Aquaveil"], player)
            
                            end
                            helpers['buffs'].cast()

                        end

                        if _act then

                            -- SACROSANCTITY.
                            if get('sacrosanctity') and isReady('JA', "Sacrosanctity") and not buff(477) then
                                add(bp.JA["Sacrosanctity"], player)
                            end

                        end

                    end
    
                end

                -- DEBUFFS.
                if get('debuffs') then
                    helpers['debuffs'].cast()
                    
                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = helpers['actions'].canAct()
                local _cast   = helpers['actions'].canCast()

                -- RERAISE.
                if not buff(113) and _cast then

                    if player.job_points['whm'].jp_spent >= 100 and isReady('MA', "Reraise IV") then
                        add(bp.MA["Reraise IV"], player)

                    elseif player.job_points['whm'].jp_spent < 100 then

                        if isReady('MA', "Reraise III") then
                            add(bp.MA["Reraise III"], player)

                        elseif isReady('MA', "Reraise II") then
                            add(bp.MA["Reraise II"], player)

                        elseif isReady('MA', "Reraise") then
                            add(bp.MA["Reraise"], player)

                        end

                    end

                end

                if get('ja') and _act then

                    -- MARTYR.
                    if get('martyr').enabled and get('martyr').target ~= "" and isReady('JA', "Martyr") then
                        local target = windower.ffxi.get_mob_by_name(get('martyr').target) or false

                        if target and helpers['party'].isInParty(target) then
                            local member = helpers['party'].getMember(target) or false

                            if member and member.mpp and member.mpp <= get('martyr').hpp and player['vitals'].hpp > 30 then
                                add(bp.JA["Martyr"], target)
                            end
                            
                        end

                    end

                    -- DEVOTION.
                    if get('devotion').enabled and get('devotion').target ~= "" and isReady('JA', "Devotion") then
                        local target = windower.ffxi.get_mob_by_name(get('devotion').target) or false
                        
                        if target and helpers['party'].isInParty(target) then
                            local member = helpers['party'].getMember(target) or false

                            if member and member.mpp and member.mpp <= get('devotion').mpp and player['vitals'].hpp > 30 then
                                add(bp.JA["Devotion"], target)
                            end

                        end

                    end

                end

                if get('buffs') then

                    if not buff(417) and not buff(418) and _act then

                        -- AFFLATUS.
                        if not get('misery') and isReady('JA', "Afflatus Solace") then
                            add(bp.JA["Afflatus Solace"], player)

                        elseif get('misery') and isReady('JA', "Afflatus Misery") then
                            add(bp.JA["Afflatus Misery"], player)

                        end

                    else

                        if _cast then

                            -- BOOSTS.
                            if get('boost').enabled and not bp.core.hasBoost() and isReady('MA', get('boost').name) then
                                add(bp.MA[get('boost').name], player)

                            -- STONESKIN.
                            elseif get('stoneskin') and not helpers['buffs'].buffActive(37) and isReady('MA', "Stoneskin") then
                                add(bp.MA["Stoneskin"], player)
            
                            -- BLNK.
                            elseif get('blink') and not get('utsusemi') and not helpers['buffs'].buffActive(36) and isReady('MA', "Blink") then
                                add(bp.MA["Blink"], player)
            
                            -- AQUAVEIL.
                            elseif get('aquaveil') and isReady('MA', "Aquaveil") and not buff(39) then
                                add(bp.MA["Aquaveil"], player)
            
                            end
                            helpers['buffs'].cast()

                        end

                        if _act then

                            -- SACROSANCTITY.
                            if get('sacrosanctity') and isReady('JA', "Sacrosanctity") and not buff(477) then
                                add(bp.JA["Sacrosanctity"], player)
                            end

                        end

                    end
    
                end

                -- DEBUFFS.
                if target and get('debuffs') then
                    helpers['debuffs'].cast()
                    
                end

            end

        end
        
    end

    private.items = function()
        local _act    = bp.helpers['actions'].canAct()
        local _cast   = bp.helpers['actions'].canCast()
        local _item   = bp.helpers['actions'].canItem()
        local add     = bp.helpers['queue'].addToFront
        local buffs   = T(bp.player.buffs)

        if _item then

            if buffs:contains(6) then
                add(bp.IT["Echo Drops"], bp.player)
            end

        end

    end

    return self

end
return job