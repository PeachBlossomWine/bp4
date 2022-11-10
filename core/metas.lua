local hmt = {}

hmt.__call = function(t, ...)
    local helper    = t
    local options   = T{...}
    
    print('meta', ...)

    if #options == 2 then
    
        if T{'incoming','outgoing'}:contains(options[1]) and type(options[2]) == 'function' then
            local direction = options[1] == 'incoming' and 'incoming chunk' or 'outgoing chunk'

            do -- Add to the events list.
                table.insert(helper.events, windower.register_event(direction, options[2]))

            end

        elseif type(options[1]) == 'string' and type(options[2]) == 'function' then
            table.insert(helper.events, windower.register_event(options[1], options[2]))

        end

    end

end
return hmt