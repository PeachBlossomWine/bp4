local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local settings  = bp.libs.__settings.new('controllers')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        settings.controllers = T(settings.controllers) or T{}

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.add = function(name)
            local target = bp.libs.__target.get(name) or windower.ffxi.get_mob_by_target('t')

            if target and target.spawn_type == 1 and not target.is_npc and not settings.controllers:contains(target.name) then
                table.insert(settings.controllers, target.name)
                bp.helpers.popchat.pop(string.format("%s ADDED TO CONTROLLERS.", target.name))

            end

        end
        
        pvt.delete = function(name)
            local target = bp.libs.__target.get(name) or windower.ffxi.get_mob_by_target('t')

            if target and target.spawn_type == 1 and not target.is_npc and settings.controllers:contains(target.name) then
                
                for name, index in settings.controllers:it() do

                    if target.name == name then
                        settings.controllers:remove(index)
                        bp.helpers.popchat.pop(string.format("%s REMOVED FROM CONTROLLERS.", target.name))

                    end

                end

            end

        end

        -- Private Events.
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'controllers' then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then
                    
                    if S{'add','a','+'}:contains(command) then
                        add(commands[1])
    
                    elseif S{'remove','delete','r','d','-'}:contains(command) then
                        delete(commands[1])
    
                    end

                end
                settings:save()
    
            end        
    
        end)

        return new

    end

    return helper

end
return buildHelper