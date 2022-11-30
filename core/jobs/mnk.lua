local job = {}
function job:init(bp, settings)

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON OUR GITHUB!\\cr', "20, 200, 125"))
        return
    end

    -- Private Variables.
    local flags     = {}
    local timers    = {}
    local sublogic  = bp.libs.__core.getSubjob(bp.player.sub_job)

    -- Private Methods.
    local useItems = function()

    end

    -- Public Methods.
    function self:automate()

        useItems()
        if bp.player.status == 1 then

        elseif bp.player.status == 0 then

            sublogic.hate(bp, settings, self)
            sublogic.buffs(bp, settings, self)

        end

    end

    -- Private Events.
    
    return self

end
return job