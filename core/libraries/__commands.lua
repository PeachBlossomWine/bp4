local library = {}
function library:new(bp)
    local bp = bp

    -- Private Variables.

    -- Public Variables.

    -- Private Methods.

    -- Public Methods.

    -- Private Events.
    windower.register_event('addon command', function(...)
        local commands  = T{...}
        local command   = commands[1] and table.remove(commands, 1):lower()
        
        if bp and command then
            local popchat = bp.helpers.popchat
            local orders = bp.libs.__orders

            if command == 'toggle' then
                bp.enabled = bp.enabled ~= true and true or false

                if not bp.enabled then
                    --self.helpers['queue'].clear() ##QUEUE!
                end
                popchat.pop(string.format('BUDDYPAL AUTOMATION ENABLED: %s.', tostring(bp.enabled)))

            elseif command == 'on' then
                bp.enabled = true
                popchat.pop('BUDDYPAL AUTOMATION NOW ENABLED!')

            elseif command == 'off' then
                bp.enabled = false
                popchat.pop('BUDDYPAL AUTOMATION NOW DISABLED!')

            elseif command == 'follow' then
                orders.deliver('p*', ('bp follow %s'):format(bp.player.name))

            elseif command == 'stop' then
                bp.libs.__actions.stop()

            elseif command == 'request_stop' then
                orders.deliver('p*', 'bp stop')

            elseif command == 'info' then
                local target = windower.ffxi.get_mob_by_target('t') or false

                if target then
                    print(string.format('ID: %s | Index: %s | Claim ID: %s | POS(x=%s, y=%s, z=%s) | Zone: %s [ %s ]', target.id, target.index, target.claim_id, target.x, target.y, target.z, self.info.zone, self.res.zones[self.info.zone].en))
                    --table.vprint(target)
                    --table.vprint(windower.ffxi.get_player())
                    --table.vprint(self.me)
                end
                --print(table.concat(self.player.buffs, '\n'))

            elseif S{'r','rld','reload'}:contains(command) then
                windower.send_command('lua r bp4')

            end

        end

    end)

    return self

end
return library