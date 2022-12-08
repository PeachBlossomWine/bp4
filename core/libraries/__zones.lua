local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Public Variables.
    self.towns      = T{26,48,50,53,70,71,80,87,94,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,252,256,257,280,281,284,251}
    self.escha      = T{288,289,291,292,293}
    self.jail       = T{131}

    -- Public Methods.
    self.isInJail = function()
        local zone = windower.ffxi.get_info().zone

        if bp and bp.res and bp.res.zones and bp.res.zones[zone] and self.jail:contains(zone) then
            return true
        end
        return false

    end

    self.isInTown = function()
        local zone = windower.ffxi.get_info().zone

        if bp and bp.res and bp.res.zones and bp.res.zones[zone] and self.towns:contains(zone) then
            return true
        end
        return false

    end

    self.isInEscha = function()
        local zone = windower.ffxi.get_info().zone

        if bp and bp.res and bp.res.zones and bp.res.zones[zone] and self.escha:contains(zone) then
            return true
        end
        return false

    end

    return self

end
return library