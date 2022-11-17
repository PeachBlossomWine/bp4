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

                    -- QUICK DRAW.
                    if get('quick draw').enabled and isReady('JA', get('quick draw').name) then

                        if bp.helpers['inventory'].getItemCount('Trump Card', 0) > 0 then
                            add(bp.JA[get('quick draw').name], target)

                        elseif bp.helpers['inventory'].getItemCount('Trump Card Case', 0) > 0 then
                            add(bp.IT["Trump Card Case"], player)

                        end
    
                    -- RANDOM DEAL.
                    elseif get('random deal') and isReady('JA', "Random Deal") then
                        add(bp.JA["Random Deal"], player)
    
                    end
    
                end
    
                if get('buffs') and _act then
    
                    -- ROLLS.
                    if get('rolls') then
                        bp.helpers['rolls'].roll()
    
                    -- TRIPLE SHOT.
                    elseif get('ra').enabled and isReady('JA', "Triple Shot") and not buff(467) then
                        add(bp.JA["Triple Shot"], player)
    
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

                if get('ja') and _act then

                    -- QUICK DRAW.
                    if target and get('quick draw').enabled and isReady('JA', get('quick draw').name) then
                        
                        if bp.helpers['inventory'].getItemCount('Trump Card', 0) > 0 then
                            add(bp.JA[get('quick draw').name], target)

                        elseif bp.helpers['inventory'].getItemCount('Trump Card Case', 0) > 0 then
                            add(bp.IT["Trump Card Case"], player)

                        end
    
                    -- RANDOM DEAL.
                    elseif get('random deal') and isReady('JA', "Random Deal") then
                        add(bp.JA["Random Deal"], player)
    
                    end
    
                end
    
                if get('buffs') and _act then
    
                    -- ROLLS.
                    if get('rolls') then
                        bp.helpers['rolls'].roll()
    
                    -- TRIPLE SHOT.
                    elseif target and get('ra').enabled and isReady('JA', "Triple Shot") and not buff(467) then
                        add(bp.JA["Triple Shot"], player)
    
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

    end

    return self

end
return job