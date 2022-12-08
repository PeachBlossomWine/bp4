local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local settings = bp.__settings.new('invites')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        do -- Private Settings.
            settings.allowed = T(settings.allowed) or T{}

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.join = function(sender)

            if settings.allowed:contains(sender:lower()) then
                windower.send_command('wait 0.75; input /join')
            end

        end

        pvt.invite = function(message, sender, mode)

            if mode == 3 and message == 'invite' and T(settings.allowed):contains(sender:lower()) then
                windower.send_command(string.format('wait 0.75; pcmd add %s', sender))
            end

        end

        pvt.add = function(name)
            local name = name:lower()
            
            if not settings.allowed:contains(name) then
                table.insert(settings.allowed, name)
                bp.popchat.pop(string.format("%s HAS BEEN ADDED TO THE PARTY WHITE-LIST.", name:upper()))

            else
                bp.popchat.pop("THAT PLAYER HAS ALREADY BEEN ADDED.")

            end

        end

        pvt.remove = function(name) 
            local index, player = settings.allowed:find(name:lower())

            if index and player and player == name:lower() then
                table.remove(settings.allowed, index)
                bp.popchat.pop(string.format("%s HAS BEEN REMOVED FROM THE PARTY WHITE-LIST!", name:upper()))

            else
                bp.popchat.pop("UNABLE TO FIND A PLAYER BY THAT NAME.")

            end

        end
        
        -- Private Events.
        helper('party invite', pvt.join)
        helper('chat message', pvt.invite)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'invites' and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command == '+' and commands[1] then
                    pvt.add(commands[1])

                elseif command == '-' and commands[1] then
                    pvt.remove(commands[1])

                elseif command == 'clear' then
                    settings.allowed = T{}
                end
                settings:save()

            end
    
        end)

        return new

    end

    return helper

end
return buildHelper