local library = {}
function library:new(bp)
    local bp = bp

    self.new = function(setting)
        local settings, mt = {}, {}

        -- Private Object Variables.
        local name = setting
        local file = bp.files.new(string.format('core/settings/%s/%s.lua', bp.player.name:lower(), setting:lower()))
        local data = file and file:exists() and dofile(string.format('%score/settings/%s/%s.lua', windower.addon_path, bp.player.name:lower(), setting:lower())) or {}

        -- Public Object Variables.
        settings.display    = false
        settings.isNew      = data and T(data):length() == 0 and true or false

        -- Public Object Methods.
        function settings:get() return data:copy() end
        function settings:save()
            file:write(string.format('return %s', T(data):tovstring()))
            return self

        end

        function settings:saveDisplay(x, y, param)

            if settings.display then

                if param == 1 and settings.display:hover(x, y) then
                    return true
    
                elseif param == 2 and settings.display:hover(x, y) then
                    settings:save()
                    return true
    
                end

            end

        end

        function settings:getDisplay()
            return not self.display and bp.libs.__displays.new(self.layout) or self.display
        end

        -- Private Events.
        windower.register_event('mouse', function(param, x, y) settings:saveDisplay(x, y, param) end)

        -- Metatable Functions.
        mt.__index = function(t, k)
            
            if rawget(data, k) ~= nil then
                return rawget(data, k)

            elseif data.core then

                if rawget(data.core, k) ~= nil then
                    return rawget(data.core, k)

                elseif data.core[bp.player.sub_job] ~= nil and rawget(data.core[bp.player.sub_job], k) ~= nil then
                    return rawget(data.core[bp.player.sub_job], k)

                elseif data.core[bp.player.main_job] ~= nil and rawget(data.core[bp.player.main_job], k) ~= nil then
                    return rawget(data.core[bp.player.main_job], k)

                end

            end
            return nil

        end

        mt.__newindex = function(t, k, v)

            if name:sub(1, 5) == 'jobs/' then

                if k == 'core' then
                    rawset(data, k, v)

                elseif data.core then
                    
                    if data.core[k] ~= nil then
                        rawset(data.core, k, v)
    
                    elseif data.core[bp.player.sub_job] and data.core[bp.player.sub_job][k] ~= nil then
                        rawset(data.core[bp.player.sub_job], k, v)
    
                    elseif data.core[bp.player.main_job] and data.core[bp.player.main_job][k] ~= nil then
                        rawset(data.core[bp.player.main_job], k, v)
    
                    end

                end
            
            else
                rawset(data, k, v)

            end

        end

        mt.__call = function(t, k)
            
            if k then

            elseif k == nil then

                if not data.core then

                else
                    return T(data.core)

                end

            end

        end

        return setmetatable(settings, mt)

    end

    return self

end
return library