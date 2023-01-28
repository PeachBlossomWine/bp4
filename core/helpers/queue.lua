local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)
    local layout    = {pos={x=200, y=80}, bg={alpha=175, red=0, green=0, blue=0, visible=true}, flags={draggable=true, bold=false}, text={size=8, font='Lucida Console', alpha=255, red=245, green=200, blue=20, stroke={width=1, alpha=255, red=0, green=0, blue=0}}, padding=2}
    local settings  = bp.__settings.new('queue')

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}

        -- Private Variables.

        do -- Private Settings.
            settings.layout     = settings.layout or layout
            settings.max        = settings.max or 30
            settings.display    = settings:getDisplay()

        end

        -- Save after all settings have been initialized.
        settings:save()

        -- Private Methods.
        pvt.render = function()
            local update = {}

            bp.__ui.renderUI(settings.display, function()
                local __ready = bp.__queue.getReady()-os.clock() > 0 and (bp.__queue.getReady()-os.clock()) or 0
                local __queue = bp.__queue.getQueue()

                if bp and bp.player and __queue:length() > 0 then

                    for q, index in __queue:it() do

                        if q.attempts and q.action and q.target then
                            local colors    = {english='0,153,204', attempts='255,255,255', name='102,225,051', cost='50,180,120'}
                            local attempts  = q.attempts
                            local english   = #q.action.en > 15 and string.format("%s...", q.action.en:sub(1,15)) or q.action.en
                            local name      = #q.target.name > 15 and string.format("%s...", q.target.name:sub(1,15)) or q.target.name
                            local cost      = 0

                            if S{'/magic','/ninjutsu','/song'}:contains(q.action.prefix) then
                                cost = q.action.mp_cost

                            elseif S{'/jobability','/pet'}:contains(q.action.prefix) then
                                cost = q.action.tp_cost >= q.action.mp_cost and q.action.tp_cost or q.action.mp_cost

                            end

                            if index <= settings.max then

                                if index == 1 then
                                    table.insert(update, string.format("\n%s[ ACTION QUEUE (%05.2f) ]%s\n", (''):lpad(' ', 25), __ready, (''):rpad(' ', 25)))
                                    table.insert(update, string.format("%s<\\cs(%s)%02d\\cr> [ \\cs(%s)%03d\\cr ] \\cs(%s)%s \\cr%s►%s\\cs(%s)%s\\cr",
                                        (''):lpad(' ', 5),
                                        colors.attempts,
                                        attempts,
                                        colors.cost,
                                        cost,
                                        colors.english,
                                        english,
                                        (''):rpad('-', 25-english:len()),
                                        (''):rpad(' ', 2),
                                        colors.name,
                                        name
                                    ))

                                else
                                    table.insert(update, string.format("%s<\\cs(%s)%02d\\cr> [ \\cs(%s)%03d\\cr ] \\cs(%s)%s \\cr%s %s\\cs(%s)%s\\cr",
                                        (''):lpad(' ', 5),
                                        colors.attempts,
                                        attempts,
                                        colors.cost,
                                        cost,
                                        colors.english,
                                        english,
                                        (''):rpad(' ', 25-english:len()),
                                        (''):rpad(' ', 2),
                                        colors.name,
                                        name

                                    ))

                                end

                            end

                        end

                        if index == __queue:length() then
                            table.insert(update, "\n")
                        end
                        
                    end
                    settings.display:text(table.concat(update, '\n'))

                else
                    settings.display:text("")
                    settings.display:hide()

                end
            
            end)

        end

        -- Private Events.
        helper('prerender', pvt.render)
        helper('addon command', function(...)
            local commands  = T{...}
            local command   = table.remove(commands, 1)
            
            if bp and command and command:lower() == '--------------------------' and #commands > 0 then

            end
    
        end)

        return new

    end

    return helper

end
return buildHelper