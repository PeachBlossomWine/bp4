local job = {}
local texts = require('texts')
local images = require('images')
function job.get(bp)
    local self = {}

    if not bp then
        print('ERROR LOADING CORE! PLEASE POST AN ISSUE ON OUR GITHUB!')
        return
    end

    -- Private Variables.
    local bp        = bp
    local private   = {events={}}
    local timers    = {update={last=0, delay=1}}
    local flags     = {}

    -- Register SMN Aliases.
    bp.helpers['alias'].register({
    
        {'smn_rage',    "ord p bp smn do_rage"},
        {'smn_ward',    "ord p bp smn do_ward"},
        {'smn_assault', "ord p bp smn do_assault"},
        {'smn_retreat', "ord p bp smn do_retreat"},
        {'smn_summon',  "ord p bp smn do_summon"},
        {'smn_release', "ord p bp smn do_release"},

    })

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
        local pet       = windower.ffxi.get_mob_by_target('pet') or false

        do
            private.items()
            if bp and bp.player and bp.player.status == 1 then
                local target  = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
                local _act    = helpers['actions'].canAct()
                local _cast   = helpers['actions'].canCast()

                if get('ja') and _act then

                    if pet then

                        if isReady('JA', "Avatar's Favor") and not buff(431) then
                            add(bp.JA["Avatar's Favor"], player)

                        else

                            if pet.name ~= get('summon').name and isReady('JA', "Release") then
                                add(bp.JA["Release"], player)

                            elseif pet.name == get('summon').name then

                                -- 1HR.
                                if target and get('1hr') and isReady('JA', "Astral Flow") and isReady('JA', "Astral Conduit") then
                                    add(bp.JA["Astral Flow"], player)
                                    add(bp.JA["Astral Conduit"], player)

                                end

                                -- ASSAULT.
                                if target and get('assault') and pet.status == 0 and isReady('JA', "Assault") then
                                    add(bp.JA["Assault"], target)

                                elseif pet.status == 1 or (pet.status == 0 and not get('assault') and target) then

                                    if pet.status == 1 and not get('assault') and isReady('JA', "Retreat") then
                                        add(bp.JA["Retreat"], player)
                                    end
                                    
                                    if not buff(504) and get('bpr') and get('bpw') and not bp.core.get('mbpact') then

                                        -- RAGES.
                                        if get('bpr').enabled and get('bpr').pacts[pet.name] and bp.JA[get('bpr').pacts[pet.name]] then
                                            local rage = bp.JA[get('bpr').pacts[pet.name]] or false

                                            if rage and isReady('JA', rage.en) then

                                                -- APOGEE.
                                                if get('apogee') and isReady('JA', "Apogee") then
                                                    add(bp.JA["Apogee"], player)
                                                end

                                                -- MANA CEDE.
                                                if get('mana cede') and isReady('JA', "Mana Cede") then
                                                    add(bp.JA["Mana Cede"], player)
                                                end
                                                add(bp.JA[rage.en], target)

                                            end

                                        end

                                        -- WARDS.
                                        if get('bpw').enabled and get('bpw').pacts[pet.name] and bp.JA[get('bpw').pacts[pet.name]] then
                                            local ward = bp.JA[get('bpw').pacts[pet.name]] or false

                                            if ward and isReady('JA', ward.en) then

                                                if ward.en == "Mewing Lullaby" then

                                                    -- APOGEE.
                                                    if get('apogee') and isReady('JA', "Apogee") then
                                                        add(bp.JA["Apogee"], player)
                                                    end

                                                    if not helpers['target'].castable(target, ward) and helpers['target'].castable(player, ward) and get('buffs') then
                                                        add(bp.JA[ward.en], player)

                                                    elseif helpers['target'].castable(target, ward) then
                                                        add(bp.JA[ward.en], target)

                                                    end

                                                else

                                                    if not helpers['target'].castable(target, ward) and helpers['target'].castable(player, ward) and get('buffs') then
                                                        add(bp.JA[ward.en], player)

                                                    elseif helpers['target'].castable(target, ward) then
                                                        add(bp.JA[ward.en], target)

                                                    end

                                                end

                                            end

                                        end

                                    elseif buff(504) and get('bpr') and get('bpw') and not bp.core.get('mbpact') then

                                        -- RAGES.
                                        if get('bpr').enabled and get('bpr').pacts[pet.name] and bp.JA[get('bpr').pacts[pet.name]] then
                                            local rage = bp.JA[get('bpr').pacts[pet.name]]

                                            if rage and isReady('JA', rage.en) then
                                                add(bp.JA[rage.en], target)
                                            end

                                        end

                                        -- WARDS.
                                        if get('bpw').enabled and get('bpw').pacts[pet.name] and bp.JA[get('bpw').pacts[pet.name]] then
                                            local ward = bp.JA[get('bpw').pacts[pet.name]]

                                            if ward and isReady('JA', ward.en) then

                                                if ward.en == "Mewing Lullaby" then
                                                    add(bp.JA[ward.en], target)
                                                end

                                            end

                                        end

                                    end

                                end

                            end

                        end

                    end

                end

                -- SUMMONING.
                if (not pet or T{2,3}:contains(pet.status)) and get('summon').enabled and isReady('MA', get('summon').name) and player['vitals'].mpp > 15 and _cast then
                    add(bp.MA[get('summon').name], player)
                end

                if get('buffs') then
                    helpers['buffs'].cast()
                end

                -- DEBUFFS.
                if get('debuffs') then
                    helpers['debuffs'].cast()                    
                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = helpers['actions'].canAct()
                local _cast   = helpers['actions'].canCast()

                if get('ja') and _act then

                    if pet then

                        if isReady('JA', "Avatar's Favor") and not buff(431) then
                            add(bp.JA["Avatar's Favor"], player)

                        else

                            if pet.name ~= get('summon').name and isReady('JA', "Release") then
                                add(bp.JA["Release"], player)

                            elseif pet.name == get('summon').name then

                                -- 1HR.
                                if target and get('1hr') and isReady('JA', "Astral Flow") and isReady('JA', "Astral Conduit") then
                                    add(bp.JA["Astral Flow"], player)
                                    add(bp.JA["Astral Conduit"], player)

                                end

                                -- ASSAULT.
                                if target and get('assault') and pet.status == 0 and isReady('JA', "Assault") then
                                    add(bp.JA["Assault"], target)

                                elseif pet.status == 1 or (pet.status == 0 and not get('assault') and target) then

                                    if pet.status == 1 and not get('assault') and isReady('JA', "Retreat") then
                                        add(bp.JA["Retreat"], player)
                                    end
                                    
                                    if not buff(504) and get('bpr') and get('bpw') and not bp.core.get('mbpact') then

                                        -- RAGES.
                                        if get('bpr').enabled and get('bpr').pacts[pet.name] and bp.JA[get('bpr').pacts[pet.name]] then
                                            local rage = bp.JA[get('bpr').pacts[pet.name]] or false

                                            if rage and isReady('JA', rage.en) then

                                                -- APOGEE.
                                                if get('apogee') and isReady('JA', "Apogee") then
                                                    add(bp.JA["Apogee"], player)
                                                end

                                                -- MANA CEDE.
                                                if get('mana cede') and isReady('JA', "Mana Cede") then
                                                    add(bp.JA["Mana Cede"], player)
                                                end
                                                add(bp.JA[rage.en], target)

                                            end

                                        end

                                        -- WARDS.
                                        if get('bpw').enabled and get('bpw').pacts[pet.name] and bp.JA[get('bpw').pacts[pet.name]] then
                                            local ward = bp.JA[get('bpw').pacts[pet.name]] or false

                                            if ward and isReady('JA', ward.en) then

                                                if ward.en == "Mewing Lullaby" then

                                                    -- APOGEE.
                                                    if get('apogee') and isReady('JA', "Apogee") then
                                                        add(bp.JA["Apogee"], player)
                                                    end

                                                    if not helpers['target'].castable(target, ward) and helpers['target'].castable(player, ward) and get('buffs') then
                                                        add(bp.JA[ward.en], player)

                                                    elseif helpers['target'].castable(target, ward) then
                                                        add(bp.JA[ward.en], target)

                                                    end

                                                else

                                                    if not helpers['target'].castable(target, ward) and helpers['target'].castable(player, ward) and get('buffs') then
                                                        add(bp.JA[ward.en], player)

                                                    elseif helpers['target'].castable(target, ward) then
                                                        add(bp.JA[ward.en], target)

                                                    end

                                                end

                                            end

                                        end

                                    elseif buff(504) and get('bpr') and get('bpw') and not bp.core.get('mbpact') then

                                        -- RAGES.
                                        if get('bpr').enabled and get('bpr').pacts[pet.name] and bp.JA[get('bpr').pacts[pet.name]] then
                                            local rage = bp.JA[get('bpr').pacts[pet.name]]

                                            if rage and isReady('JA', rage.en) then
                                                add(bp.JA[rage.en], target)
                                            end

                                        end

                                        -- WARDS.
                                        if get('bpw').enabled and get('bpw').pacts[pet.name] and bp.JA[get('bpw').pacts[pet.name]] then
                                            local ward = bp.JA[get('bpw').pacts[pet.name]]

                                            if ward and isReady('JA', ward.en) then

                                                if ward.en == "Mewing Lullaby" then
                                                    add(bp.JA[ward.en], target)
                                                end

                                            end

                                        end

                                    end

                                end

                            end

                        end

                    end

                end

                -- SUMMONING.
                if (not pet or T{2,3}:contains(pet.status)) and get('summon').enabled and isReady('MA', get('summon').name) and player['vitals'].mpp > 15 and _cast then
                    add(bp.MA[get('summon').name], player)
                end

                if get('buffs') then
                    helpers['buffs'].cast()
                end

                -- DEBUFFS.
                if target and get('debuffs') then
                    helpers['debuffs'].cast()                    
                end

            end

        end
        
    end

    private.items = function()
        local target    = bp.helpers['target'].getTarget()
        local _act      = bp.helpers['actions'].canAct()
        local _cast     = bp.helpers['actions'].canCast()
        local _item     = bp.helpers['actions'].canItem()
        local add       = bp.helpers['queue'].addToFront
        local buffs     = T(bp.player.buffs)

        if _item then

            if buffs:contains(6) and not buffs:contains(29) and bp.helpers['inventory'].hasItem("Echo Drops", 0) then
                add(bp.IT["Echo Drops"], bp.player)

            elseif (buffs:contains(149) or buffs:contains(558)) and bp.helpers['inventory'].hasItem("Panacea", 0) then
                add(bp.IT["Panacea"], bp.player)

            elseif bp.player['vitals'].mpp <= 15 and buffs:contains(504) and bp.helpers['inventory'].hasItem("Megalixir", 3) then
                add(bp.IT["Megalixir"], bp.player)

            end

        end

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = table.remove(commands, 1)

        if bp and helper and helper:lower() == 'smn' then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if command then
                local target = windower.ffxi.get_mob_by_target('bt') or false
                local pet = windower.ffxi.get_mob_by_target('pet') or false

                if target and pet then
                    local rage = bp.JA[bp.core.get('bpr').pacts[pet.name]] or false
                    local ward = bp.JA[bp.core.get('bpw').pacts[pet.name]] or false

                    if command == 'do_rage' then
                        windower.send_command(string.format('input /pet "%s" %s', rage.en, target.id))

                    elseif command == 'do_ward' then
                        windower.send_command(string.format('input /pet "%s" %s', ward.en, target.id))

                    elseif command == 'do_assault' then
                        windower.send_command(string.format('input /pet "Assault" %s', target.id))

                    end

                elseif pet then

                    if command == 'do_retreat' then
                        windower.send_command('input /pet "Retreat" <me>')

                    elseif command == 'do_release' then
                        windower.send_command('input /pet "Release" <me>')

                    end

                else
                    
                    if command == 'do_summon' then
                        windower.send_command(string.format('input /pet "%s" <me>', bp.core.get('summon').name))

                    end

                end

            end

        end

    end)

    private.events.jobchange = windower.register_event('job change', function(main, sub)

        for _,id in pairs(private.events) do
            windower.unregister_event(id)
        end
        bp.helpers['alias'].unregister({'smn_rage','smn_ward','smn_assault','smn_retreat','smn_summon','smn_release'})

    end)

    private.events.actions = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
        
        if bp and id == 0x028 then
            local parsed    = bp.packets.parse('incoming', original)
            local player    = bp.player
            local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
            local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
            local pet       = windower.ffxi.get_mob_by_target('pet') or false
            local category  = parsed['Category']
            local param     = parsed['Param']
            
            if player and actor and target and actor.id == target.id and actor.id == player.id and bp.core.get('rotate') then
                local wards = S{
                    
                    'Shining Ruby','Glittering Ruby','Healing Ruby II','Soothing Ruby','Mewing Lullaby','Crimson Howl','Inferno Howl','Crystal Blessing','Whispering Wind','Hastega II',
                    'Earthen Armor','Rolling Thunder','Shock Squall','Spring Water','Ecliptic Growl','Ecliptic Howl','Somnolence','Dream Shroud','Bitter Elegy','Wind\'s Blessing',
        
                }

                if category == 6 and bp.res.job_abilities[param] and wards:contains(bp.res.job_abilities[param].en) then
                    bp.core.rotateWards()
                end

            elseif player and actor and target and pet and bp.helpers['party'].isInParty(actor, true) and bp.core.get('mbpact') and bp.helpers['target'].getTarget() then
                
                if T{3,4,13}:contains(parsed['Category']) then
                    local chains = bp.helpers['burst'].getChains()
                    
                    if chains and S{288,289,290,291,292,293,294,295,296,297,298,299,300,301,385,386,387,388,389,390,391,392,393,394,395,396,397,767,768,769,770}:contains(parsed['Target 1 Action 1 Added Effect Message']) and chains[parsed['Target 1 Action 1 Added Effect Message']] then
                        local rage = bp.core.get('bpr').pacts[pet.name] or false

                        if bp.JA[rage] and chains[parsed['Target 1 Action 1 Added Effect Message']]:contains(bp.res.elements[bp.JA[rage].element].en) then
                            bp.helpers['queue'].add(bp.JA[rage], target)
                        end

                    end

                end

            end

        end

    end)

    return self

end
return job