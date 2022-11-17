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

                if get('buffs') and _cast then
                    helpers['bubbles'].handle(target)
                    helpers['buffs'].cast()
                    
                end

                -- DRAIN.
                if target and get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and _cast then

                    if isReady('MA', "Drain") then
                        add(bp.MA["Drain"], target)
                    end

                end

                -- ASPIR.
                if target and get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and _cast then
                    
                    if isReady('MA', "Aspir III") then
                        add(bp.MA["Aspir III"], target)

                    elseif isReady('MA', "Aspir II") then
                        add(bp.MA["Aspir II"], target)

                    elseif isReady('MA', "Aspir") then
                        add(bp.MA["Aspir"], target)
                        
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

                if get('buffs') and _cast then
                    helpers['bubbles'].handle(target)
                    helpers['buffs'].cast()

                end

                -- DRAIN.
                if target and get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and _cast then

                    if isReady('MA', "Drain") then
                        add(bp.MA["Drain"], target)
                    end

                end

                -- ASPIR.
                if target and get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and _cast then
                    
                    if isReady('MA', "Aspir III") then
                        add(bp.MA["Aspir III"], target)

                    elseif isReady('MA', "Aspir II") then
                        add(bp.MA["Aspir II"], target)

                    elseif isReady('MA', "Aspir") then
                        add(bp.MA["Aspir"], target)
                        
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

    end

    -- Private Events.
    private.events.timechange = windower.register_event('time change', function()

        if bp and bp.helpers['target'].getTarget() then
            local target = bp.helpers['target'].getTarget()

            if target and target.name == 'Brimboil' and not T{2,3}:contains(target.status) then

                if isReady('MA', "Blizzard") and helpers['actions'].canCast() then
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