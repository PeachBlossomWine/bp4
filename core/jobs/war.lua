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
    local timers    = {warcry=0}
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

                if get('hate').enabled then

                    -- PROVOKE.
                    if get('provoke') and isReady('JA', "Provoke") and _act then
                        add(bp.JA["Provoke"], target)
                    end
    
                end

                if get('ja') and _act then

                    -- TOMAHAWK.
                    if get('tomahawk') and isReady('JA', "Tomahawk") then
                        add(bp.JA["Tomahawk"], target)
                    end

                end
    
                if get('buffs') and _act then

                    -- 1 HOURS.
                    if get('1hr') and not buff(44) and not buff(490) and isReady('JA', "Mighty Strikes") and isReady('JA', "Brazen Rush") then
                        add(bp.JA["Mighty Strikes"], player)
                        add(bp.JA["Brazen Rush"], player)

                    end
    
                    -- BERSERK.
                    if not get('tank') and get('berserk') and isReady('JA', "Berserk") and not buff(56) then
                        add(bp.JA["Berserk"], player)
    
                    -- DEFENDER.
                    elseif get('tank') and get('defender') and isReady('JA', "Defender") and not buff(57) then
                        add(bp.JA["Defender"], player)
    
                    -- WARCRY.
                    elseif get('warcry') and isReady('JA', "Warcry") and not buff(68) and not buff(460) and (os.clock()-timers.warcry) > 3 then
                        add(bp.JA["Warcry"], player)
                        timers.warcry = os.clock()
    
                    -- AGGRESSOR.
                    elseif get('aggressor') and isReady('JA', "Aggressor") and not buff(58) then
                        add(bp.JA["Aggressor"], player)
    
                    -- RETALIATION.
                    elseif get('retaliation') and isReady('JA', "Retaliation") and not buff(405) then
                        add(bp.JA["Retaliation"], player)

                    -- RESTRAINT.
                    elseif get('restraint') and isReady('JA', "Restraint") and not buff(435) then
                        add(bp.JA["Restraint"], player)

                    -- BLOOD RAGE.
                    elseif get('blood rage') and isReady('JA', "Blood Rage") and not buff(68) and not buff(460) and (os.clock()-timers.warcry) > 3 then
                        add(bp.JA["Blood Rage"], player)
                        timers.warcry = os.clock()
    
                    end

                    -- WARRIORS CHARGE.
                    if get('warrior\'s charge') and isReady('JA', "Warrior's Charge") and player['vitals'].tp >= get('ws').tp and (not get('am') or bp.helpers['aftermath'].hasAftermath()) then
                        add(bp.JA["Warrior's Charge"], player)
                    end
                    helpers['buffs'].cast()
    
                end 
                
                -- DEBUFFS.
                if get('debuffs') then
                    helpers['debuffs'].cast()
                    
                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = helpers['actions'].canAct()
                local _cast   = helpers['actions'].canCast()

                if get('hate').enabled then

                    -- PROVOKE.
                    if target and get('provoke') and _act and isReady('JA', "Provoke") then
                        add(bp.JA["Provoke"], target)
                    end
    
                end

                if get('ja') and _act then

                    -- TOMAHAWK.
                    if get('tomahawk') and isReady('JA', "Tomahawk") then
                        add(bp.JA["Tomahawk"], target)
                    end

                end
    
                if get('buffs') and _act then
    
                    -- DEFENDER.
                    if target and get('tank') and get('defender') and isReady('JA', "Defender") and not buff(57) then
                        add(bp.JA["Defender"], player)
    
                    -- RETALIATION.
                    elseif get('retaliation') and isReady('JA', "Retaliation") and not buff(405) then
                        add(bp.JA["Retaliation"], player)
    
                    end
                    helpers['buffs'].cast()
    
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

            if buffs:contains(15) and bp.helpers['inventory'].hasItem("Holy Water", 0) then
                add(bp.IT["Holy Water"], bp.player)

            elseif buffs:contains(6) and bp.helpers['inventory'].hasItem("Echo Drops", 0) then
                add(bp.IT["Echo Drops"], bp.player)

            elseif (buffs:contains(149) or buffs:contains(558)) and bp.helpers['inventory'].hasItem("Panacea", 0) then
                add(bp.IT["Panacea"], bp.player)

            end

        end

    end

    return self

end
return job