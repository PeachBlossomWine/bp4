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

        -- Metatable Functions.
        mt.__index = function(t, k)
            
            if rawget(data, k) ~= nil then
                return rawget(data, k)

            elseif data.core then
                
                if rawget(data.core, k) ~= nil then
                    return rawget(data.core, k)

                elseif data.core[bp.player.sub_job] ~= nil then
                    return rawget(data.core[bp.player.sub_job], k)

                elseif data.core[bp.player.main_job] ~= nil then
                    return rawget(data.core[bp.player.main_job], k)

                end

            else
                return nil

            end

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

        return setmetatable(settings, mt)

    end

    return self

end
return library