local library = {}
function library:new(bp)
    local bp = bp

    -- Private Variables.
    local methods   = {}
    local order     = {}

    -- Private Methods.
    methods.deliver = function(order)

        if order and order.player then
            windower.send_command(windower.convert_auto_trans(order.player))
        end

        if order and order.others and #order.others > 0 then
            windower.send_ipc_message(windower.convert_auto_trans(table.concat(order.others, ' ')))
        end

    end

    methods['@'] = function(orders)
        local delay = 0
    
        for account in bp.accounts:it() do

            if account == bp.player.name then
                order.player = string.format('wait %s; %s', delay, orders)
    
            else
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
    
            end
    
        end
        methods.deliver(order)
    
    end

    methods['@*'] = function(orders)
        local delay = 0
    
        for account in accounts:it() do
    
            if account ~= bp.player.name then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
            end
    
        end
        helpers.deliver(order)
    
    end

    methods['@@*'] = function(orders)
        local delay = 0
    
        for account in accounts:it() do
    
            if account ~= bp.player.name then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
                delay = (delay + stagger)
    
            end
    
        end
        methods.deliver(order)
    
    end

    methods['r'] = function(orders)
        local delay = 0
    
        for account in accounts:it() do
            local target = bp.libs.__target.get(account)
    
            if account == bp.player.name then
                order.player = string.format('wait %s; %s', delay, orders)
    
            elseif target and bp.lib.__distance.get(target) < 25 then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
    
            end
    
        end
        methods.deliver(order)
    
    end

    methods['rr'] = function(orders)
        local delay = 0
    
        for account in accounts:it() do
            local target = bp.libs.__target.get(account)
    
            if account == bp.player.name then
                order.player = string.format('wait %s; %s', delay, orders)
                delay = (delay + stagger)
    
            elseif target and bp.lib.__distance.get(target) < 25 then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
                delay = (delay + stagger)
    
            end
    
        end
        methods.deliver(order)
    
    end

    methods['r*'] = function(orders)
        local delay = 0
    
        for account in accounts:it() do
            local target = bp.libs.__target.get(account)
    
            if target and account ~= bp.player.name and bp.lib.__distance.get(target) < 25 then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
            end
    
        end
        methods.deliver(order)
    
    end

    methods['rr*'] = function(orders)
        local delay = 0
    
        for account in accounts:it() do
            local target = bp.libs.__target.get(account)
    
            if target and account ~= bp.player.name and bp.lib.__distance.get(target) < 25 then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
                delay = (delay + stagger)
    
            end
    
        end
        methods.deliver(order)
    
    end

    methods['p'] = function(orders)
        local delay = 0
    
        for account in accounts:it() do
    
            if account == bp.player.name then
                order.player = string.format('wait %s; %s', delay, orders)
    
            elseif bp.libs.__party.isMember(account) then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
    
            end
    
        end
        methods.deliver(order)
    
    end

    methods['pp'] = function(orders)
        local delay = 0
    
        for account in accounts:it() do
    
            if account == bp.player.name then
                order.player = string.format('wait %s; %s', delay, orders)
                delay = (delay + stagger)
    
    
            elseif bp.libs.__party.isMember(account) then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
                delay = (delay + stagger)
    
            end
    
        end
        methods.deliver(order)
    
    end

    methods['p*'] = function(orders)
        local delay = 0
    
        for account in accounts:it() do
    
            if account ~= bp.player.name and bp.libs.__party.isMember(account) then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
            end
    
        end
        methods.deliver(order)
    
    end

    methods['pp*'] = function(orders)
        local delay = 0
    
        for account in accounts:it() do
    
            if account ~= bp.player.name and bp.libs.__party.isMember(account) then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
                delay = (delay + stagger)
    
            end
    
        end
        methods.deliver(order)
    
    end

    methods['z'] = function(orders)
        local delay = 0
    
        for account in accounts:it() do
    
            if account == bp.player.name then
                order.player = string.format('wait %s; %s', delay, orders)
    
            elseif account ~= bp.player.name and bp.libs.__party.isInZone(account) then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
    
            end
    
        end
        methods.deliver(order)
    
    end
    
    methods['zz'] = function(orders)
        local delay = 0
    
        for account in accounts:it() do
    
            if account == bp.player.name then
                order.player = string.format('wait %s; %s', delay, orders)
                delay = (delay + stagger)
    
            elseif account ~= bp.player.name and bp.libs.__party.isInZone(account) then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
                delay = (delay + stagger)
    
            end
    
        end
        methods.deliver(order)
    
    end
    
    methods['z*'] = function(orders)
        local delay = 0
    
        for account in accounts:it() do
    
            if account ~= bp.player.name and bp.libs.__party.isInZone(account) then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))    
            end
    
        end
        methods.deliver(order)
    
    end
    
    methods['zz*'] = function(orders)
        local delay = 0
    
        for account in accounts:it() do
    
            if account ~= player.name and bp.libs.__party.isInZone(account) then
                table.insert(order.others, string.format('||%s wait %s; %s', account, delay, orders))
                delay = (delay + stagger)
    
            end
    
        end
        methods.deliver(order)
    
    end

    methods['j'] = function(orders, job)
        local delay = 0
        
        for account in accounts:it() do
            local target = bp.libs.__target.get(account)
    
            if account == bp.player.name and bp.player.main_job:lower() == job then
                order.player = string.format('wait %s; %s', delay, orders)
    
            elseif target and account ~= bp.player.name and bp.libs.__distance.get(target) < 25 then
                table.insert(order.others, string.format('||%s:%s wait %s; %s', account, job, delay, orders))
    
            end
    
        end
        methods.deliver(order)
    
    end
    
    methods['jj'] = function(orders, job)
        local delay = 0
    
        for account in accounts:it() do
            local target = bp.libs.__target.get(account)
    
            if account == bp.player.name and bp.player.main_job:lower() == job then
                order.player = string.format('wait %s; %s', delay, orders)
                delay = (delay + stagger)
    
            elseif target and account ~= bp.player.name and bp.libs.__distance.get(target) < 25 then
                table.insert(order.others, string.format('||%s:%s wait %s; %s', account, job, delay, orders))
                delay = (delay + stagger)
    
            end
    
        end
        methods.deliver(order)
    
    end

    -- Public Methods.
    self.deliver = function(t, order)
        windower.send_command(string.format("%s %s", t, order))
    end

    -- Private Events.
    windower.register_event('unhandled command', function(...)
        local commands = T{...}
        local command = table.remove(commands, 1)
    
        if bp and command and S{'ord','orders'}:contains(command:lower()) then
            local command = commands[1] and table.remove(commands, 1) or false

            if bp.player then
                order = {player=false, others={}}

                if #command > 3 and S{'war','mnk','whm','blm','rdm','thf','pld','drk','bst','brd','rng','smn','sam','nin','drg','blu','cor','pup','dnc','sch','geo','run'}:contains(command:sub(1, 3)) then

                    if command:sub(4, 4) == '*' then
                        methods['jj'](table.concat(commands, ' '), command:sub(1, 3))

                    else
                        methods['j'](table.concat(commands, ' '), command:sub(1, 3))

                    end

                elseif methods[command] then
                    methods[command](table.concat(commands, ' '))

                end

            end

        end

    end)

    windower.register_event('ipc message', function(message)
    
        if bp and bp.player and message then
    
            for order in T(message:split('||')):it() do
    
                if order:sub(1, (#bp.player.name)) == bp.player.name then
    
                    if order:sub((#bp.player.name) + 1, (#bp.player.name) + 1) == ':' then
                        local job = order:sub((#bp.player.name) + 2, (#bp.player.name) + 4)
    
                        if bp.player.main_job:lower() == job then                        
                            windower.send_command(order:sub((#bp.player.name) + 4, #order))
                        end
    
                    else
                        windower.send_command(order:sub((#bp.player.name) + 2, #order))
    
                    end
    
                end
    
            end
    
        end
    
    end)

    return self

end
return library