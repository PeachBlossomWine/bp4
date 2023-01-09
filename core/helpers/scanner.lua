local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.
        local __keywords = T{}

        -- Private Methods.
        pvt.scan = function(id, original)

            if bp and id == 0x017 and #__keywords > 0 then
                local parsed = bp.packets.parse('incoming', original)
            
                if parsed and parsed['Mode'] == 26 and parsed['Message'] then
                    local words = {}

                    for _,word in ipairs(windower.convert_auto_trans(parsed['Message']):gsub('[%p%c]', ''):split(' ')) do
                        table.insert(words, word:lower())
                    end
                    
                    for _,word in ipairs(words) do

                        for keyword in __keywords:it() do

                            if word:match(keyword:lower()) then
                                bp.__orders.deliver('@', string.format("input /echo %s has keyword match [ %s ] in yell.", parsed['Sender Name']:color(258), keyword:color(258)))
                                break

                            end

                        end

                    end

                end

            end

        end
        
        -- Private Events.
        helper('incoming chunk', pvt.scan)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == 'scan' and #commands > 0 then
                local command = commands[1] and table.remove(commands, 1):lower() or false

                if command == '+' and commands[1] and not __keywords:contains(commands[1]:lower()) then
                    table.insert(__keywords, commands[1]:lower())
                    bp.popchat.pop(string.format("\\cs(%s)%s\\cr ADDED TO CHAT SCANNER", bp.colors.setting, commands[1]:upper()))

                elseif command == '-' and commands[1] and __keywords:contains(commands[1]:lower()) then
                    
                    for keyword, index in __keywords:it() do

                        if commands[1] == keyword then
                            __keywords:remove(index)
                            bp.popchat.pop(string.format("\\cs(%s)%s\\cr REMOVED FROM CHAT SCANNER", bp.colors.setting, commands[1]:upper()))
                            break

                        end

                    end

                elseif command == 'clear' then
                    __keywords = T{}

                end

            end
    
        end)

        return new

    end

    return helper

end
return buildHelper