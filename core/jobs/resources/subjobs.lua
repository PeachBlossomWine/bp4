local subjobs = {}
subjobs['WAR'] = function()
    local player = bp.player

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('hate').enabled and target then

            -- PROVOKE.
            if target and get('provoke') and _act and isReady('JA', "Provoke") then
                add(bp.JA["Provoke"], target)
            end

        end

        if get('buffs') and target and _act then

            -- BERSERK.
            if target and not get('tank') and get('berserk') and isReady('JA', "Berserk") and not inQueue(bp.JA["Defender"]) and not buff(56) then
                add(bp.JA["Berserk"], player)

            -- DEFENDER.
            elseif target and get('tank') and get('defender') and isReady('JA', "Defender") and not inQueue(bp.JA["Berserk"]) and not buff(57) then
                add(bp.JA["Defender"], player)

            -- WARCRY.
            elseif target and get('warcry') and isReady('JA', "Warcry") and not buff(68) then
                add(bp.JA["Warcry"], player)

            -- AGGRESSOR.
            elseif target and get('aggressor') and isReady('JA', "Aggressor") and not buff(58) then
                add(bp.JA["Aggressor"], player)

            -- RETALIATION.
            elseif target and get('retaliation') and isReady('JA', "Retaliation") and not buff(405) then
                add(bp.JA["Retaliation"], player)

            end

        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('hate').enabled then

            -- PROVOKE.
            if get('provoke') and _act and isReady('JA', "Provoke") then
                add(bp.JA["Provoke"], target)
            end

        end

        if get('buffs') and _act then

            -- BERSERK.
            if not get('tank') and get('berserk') and isReady('JA', "Berserk") and not inQueue(bp.JA["Defender"]) and not buff(56) then
                add(bp.JA["Berserk"], player)

            -- DEFENDER.
            elseif get('tank') and get('defender') and isReady('JA', "Defender") and not inQueue(bp.JA["Berserk"]) and not buff(57) then
                add(bp.JA["Defender"], player)

            -- WARCRY.
            elseif get('warcry') and isReady('JA', "Warcry") and not buff(68) then
                add(bp.JA["Warcry"], player)

            -- AGGRESSOR.
            elseif get('aggressor') and isReady('JA', "Aggressor") and not buff(58) then
                add(bp.JA["Aggressor"], player)

            -- RETALIATION.
            elseif get('retaliation') and isReady('JA', "Retaliation") and not buff(405) then
                add(bp.JA["Retaliation"], player)

            end

        end

    end

end

subjobs['MNK'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and _act then

            -- CHAKRA.
            if get('chakra').enabled and isReady('JA', "Chakra") and player['vitals'].hpp <= get('chakra').hpp then
                add(bp.JA["Chakra"], player)

            -- CHI BLAST.
            elseif target and get('chi blast') and isReady('JA', "Chi Blast") then
                add(bp.JA["Chi Blast"], target)

            end

        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and _act then

            -- CHAKRA.
            if get('chakra').enabled and isReady('JA', "Chakra") and player['vitals'].hpp <= get('chakra').hpp then
                add(bp.JA["Chakra"], player)

            -- CHI BLAST.
            elseif get('chi blast') and isReady('JA', "Chi Blast") then
                add(bp.JA["Chi Blast"], target)

            end

        end

        if get('buffs') and _act then

            -- FOCUS.
            if get('focus') and isReady('JA', "Focus") and not buff(59) then
                add(bp.JA["Focus"], player)

            -- DODGE.
            elseif get('dodge') and isReady('JA', "Dodge") and not buff(60) then
                add(bp.JA["Dodge"], player)

            -- COUNTERSTANCE.
            elseif get('counterstance') and isReady('JA', "Counterstance") and not buff(61) then
                add(bp.JA["Counterstance"], player)

            -- FOOTWORK.
            elseif get('footwork') and isReady('JA', "Footwork") and not buff(406) then
                add(bp.JA["Footwork"], player)

            end

        end

    end

end

subjobs['WHM'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        -- RERAISE.
        if not buff(113) and _cast then

            if isReady('MA', "Reraise III") then
                add(bp.MA["Reraise III"], player)

            elseif isReady('MA', "Reraise II") then
                add(bp.MA["Reraise II"], player)

            elseif isReady('MA', "Reraise") then
                add(bp.MA["Reraise"], player)

            end

        end

        if get('buffs') and _cast then

            -- STONESKIN.
            if get('stoneskin') and not buff(37) and isReady('MA', "Stoneskin") then
                add(bp.MA["Stoneskin"], player)

            -- BLNK.
            elseif get('blink') and not get('utsusemi') and not buff(36) and isReady('MA', "Blink") and target then
                add(bp.MA["Blink"], player)

            -- AQUAVEIL.
            elseif get('aquaveil') and isReady('MA', "Aquaveil") then
                add(bp.MA["Aquaveil"], player)

            end

        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        -- RERAISE.
        if not buff(113) and _cast then

            if isReady('MA', "Reraise III") then
                add(bp.MA["Reraise III"], player)

            elseif isReady('MA', "Reraise II") then
                add(bp.MA["Reraise II"], player)

            elseif isReady('MA', "Reraise") then
                add(bp.MA["Reraise"], player)

            end

        end

        if get('buffs') and _cast then

            -- STONESKIN.
            if get('stoneskin') and not buff(37) and isReady('MA', "Stoneskin") then
                add(bp.MA["Stoneskin"], player)

            -- BLNK.
            elseif get('blink') and not get('utsusemi') and not buff(36) and isReady('MA', "Blink") then
                add(bp.MA["Blink"], player)

            -- AQUAVEIL.
            elseif get('aquaveil') and isReady('MA', "Aquaveil") then
                add(bp.MA["Aquaveil"], player)

            end

        end

    end

end

subjobs['BLM'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('buffs') and _cast then

            -- SPIKES.
            if get('spikes').enabled and not self.hasSpikes() and isReady('MA', get('spikes').name) then
                add(bp.MA[get('spikes').name], player)
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

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        -- SPIKES.
        if get('buffs') and _cast then

            if get('spikes').enabled and not self.hasSpikes() and isReady('MA', get('spikes').name) then
                add(bp.MA[get('spikes').name], player)
            end

        end

        -- DRAIN.
        if get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and isReady('MA', "Drain") and _cast then
            add(bp.MA["Drain"], target)
        end

        -- ASPIR.
        if get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Aspir") and _cast then
            add(bp.MA["Aspir"], target)
        end

    end

end

subjobs['RDM'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()
        
        if get('ja') and _act then

            -- CONVERT.
            if get('convert').enabled and player['vitals'].hpp >= get('convert').hpp and player['vitals'].mpp <= get('convert').mpp then
                            
                if isReady('JA', "Convert") then
                    add(bp.JA["Convert"], player)
                end
                
            end

        end

        if get('buffs') and _cast then
            
            -- HASTE.
            if isReady('MA', "Haste") and not buff(33) then
                add(bp.MA["Haste"], player)
            
            -- PHALANX.
            elseif isReady('MA', "Phalanx") and not buff(116) then
                add(bp.MA["Phalanx"], player)
                
            -- REFRESH.
            elseif (not get('sublimation') or get('sublimation') and not get('sublimation').enabled) and isReady('MA', "Refresh") and not buff(43) and (not buff(187) or not buff(188)) then
                add(bp.MA["Refresh"], player)

            -- ENSPELLS.
            elseif get('en').enabled and not self.hasEnspell() then
                    
                if isReady('MA', get('en').name) then
                    add(bp.MA[get('en').name], player)
                end
                
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
            elseif isReady('MA', get('spikes').name) and not self.hasSpikes() then
                add(bp.MA[get('spikes')], player)
                
            end 

        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and _act then

            -- CONVERT.
            if get('convert').enabled and player['vitals'].hpp >= get('convert').hpp and player['vitals'].mpp <= get('convert').mpp then
                            
                if isReady('JA', "Convert") then
                    add(bp.JA["Convert"], player)                        
                end
                
            end

        end

        if get('buffs') and _cast then
            
            -- HASTE.
            if isReady('MA', "Haste") and not buff(33) then
                add(bp.MA["Haste"], player)
            
            -- PHALANX.
            elseif isReady('MA', "Phalanx") and not buff(116) then
                add(bp.MA["Phalanx"], player)
                
            -- REFRESH.
            elseif (not get('sublimation') or get('sublimation') and not get('sublimation').enabled) and isReady('MA', "Refresh") and not buff(43) and (not buff(187) or not buff(188)) then
                add(bp.MA["Refresh"], player)

            -- ENSPELLS.
            elseif get('en').enabled and not self.hasEnspell() then
                    
                if isReady('MA', get('en').name) then
                    add(bp.MA[get('en').name], player)
                end
                
            end 

        end

    end

end

subjobs['THF'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        -- FLEE.
        if not target and get('flee') and isReady('JA', "Flee") and not buff(32) then
            add(bp.JA["Flee"], player)
        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()
        
        if get('ja') and _act then
            
            -- STEAL.
            if get('steal') and isReady('JA', "Steal") then
                add(bp.JA["Steal"], target)

            -- MUG.
            elseif get('mug') and isReady('JA', "Mug") then
                add(bp.JA["Mug"], target)

            end

        end

        if get('buffs') and _act then
            local behind = helpers['actions'].isBehind(target)
            local facing = helpers['actions'].isFacing(target)
            
            -- SNEAK ATTACK.
            if get('sneak attack') and isReady('JA', 'Sneak Attack') and not buff(65) and player['vitals'].tp < get('ws').tp and (not get('am') or bp.helpers['aftermath'].hasAftermath()) then
                
                if isReady('JA', 'Hide') then
                    add(bp.JA["Hide"], player)
                    add(bp.MA["Sneak Attack"], player)

                elseif behind then
                    add(bp.JA["Sneak Attack"], player)

                end

            -- TRICK ATTACK.
            elseif get('trick attack') and isReady('JA', 'Trick Attack') and not buff(87) and player['vitals'].tp < get('ws').tp and (not get('am') or bp.helpers['aftermath'].hasAftermath()) then

                if behind then
                    add(bp.JA["Trick Attack"], player)
                end

            end

        end

    end

end

subjobs['PLD'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and _act then

            -- COVER.
            if get('cover').enabled and isReady('JA', "Cover") and helpers['party'].isInParty(windower.ffxi.get_mob_by_name(get('cover').target)) and helpers['enmity'].hasEnmity(windower.ffxi.get_mob_by_name(get('cover').target)) then
                add(bp.MA["Cover"], windower.ffxi.get_mob_by_name(get('cover').target))

            -- SHIELD BASH.
            elseif target and get('shield bash') and isReady('JA', "Shield Bash") then
                add(bp.JA["Shield Bash"], target)

            end

        end

        if get('hate').enabled and target then

            -- FLASH.
            if isReady('MA', "Flash") and _cast then
                helpers['queue'].addToFront(bp.MA["Flash"], target)

            -- SHIELD BASH.
            elseif get('shield bash') and isReady('JA', "Shield Bash") and _act then
                add(bp.JA["Shield Bash"], target)

            end

        end

        if get('buffs') and _act and target then

            -- REPRISAL.
            if isReady('MA', "Reprisal") and not buff(403) then
                add(bp.MA["Reprisal"], player)

            -- SENTINEL.
            elseif get('sentinel') and isReady('JA', "Sentinel") and not buff(62) and (get('hate') or helpers['enmity'].hasEnmity(player)) then
                add(bp.JA["Sentinel"], player)

            -- RAMPART.
            elseif get('rampart') and isReady('JA', "Rampart") and not buff(623) then
                add(bp.MA["Rampart"], player)

            end

        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and _act then
            local cover = get('cover').target ~= "" and windower.ffxi.get_mob_by_name(get('cover').target) or false

            -- COVER.
            if get('cover').enabled and isReady('JA', "Cover") and cover and helpers['party'].isInParty(cover) and helpers['enmity'].hasEnmity(cover) then
                add(bp.JA["Cover"], cover)

            -- SHIELD BASH.
            elseif get('shield bash') and isReady('JA', "Shield Bash") then
                add(bp.JA["Shield Bash"], target)

            end

        end

        if get('hate').enabled then

            -- FLASH.
            if isReady('MA', "Flash") and _cast then
                helpers['queue'].addToFront(bp.MA["Flash"], target)

            -- SHIELD BASH.
            elseif get('shield bash') and isReady('JA', "Shield Bash") and _act then
                add(bp.JA["Shield Bash"], target)

            end

        end

        if get('buffs') and _act then

            -- REPRISAL.
            if isReady('MA', "Reprisal") and not buff(403) then
                add(bp.MA["Reprisal"], player)

            -- SENTINEL.
            elseif get('sentinel') and isReady('JA', "Sentinel") and not buff(62) and (get('hate') or helpers['enmity'].hasEnmity(player)) then
                add(bp.JA["Sentinel"], player)

            -- RAMPART.
            elseif get('rampart') and isReady('JA', "Rampart") and not buff(623) then
                add(bp.MA["Rampart"], player)

            end

        end

    end

end

subjobs['DRK'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('tank') and (T(bp.player.buffs):contains(63) or T(bp.player.buffs):contains(64)) then
            windower.send_command("cancel 63")
            windower.send_command("cancel 64")
        end

        if get('hate').enabled and target then

            -- STUN.
            if isReady('MA', "Stun") and _cast then
                helpers['queue'].addToFront(bp.MA["Stun"], target)                            
            end
            
            if (os.clock()-private.timers.hate) > get('hate').delay then
            
                -- SOULEATER.
                if get('souleater') and isReady('JA', "Souleater") and not buff(63) and not buff(64) then
                    add(bp.JA["Souleater"], player)
                    private.timers.hate = os.clock()
                    
                -- LAST RESORT.
                elseif get('last resort') and isReady('JA', "Last Resort") and not buff(63) and not buff(64) then
                    add(bp.JA["Last Resort"], player)
                    private.timers.hate = os.clock()
                    
                end
                
            end

        end

        if get('buffs') and target then

            -- SOULEATER.
            if get('souleater') and not get('hate').enabled and isReady('JA', "Souleater") and not buff(63) and not buff(64) then
                add(bp.JA["Souleater"], player)
            
            -- LAST RESORT.
            elseif get('last resort') and not get('hate').enabled and isReady('JA', "Last Resort") and not buff(63) and not buff(64) then
                add(bp.JA["Last Resort"], player)

            -- CONSUME MANA.
            elseif get('consume mana') and isReady('JA', "Consume Mana") and not buff(599) then
                add(bp.JA["Consume Mana"], player)

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

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('tank') and ((bp.player.buffs):contains(63) or (bp.player.buffs):contains(64)) then
            windower.send_command("cancel 63")
            windower.send_command("cancel 64")
        end

        if get('hate').enabled and target then

            -- STUN.
            if isReady('MA', "Stun") and _cast then
                helpers['queue'].addToFront(bp.MA["Stun"], target)
            end
            
            if (os.clock()-private.timers.hate) > get('hate').delay then
            
                -- SOULEATER.
                if get('souleater') and isReady('JA', "Souleater") and not buff(63) and not buff(64) then
                    add(bp.JA["Souleater"], player)
                    private.timers.hate = os.clock()
                    
                -- LAST RESORT.
                elseif get('last resort') and isReady('JA', "Last Resort") and not buff(63) and not buff(64) then
                    add(bp.JA["Last Resort"], player)
                    private.timers.hate = os.clock()
                    
                end
                
            end

        end

        if get('buffs') and target then

            -- SOULEATER.
            if get('souleater') and not get('hate').enabled and isReady('JA', "Souleater") and not buff(63) and not buff(64) then
                add(bp.JA["Souleater"], player)
            
            -- LAST RESORT.
            elseif get('last resort') and not get('hate').enabled and isReady('JA', "Last Resort") and not buff(63) and not buff(64) then
                add(bp.JA["Last Resort"], player)

            -- CONSUME MANA.
            elseif get('consume mana') and isReady('JA', "Consume Mana") and not buff(599) then
                add(bp.JA["Consume Mana"], player)

            end

        end

        -- DRAIN.
        if get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and isReady('MA', "Drain") and _cast then
            add(bp.MA["Drain"], target)
        end

        -- ASPIR.
        if get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Aspir") and _cast then
            add(bp.MA["Aspir"], target)
        end

    end

end

subjobs['BST'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

    end

end

subjobs['BRD'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

    end

end

subjobs['RNG'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and _act then

            -- SCAVENGE.
            if get('scavenge') and isReady('JA', "Scavenge") then
                add(bp.JA["Scavenge"], player)
            end

        end

        if get('buffs') and target and _act then

            -- SHARPSHOT.
            if get('sharpshot') and isReady('JA', "Sharpshot") then
                add(bp.JA["Sharpshot"], player)

            -- BARRAGE.
            elseif get('barrage') and isReady('JA', "Barrage") then

                if get('camouflage') and isReady('JA', "Camouflage") then
                    add(bp.JA["Camouflage"], player)
                    add(bp.JA["Barrage"], player)

                else
                    add(bp.JA["Barrage"], player)

                end

            -- VELOCITY SHOT.
            elseif get('velocity shot') and isReady('JA', "Velocity Shot") then
                add(bp.JA["Velocity Shot"], player)

            -- UNLIMITED SHOT.
            elseif get('unlimited shot') and isReady('JA', "Unlimited Shot") then
                add(bp.JA["Unlimited Shot"], player)

            end

        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and _act then

            -- SCAVENGE.
            if get('scavenge') and isReady('JA', "Scavenge") then
                add(bp.JA["Scavenge"], player)
            end

        end

        if get('buffs') and _act then

            -- SHARPSHOT.
            if get('sharpshot') and isReady('JA', "Sharpshot") then
                add(bp.JA["Sharpshot"], player)

            -- BARRAGE.
            elseif get('barrage') and isReady('JA', "Barrage") then

                if get('camouflage') and isReady('JA', "Camouflage") then
                    add(bp.JA["Camouflage"], player)
                    add(bp.JA["Barrage"], player)

                else
                    add(bp.JA["Barrage"], player)

                end

            -- VELOCITY SHOT.
            elseif get('velocity shot') and isReady('JA', "Velocity Shot") then
                add(bp.JA["Velocity Shot"], player)

            -- UNLIMITED SHOT.
            elseif get('unlimited shot') and isReady('JA', "Unlimited Shot") then
                add(bp.JA["Unlimited Shot"], player)

            end

        end

    end

end

subjobs['SMN'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and _act then
            local pet = windower.ffxi.get_mob_by_target('pet') or false
            
            if pet and pet.status == 1 then

                if get('bpr').enabled and get('bpr').pacts[pet.name] and isReady('JA', "Blood Pact: Rage") then
                    
                    if get('mana cede') and isReady('JA', "Mana Cede") then
                        add(bp.JA["Mana Cede"], player)
                    end

                    if get('apogee') and isReady('JA', "Apogee") then
                        add(bp.JA["Apogee"], player)
                    end
                    add(bp.JA[get('bpr').pacts[pet.name]], target)
                
                elseif get('bpw').enabled and get('bpw').pacts[pet.name] and isReady('JA', "Blood Pact: Ward") then
                    local ward = bp.JA[get('bpw').pacts[pet.name]]

                    if get('buffs') and helpers['target'].castable(player, ward) then
                        add(bp.JA[get('bpw').pacts[pet.name]], player)

                    else
                        add(bp.JA[get('bpw').pacts[pet.name]], target)

                    end

                end

            elseif pet and (target or pet.status == 0) then
                
                if get('assault') and isReady('JA', "Blood Pact: Rage") and target then
                    add(bp.JA["Assault"], target)
                    
                else
                    
                    if get('bpr').enabled and get('bpr').pacts[pet.name] and isReady('JA', "Blood Pact: Rage") and target then
                        
                        if get('mana cede') and isReady('JA', "Mana Cede") then
                            add(bp.JA["Mana Cede"], player)
                        end

                        if get('apogee') and isReady('JA', "Apogee") then
                            add(bp.JA["Apogee"], player)
                        end
                        add(bp.JA[get('bpr').pacts[pet.name]], target)

                    elseif get('bpw').enabled and get('bpw').pacts[pet.name] and isReady('JA', "Blood Pact: Ward") then
                        local ward = bp.JA[get('bpw').pacts[pet.name]]

                        if get('buffs') and helpers['target'].castable(player, ward) then
                            add(bp.JA[get('bpw').pacts[pet.name]], player)
    
                        else
                            add(bp.JA[get('bpw').pacts[pet.name]], target)
    
                        end

                    end

                end

            end

        end

        if get('summon').enabled and _cast then
            local pet = windower.ffxi.get_mob_by_target('pet') or false

            if not pet and isReady('MA', get('summon').name) and player['vitals'].mpp >= 5 then
                add(bp.MA[get('summon').name], player)
            end

        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and _act then
            local pet = windower.ffxi.get_mob_by_target('pet') or false
            
            if pet and pet.status == 1 then

                if get('bpr').enabled and get('bpr').pacts[pet.name] and isReady('JA', "Blood Pact: Rage") then
                    
                    if get('mana cede') and isReady('JA', "Mana Cede") then
                        add(bp.JA["Mana Cede"], player)
                    end

                    if get('apogee') and isReady('JA', "Apogee") then
                        add(bp.JA["Apogee"], player)
                    end
                    add(bp.JA[get('bpr').pacts[pet.name]], target)

                elseif get('bpw').enabled and get('bpw').pacts[pet.name] and isReady('JA', "Blood Pact: Ward") then
                    local ward = bp.JA[get('bpw').pacts[pet.name]]

                    if get('buffs') and helpers['target'].castable(player, ward) then
                        add(bp.JA[get('bpw').pacts[pet.name]], player)

                    else
                        add(bp.JA[get('bpw').pacts[pet.name]], target)

                    end

                end

            elseif pet and pet.status == 0 then
                
                if get('assault') and isReady('JA', "Blood Pact: Rage") then
                    add(bp.JA["Assault"], target)
                    
                else
                    
                    if get('bpr').enabled and get('bpr').pacts[pet.name] and isReady('JA', "Blood Pact: Rage") then
                        
                        if get('mana cede') and isReady('JA', "Mana Cede") then
                            add(bp.JA["Mana Cede"], player)
                        end

                        if get('apogee') and isReady('JA', "Apogee") then
                            add(bp.JA["Apogee"], player)
                        end
                        add(bp.JA[get('bpr').pacts[pet.name]], target)

                    elseif get('bpw').enabled and get('bpw').pacts[pet.name] and isReady('JA', "Blood Pact: Ward") then
                        local ward = bp.JA[get('bpw').pacts[pet.name]]

                        if get('buffs') and helpers['target'].castable(player, ward) then
                            add(bp.JA[get('bpw').pacts[pet.name]], player)
    
                        else
                            add(bp.JA[get('bpw').pacts[pet.name]], target)
    
                        end

                    end

                end

            end

        end

        if get('summon').enabled and _cast then
            local pet = windower.ffxi.get_mob_by_target('pet') or false

            if not pet and isReady('MA', get('summon').name) and player['vitals'].mpp >= 5 then
                add(bp.MA[get('summon').name], player)
            end

        end

    end

end

subjobs['SAM'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and _act then

            -- MEDITATE
            if get('meditate') and isReady('JA', "Meditate") and (os.clock()-private.timers.meditate) > 30 then
                add(bp.JA["Meditate"], player)
                private.timers.meditate = os.clock()
                
            end

        end

        if get('buffs') and _act then
            local weapon = bp.helpers['equipment'].main
                        
            -- HASSO & SEIGAN.
            if (get('hasso') or get('seigan')) and weapon then

                if get('hasso') and isReady('JA', "Hasso") and not buff(353) and not get('tank') and T{4,6,7,8,10,12}:contains(weapon.skill) then
                    add(bp.JA["Hasso"], player)

                elseif get('seigan') and isReady('JA', "Seigan") and not buff(354) and get('tank') and T{4,6,7,8,10,12}:contains(weapon.skill) then
                    add(bp.JA["Seigan"], player)

                end

            end

            if (not get('hasso') and not get('seigan')) or (buff(353) or buff(354)) and target then

                -- THIRD EYE.
                if get('third eye') and isReady('JA', "Third Eye") and not buff(67) and not buff(36) and target and not self.hasShadows() then
                    add(bp.JA["Third Eye"], player)
                end

                -- SEKKANOKI.
                if get('sekkanoki') and isReady('JA', "Sekkanoki") and not buff(408) and player['vitals'].tp >= 2000 then
                    add(bp.JA["Sekkanoki"], player)
                end

                -- KONZEN-ITTAI.
                if get('konzen-ittai') and isReady('JA', "Konzen-Ittai") and player['vitals'].tp >= math.floor((get('ws').tp/3)*2) and (os.clock()-private.timers.konzen) > 60 then
                    add(bp.JA["Konzen-Ittai"])
                    private.timers.konzen = os.clock()

                end

            end

        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and _act then

            -- MEDITATE
            if get('meditate') and isReady('JA', "Meditate") and (os.clock()-private.timers.meditate) > 30 then
                add(bp.JA["Meditate"], player)
                private.timers.meditate = os.clock()
                
            end

        end

        if get('buffs') and _act then
            local weapon = bp.helpers['equipment'].main
                        
            -- HASSO & SEIGAN.
            if (get('hasso') or get('seigan')) and weapon then

                if get('hasso') and isReady('JA', "Hasso") and not buff(353) and not get('tank') and T{4,6,7,8,10,12}:contains(weapon.skill) then
                    add(bp.JA["Hasso"], player)

                elseif get('seigan') and isReady('JA', "Seigan") and not buff(354) and get('tank') and T{4,6,7,8,10,12}:contains(weapon.skill) then
                    add(bp.JA["Seigan"], player)

                end

            end

            if (not get('hasso') and not get('seigan')) or (buff(353) or buff(354)) then

                -- THIRD EYE.
                if get('third eye') and isReady('JA', "Third Eye") and not buff(67) and not buff(36) and not self.hasShadows() then
                    add(bp.JA["Third Eye"], player)
                end

                -- SEKKANOKI.
                if get('sekkanoki') and isReady('JA', "Sekkanoki") and not buff(408) and player['vitals'].tp >= 2000 then
                    add(bp.JA["Sekkanoki"], player)
                end

                -- KONZEN-ITTAI.
                if get('konzen-ittai') and isReady('JA', "Konzen-Ittai") and player['vitals'].tp >= math.floor((get('ws').tp/3)*2) and (os.clock()-private.timers.konzen) > 60 then
                    add(bp.JA["Konzen-Ittai"])
                    private.timers.konzen = os.clock()

                end

            end

        end

    end

end

subjobs['NIN'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('buffs') and target then

            -- INNIN & YONIN.
            if get('tank') and get('yonin') and isReady('JA', "Yonin") and not buff(420) and helpers['actions'].isFacing() and _act then
                add(bp.JA["Yonin"], player)

            elseif not get('tank') and get('innin') and isReady('JA', "Innin") and not buff(421) and helpers['actions'].isBehind() and _act then
                add(bp.JA["Innin"], player)

            end

            -- UTSUSEMI.
            if get('utsusemi') and (os.clock()-private.timers.utsusemi) > 1.5 and _cast then
                local tools = helpers['inventory'].findItemByName("Shihei")

                if tools and not self.hasShadows() then
                    local queue = helpers['queue'].queue
                    local check = false
                    
                    for _,v in ipairs(queue) do
                        if v.action.en:match('Utsusemi') then
                            check = true
                            break

                        end
                    end

                    if not check then
                        
                        if helpers['actions'].isReady('MA', "Utsusemi: San") then
                            helpers['queue'].addToFront(bp.MA["Utsusemi: San"], player)

                        elseif helpers['actions'].isReady('MA', "Utsusemi: Ni") then
                            helpers['queue'].addToFront(bp.MA["Utsusemi: Ni"], player)
                                
                        elseif helpers['actions'].isReady('MA', "Utsusemi: Ichi") then
                            helpers['queue'].addToFront(bp.MA["Utsusemi: Ichi"], player)
                                
                        end
                    
                    end

                elseif not tools then
                    local toolbag = helpers['inventory'].findItemByName("Toolbag (Shihe)")

                    if toolbag and helpers['inventory'].hasSpace() and helpers['actions'].canItem() then
                        helpers['queue'].addToFront(bp.IT["Toolbag (Shihe)"], player)
                    end

                end

            end

        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('buffs') then

            -- INNIN & YONIN.
            if get('tank') and get('yonin') and isReady('JA', "Yonin") and not buff(420) and helpers['actions'].isFacing() and _act then
                add(bp.JA["Yonin"], player)

            elseif not get('tank') and get('innin') and isReady('JA', "Innin") and not buff(421) and helpers['actions'].isBehind() and _act then
                add(bp.JA["Innin"], player)

            end

            -- UTSUSEMI.
            if get('utsusemi') and (os.clock()-private.timers.utsusemi) > 1.5 and _cast then
                local tools = helpers['inventory'].findItemByName("Shihei")

                if tools and not self.hasShadows() then
                    local queue = helpers['queue'].queue.data
                    local check = false
                    
                    for _,v in ipairs(queue) do
                        if v.action.en:match('Utsusemi') then
                            check = true
                            break

                        end
                    end

                    if not check then
                        
                        if helpers['actions'].isReady('MA', "Utsusemi: San") then
                            helpers['queue'].addToFront(bp.MA["Utsusemi: San"], player)

                        elseif helpers['actions'].isReady('MA', "Utsusemi: Ni") then
                            helpers['queue'].addToFront(bp.MA["Utsusemi: Ni"], player)
                                
                        elseif helpers['actions'].isReady('MA', "Utsusemi: Ichi") then
                            helpers['queue'].addToFront(bp.MA["Utsusemi: Ichi"], player)
                                
                        end
                    
                    end

                elseif not tools then
                    local toolbag = helpers['inventory'].findItemByName("Toolbag (Shihe)")

                    if toolbag and helpers['inventory'].hasSpace() and helpers['actions'].canItem() then
                        helpers['queue'].addToFront(bp.IT["Toolbag (Shihe)"], player)
                    end

                end

            end

        end

    end

end

subjobs['DRG'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and target and _act then

            -- JUMP.
            if get('jump') and isReady('JA', "Jump") then
                add(bp.JA["Jump"], target)
                
            -- HIGH JUMP.
            elseif get('high jump') and isReady('JA', "High Jump") then
                add(bp.JA["High Jump"], target)
                
            end

            -- SUPER JUMP.
            if get('super jump') and isReady('JA', "Super Jump") and helpers['enmity'].hasEnmity(player) then
                add(bp.JA["Super Jump"], target)
            end

        end

        if get('buffs') and _act and target then

            -- ANCIENT CIRCLE.
            --if target and not buff(118) and helpers['actions'].isReady('JA', "Ancient Circle") then
                --helpers['queue'].add(bp.JA["Ancient Circle"], player)                            
            --end

        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and _act then

            -- JUMP.
            if get('jump') and isReady('JA', "Jump") then
                add(bp.JA["Jump"], target)
                
            -- HIGH JUMP.
            elseif get('high jump') and isReady('JA', "High Jump") then
                add(bp.JA["High Jump"], target)
                
            end

            -- SUPER JUMP.
            if get('super jump') and isReady('JA', "Super Jump") and helpers['enmity'].hasEnmity(player) then
                add(bp.JA["Super Jump"], target)
            end

        end

        if get('buffs') and _act then

            -- ANCIENT CIRCLE.
            --if target and not buff(118) and helpers['actions'].isReady('JA', "Ancient Circle") then
                --helpers['queue'].add(bp.JA["Ancient Circle"], player)                            
            --end

        end

    end

end

subjobs['BLU'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target    = helpers['target'].getTarget() or false
        local _cast     = helpers['actions'].canCast()
        local _act      = helpers['actions'].canAct()

        if get('hate').enabled and target and _cast then

            -- JETTATURA.
            if isReady('MA', "Jettatura") then
                add(bp.MA["Jettatura"], target)
                
            -- BLANK GAZE.
            elseif isReady('MA', "Blank Gaze") then
                add(bp.MA["Blank Gaze"], target)
                
            end
            
            if get('hate').aoe and (os.clock()-private.timers.hate) > get('hate').delay then
                
                -- SOPORIFIC.
                if isReady('MA', "Soporific") then
                    add(bp.MA["Soporific"], target)
                    private.timers.hate = os.clock()
                
                -- GEIST WALL.
                elseif isReady('MA', "Geist Wall") then
                    add(bp.MA["Geist Wall"], target)
                    private.timers.hate = os.clock()
                
                -- SHEEP SONG.
                elseif isReady('MA', "Sheep Song") then
                    add(bp.MA["Sheep Song"], target)
                    private.timers.hate = os.clock()

                -- STINKING GAS.
                elseif isReady('MA', "Stinking Gas") then
                    add(bp.MA["Stinking Gas"], target)
                    private.timers.hate = os.clock()
                
                end
                
            end

        end

        if get('buffs') and target and _cast then

            -- HASTE.
            if not buff(93) then

                if player.main_job_level >= 99 and isReady('MA', "Erratic Flutter") then
                    add(bp.MA["Erratic Flutter"], player)

                elseif player.main_job_level >= 99 and isReady('MA', "Animating Wail") then
                    add(bp.MA["Animating Wail"], player)

                elseif player.main_job_level <= 48 and isReady('MA', "Refueling") then
                    add(bp.MA["Refueling"], player)

                end

            end

            -- COCOON.
            if isReady('MA', "Cocoon") and not buff(93) then
                add(bp.MA["Cocoon"], player)
            end

        end

    elseif player.status == 1 then
        local target    = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local current   = T(windower.ffxi.get_mjob_data().spells)
        local _cast     = helpers['actions'].canCast()
        local _act      = helpers['actions'].canAct()

        if get('hate').enabled and _cast then

            -- JETTATURA.
            if isReady('MA', "Jettatura") then
                add(bp.MA["Jettatura"], target)
                
            -- BLANK GAZE.
            elseif isReady('MA', "Blank Gaze") then
                add(bp.MA["Blank Gaze"], target)
                
            end
            
            if get('hate').aoe and (os.clock()-private.timers.hate) > get('hate').delay then
                
                -- SOPORIFIC.
                if isReady('MA', "Soporific") then
                    add(bp.MA["Soporific"], target)
                    private.timers.hate = os.clock()
                
                -- GEIST WALL.
                elseif isReady('MA', "Geist Wall") then
                    add(bp.MA["Geist Wall"], target)
                    private.timers.hate = os.clock()
                
                -- SHEEP SONG.
                elseif isReady('MA', "Sheep Song") then
                    add(bp.MA["Sheep Song"], target)
                    private.timers.hate = os.clock()

                -- STINKING GAS.
                elseif isReady('MA', "Stinking Gas") then
                    add(bp.MA["Stinking Gas"], target)
                    private.timers.hate = os.clock()
                
                end
                
            end

        end

        if get('buffs') and _cast then

            -- HASTE.
            if not buff(93) then

                if player.main_job_level >= 99 and isReady('MA', "Erratic Flutter") then
                    add(bp.MA["Erratic Flutter"], player)

                elseif player.main_job_level >= 99 and isReady('MA', "Animating Wail") then
                    add(bp.MA["Animating Wail"], player)

                elseif player.main_job_level <= 48 and isReady('MA', "Refueling") then
                    add(bp.MA["Refueling"], player)

                end

            end

            -- COCOON.
            if isReady('MA', "Cocoon") and not buff(93) then
                add(bp.MA["Cocoon"], player)
            end

        end

    end

end

subjobs['COR'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and _act then

            -- QUICK DRAW.
            if get('quick draw').enabled and isReady('JA', get('quick draw').name) then
                add(bp.JA[get('quick draw').name], player)

            -- RANDOM DEAL.
            elseif get('random deal') and isReady('JA', "Random Deal") then
                add(bp.JA["Random Deal"], player)

            end

        end

        if get('buffs') and _act then
            local active = bp.helpers['rolls'].getActive()

            -- ROLLS.
            if get('rolls') then
                bp.helpers['rolls'].roll()

            -- TRIPLE SHOT.
            elseif get('ra').enabled and isReady('JA', "Triple Shot") and not buff(467) and target then
                add(bp.JA["Triple Shot"], player)

            end

        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        if get('ja') and _act then

            -- QUICK DRAW.
            if get('quick draw').enabled and isReady('JA', get('quick draw').name) then
                add(bp.JA[get('quick draw').name], player)

            -- RANDOM DEAL.
            elseif get('random deal') and isReady('JA', "Random Deal") then
                add(bp.JA["Random Deal"], player)

            end

        end

        if get('buffs') and _act then
            local active = bp.helpers['rolls'].getActive()

            -- ROLLS.
            if get('rolls') then
                bp.helpers['rolls'].roll()

            -- TRIPLE SHOT.
            elseif get('ra').enabled and isReady('JA', "Triple Shot") and not buff(467) and target then
                add(bp.JA["Triple Shot"], player)

            end

        end

    end

end

subjobs['PUP'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

    end

end

subjobs['DNC'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()
        local moves  = helpers['buffs'].getFinishingMoves()

        if get('ja') and _act and target then

            -- FLOURISHES.
            if get('flourishes').enabled then
                local f1 = get('flourishes').cat_1
                local f2 = get('flourishes').cat_2
                local f3 = get('flourishes').cat_3

                if moves > 0 then

                    if isReady('JA', f1) and f1 ~= 'Animated Flourish' then
                        add(bp.JA[f1], target)
                    
                    elseif isReady('JA', f2) then
                        add(bp.JA[f2], target)

                    elseif isReady('JA', f3) then
                        add(bp.JA[f3], target)

                    end

                end

            end

            -- STEPS.
            if get('steps').enabled and isReady('JA', get('steps').name) then
                add(bp.JA[get('steps').name], target)
            end

        end

        if get('hate').enabled and _act and target then

            -- ANIMATED FLOURISH.
            if moves > 0 and isReady('JA', f1) and f1 == 'Animated Flourish' then
                add(bp.JA[f1], target)
            end

        end

        if get('buffs') and _act and target then

            -- SAMBAS.
            if get('sambas').enabled and isReady('JA', get('sambas').name) then
                add(bp.JA[get('sambas').name], player)
            end

        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()
        local moves  = helpers['buffs'].getFinishingMoves()

        if get('ja') and _act then

            -- FLOURISHES.
            if get('flourishes').enabled then
                local f1 = get('flourishes').cat_1
                local f2 = get('flourishes').cat_2
                local f3 = get('flourishes').cat_3

                if moves > 0 then

                    if isReady('JA', f1) and f1 ~= 'Animated Flourish' then
                        add(bp.JA[f1], target)
                    
                    elseif isReady('JA', f2) then
                        add(bp.JA[f2], target)

                    elseif isReady('JA', f3) then
                        add(bp.JA[f3], target)

                    end

                end

            end

            -- STEPS.
            if get('steps').enabled and isReady('JA', get('steps').name) then
                add(bp.JA[get('steps').name], target)
            end

        end

        if get('hate').enabled and _act then

            -- ANIMATED FLOURISH.
            if moves > 0 and isReady('JA', f1) and f1 == 'Animated Flourish' then
                add(bp.JA[f1], target)
            end

        end

        if get('buffs') and _act then

            -- SAMBAS.
            if get('sambas').enabled and isReady('JA', get('sambas').name) then
                add(bp.JA[get('sambas').name], player)
            end

        end

    end

end

subjobs['SCH'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()
        local gems   = helpers['stratagems'].gems

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
                        
                if player['vitals'].mpp <= get('sublimation').mpp and isReady('JA', "Sublimation") and buff(188) and (os.clock()-private.timers.sublimation) > 60 then
                    add(bp.JA["Sublimation"], player)
                    private.timers.sublimation = os.clock()

                elseif player['vitals'].mpp <= 20 and isReady('JA', "Sublimation") and (buff(187) or buff(188)) and (os.clock()-private.timers.sublimation) > 60 then
                    add(bp.JA["Sublimation"], player)
                    private.timers.sublimation = os.clock()

                elseif isReady('JA', "Sublimation") and not buff(187) and not buff(188) then
                    add(bp.JA["Sublimation"], player)
                    private.timers.sublimation = os.clock()

                end

            elseif not get('sublimation').enabled and (buff(187) or buff(188)) then
                add(bp.JA["Sublimation"], player)
                
            end

            -- LIBRA.
            if get('libra') and isReady('JA', "Libra") and target then
                add(bp.JA["Libra"], target)
            end

        end

        if get('buffs') and _cast then
    
            if (buff(358) or buff(359) or buff(401) or buff(402)) then

                -- STORMS.
                if get('storms').enabled and not self.hasStorm() then

                    if (buff(358) or buff(401)) then
                        add(bp.MA["Aurorastorm"], player)

                    elseif (buff(359) or buff(402)) then
                        add(bp.MA[get('storms').name], player)

                    end

                end

                -- KLIMAFORM
                if not get('light arts') and isReady('MA', "Klimaform") and (buff(359) or buff(402)) and target then
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
                elseif isReady('MA', get('spikes').name) and self.hasSpikes() and target then
                    add(bp.MA[get('spikes')], player)
                    
                end

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

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()
        local gems   = helpers['stratagems'].gems

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
                        
                if player['vitals'].mpp <= get('sublimation').mpp and isReady('JA', "Sublimation") and buff(188) and (os.clock()-private.timers.sublimation) > 60 then
                    add(bp.JA["Sublimation"], player)
                    private.timers.sublimation = os.clock()

                elseif player['vitals'].mpp <= 20 and isReady('JA', "Sublimation") and (buff(187) or buff(188)) and (os.clock()-private.timers.sublimation) > 60 then
                    add(bp.JA["Sublimation"], player)
                    private.timers.sublimation = os.clock()

                elseif isReady('JA', "Sublimation") and not buff(187) and not buff(188) then
                    add(bp.JA["Sublimation"], player)
                    private.timers.sublimation = os.clock()

                end

            elseif not get('sublimation').enabled and (buff(187) or buff(188)) then
                add(bp.JA["Sublimation"], player)
                
            end

            -- LIBRA.
            if get('libra') and isReady('JA', "Libra") then
                add(bp.JA["Libra"], target)
            end

        end

        if get('buffs') and _cast then
    
            if (buff(358) or buff(359) or buff(401) or buff(402)) then

                -- STORMS.
                if get('storms').enabled and not self.hasStorm() then

                    if (buff(358) or buff(401)) then
                        add(bp.MA["Aurorastorm"], player)

                    elseif (buff(359) or buff(402)) then
                        add(bp.MA[get('storms').name], player)

                    end

                end

                -- KLIMAFORM
                if not get('light arts') and isReady('MA', "Klimaform") and (buff(359) or buff(402)) and target then
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
                elseif isReady('MA', get('spikes').name) and self.hasSpikes() and target then
                    add(bp.MA[get('spikes')], player)
                    
                end

            end

        end

        -- DRAIN.
        if get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and isReady('MA', "Drain") and _cast then
            add(bp.MA["Drain"], target)
        end

        -- ASPIR.
        if get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Aspir") and _cast then
            add(bp.MA["Aspir"], target)
        end

    end

end

subjobs['GEO'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get

    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        -- DRAIN.
        if get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and isReady('MA', "Drain") and _cast then
            add(bp.MA["Drain"], target)
        end

        -- ASPIR.
        if get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Aspir") and _cast then
            add(bp.MA["Aspir"], target)
        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()

        -- DRAIN.
        if get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and isReady('MA', "Drain") and _cast then
            add(bp.MA["Drain"], target)
        end

        -- ASPIR.
        if get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Aspir") and _cast then
            add(bp.MA["Aspir"], target)
        end

    end

end

subjobs['RUN'] = function()
    local player    = bp.player
    local helpers   = bp.helpers
    local isReady   = helpers['actions'].isReady
    local inQueue   = helpers['queue'].inQueue
    local buff      = helpers['buffs'].buffActive
    local add       = helpers['queue'].add
    local get       = private.settings.get
    
    if player.status == 0 then
        local target = helpers['target'].getTarget() or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()
        local active = helpers['runes'].getActive()
        
        if get('hate').enabled and target then

            -- FLASH.
            if isReady('MA', "Flash") and isReady('MA', "Flash") and _cast then
                helpers['queue'].addToFront(bp.MA["Flash"], target)

            -- FOIL.
            elseif isReady('MA', "Foil") and isReady('MA', "Foil") and _cast then
                helpers['queue'].addToFront(bp.MA["Foil"], target)

            end
            
            -- DELAYED HATE ACTIONS.
            if (os.clock()-private.timers.hate) > get('hate').delay and active > 0 then
            
                -- VALLATION.
                if get('vallation') and isReady('JA', "Vallation") and not buff(531) and not buff(535) and active == helpers['runes'].maxRunes() and _act then
                    add(bp.JA["Vallation"], player)
                    private.timers.hate = os.clock()

                -- VALIANCE.
                elseif get('valiance') and isReady('JA', "Valiance") and not buff(531) and not buff(535) and active == helpers['runes'].maxRunes() and _act then
                    add(bp.JA["Valiance"], player)
                    private.timers.hate = os.clock()
                    
                -- PFLUG.
                elseif get('pflug') and isReady('JA', "Pflug") and not buff(533) and active == helpers['runes'].maxRunes() and _act then
                    add(bp.JA["Pflug"], player)
                    private.timers.hate = os.clock()
                    
                end
                
            end

        end

        if get('buffs') then

            -- RUNE ENCHANMENTS.
            if get('runes') then
                helpers['runes'].handleRunes()
            end

            if get('embolden').enabled and isReady('JA', "Embolden") and not buff(534) and _act and _cast and target then

                if isReady('MA', get('embolden').name) then
                    add(bp.JA["Embolden"], player)
                    add(bp.MA[get('embolden').name], player)
                end

            end

            -- PHALANX.
            if isReady('MA', "Phalanx") and not buff(116) and _cast and target then
                add(bp.MA["Phalanx"], player)

            -- SWORDPLAY.
            elseif get('swordplay') and isReady('JA', "Swordplay") and not buff(532) and _act and target then
                add(bp.JA["Swordplay"], player)

            -- STONESKIN.
            elseif get('stoneskin') and isReady('MA', "Stoneskin") and not buff(37) and _cast then
                add(bp.MA["Stoneskin"], player)

            -- AQUAVEIL.
            elseif get('aquaveil') and isReady('MA', "Aquaveil") and not buff(39) and _cast then
                add(bp.MA["Aquaveil"], player)

            -- BLINK.
            elseif get('blink') and isReady('MA', "Blink") and not get('utsusemi') and not buff(36) and _cast then
                add(bp.MA["Blink"], player)
                
            -- SPIKES.
            elseif get('spikes').enabled and isReady('MA', get('spikes').name) and self.hasSpikes() and _cast then
                add(bp.MA[get('spikes')], player)

            end
        
        end

    elseif player.status == 1 then
        local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
        local _cast  = helpers['actions'].canCast()
        local _act   = helpers['actions'].canAct()
        local active = helpers['runes'].getActive()

        if get('hate').enabled and target then

            -- FLASH.
            if isReady('MA', "Flash") and isReady('MA', "Flash") and _cast then
                helpers['queue'].addToFront(bp.MA["Flash"], target)

            -- FOIL.
            elseif isReady('MA', "Foil") and isReady('MA', "Foil") and _cast then
                helpers['queue'].addToFront(bp.MA["Foil"], target)

            end
            
            -- DELAYED HATE ACTIONS.
            if (os.clock()-private.timers.hate) > get('hate').delay and active > 0 then
            
                -- VALLATION.
                if get('vallation') and isReady('JA', "Vallation") and not buff(531) and not buff(535) and active == helpers['runes'].maxRunes() and _act then
                    add(bp.JA["Vallation"], player)
                    private.timers.hate = os.clock()

                -- VALIANCE.
                elseif get('valiance') and isReady('JA', "Valiance") and not buff(531) and not buff(535) and active == helpers['runes'].maxRunes() and _act then
                    add(bp.JA["Valiance"], player)
                    private.timers.hate = os.clock()
                    
                -- PFLUG.
                elseif get('pflug') and isReady('JA', "Pflug") and not buff(533) and active == helpers['runes'].maxRunes() and _act then
                    add(bp.JA["Pflug"], player)
                    private.timers.hate = os.clock()
                    
                end
                
            end

        end

        if get('buffs') then

            -- RUNE ENCHANMENTS.
            if get('runes') then
                helpers['runes'].handleRunes()
            end

            if get('embolden').enabled and isReady('JA', "Embolden") and not buff(534) and _act and _cast then

                if isReady('MA', get('embolden').name) then
                    add(bp.JA["Embolden"], player)
                    add(bp.MA[get('embolden').name], player)
                end

            end

            -- PHALANX.
            if isReady('MA', "Phalanx") and not buff(116) and _cast then
                add(bp.MA["Phalanx"], player)

            -- SWORDPLAY.
            elseif get('swordplay') and isReady('JA', "Swordplay") and not buff(532) and _act then
                add(bp.JA["Swordplay"], player)

            -- STONESKIN.
            elseif get('stoneskin') and isReady('MA', "Stoneskin") and not buff(37) and _cast then
                add(bp.MA["Stoneskin"], player)

            -- AQUAVEIL.
            elseif get('aquaveil') and isReady('MA', "Aquaveil") and not buff(39) and _cast then
                add(bp.MA["Aquaveil"], player)

            -- BLINK.
            elseif get('blink') and isReady('MA', "Blink") and not get('utsusemi') and not buff(36) and _cast then
                add(bp.MA["Blink"], player)
                
            -- SPIKES.
            elseif get('spikes').enabled and isReady('MA', get('spikes').name) and self.hasSpikes() and _cast then
                add(bp.MA[get('spikes')], player)

            end
        
        end

    end

end
return subjobs