local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local settings  = bp.__settings.new('blusets')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __flags = {busy=false}

        do -- Private Settings.
            settings.sets = settings.sets or {}

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.save = function(name)
            if (not bp or __flags.busy or not name) then return end
            local name = name:lower()

            if not settings.sets[name] then
                settings.sets[name] = {}
                bp.popchat.pop(string.format('NEW BLUE MAGE SPELL SET: %s.', name))

            end

            if settings.sets[name] then

                coroutine.schedule(function()
                    __flags.busy = true

                    settings.sets[name] = bp.__blu.getSpellSet()
                    coroutine.schedule(function()
                        bp.popchat.pop(string.format('SPELL SET "%s"; SAVED.', name))
                        settings:save()
                        __flags.busy = false
                    
                    end, 1)

                end, 0.25)

            end
        
        end
        
        pvt.delete = function(name)
            if not bp or __flags.busy or not name then return end
            local name = name:lower()

            if settings.sets[name] then
                __flags.busy = true

                settings.sets[name] = nil
                coroutine.schedule(function()
                    settings:save()
                    __flags.busy = false

                end, 1)
                bp.popchat.pop(string.format('DELETEING BLUE MAGE SPELL SET: %s.', name))

            end
        
        end
        
        pvt.load = function(name)
            if not bp or __flags.busy or not name then return end
            local name = name:lower()

            if settings.sets[name] then
                __flags.busy = true

                windower.ffxi.reset_blue_magic_spells()
                coroutine.schedule(function()

                    for index, id in ipairs(settings.sets[name]) do
                        windower.ffxi.set_blue_magic_spell(id, index)
                        coroutine.sleep(0.25)

                    end
                    __flags.busy = false

                end, 1)
                bp.popchat.pop(string.format('LOADING BLUE MAGE SPELL SET: %s!', name))

            end
        
        end

        -- Private Events.
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'blusets' then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command then
    
                    if command == 'clear' then
                        windower.ffxi.reset_blue_magic_spells()
    
                    elseif command == 'load' and commands[1] then
                        pvt.load(commands[1])
    
                    elseif command == 'save' and commands[1] then
                        pvt.save(commands[1])
    
                    elseif command == 'delete' and commands[1] then
                        pvt.delete(commands[1])
    
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