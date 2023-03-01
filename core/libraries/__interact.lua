local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __event       = nil
    local __busy        = false
    local __command     = false
    local __messages    = {"./","Got it.","Ready","Lezgo",".","I'm Ready.","Let's go!",".//","got","ready","rdy","Let's gooooooooooooooo!","go","headin in","Heading in"}
    local __targets     = {}
    
    -- Private Methods.
    pm.handleMenu = function(parsed, menus)

        if parsed and menus and menus[__command] then
            menus[__command]()
        
        else
            bp.__menus.send(parsed, {bp.__menus.done})
        
        end
        __command = false

    end

    pm.poke = function()

        for name in pairs(__targets) do
            local targets = bp.__mobs.nearby(name, true, 6)

            if targets and #targets > 0 then
                __busy = true

                do
                    bp.__actions.perform(targets[1], 'interact', 0)
                    break

                end

            end

        end

    end

    pm.generateMessage = function()
        local random = math.random(1, #__messages)

        if __messages[random] then
            windower.send_command:schedule(1, string.format("input /p %s", __messages[random]))

        end

    end

    __targets['Affi'] = function(parsed)
        local menus = {}

        menus['rads'] = function()
            
            if not bp.__inventory.hasKeyItem(3031) and parsed['Menu ID'] == 9701 then
                bp.__menus.send(parsed, {{14, 0, 0, true},{08, 0, 0, true},{09, 0, 0, true},{03, 0, 0, true},{2308, 0, 0, true},{3, 0, 0, true},bp.__menus.done})
                pm.generateMessage()
    
            else
                bp.__menus.send(parsed, {bp.__menus.done})
    
            end

        end
        pm.handleMenu(parsed, menus)

    end

    __targets['Dremi'] = function(parsed)
        local menus = {}

        menus['rads'] = function()
            
            if not bp.__inventory.hasKeyItem(3031) and parsed['Menu ID'] == 9701 then
                bp.__menus.send(parsed, {{14, 0, 0, true},{08, 0, 0, true},{09, 0, 0, true},{03, 0, 0, true},{2308, 0, 0, true},{3, 0, 0, true},bp.__menus.done})
                pm.generateMessage()
    
            else
                bp.__menus.send(parsed, {bp.__menus.done})
    
            end

        end
        pm.handleMenu(parsed, menus)

    end

    __targets['Shiftrix'] = function(parsed)
        local menus = {}

        menus['rads'] = function()
            
            if not bp.__inventory.hasKeyItem(3031) and parsed['Menu ID'] == 9701 then
                bp.__menus.send(parsed, {{14, 0, 0, true},{08, 0, 0, true},{09, 0, 0, true},{03, 0, 0, true},{2308, 0, 0, true},{3, 0, 0, true},bp.__menus.done})
                pm.generateMessage()
    
            else
                bp.__menus.send(parsed, {bp.__menus.done})
    
            end

        end
        pm.handleMenu(parsed, menus)

    end

    __targets['Incantrix'] = function(parsed)
        local menus = {}

        menus['canteen'] = function()

            if not bp.__inventory.hasKeyItem(3137) and parsed['Menu ID'] == 31 then
                bp.__menus.send(parsed, {{2, 0, 0, true},{3, 0, 0, false}})
                pm.generateMessage()
    
            else
                bp.__menus.send(parsed, {bp.__menus.done})
    
            end

        end
        pm.handleMenu(parsed, menus)

    end

    -- Public Methods.
    self.start = function(target, block, success)
        local target = bp.__target.get(target)

        if target and bp.player.status == 0 and bp.__distance.get(target) < 7 then

            if not __event then
                
                __event = windower.register_event('incoming chunk', function(id, original)

                    if (id == 0x032 or id == 0x034) then
                        local parsed = bp.packets.parse('incoming', original)

                        if parsed and target and parsed['NPC Index'] == target.index then
                            windower.unregister_event(__event)
                            __event = nil

                            if success and type(success) == 'function' then
                                success(parsed, target)
                            end

                            if block then
                                return true
                            end

                        else
                            windower.unregister_event(__event)
                            __event = nil
                            
                        end

                    end

                end)

            end
            bp.__actions.perform(target, 'interact', 0)

        end

    end

    self.trade = function(target, items, block, success)
        local target = bp.__target.get(target)

        if target and items and bp.player.status == 0 and bp.__distance.get(target) < 7 then
            
            if not __event then
                
                __event = windower.register_event('incoming chunk', function(id, original)

                    if (id == 0x032 or id == 0x034) then
                        local parsed = bp.packets.parse('incoming', original)

                        if parsed and parsed['NPC Index'] == target.index then
                            windower.unregister_event(__event)
                            __event = nil

                            if success and type(success) == 'function' then
                                success(parsed, target)
                            end

                            if block then
                                return true
                            end

                        elseif parsed and not target or (target and parsed['NPC Index'] ~= target.index) then
                            windower.unregister_event(__event)
                            __event = nil

                        end

                    end

                end)

            end
            bp.__actions.trade(target, items)

        end

    end

    -- Private Events.
    windower.register_event('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)

        if bp and bp.player and command and command:lower() == 'interact' then
            local command = commands[1] and table.remove(commands, 1):lower() or false
            
            if command then

                if ('poke'):startswith(command) and #commands > 0 then
                    self.start(commands[1], false)

                elseif ('start'):startswith(command) then
                    local target = bp.__target.get('t')

                    if target and target.id then
                        windower.send_command(string.format('bp ord rr bp interact poke %d', target.id))
                    end

                elseif ('buy'):startswith(command) and commands[1] then
                    __command = commands[1]:lower()
                    pm.poke()

                end

            end

        end

    end)

    windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)

        if (id == 0x032 or id == 0x034) and bp and bp.player and bp.player.status == 0 and __busy then
            local parsed = bp.packets.parse('incoming', original)

            if parsed then
                local target = bp.__target.get(parsed['NPC Index'])

                if target and __targets[target.name] then
                    __targets[target.name](parsed)
                    return true
                    
                end

            end

        end

    end)

    windower.register_event('outgoing chunk', function(id, original, modified, injected, blocked)

        if id == 0x05b then
            local parsed = bp.packets.parse('outgoing', original)

            if parsed and not parsed['Automated Message'] then
                __busy = false
            end

        end

    end)

    return self

end
return library