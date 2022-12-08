local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.

    -- Public Variables.

    -- Private Methods.
    pm['toggle'] = function()
        bp.enabled = bp.enabled ~= true and true or false
        bp.popchat.pop(string.format('BUDDYPAL AUTOMATION ENABLED: \\cs(%s)%s\\cr', bp.colors.setting, tostring(bp.enabled):upper()))

        if not bp.enabled then
            bp.__queue.clear()
        end

    end

    pm['on'] = function()
        bp.enabled = true
        bp.popchat.pop(string.format('BUDDYPAL AUTOMATION ENABLED: \\cs(%s)%s\\cr', bp.colors.setting, tostring(bp.enabled):upper()))

    end

    pm['off'] = function()
        bp.enabled = false
        bp.__queue.clear()
        bp.popchat.pop(string.format('BUDDYPAL AUTOMATION ENABLED: \\cs(%s)%s\\cr', bp.colors.setting, tostring(bp.enabled):upper()))

    end

    pm['follow'] = function()
        bp.__orders.deliver('p*', ('bp follow %s'):format(bp.player.name))
    end

    pm['request_stop'] = function()
        orders.deliver('p*', 'bp stop')
    end

    pm['stop'] = function()
        bp.__actions.stop()
    end

    pm['info'] = function()
        local target = windower.ffxi.get_mob_by_target('t') or false

        if target then
            print(string.format('ID: %s | Index: %s | Claim ID: %s | POS(x=%s, y=%s, z=%s) | Zone: %s [ %s ]', target.id, target.index, target.claim_id, target.x, target.y, target.z, bp.info.zone, bp.res.zones[bp.info.zone].en))
            --table.vprint(target)
            --table.vprint(windower.ffxi.get_player())
            --table.vprint(self.me)
        end

    end

    pm['helper'] = function(commands)
        local command = commands[1] and table.remove(commands, 1):lower()

        if command and bp.helpers[command] then

            if command == 'reload' and commands[1] and bp[commands[1]] then
                bp.helpers:reload(commands[1])
            end
            
        end
        
    end

    -- Private Events.
    windower.register_event('addon command', function(...)
        local commands  = T{...}
        local command   = commands[1] and table.remove(commands, 1):lower()
        
        if bp and command then
            local popchat = bp.popchat
            local orders = bp.__orders

            if pm[command] then
                pm[command](commands)

            elseif S{'r','rld','reload'}:contains(command) then
                windower.send_command('lua r bp4')

            end

        end

    end)

    return self

end
return library