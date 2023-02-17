local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __enabled = false
        local __timer   = 0

        -- Private Methods.
        pvt.valid = function(flags) return (flags:contains('No Auction') and flags:contains('No Delivery') and flags:contains('No NPC Sale') and flags:contains('Usable') and (flags:contains('Flag02') or flags:contains('Flag03'))) and true or false end
        pvt.use = function()

            if bp and bp.enabled and __enabled and (os.time()-__timer) >= 2 then

                for i=1, 80 do
                    local index, count, id, status, bag, res = bp.__inventory.getByIndex(0, i)

                    if index and res and res.stack > 1 and pvt.valid(res.flags) then
                        bp.__queue.add(res, bp.player, 1)
                    end

                end
                __timer = os.time()

            end

        end
        
        -- Private Events.
        helper('prerender', pvt.use)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'stacks' then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command and T{'!','#'}:contains(command) then
                    __enabled = (command == '!')

                else
                    __enabled = __enabled ~= true and true or false

                end
                bp.popchat.pop(string.format("USE STACKED ITEMS: \\cs(%s)%s\\cr", bp.colors.setting, tostring(__enabled):upper()))

            end
    
        end)

        return new

    end

    return helper

end
return buildHelper