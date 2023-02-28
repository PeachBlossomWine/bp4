local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Methods.
    pm['memory'] = function()
        bp.memory = bp.memory ~= true and true or false
        bp.popchat.pop(string.format('WATCH MEMORY: %s', tostring(bp.memory):upper()))

    end

    pm['music'] = function()
        windower.send_command(('setbgm %s'):format(math.random(1,255)))
    end

    pm['wring'] = function()
        bp.ping = (bp.pinger + 10)
        bp.__actions.castItem("Warp Ring", 13)
        bp.popchat.pop("ATTEMPTING TO USE WARP RING...")
    end

    pm['dring'] = function()
        bp.ping = (bp.pinger + 10)
        bp.__actions.castItem("Dim. Ring (Dem)", 13)
        bp.popchat.pop("ATTEMPTING TO USE DIMENSIONAL RING...")
    end

    pm['hring'] = function()
        bp.ping = (bp.pinger + 10)
        bp.__actions.castItem("Dim. Ring (Holla)", 13)
        bp.popchat.pop("ATTEMPTING TO USE DIMENSIONAL RING...")
    end

    pm['mring'] = function()
        bp.ping = (bp.pinger + 10)
        bp.__actions.castItem("Dim. Ring (Mea)", 13)
        bp.popchat.pop("ATTEMPTING TO USE DIMENSIONAL RING...")
    end

    pm['toggle'] = function()
        bp.enabled = bp.enabled ~= true and true or false
        bp.core.resetIdle()
        bp.popchat.pop(string.format('BUDDYPAL AUTOMATION: \\cs(%s)%s\\cr', bp.colors.setting, tostring(bp.enabled):upper()))

        if not bp.enabled then
            bp.__queue.clear()
        end

    end

    pm['on'] = function()
        bp.enabled = true
        bp.core.resetIdle()
        bp.popchat.pop(string.format('BUDDYPAL AUTOMATION: \\cs(%s)%s\\cr', bp.colors.setting, tostring(bp.enabled):upper()))

    end

    pm['off'] = function()
        bp.enabled = false
        bp.__queue.clear()
        bp.core.resetIdle()
        bp.popchat.pop(string.format('BUDDYPAL AUTOMATION: \\cs(%s)%s\\cr', bp.colors.setting, tostring(bp.enabled):upper()))

    end

    pm['follow'] = function()
        bp.__orders.deliver('p*', string.format('follow %s', bp.player.name))
    end

    pm['request_stop'] = function()
        bp.__orders.deliver('p*', 'bp stop')
    end

    pm['stop'] = function()
        bp.__actions.stop()
    end

    pm['mytarget'] = function()
        local target = windower.ffxi.get_mob_by_target('t') or false

        if target then
            print(string.format('ID: %s | Index: %s | Claim ID: %s | POS(x=%s, y=%s, z=%s) | Zone: %s [ %s ]', target.id, target.index, target.claim_id, target.x, target.y, target.z, bp.info.zone, bp.res.zones[bp.info.zone].en))
            table.vprint(target)
            --table.vprint(windower.ffxi.get_player())
            --table.vprint(self.me)
        end

    end

    pm['mybuffs'] = function()
        table.print(windower.ffxi.get_player().buffs)
    end

    pm['trade'] = function(commands)
        local target = bp.__target.get('t')

        if bp and bp.player and target and target.id ~= bp.player.id and bp.__distance.get(target) < 7 then
            local items = {}

            for i=1, #commands do
                local item, quant = unpack(commands[i]:split(':'))
                
                if item then
                    local index, count, id = bp.__inventory.findByName(item)

                    if index and count and id and count >= (tonumber(quant) or 1) and bp.res.items[id] then
                        table.insert(items, {name=bp.res.items[id].en, count=tonumber(quant) or 1})
                    end

                end

            end
            
            if #items > 0 then
                bp.__actions.trade(target, unpack(items))
            end

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