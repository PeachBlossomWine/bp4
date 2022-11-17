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
        local player     = bp.player
        local helpers    = bp.helpers
        local isReady    = helpers['actions'].isReady
        local inQueue    = helpers['queue'].inQueue
        local buff       = helpers['buffs'].buffActive
        local addToFront = helpers['queue'].addToFront
        local add        = helpers['queue'].add
        local get        = bp.core.get

        do
            private.items()
            if bp and bp.player and bp.player.status == 1 then
                local target  = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
                local _act    = helpers['actions'].canAct()
                local _cast   = helpers['actions'].canCast()

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
                local _act    = helpers['actions'].canAct()
                local _cast   = helpers['actions'].canCast()

            end

        end
    end

    private.items = function()
    end

    return self

end
return job