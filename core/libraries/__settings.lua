local library = {}
function library:new(bp)
    local bp = bp

    -- Public Methods.
    self.new = function(setting)
        local object = {}

        -- Private Object Variables.
        local name = setting
        local file = bp.files.new(string.format('core/settings/%s/%s.lua', bp.player.name:lower(), setting:lower()))
        local data = file and file:exists() and dofile(string.format('%score/settings/%s/%s.lua', windower.addon_path, bp.player.name:lower(), setting:lower())) or {}

        -- Public Object Variables.
        object.display  = false

        -- Public Object Methods.
        function object:save()
            file:write(string.format('return %s', T(data):tovstring()))
            return self

        end

        function object:saveDisplay(x, y, param)

            if self.display then

                if param == 1 and self.display:hover(x, y) then
                    return true
    
                elseif param == 2 and self.display:hover(x, y) then
                    self:save()
                    return true
    
                end

            end

        end

        return setmetatable(object, {
            __newindex = function(t, k, v)
                
                if data[k] then
                    data[k] = v
                end

            end,

            __index = function(t, k)

                if data[k] then
                    return data[k]
                end

            end

        })

    end

    return self

end
return library