local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local settings  = bp.__settings.new('controllers')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        settings.controllers = T(settings.controllers) or T{}

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.add = function(name)
            local target = bp.__target.get(name) or bp.__target.get('t')

            if target and target.spawn_type == 13 and not target.is_npc and not settings.controllers:contains(target.name:lower()) then
                table.insert(settings.controllers, target.name:lower())
                bp.helpers.popchat.pop(string.format("\\cs(%s)%s\\cr ADDED TO CONTROLLERS", bp.colors.setting, target.name:upper()))

            end

        end
        
        pvt.delete = function(name)
            local target = bp.__target.get(name) or bp.__target.get('t')

            if target and target.spawn_type == 13 and not target.is_npc and settings.controllers:contains(target.name:lower()) then
                
                for name, index in settings.controllers:it() do

                    if target.name:lower() == name:lower() then
                        settings.controllers:remove(index)
                        bp.helpers.popchat.pop(string.format("\\cs(%s)%s\\cr REMOVED FROM CONTROLLERS", bp.colors.setting, target.name:upper()))
                        break

                    end

                end

            end

        end

        -- Public Methods.
        new.contains = function(name)
            local name = type(name) == 'string' and name:lower() or false

            if name then
                return settings.controllers:contains(name)
            end
            return false

        end

        -- Private Events.
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'controllers' then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then

                    if T{'add','a','+'}:contains(command) then
                        pvt.add(commands[1])
    
                    elseif T{'remove','delete','r','d','-'}:contains(command) then
                        pvt.delete(commands[1])
    
                    end
                    settings:save()

                end
    
            end        
    
        end)

        return new

    end

    return helper

end
return buildHelper