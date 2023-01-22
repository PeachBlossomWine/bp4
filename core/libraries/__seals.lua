local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Public Methods.
    self.get = function(parsed)

        if parsed and parsed['Menu Parameters'] then
            local target = bp.__target.get(parsed['NPC'])
            local parameters = T{ parsed['Menu Parameters']:unpack('H16') }

            if target and parameters and T{'Shami','Shemo'}:contains(target.name) then
                return T{parameters[1], parameters[2], parameters[3], parameters[4], parameters[5]}
            end

        end

    end

    return self

end
return library