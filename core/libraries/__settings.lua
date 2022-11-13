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
        settings.display  = false

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

        -- Metatable Functions.
        mt.__index = function(t, k)

            if rawget(data, k) then
                return rawget(data, k)
            else
                return nil

            end

        end

        mt.__newindex = function(t, k, v)
            rawset(data, k, v)
        end

        return setmetatable(settings, mt)

    end

    return self

end
return library