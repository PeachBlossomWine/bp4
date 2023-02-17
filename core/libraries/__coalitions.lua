local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Public Methods.
    self.getRank = function(parsed)

        if parsed and parsed['Menu Parameters'] then
            local target = bp.__target.get(parsed['NPC'])
            local parameters = T{ parsed['Menu Parameters']:unpack('H16') }

            if target and parameters and target.name == "Civil Registrar" and parameters[9] then
                return parameters[9]
            end

        end

    end

    return self

end
return library