local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.

    -- Public Variables.

    -- Private Methods.
    pm.handle = function(message, sender, mode, gm)
        if gm then return end

        if bp and bp.controllers and message and sender and mode and bp.controllers:contains(sender:lower()) and T{3,4}:contains(mode) then
            local commands = message:split(" ")
            local target = bp.__target.get(sender)
            
            if #commands > 0 then
                
                for command, n in commands:it() do
                    pm[bp.player.main_job](command, target)
                end

            elseif #commands == 1 then
                pm[bp.player.main_job](commands[1], target)

            end

        end

    end

    pm['WAR'] = function(command, target)

    end

    pm['MNK'] = function(command, target)

    end

    pm['WHM'] = function(command, target)

        if command == 'haste' and target then
            bp.__queue.add('Haste', target, bp.priorities.get('Haste'))

        elseif command == 'protect' and target then
            bp.__queue.add('Protect V', target, bp.priorities.get('Protect V'))

        elseif command == 'shell' and target then
            bp.__queue.add('Sehll V', target, bp.priorities.get('Shell V'))

        elseif command == 'auspice' then
            bp.__queue.add('Auspice', bp.player, bp.priorities.get('Auspice'))

        elseif command == 'regen' and target then
            bp.__queue.add('Regen IV', target, bp.priorities.get('Regen IV'))

        elseif command == 'erase' and target then
            bp.__queue.add('Erase', target, bp.priorities.get('Erase'))

        elseif command == 'firebuff' then
            bp.__queue.add('Protectra V', target, bp.priorities.get('Protectra V'))
            bp.__queue.add('Shellra V', target, bp.priorities.get('Shellra V'))
            bp.__queue.add('Barfira', target, bp.priorities.get('Barfira'))
            bp.__queue.add('Baramnesra', target, bp.priorities.get('Baramnesra'))
            bp.__queue.add('Auspice', target, bp.priorities.get('Auspice'))

        elseif command == 'waterbuff' then
            bp.__queue.add('Protectra V', target, bp.priorities.get('Protectra V'))
            bp.__queue.add('Shellra V', target, bp.priorities.get('Shellra V'))
            bp.__queue.add('Barwatera', target, bp.priorities.get('Barwatera'))
            bp.__queue.add('Barpoisonra', target, bp.priorities.get('Barpoisonra'))
            bp.__queue.add('Auspice', target, bp.priorities.get('Auspice'))

        elseif command == 'stonebuff' then
            bp.__queue.add('Protectra V', target, bp.priorities.get('Protectra V'))
            bp.__queue.add('Shellra V', target, bp.priorities.get('Shellra V'))
            bp.__queue.add('Barstonra', target, bp.priorities.get('Barstonra'))
            bp.__queue.add('Barpetra', target, bp.priorities.get('Barpetra'))
            bp.__queue.add('Auspice', target, bp.priorities.get('Auspice'))

        elseif command == 'icebuff' then
            bp.__queue.add('Protectra V', target, bp.priorities.get('Protectra V'))
            bp.__queue.add('Shellra V', target, bp.priorities.get('Shellra V'))
            bp.__queue.add('Barblizzara', target, bp.priorities.get('Barblizzara'))
            bp.__queue.add('Barparalyzra', target, bp.priorities.get('Barparalyzra'))
            bp.__queue.add('Auspice', target, bp.priorities.get('Auspice'))

        elseif command == 'windbuff' then
            bp.__queue.add('Protectra V', target, bp.priorities.get('Protectra V'))
            bp.__queue.add('Shellra V', target, bp.priorities.get('Shellra V'))
            bp.__queue.add('Baraera', target, bp.priorities.get('Baraera'))
            bp.__queue.add('Barsilencera', target, bp.priorities.get('Barsilencera'))
            bp.__queue.add('Auspice', target, bp.priorities.get('Auspice'))

        elseif command == 'thunderbuff' then
            bp.__queue.add('Protectra V', target, bp.priorities.get('Protectra V'))
            bp.__queue.add('Shellra V', target, bp.priorities.get('Shellra V'))
            bp.__queue.add('Barthundra', target, bp.priorities.get('Barthundra'))
            bp.__queue.add('Barviruna', target, bp.priorities.get('Barviruna'))
            bp.__queue.add('Auspice', target, bp.priorities.get('Auspice'))

        elseif T{'raise','arise'} and target and T{2,3}:contains(target.status) then
            bp.__queue.add('Arise', target, bp.priorities.get('Arise'))

        elseif T{'para','parad','paralyze','paralyzed'}:contains(command) and target then
            bp.__queue.add('Paralyna', target, bp.priorities.get('Paralyna'))

        elseif T{'stone','stoned','petra','petrafied'}:contains(command) and target then
            bp.__queue.add('Stona', target, bp.priorities.get('Stona'))

        elseif T{'doom','doomed','cursed','curse'}:contains(command) and target then
            bp.__queue.add('Cursna', target, bp.priorities.get('Cursna'))

        elseif (('zzzzzzzzzzzzzz'):startswith(command) or T{'asleep','slept','sleep','zzz'}) and target then

            if bp.__party.isMember(target) then
                bp.__queue.add('Curaga', target, bp.priorities.get('Curaga'))

            else
                bp.__queue.add('Cure', target, bp.priorities.get('Cure'))

            end

        end

    end

    pm['BLM'] = function(command, target)

    end

    pm['RDM'] = function(command, target)

    end

    pm['THF'] = function(command, target)

    end

    pm['PLD'] = function(command, target)

    end

    pm['DRK'] = function(command, target)

    end

    pm['BST'] = function(command, target)

    end

    pm['BRD'] = function(command, target)

    end

    pm['RNG'] = function(command, target)

    end

    pm['SMN'] = function(command, target)

    end

    pm['SAM'] = function(command, target)

    end

    pm['NIN'] = function(command, target)

    end

    pm['DRG'] = function(command, target)

    end

    pm['BLU'] = function(command, target)

    end

    pm['COR'] = function(command, target)

    end

    pm['PUP'] = function(command, target)

        if command == 'jump' then
            windower.send_command('input /jump')
        end

    end

    pm['DNC'] = function(command, target)

    end

    pm['SCH'] = function(command, target)

    end

    pm['GEO'] = function(command, target)

    end

    pm['RUN'] = function(command, target)

    end

    -- Public Methods.

    -- Private Events.
    windower.register_event('chat message', pm.handle)

    return self

end
return library