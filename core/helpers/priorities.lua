local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local __ja      = bp.libs.__settings.new("/priorities/abilities")
    local __ma      = bp.libs.__settings.new("/priorities/spells")
    local __ws      = bp.libs.__settings.new("/priorities/skills")
    local __it      = bp.libs.__settings.new("/priorities/items")
    local base      = {
        
        __ja = bp.files.new('core/resources/priorities/__ja.lua'):exists() and dofile(string.format('%score/resources/priorities/__ja.lua', windower.addon_path)) or {},
        __ma = bp.files.new('core/resources/priorities/__ma.lua'):exists() and dofile(string.format('%score/resources/priorities/__ma.lua', windower.addon_path)) or {},
        __ws = bp.files.new('core/resources/priorities/__ws.lua'):exists() and dofile(string.format('%score/resources/priorities/__ws.lua', windower.addon_path)) or {},
        __it = bp.files.new('core/resources/priorities/__it.lua'):exists() and dofile(string.format('%score/resources/priorities/__it.lua', windower.addon_path)) or {},

    }

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        
        do -- Private Settings.
            __ja.priorities = __ja.priorities or base.__ja
            __ma.priorities = __ma.priorities or base.__ma
            __ws.priorities = __ws.priorities or base.__ws
            __it.priorities = __it.priorities or base.__it

            if __ja.isNew then __ja:save() end
            if __ma.isNew then __ma:save() end
            if __ws.isNew then __ws:save() end
            if __it.isNew then __it:save() end

        end

        -- Private Methods.
        
        -- Public Methods.
        new.get = function(resource)
            local resource = bp.JA[resource] or bp.MA[resource] or bp.WS[resource] or bp.IT[resource] or false
    
            if resource then
                
                if S{'/jobability','/pet'}:contains(resource.prefix) then
                    return __ja.priorities[resource.id] or 1
    
                elseif S{'/magic','/ninjutsu','/song'}:contains(resource.prefix) then
                    return __ma.priorities[resource.id] or 1
    
                elseif S{'/weaponskill'}:contains(resource.prefix) then
                    return __ws.priorities[resource.id] or 1
    
                elseif resource.flags and resource.flags:contains('Usable') then
                    return __it.priorities[resource.id] or 1
    
                end
    
            end
            return 1
    
        end

        new.set = function(resource, value)
            local resource = bp.JA[resource] or bp.MA[resource] or bp.WS[resource] or bp.IT[resource] or false
            local value = tonumber(value)
    
            if resource and value and new.get(resource.en) then
                
                if S{'/jobability','/pet'}:contains(resource.prefix) then
                    bp.helpers.popchat.pop(string.format("\\cs(%s)%s\\cr PRIORITY → \\cs(%s)%s\\cr", bp.colors.setting, resource.en:upper(), bp.colors.setting, value))
                    __ja.priorities[resource.id] = value
                    __ja:save()
    
                elseif S{'/magic','/ninjutsu','/song'}:contains(resource.prefix) then
                    bp.helpers.popchat.pop(string.format("\\cs(%s)%s\\cr PRIORITY → \\cs(%s)%s\\cr", bp.colors.setting, resource.en:upper(), bp.colors.setting, value))
                    __ma.priorities[resource.id] = value
                    __ma:save()
    
                elseif S{'/weaponskill'}:contains(resource.prefix) then
                    bp.helpers.popchat.pop(string.format("\\cs(%s)%s\\cr PRIORITY → \\cs(%s)%s\\cr", bp.colors.setting, resource.en:upper(), bp.colors.setting, value))
                    __ws.priorities[resource.id] = value
                    __ws:save()
    
                elseif resource.flags and resource.flags:contains('Usable') then
                    bp.helpers.popchat.pop(string.format("\\cs(%s)%s\\cr PRIORITY → \\cs(%s)%s\\cr", bp.colors.setting, resource.en:upper(), bp.colors.setting, value))
                    __it.priorities[resource.id] = value
                    __it:save()
    
                end
    
            end
    
        end
        
        -- Private Events.
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'priority' and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if new.get(command) and commands[1] and tonumber(commands[1]) ~= nil then
                    new.set(windower.convert_auto_trans(command), commands[1])
                end

            end
    
        end)

        return new

    end

    return helper

end
return buildHelper