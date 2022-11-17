local library = {}
function library:new(bp)
    local bp = bp

    -- Private Variables.
    local rate = 0

    -- Public Variables.
    self.current    = 0
    self.max        = 0

    -- Private Methods.
    local calculate = function()
        local current = math.floor((self.max-(windower.ffxi.get_ability_recasts()[231] or 0/rate)))

        do -- Set the current stratagem count.
            self.current = current > -math.huge and current < math.huge and current or 0

        end

    end

    local setStratagems = function()

        if bp and bp.player then

            if bp.player.main_job and bp.player.main_job == 'SCH' then
                local main = {job=bp.player.main_job, lvl=bp.player.main_job_level}
            
                if (main.lvl >= 10 and main.lvl <= 29) then
                    self.max, rate = 1, 240

                elseif (main.lvl >= 30 and main.lvl <= 49) then
                    self.max, rate = 2, 120

                elseif (main.lvl >= 50 and main.lvl <= 69) then
                    self.max, rate = 3, 80

                elseif (main.lvl >= 70 and main.lvl <= 89) then
                    self.max, rate = 4, 60
                        
                elseif main.lvl >= 90 then

                    if bp.player['job_points'][main.job:lower()].jp_spent >= 550 then
                        self.max, rate = 5, 33

                    else
                        self.max, rate = 5, 48

                    end
                        
                end
                
            elseif bp.player.sub_job and bp.player.sub_job == 'SCH' then
                local sub = {job=bp.player.sub_job, lvl=bp.player.sub_job_level}
                
                if (sub.lvl >= 10 and sub.lvl <= 29) then
                    self.max, rate = 1, 240

                elseif (sub.lvl >= 30 and sub.lvl <= 49) then
                    self.max, rate = 2, 120

                elseif (sub.lvl >= 50 and sub.lvl <= 69) then
                    self.max, rate = 3, 80

                end            
                    
            else
                self.max, rate = 0, 255
                    
            end

        end
    
    end

    -- Public Methods.
    self.getCurrent = function() return self.stratagems.current end
    self.getMax = function() return self.stratagems.max end

    -- Private Events.
    windower.register_event('prerender', calculate)
    windower.register_event('login','load','job change', function()  setStratagems:schedule(1) end)
    windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
        
        if bp and id == 0x028 then
            local parsed    = bp.packets.parse('incoming', original)
            local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
            local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
            
            if bp.player and parsed and actor and actor.id == bp.player.id and parsed['Category'] == 6 then
                setStratagems()
            end
    
        end
        
    end)

    return self

end
return library