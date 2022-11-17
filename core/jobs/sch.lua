local images = require('images')
local job = {}
function job.get(bp)
    local self = {}

    if not bp then
        print('ERROR LOADING CORE! PLEASE POST AN ISSUE ON OUR GITHUB!')
        return
    end

    -- Private Variables.
    local bp        = bp
    local private   = {events={}, busy=false}
    local timers    = {skillchains={last=0, delay=15}, sublimation=0}
    local hovers    = {chain=false}
    local chains    = {}
    local flags     = {}

    self.getFlags = function()
        return flags
    end

    self.automate = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = bp.core.get

        do
            private.items()
            if bp and bp.player and bp.player.status == 1 and not private.busy then
                local target  = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
                local _act    = helpers['actions'].canAct()
                local _cast   = helpers['actions'].canCast()
                local gems    = helpers['stratagems'].gems

                if get('ja') and _act then


                end

                if get('buffs') then
                    helpers['buffs'].cast()

                end

                -- DEBUFFS.
                if get('debuffs') then
                    helpers['debuffs'].cast()
                    
                end

            elseif bp and bp.player and bp.player.status == 0 and not private.busy then
                local target  = helpers['target'].getTarget() or false
                local _act    = helpers['actions'].canAct()
                local _cast   = helpers['actions'].canCast()
                local gems    = helpers['stratagems'].gems

                -- HANDLE AUTO-SKILLCHAINS.
                if target and get('ja') and get('skillchain') and get('skillchain').enabled and not get('light arts') and (buff(359) or buff(402)) and gems.current >= 2 and ((os.clock()-timers.skillchains.last) > timers.skillchains.delay or buff(377)) and _act and _cast then
                    private[get('skillchain').mode](target)

                else

                    if get('ja') and _act then

                        -- ARTS.
                        if get('light arts') and isReady('JA', "Light Arts") and not buff(358) and not buff(401) then
                            add(bp.JA["Light Arts"], player)

                        elseif not get('light arts') and isReady('JA', "Dark Arts") and not buff(359) and not buff(402) then
                            add(bp.JA["Dark Arts"], player)

                        end

                        -- ADDENDUM.
                        if get('addendum') and gems.current > 0 and not inQueue(bp.JA["Addendum: White"]) and not inQueue(bp.JA["Addendum: Black"]) then

                            if get('light arts') and isReady('JA', "Addendum: White") and not buff(401) then
                                add(bp.JA["Addendum: White"], player)

                            elseif not get('light arts') and isReady('JA', "Addendum: Black") and not buff(402) then
                                add(bp.JA["Addendum: Black"], player)
                            
                            end

                        end

                        -- SUBLIMATION.
                        if get('sublimation').enabled and _act then
                                    
                            if player['vitals'].mpp <= get('sublimation').mpp and isReady('JA', "Sublimation") and buff(188) and (os.clock()-timers.sublimation) > 60 then
                                add(bp.JA["Sublimation"], player)
                                timers.sublimation = os.clock()

                            elseif player['vitals'].mpp <= 20 and isReady('JA', "Sublimation") and (buff(187) or buff(188)) and (os.clock()-timers.sublimation) > 60 then
                                add(bp.JA["Sublimation"], player)
                                timers.sublimation = os.clock()

                            elseif isReady('JA', "Sublimation") and not buff(187) and not buff(188) then
                                add(bp.JA["Sublimation"], player)
                                timers.sublimation = os.clock()

                            end

                        elseif not get('sublimation').enabled and (buff(187) or buff(188)) then
                            add(bp.JA["Sublimation"], player)
                            
                        end

                    end

                    if get('buffs') and _cast then
        
                        if (buff(358) or buff(359) or buff(401) or buff(402)) then
        
                            -- STORMS.
                            if get('storms').enabled and not bp.core.hasStorm() then

                                if player.job_points['sch'].jp_spent >= 100 then

                                    if (buff(358) or buff(401)) then
                                        add(bp.MA["Aurorastorm II"], player)

                                    elseif (buff(359) or buff(402)) then
                                        add(bp.MA[string.format('%s II', get('storms').name)], player)

                                    end

                                elseif player.job_points['sch'].jp_spent < 100 then

                                    if (buff(358) or buff(401)) then
                                        add(bp.MA["Aurorastorm"], player)

                                    elseif (buff(359) or buff(402)) then
                                        add(bp.MA[get('storms').name], player)

                                    end

                                end

                            end
        
                            -- KLIMAFORM
                            if not get('light arts') and isReady('MA', "Klimaform") and (buff(359) or buff(402)) and not buff(407) and target then
                                add(bp.MA["Klimaform"], player)
        
                            -- STONESKIN.
                            elseif get('stoneskin') and isReady('MA', "Stoneskin") and not buff(37) then
                                add(bp.MA["Stoneskin"], player)
        
                            -- AQUAVEIL.
                            elseif get('aquaveil') and isReady('MA', "Aquaveil") and not buff(39) then
                                add(bp.MA["Aquaveil"], player)
        
                            -- BLINK.
                            elseif get('blink') and isReady('MA', "Blink") and not get('utsusemi') and not buff(36) then
                                add(bp.MA["Blink"], player)
                                
                            -- SPIKES.
                            elseif isReady('MA', get('spikes').name) and bp.core.hasSpikes() and target then
                                add(bp.MA[get('spikes')], player)
                                
                            end
                            helpers['buffs'].cast()
        
                        end
        
                    end
        
                    -- DRAIN.
                    if target and get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and isReady('MA', "Drain") and _cast then
                        add(bp.MA["Drain"], target)
                    end
        
                    -- ASPIR.
                    if target and get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Aspir") and _cast then
                        add(bp.MA["Aspir"], target)
                    end

                    -- DEBUFFS.
                    if target and get('debuffs') then
                        helpers['debuffs'].cast()
                        
                    end

                end

            elseif bp and private.busy then

                if (not bp.helpers['actions'].canAct() or not bp.helpers['actions'].canCast()) then
                    bp.helpers['queue'].clear()
                    private.busy = false

                end

            end

        end
        
    end

    private.items = function()

    end

    private['Scission'] = function(target)

        if bp and target and not bp.core.get('light arts') then
            bp.helpers['queue'].clear()

            if bp.helpers['actions'].isReady('MA', "Fire") and bp.helpers['actions'].isReady('MA', "Stone") then
                private.busy = true

                do
                    if not bp.helpers['buffs'].buffActive(470) then
                        bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    end
                    bp.helpers['queue'].add(bp.MA['Fire'], target)
                    bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    bp.helpers['queue'].add(bp.MA['Stone'], target)

                end
                windower.send_command(string.format('input /p Starting Skillchain >> %s...', bp.core.get('skillchain').mode))

            end

        end

    end

    private['Reverberation'] = function(target)

        if bp and target and not bp.core.get('light arts') then
            bp.helpers['queue'].clear()

            if bp.helpers['actions'].isReady('MA', "Stone") and bp.helpers['actions'].isReady('MA', "Water") then
                private.busy = true

                do
                    if not bp.helpers['buffs'].buffActive(470) then
                        bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    end
                    bp.helpers['queue'].add(bp.MA['Stone'], target)
                    bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    bp.helpers['queue'].add(bp.MA['Water'], target)

                end
                windower.send_command(string.format('input /p Starting Skillchain >> %s...', bp.core.get('skillchain').mode))

            end

        end

    end

    private['Detonation'] = function(target)

        if bp and target and not bp.core.get('light arts') then
            bp.helpers['queue'].clear()

            if bp.helpers['actions'].isReady('MA', "Thunder") and bp.helpers['actions'].isReady('MA', "Aero") then
                private.busy = true

                do
                    if not bp.helpers['buffs'].buffActive(470) then
                        bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    end
                    bp.helpers['queue'].add(bp.MA['Thunder'], target)
                    bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    bp.helpers['queue'].add(bp.MA['Aero'], target)

                end
                windower.send_command(string.format('input /p Starting Skillchain >> %s...', bp.core.get('skillchain').mode))

            end

        end

    end

    private['Liquefaction'] = function(target)

        if bp and target and not bp.core.get('light arts') then
            bp.helpers['queue'].clear()

            if bp.helpers['actions'].isReady('MA', "Thunder") and bp.helpers['actions'].isReady('MA', "Fire") then
                private.busy = true

                do
                    if not bp.helpers['buffs'].buffActive(470) then
                        bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    end
                    bp.helpers['queue'].add(bp.MA['Thunder'], target)
                    bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    bp.helpers['queue'].add(bp.MA['Fire'], target)

                end
                windower.send_command(string.format('input /p Starting Skillchain >> %s...', bp.core.get('skillchain').mode))

            end

        end

    end

    private['Induration'] = function(target)

        if bp and target and not bp.core.get('light arts') then
            bp.helpers['queue'].clear()

            if bp.helpers['actions'].isReady('MA', "Water") and bp.helpers['actions'].isReady('MA', "Blizzard") then
                private.busy = true

                do
                    if not bp.helpers['buffs'].buffActive(470) then
                        bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    end
                    bp.helpers['queue'].add(bp.MA['Water'], target)
                    bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    bp.helpers['queue'].add(bp.MA['Blizzard'], target)

                end
                windower.send_command(string.format('input /p Starting Skillchain >> %s...', bp.core.get('skillchain').mode))

            end

        end

    end

    private['Impaction'] = function(target)

        if bp and target and not bp.core.get('light arts') then
            bp.helpers['queue'].clear()

            if bp.helpers['actions'].isReady('MA', "Blizzard") and bp.helpers['actions'].isReady('MA', "Thunder") then
                private.busy = true

                do
                    if not bp.helpers['buffs'].buffActive(470) then
                        bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    end
                    bp.helpers['queue'].add(bp.MA['Blizzard'], target)
                    bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    bp.helpers['queue'].add(bp.MA['Thunder'], target)

                end
                windower.send_command(string.format('input /p Starting Skillchain >> %s...', bp.core.get('skillchain').mode))

            end

        end

    end

    private['Compression'] = function(target)

        if bp and target and not bp.core.get('light arts') then
            bp.helpers['queue'].clear()

            if bp.helpers['actions'].isReady('MA', "Blizzard") and bp.helpers['actions'].isReady('MA', "Noctohelix") then
                private.busy = true

                do
                    if not bp.helpers['buffs'].buffActive(470) then
                        bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    end
                    bp.helpers['queue'].add(bp.MA['Blizzard'], target)
                    bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    bp.helpers['queue'].add(bp.MA['Noctohelix'], target)

                end
                windower.send_command(string.format('input /p Starting Skillchain >> %s...', bp.core.get('skillchain').mode))

            end

        end

    end

    private['Gravitation'] = function(target)

        if bp and target and not bp.core.get('light arts') then
            bp.helpers['queue'].clear()

            if bp.helpers['actions'].isReady('MA', "Aero") and bp.helpers['actions'].isReady('MA', "Noctohelix") then
                private.busy = true

                do
                    if not bp.helpers['buffs'].buffActive(470) then
                        bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    end
                    bp.helpers['queue'].add(bp.MA['Aero'], target)
                    bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    bp.helpers['queue'].add(bp.MA['Noctohelix'], target)

                end
                windower.send_command(string.format('input /p Starting Skillchain >> %s...', bp.core.get('skillchain').mode))

            end

        end

    end

    private['Distortion'] = function(target)

        if bp and target and not bp.core.get('light arts') then
            bp.helpers['queue'].clear()

            if bp.helpers['actions'].isReady('MA', "Luminohelix") and bp.helpers['actions'].isReady('MA', "Stone") then
                private.busy = true

                do
                    if not bp.helpers['buffs'].buffActive(470) then
                        bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    end
                    bp.helpers['queue'].add(bp.MA['Luminohelix'], target)
                    bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    bp.helpers['queue'].add(bp.MA['Stone'], target)

                end
                windower.send_command(string.format('input /p Starting Skillchain >> %s...', bp.core.get('skillchain').mode))

            end

        end

    end

    private['Fragmentation'] = function(target)

        if bp and target and not bp.core.get('light arts') then
            bp.helpers['queue'].clear()

            if bp.helpers['actions'].isReady('MA', "Blizzard") and bp.helpers['actions'].isReady('MA', "Water") then
                private.busy = true

                do
                    if not bp.helpers['buffs'].buffActive(470) then
                        bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    end
                    bp.helpers['queue'].add(bp.MA['Blizzard'], target)
                    bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    bp.helpers['queue'].add(bp.MA['Water'], target)

                end
                windower.send_command(string.format('input /p Starting Skillchain >> %s...', bp.core.get('skillchain').mode))

            end

        end

    end

    private['Fusion'] = function(target)

        if bp and target and not bp.core.get('light arts') then
            bp.helpers['queue'].clear()

            if bp.helpers['actions'].isReady('MA', "Fire") and bp.helpers['actions'].isReady('MA', "Thunder") then
                private.busy = true

                do
                    if not bp.helpers['buffs'].buffActive(470) then
                        bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    end
                    bp.helpers['queue'].add(bp.MA['Fire'], target)
                    bp.helpers['queue'].add(bp.JA['Immanence'], bp.player)
                    bp.helpers['queue'].add(bp.MA['Thunder'], target)

                end
                windower.send_command(string.format('input /p Starting Skillchain >> %s...', bp.core.get('skillchain').mode))

            end

        end

    end

    private.buildSkillchainDisplay = function()
        local elements  = {false,'Compression','Liquefaction','Scission','Reverberation','Detonation','Induration','Impaction','Gravitation','Distortion','Fusion','Fragmentation',false,false,false,false}

        if bp and bp.player and bp.player.main_job == 'SCH' then
            
            for n, element in ipairs(elements) do
                
                if element then
                    table.insert(chains, {display=images.new({color={alpha = 255}, texture={fit=false}, draggable=false}), element=element})
                    
                    if #chains == 1 then
                        chains[#chains].display:path(string.format("%sbp/resources/icons/skillchains/%s.png", windower.addon_path, n))
                        chains[#chains].display:size(22, 22)
                        chains[#chains].display:transparency(0)
                        chains[#chains].display:pos_x(bp.core.get('pos').x or 1200)
                        chains[#chains].display:pos_y(bp.core.get('pos').y or 1220)

                        if bp and element == bp.core.get('skillchain').mode then
                            chains[#chains].display:color(255,255,255)

                        else
                            chains[#chains].display:color(50,50,50)

                        end
                        chains[#chains].display:show()
            
                    else
                        chains[#chains].display:path(string.format("%sbp/resources/icons/skillchains/%s.png", windower.addon_path, n))
                        chains[#chains].display:size(22, 22)
                        chains[#chains].display:transparency(0)
                        chains[#chains].display:pos_x(chains[#chains-1].display:pos_x()+22)
                        chains[#chains].display:pos_y(chains[#chains-1].display:pos_y())
                        
                        if bp and element == bp.core.get('skillchain').mode then
                            chains[#chains].display:color(255,255,255)

                        else
                            chains[#chains].display:color(50,50,50)

                        end
                        chains[#chains].display:show()
            
                    end

                end
        
            end

        end

    end

    private.updateSkillchainDisplay = function()
        local elements  = {false,'Compression','Liquefaction','Scission','Reverberation','Detonation','Induration','Impaction','Gravitation','Distortion','Fusion','Fragmentation',false,false,false,false}

        if bp and bp.player and bp.player.main_job == 'SCH' then
            local update_pos = false

            for n, object in ipairs(chains) do
                    
                if n == 1 then
                    
                    if (object.display:pos_x() ~= bp.core.get('pos').x or object.display:pos_y() ~= bp.core.get('pos').y) then
                        object.display:pos_x(bp.core.get('pos').x)
                        object.display:pos_y(bp.core.get('pos').y)
                        update_pos = true

                    end

                    if object.element == bp.core.get('skillchain').mode then
                        object.display:color(255,255,255)

                    else
                        object.display:color(50,50,50)

                    end
        
                else

                    if update_pos then
                        object.display:pos_x(chains[n-1].display:pos_x()+22)
                        object.display:pos_y(chains[n-1].display:pos_y())

                    end
                    
                    if object.element == bp.core.get('skillchain').mode then
                        object.display:color(255,255,255)

                    else
                        object.display:color(50,50,50)

                    end
        
                end
        
            end

        end

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = table.remove(commands, 1)

        if bp and bp.player and helper and helper:lower() == 'sch' then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if command then

                if command == 'pos' then
                    coroutine.schedule(function()
                        private.updateSkillchainDisplay()
                    
                    end, 0.10)

                end

            end

        end

    end)

    private.events.mouse = windower.register_event('mouse', function(param, x, y, delta, blocked)

        if param == 1 then
            
            for _,object in ipairs(chains) do
                
                if object.display:hover(x, y) then
                    windower.send_command(string.format('bp ? skillchain %s', object.element:lower()))
                    hovers.chain = true
                    return true
                    
                end

            end

        elseif param == 2 then
            
            if hovers.chain then
                hovers.chain = false
                private.updateSkillchainDisplay()
                return true
            end

        end

    end)

    private.events.actions = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
        
        if bp and id == 0x028 and bp.core.get('skillchain') and bp.core.get('skillchain').enabled then
            local parsed    = bp.packets.parse('incoming', original)
            local player    = bp.player
            local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
            local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
            local count     = parsed['Target Count']
            local category  = parsed['Category']
            local param     = parsed['Param']
            
            if player and parsed and actor and target then

                if S{3,4,13}:contains(parsed['Category']) and bp.helpers['party'].isInParty(actor, true) then

                    if S{288,289,290,291,292,293,294,295,296,297,298,299,300,301,385,386,387,388,389,390,391,392,393,394,395,396,397,767,768,769,770}:contains(parsed['Target 1 Action 1 Added Effect Message']) then
                        timers.skillchains.last = os.clock()
                        private.busy = false

                        if actor.id == player.id then
                            windower.send_command(string.format('input /p Skillchain Complete!', actor.name))

                        else
                            windower.send_command(string.format('input /p Skillchain Interrupted/Closed by: %s!', actor.name))

                        end

                    end

                end

            end

        end

    end)

    private.events.jobchange = windower.register_event('job change', function()
        local elements  = {false,'Compression','Liquefaction','Scission','Reverberation','Detonation','Induration','Impaction','Gravitation','Distortion','Fusion','Fragmentation',false,false,false,false}
        
        for n, element in ipairs(elements) do

            if chains[n] then
                chains[n].display:destroy()
            end
            
        end
        
        for _,id in pairs(private.events) do
            windower.unregister_event(id)
        end

    end)

    -- Initialize Display.
    coroutine.schedule(function()
        private.buildSkillchainDisplay()

    end, 2)

    return self

end
return job