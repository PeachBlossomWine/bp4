local library = {}
function library:new(bp)
    local bp = bp

    -- Public Methods.
    self.get = function(resource)

        if resource and bp.files.new(string.format('core/resources/%s.lua', resource)):exists() then
            return dofile(string.format('%score/resources/%s.lua', windower.addon_path, resource))
        end
        return {}

    end

    return self

end
return library