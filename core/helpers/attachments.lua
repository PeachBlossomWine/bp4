local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local settings  = bp.__settings.new('attachments')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.

        do -- Private Settings.
            settings.sets = settings.sets or {}

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.save = function(name)
            local name = type(name) == 'string' and name:lower() or false

            if not settings.sets[name] then
                settings.sets[name] = {}
                bp.popchat.pop(string.format('NEW ATTACHMENT SET: \\cs(%s)%s\\cr', bp.colors.setting, name:upper()))

            end

            if settings.sets[name] and bp.__attachments.getHead() and bp.__attachments.getFrame() then
                settings.sets[name] = {head=bp.__attachments.getHead(), frame=bp.__attachments.getFrame(), attachments=bp.__attachments.getCurrent()}
                bp.popchat.pop(string.format('SAVING ATTACHMENT SET: \\cs(%s)%s\\cr', bp.colors.setting, name:upper()))

            end
            settings:save()
        
        end
        
        pvt.delete = function(name)
            local name = type(name) == 'string' and name:lower() or false

            if settings.sets[name] then
                settings.sets[name] = nil
                bp.popchat.pop(string.format('DELETEING ATTACHMENT SET: \\cs(%s)%s\\cr', bp.colors.setting, name:upper()))

            end
            settings:save()
        
        end
        
        pvt.load = function(name)
            local name = type(name) == 'string' and name:lower() or false

            if settings.sets[name] then

                windower.ffxi.reset_attachments()
                coroutine.schedule(function()
                    bp.__attachments.equipHead:schedule(0.00, settings.sets[name].head)
                    bp.__attachments.equipFrame:schedule(0.10, settings.sets[name].frame)
                    bp.__attachments.equipSet:schedule(0.20, settings.sets[name].attachments)

                end, 0.15)
                bp.popchat.pop(string.format('LOADING ATTACHMENT SET: \\cs(%s)%s\\cr', bp.colors.setting, name:upper()))

            else
                bp.popchat.pop(string.format('\\cs(%s)%s\\cr IS NOT A SET', bp.colors.setting, name:upper()))

            end
        
        end

        -- Private Events.
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'attach' then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then
                    
                    if ('clear'):startswith(command) then
                        windower.ffxi.reset_attachments()
    
                    elseif ('load'):startswith(command) and commands[1] then
                        pvt.load(commands[1])
    
                    elseif (('save'):startswith(command) or ('new'):startswith(command) or ('create'):startswith(command)) and commands[1] then
                        pvt.save(commands[1])
    
                    elseif ('delete'):startswith(command) and commands[1] then
                        pvt.delete(commands[1])
    
                    end

                end
    
            end        
    
        end)

        return new

    end

    return helper

end
return buildHelper