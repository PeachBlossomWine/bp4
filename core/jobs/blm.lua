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

    self.magicBurst = function()
        -- NEED TO ADD MAGIC BURST LOGIC IN THE FUTURE.
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
                local target  = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
                local _act    = helpers['actions'].canAct()
                local _cast   = helpers['actions'].canCast()

                if get('ja') and _act then

                    if helpers['enmity'].hasEnmity(player) then

                        -- MANA WALL.
                        if get('mana wall') and isReady('JA', "Mana Wall") then
                            add(bp.JA["Mana Wall"], player)
                        end

                        -- ENMITY DOUSE.
                        if get('enmity douse') and isReady('JA', "Enmity Douse") then
                            add(bp.JA["Enmity Douse"], player)
                        end

                    end

                end
                
                if get('buffs') then

                    if get('burst') and _cast then

                        -- ELEMENTAL SEAL.
                        if get('elemental seal') and isReady('JA', "Elemental Seal") then
                            add(bp.JA["Elemental Seal"], player)
                        end

                        -- CASCADE.
                        if get('cascade').enabled and isReady('JA', "Cascade") and player['vitals'].tp > get('cascade').tp then
                            add(bp.JA["Cascade"], player)
                        end

                        -- MANAWELL.
                        if get('manawell') and isReady('JA', "Manawell") then
                            add(bp.JA["Manawell"], player)
                        end

                    end
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
                    
                    if isReady('MA', "Aspir II") then
                        add(bp.MA["Drain II"], target)

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

                if get('ja') and _act then

                    if helpers['enmity'].hasEnmity(player) then

                        -- MANA WALL.
                        if get('mana wall') and isReady('JA', "Mana Wall") then
                            add(bp.JA["Mana Wall"], player)
                        end

                        -- ENMITY DOUSE.
                        if get('enmity douse') and isReady('JA', "Enmity Douse") then
                            add(bp.JA["Enmity Douse"], player)
                        end

                    end

                end
                
                if get('buffs') then

                    if target and get('burst') and _cast then

                        -- ELEMENTAL SEAL.
                        if get('elemental seal') and isReady('JA', "Elemental Seal") then
                            add(bp.JA["Elemental Seal"], player)
                        end

                        -- CASCADE.
                        if get('cascade').enabled and isReady('JA', "Cascade") and player['vitals'].tp > get('cascade').tp then
                            add(bp.JA["Cascade"], player)
                        end

                        -- MANAWELL.
                        if get('manawell') and isReady('JA', "Manawell") then
                            add(bp.JA["Manawell"], player)
                        end

                    end
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
                    
                    if isReady('MA', "Aspir II") then
                        add(bp.MA["Drain II"], target)

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