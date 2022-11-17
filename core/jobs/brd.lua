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
    local timers    = {sleep=0}
    local flags     = {}

    do
        flags.__sleep = false
        flags.__count = 2

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
    
                if get('buffs') and _cast then
                    helpers['songs'].playJukebox()
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
    
                if get('buffs') and _cast then
                    helpers['songs'].playJukebox()  
                    helpers['buffs'].cast()  
                    
                end

                -- DEBUFFS.
                if target and get('debuffs') then
                    helpers['debuffs'].cast()                    
                end

                -- AUTO-HORDE
                if _cast and bp.helpers['aggro'] and flags.__sleep and (os.clock()-timers.sleep) > 12 then
                    local aggro = bp.helpers['aggro'].getAggro()

                    if aggro and #aggro > flags.__count and (isReady('MA', "Horde Lullaby") or isReady('MA', "Horde Lullaby II")) then
                        local target = windower.ffxi.get_mob_by_id(aggro[1]) or false

                        if target then

                            if isReady('MA', "Horde Lullaby II") then
                                helpers['queue'].addToFront(bp.MA["Horde Lullaby II"], target)
                                timers.sleep = os.clock()

                            elseif isReady('MA', "Horde Lullaby") then
                                helpers['queue'].addToFront(bp.MA["Horde Lullaby"], target)
                                timers.sleep = os.clock()

                            end

                        end

                    end

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

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = table.remove(commands, 1)

        if bp and bp.player and helper and helper:lower() == 'brd' then
            local command = commands[1] and table.remove(commands, 1):lower()

            if command then

                if command == 'sleep' then

                    if commands[1] then
                        local option = commands[1] and table.remove(commands, 1):lower()

                        if option == '!' then
                            flags.__sleep = true

                        elseif option == '#' then
                            flags.__sleep = false

                        end

                    else
                        flags.__sleep = flags.__sleep ~= true and true or false

                    end
                    bp.helpers['popchat'].pop(string.format('AUTO HORDE-LULLABY: %s.', tostring(flags.__sleep)))

                end

            end

        end

    end)

    return self

end
return job