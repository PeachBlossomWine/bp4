local library = {}
function library:new(bp)
    local bp = bp

    -- Private Variables.
    local resolution    = {x=windower.get_windower_settings().x_res, y=windower.get_windower_settings().y_res}
    local settings      = {pos={x=1, y=1}, bg={alpha=200, red=0, green=0, blue=0, visible=true}, flags={draggable=false, bold=true}, text={size=9, fonts={'Lucida Console','Arial'}, font='Lucida Console', alpha=255, red=245, green=200, blue=20, stroke={width=1, alpha=255, red=0, green=0, blue=0}}, padding=1}

    -- Public Methods.
    self.new = function()
        return bp.texts.new(settings)
    end

    self.center = function(obj)

        if obj then
            local x, y = obj:extents()

            if x and y then
                obj:pos((resolution.x / 2) - math.floor(x/2), (resolution.y / 2) - math.floor(y/2))
            end
            
        end

    end

    self.pad = function(obj, padding)

        if obj and padding and tonumber(padding) ~= nil then
            obj:pad(padding)
        end

    end

    return self

end
return library