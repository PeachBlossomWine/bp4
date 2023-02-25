local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __profile = false

        -- Private Methods.
        pvt.clean = function()
        
            if __profile and __profile.drop and #__profile.drop > 0 then
    
                for item, index in T(windower.ffxi.get_items(0)):it() do

                    if item and type(item) == 'table' and item.id and item.status and item.status == 0 and item.count and T(__profile.drop):contains(item.id) then
                        bp.__inventory.drop(index, item.count)
                    end
    
                end
    
            end
    
        end

        pvt.autodrop = function()

            if __profile.autodrop then
                pvt.clean()            
            end

        end

        pvt.handle = function(id, original)

            if id and original and id == 0x020 and __profile then
                local parsed = bp.packets.parse('incoming', original)

                if parsed['Bag'] == 0 and parsed['Index'] ~= 0 and __profile.autodrop then

                    if T(__profile.drop):contains(parsed['Item']) and parsed['Status'] == 0 then
                        bp.__inventory.drop(parsed['Index'], parsed['Count'])
                    end

                end

            elseif id and original and id == 0x0d2 and __profile then
                local parsed = bp.packets.parse('incoming', original)

                if parsed and parsed['Item'] ~= 0 then

                    if #__profile.lot > 0 and T(__profile.lot):contains(parsed['Item']) then

                        if __profile.delay then
                            bp.__inventory.lot:schedule(math.random(1, 5), parsed['Index'])

                        else
                            bp.__inventory.lot(parsed['Index'])

                        end

                    elseif #__profile.pass > 0 and T(__profile.pass):contains(parsed['Item']) then

                        if __profile.delay then
                            bp.__inventory.pass:schedule(math.random(1, 5), parsed['Index'])

                        else
                            bp.__inventory.pass(parsed['Index'])

                        end

                    end

                end

            end

        end

        -- Public Methods.
        new.load = function(profile)

            if type(profile) == 'string' then
                if __profile then __profile:save() end                
                __profile = bp.__settings.new(string.format('inventory/%s', profile:lower()))

                if __profile.isNew then
                    __profile.autodrop  = false
                    __profile.delay     = false
                    __profile.pass      = {}
                    __profile.drop      = {}
                    __profile.lot       = {}

                end
                __profile:save()
                bp.popchat.pop(string.format("LOADING INVENTORY PROFILE: \\cs(%s)%s\\cr", bp.colors.setting, profile:upper()))

            end

        end

        new.clear = function()

            if __profile then
                __profile.autodrop  = false
                __profile.delay     = 0
                __profile.pass      = {}
                __profile.drop      = {}
                __profile.lot       = {}

            end
            __profile:save()

        end

        new.addDrop = function(name)
            if not __profile then return end
            
            for item in T(bp.res.items):it() do

                if type(name) == 'table' then

                    for name, index in T(name):it() do

                        if (item.en:lower() == windower.convert_auto_trans(name):lower() or item.enl:lower() == windower.convert_auto_trans(name):lower() or item.id == name) then

                            if not T(__profile.drop):contains(item.id) then
    
                                if not T(__profile.lot):contains(item.id) and not T(__profile.pass):contains(item.id) then
                                    table.insert(__profile.drop, item.id)
                                end
    
                            end
    
                        end

                    end

                else

                    if (item.en:lower() == windower.convert_auto_trans(name):lower() or item.enl:lower() == windower.convert_auto_trans(name):lower() or item.id == name) then

                        if not T(__profile.drop):contains(item.id) then

                            if not T(__profile.lot):contains(item.id) and not T(__profile.pass):contains(item.id) then
                                bp.popchat.pop(string.format("ADDED \\cs(%s)%s\\cr TO DROP LIST.", bp.colors.setting, item.en:upper()))
                                table.insert(__profile.drop, item.id)
                                __profile:save()
                                pvt.autodrop()
                                return

                            else
                                bp.popchat.pop("CANNOT LOT/DROP/PASS ON THE SAME ITEM")
                                return

                            end

                        end
                        return

                    end

                end

            end
            __profile:save()
            pvt.autodrop()
    
        end

        new.removeDrop = function(name)
            if not __profile then return end
            
            for item in T(bp.res.items):it() do

                if type(name) == 'table' then

                    for name, index in T(name):it() do

                        if (item.en:lower() == windower.convert_auto_trans(name):lower() or item.enl:lower() == windower.convert_auto_trans(name):lower() or item.id == name) and T(__profile.drop):contains(item.id) then

                            for id, index in T(__profile.drop):it() do
    
                                if id == item.id then
                                    table.remove(__profile.drop, index)    
                                end
    
                            end
    
                        end

                    end

                else
                
                    if (item.en:lower() == windower.convert_auto_trans(name):lower() or item.enl:lower() == windower.convert_auto_trans(name):lower() or item.id == name) and T(__profile.drop):contains(item.id) then

                        for id, index in T(__profile.drop):it() do

                            if id == item.id then
                                bp.popchat.pop(string.format("REMOVED \\cs(%s)%s\\cr FROM THE DROP LIST.", bp.colors.setting, item.en:upper()))
                                table.remove(__profile.drop, index)
                                __profile:save()
                                pvt.autodrop()
                                return

                            end

                        end

                    end

                end

            end
            __profile:save()
            pvt.autodrop()
    
        end

        new.addLot = function(name)
            if not __profile then return end    
            
            for item in T(bp.res.items):it() do

                if type(name) == 'table' then

                    for name, index in T(name):it() do

                        if (item.en:lower() == windower.convert_auto_trans(name):lower() or item.enl:lower() == windower.convert_auto_trans(name):lower() or item.id == name) then

                            if not T(__profile.lot):contains(item.id) then
    
                                if not T(__profile.drop):contains(item.id) and not T(__profile.pass):contains(item.id) then
                                    table.insert(__profile.lot, item.id)                                
                                end
    
                            end
    
                        end

                    end

                else

                    if (item.en:lower() == windower.convert_auto_trans(name):lower() or item.enl:lower() == windower.convert_auto_trans(name):lower() or item.id == name) then

                        if not T(__profile.lot):contains(item.id) then

                            if not T(__profile.drop):contains(item.id) and not T(__profile.pass):contains(item.id) then
                                bp.popchat.pop(string.format("ADDED \\cs(%s)%s\\cr TO LOT LIST.", bp.colors.setting, item.en:upper()))
                                table.insert(__profile.lot, item.id)
                                __profile:save()
                                pvt.autodrop()
                                return

                            else
                                bp.popchat.pop("CANNOT LOT/DROP/PASS ON THE SAME ITEM")
                                return

                            end

                        end
                        return

                    end

                end

            end
            __profile:save()
            pvt.autodrop()
    
        end

        new.removeLot = function(name)
            if not __profile then return end
            
            for item in T(bp.res.items):it() do

                if type(name) == 'table' then

                    for name, index in T(name):it() do

                        if (item.en:lower() == windower.convert_auto_trans(name):lower() or item.enl:lower() == windower.convert_auto_trans(name):lower() or item.id == name) and T(__profile.lot):contains(item.id) then

                            for id, index in T(__profile.lot):it() do

                                if id == item.id then
                                    table.remove(__profile.lot, index)
                                end

                            end

                        end

                    end

                else
                
                    if (item.en:lower() == windower.convert_auto_trans(name):lower() or item.enl:lower() == windower.convert_auto_trans(name):lower() or item.id == name) and T(__profile.lot):contains(item.id) then

                        for id, index in T(__profile.lot):it() do

                            if id == item.id then
                                bp.popchat.pop(string.format("REMOVED \\cs(%s)%s\\cr FROM THE LOT LIST.", bp.colors.setting, item.en:upper()))
                                table.remove(__profile.lot, index)
                                __profile:save()
                                pvt.autodrop()
                                return

                            end

                        end

                    end

                end

            end
            __profile:save()
            pvt.autodrop()
    
        end

        new.addPass = function(name)
            if not __profile then return end
            
            for item in T(bp.res.items):it() do

                if type(name) == 'table' then

                    for name, index in T(name):it() do

                        if (item.en:lower() == windower.convert_auto_trans(name):lower() or item.enl:lower() == windower.convert_auto_trans(name):lower() or item.id == name) then

                            if not T(__profile.pass):contains(item.id) then
    
                                if not T(__profile.drop):contains(item.id) and not T(__profile.lot):contains(item.id) then
                                    table.insert(__profile.pass, item.id)
                                end
    
                            end
    
                        end

                    end

                else

                    if (item.en:lower() == windower.convert_auto_trans(name):lower() or item.enl:lower() == windower.convert_auto_trans(name):lower() or item.id == name) then

                        if not T(__profile.pass):contains(item.id) then

                            if not T(__profile.drop):contains(item.id) and not T(__profile.lot):contains(item.id) then
                                bp.popchat.pop(string.format("ADDED \\cs(%s)%s\\cr TO PASS LIST.", bp.colors.setting, item.en:upper()))
                                table.insert(__profile.pass, item.id)
                                __profile:save()
                                pvt.autodrop()
                                return

                            else
                                bp.popchat.pop("CANNOT LOT/DROP/PASS ON THE SAME ITEM")
                                return

                            end

                        end
                        return

                    end

                end

            end
            __profile:save()
            pvt.autodrop()
    
        end

        new.removePass = function(name)
            if not __profile then return end
            
            for item in T(bp.res.items):it() do

                if type(name) == 'table' then

                    for name, index in T(name):it() do

                        if (item.en:lower() == windower.convert_auto_trans(name):lower() or item.enl:lower() == windower.convert_auto_trans(name):lower() or item.id == name) and T(__profile.pass):contains(item.id) then

                            for id, index in T(__profile.pass):it() do
    
                                if id == item.id then
                                    table.remove(__profile.pass, index)    
                                end
    
                            end
    
                        end

                    end

                else
                
                    if (item.en:lower() == windower.convert_auto_trans(name):lower() or item.enl:lower() == windower.convert_auto_trans(name):lower() or item.id == name) and T(__profile.pass):contains(item.id) then

                        for id, index in T(__profile.pass):it() do

                            if id == item.id then
                                bp.popchat.pop(string.format("REMOVED \\cs(%s)%s\\cr FROM THE PASS LIST.", bp.colors.setting, item.en:upper()))
                                table.remove(__profile.pass, index)
                                __profile:save()
                                pvt.autodrop()
                                return

                            end

                        end

                    end

                end

            end
            __profile:save()
            pvt.autodrop()
    
        end

        new.setAutoDrop = function(bool)

            if __profile then
                __profile.autodrop = bool
            end

        end
        
        -- Private Events.
        helper('incoming chunk', pvt.handle)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and T{'inv','inventory'}:contains(command:lower()) and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if ('load'):startswith(command) and commands[1] then
                    new.load(commands[1]:lower())

                elseif ('lot'):startswith(command) and #commands > 0 and __profile then
                    local option = commands[1] and table.remove(commands, 1):lower() or false

                    if option and option == '+' and #commands > 0 then
                        new.addLot(table.concat(commands, ' '))

                    elseif option and option == '-' and #commands > 0 then
                        new.removeLot(table.concat(commands, ' '))

                    end

                elseif ('pass'):startswith(command) and #commands > 0 and __profile then
                    local option = commands[1] and table.remove(commands, 1):lower() or false

                    if option and option == '+' and #commands > 0 then
                        new.addPass(table.concat(commands, ' '))

                    elseif option and option == '-' and #commands > 0 then
                        new.removePass(table.concat(commands, ' '))

                    end

                elseif ('drop'):startswith(command) and #commands > 0 and __profile then
                    local option = commands[1] and table.remove(commands, 1):lower() or false

                    if option and option == '+' and #commands > 0 then
                        new.addDrop(table.concat(commands, ' '))

                    elseif option and option == '-' and #commands > 0 then
                        new.removeDrop(table.concat(commands, ' '))

                    end

                elseif ('clear'):startswith(command) and __profile then
                    new.clear()

                elseif ('autodrop'):startswith(command) and __profile then
                    
                    if #commands > 0 and T{'!','#'}:contains(commands[1]) then
                        __profile.autodrop = (commands[1] == '!')

                    else
                        __profile.autodrop = (__profile.autodrop ~= true) and true or false
                        bp.popchat.pop(string.format("AUTO-DROP ITEMS: \\cs(%s)%s\\cr", bp.colors.setting, tostring(__profile.autodrop):upper()))

                    end
                    __profile:save()
                    pvt.autodrop()

                elseif ('delay'):startswith(command) and __profile then
                    
                    if #commands > 0 and T{'!','#'}:contains(commands[1]) then
                        __profile.delay = (commands[1] == '!')

                    else
                        __profile.delay = (__profile.delay ~= true) and true or false
                        bp.popchat.pop(string.format("RANDOMIZED DELAY: \\cs(%s)%s\\cr", bp.colors.setting, tostring(__profile.delay):upper()))

                    end

                end

            end
    
        end)

        return new

    end

    return helper

end
return buildHelper