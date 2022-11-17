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

                if get('ja') and _act then

                    -- CONVERT.
                    if get('convert').enabled and player['vitals'].hpp >= get('convert').hpp and player['vitals'].mpp <= get('convert').mpp then
                                    
                        if isReady('JA', "Convert") then
                            add(bp.JA["Convert"], player)
                        end
                        
                    end

                    -- SABOTEUR.
                    if get('debuffs') and get('saboteur') and isReady('JA', "Saboteur") and not buff(454) then
                        add(bp.JA["Saboteur"], player)
                    end

                    -- SPONTANEITY.
                    if get('spontaneity') and isReady('JA', "Spontaneity") and not buff(230) and get('buffs') then
                        add(bp.JA["Spontaneity"], player)
                    end
    
                end
    
                if get('buffs') then

                    if get('composure') and not buff(419) then

                        -- SABOTEUR.
                        if get('composure') and isReady('JA', "Composure") and not buff(419) then
                            add(bp.JA["Composure"], player)
                        end

                    elseif (not get('composure') or buff(419)) and _cast then
                    
                        -- HASTE.
                        if not buff(33) and player.main_job_level >= 48 then
                            
                            if player.main_job_level >= 96 and isReady('MA', "Haste II") then
                                add(bp.MA["Haste II"], player)

                            elseif player.main_job_level < 96 and isReady('MA', "Haste") then
                                add(bp.MA["Haste"], player)

                            end
                        
                        end

                        -- TEMPER.
                        if not buff(432) and player.main_job_level >= 95 then

                            if player.job_points['rdm'].jp_spent >= 99 and isReady('MA', "Temper II") then
                                add(bp.MA["Temper II"], player)

                            elseif player.job_points['rdm'].jp_spent < 99 and isReady('MA', "Temper") then
                                add(bp.MA["Temper"], player)

                            end

                        end

                        -- GAINS.
                        if get('gain').enabled and not bp.core.hasBoost() and isReady('MA', get('gain').name) then
                            add(bp.MA[get('gain').name], player)                                                
                        end
                        
                        -- PHALANX.
                        if isReady('MA', "Phalanx") and not buff(116) then
                            add(bp.MA["Phalanx"], player)
                            
                        -- REFRESH.
                        elseif not buff(43) and (not buff(187) or not buff(188)) then

                            if player.job_points['rdm'].jp_spent >= 1200 and isReady('MA', "Refresh III") then
                                add(bp.MA["Refresh III"], player)

                            elseif player.main_job_level >= 82 and player.job_points['rdm'].jp_spent < 1200 and isReady('MA', "Refresh II") then
                                add(bp.MA["Refresh II"], player)

                            elseif player.main_job_level < 82 and player.job_points['rdm'].jp_spent < 1200 and isReady('MA', "Refresh") then
                                add(bp.MA["Refresh"], player)
                            
                            end
        
                        -- ENSPELLS.
                        elseif get('en').enabled and not bp.core.hasEnspell() then
                                
                            if isReady('MA', get('en').name) then
                                add(bp.MA[get('en').name], player)
                            end
                            
                        end
                        helpers['buffs'].cast()

                    end
    
                end

                -- DEBUFFS.
                if get('debuffs') and _cast then

                    if get('saboteur') and buff(454) then
                        helpers['debuffs'].cast()

                    elseif get('saboteur') and not buff(454) and not isReady('JA', 'Saboteur') then
                        helpers['debuffs'].cast()

                    elseif not get('saboteur') then
                        helpers['debuffs'].cast()

                    end

                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = helpers['actions'].canAct()
                local _cast   = helpers['actions'].canCast()

                if get('ja') and _act then

                    -- CONVERT.
                    if get('convert').enabled and player['vitals'].hpp >= get('convert').hpp and player['vitals'].mpp <= get('convert').mpp then
                                    
                        if isReady('JA', "Convert") then
                            add(bp.JA["Convert"], player)                        
                        end
                        
                    end

                    -- SABOTEUR.
                    if target and get('debuffs') and get('saboteur') and isReady('JA', "Saboteur") and not buff(454) then
                        add(bp.JA["Saboteur"], player)
                    end

                    -- SPONTANEITY.
                    if target and get('spontaneity') and isReady('JA', "Spontaneity") and not buff(230) and get('buffs') then
                        add(bp.JA["Spontaneity"], player)
                    end
    
                end
    
                if get('buffs') then

                    if get('composure') and not buff(419) then

                        -- SABOTEUR.
                        if get('composure') and isReady('JA', "Composure") and not buff(419) then
                            add(bp.JA["Composure"], player)
                        end

                    elseif (not get('composure') or buff(419)) and _cast then
                    
                        -- HASTE.
                        if not buff(33) and player.main_job_level >= 48 then
                            
                            if player.main_job_level >= 96 and isReady('MA', "Haste II") then
                                add(bp.MA["Haste II"], player)

                            elseif player.main_job_level < 96 and isReady('MA', "Haste") then
                                add(bp.MA["Haste"], player)

                            end
                        
                        end

                        -- GAINS.
                        if get('gain').enabled and not bp.core.hasBoost() and isReady('MA', get('gain').name) then
                            add(bp.MA[get('gain').name], player)                                                
                        end
                        
                        -- PHALANX.
                        if isReady('MA', "Phalanx") and not buff(116) then
                            add(bp.MA["Phalanx"], player)
                            
                        -- REFRESH.
                        elseif not buff(43) and (not buff(187) or not buff(188)) then

                            if player.job_points['rdm'].jp_spent >= 1200 and isReady('MA', "Refresh III") then
                                add(bp.MA["Refresh III"], player)

                            elseif player.main_job_level >= 82 and player.job_points['rdm'].jp_spent < 1200 and isReady('MA', "Refresh II") then
                                add(bp.MA["Refresh II"], player)

                            elseif player.main_job_level < 82 and player.job_points['rdm'].jp_spent < 1200 and isReady('MA', "Refresh") then
                                add(bp.MA["Refresh"], player)
                            
                            end
                            
                        -- STONESKIN.
                        elseif get('stoneskin') and isReady('MA', "Stoneskin") and not buff(37) then
                            add(bp.MA["Stoneskin"], player)
        
                        -- AQUAVEIL.
                        elseif get('aquaveil') and isReady('MA', "Aquaveil") and not buff(39) then
                            add(bp.MA["Aquaveil"], player)
        
                        -- BLINK.
                        elseif get('blink') and isReady('MA', "Blink") and not get('utsusemi') and not buff(36) and not bp.core.hasShadows() then
                            add(bp.MA["Blink"], player)
                            
                        -- SPIKES.
                        elseif isReady('MA', get('spikes').name) and not bp.core.hasSpikes() then
                            add(bp.MA[get('spikes')], player)
                            
                        end

                    end
                    helpers['buffs'].cast()
    
                end

                if target and get('debuffs') and _cast then

                    if get('saboteur') and buff(454) then
                        helpers['debuffs'].cast()

                    elseif get('saboteur') and not buff(454) and not isReady('JA', 'Saboteur') then
                        helpers['debuffs'].cast()

                    elseif not get('saboteur') then
                        helpers['debuffs'].cast()

                    end

                end

            end

        end
        
    end

    private.items = function()

    end

    -- Private Events.
    private.events.actions = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
        
        if bp and id == 0x028 then
            local pack      = bp.packets.parse('incoming', original)
            local actor     = windower.ffxi.get_mob_by_id(pack['Actor'])
            local target    = windower.ffxi.get_mob_by_id(pack['Target 1 ID'])
            local count     = pack['Target Count']
            local category  = pack['Category']
            local param     = pack['Param']
            local player    = bp.player
            
            if player and actor and target then

                -- Finish Job Ability.
                if pack['Category'] == 6 and player.id == actor.id and bp.res.job_abilities[param] and bp.res.job_abilities[param].en == 'Saboteur' then
                    --bp.helpers['debuffs'].reset() Reset?
                end

            end

        end

    end)

    private.events.timechange = windower.register_event('time change', function()
        local isReady   = bp.helpers['actions'].isReady
        local add       = bp.helpers['queue'].add

        if bp and bp.helpers['target'].getTarget() then
            local target = bp.helpers['target'].getTarget()

            if target and target.name == 'Brimboil' and not T{2,3}:contains(target.status) then

                if isReady('MA', "Blizzard") and bp.helpers['actions'].canCast() then
                    add(bp.MA["Blizzard"], target)
                end

            end

        end

    end)

    private.events.jobchange = windower.register_event('job change', function()
        
        for _,id in pairs(private.events) do
            windower.unregister_event(id)
        end

    end)

    return self

end
return job