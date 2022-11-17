local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local settings = bp.libs.__settings.new(string.format("jobs/%s", bp.player.main_job))

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local automation = {main=nil, sub=bp.libs.__core.loadSubLogic(bp.player.sub_job)}
        local __d = bp.libs.__distance
        local __a = bp.libs.__actions
        local __t = bp.libs.__target
        local __p = bp.libs.__party
        local __q = bp.libs.__queue
        local __b = bp.libs.__buffs

        do -- Private Settings.
            settings.core = T(settings.core) or bp.libs.__core.newSettings()

            do -- Update settings if a new version was detected, then save them.
                coroutine.schedule(function()
                    bp.libs.__core.updateSettings(settings.core)
                    coroutine.schedule(function()
                        settings:save()

                    end, 1)

                end, 1)
            
            end

        end

        -- Private Methods.
        
        -- Public Methods.
        new.handleAutomation = function()
        
            if bp.player and __q.isReady() then
                print('test')
            end
    
        end

        new.set = function(commands)
            bp.libs.__core.set(settings, commands)
            settings:save()

        end
        
        new.get = function(name)
            return bp.libs.__core.get(settings, name)
        end
        
        -- Private Events.
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == '?' and #commands > 0 then
                new.set(commands)
            end
    
        end)

        helper('job change', function(new, old)
            settings:save()

            if bp.player.main_job_id ~= new then
                settings = bp.libs.__settings.new(string.format("jobs/%s", bp.res.jobs[new].ens))

                do -- Reload the helper after updating the settings.
                    bp.helpers:reload('core')

                end

            end

        end)

        return new

    end

    return helper

end
return buildHelper