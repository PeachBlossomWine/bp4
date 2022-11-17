local job = {}
function job.get(bp)
    local self = {}

    if not bp then
        print('ERROR LOADING CORE! PLEASE POST AN ISSUE ON OUR GITHUB!')
        return
    end

    -- Private Variables.
    local bp        = bp
    local private   = {events={}}
    local timers    = {}
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
            if bp and bp.player and bp.player.status == 1 then
                local target  = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
                local _act    = helpers['actions'].canAct()
                local _cast   = helpers['actions'].canCast()

                if get('ja') and _act then

                    -- CHAKRA.
                    if get('chakra').enabled and isReady('JA', "Chakra") and player['vitals'].hpp <= get('chakra').hpp then
                        add(bp.JA["Chakra"], player)
    
                    -- CHI BLAST.
                    elseif get('chi blast') and isReady('JA', "Chi Blast") then
                        add(bp.JA["Chi Blast"], target)
    
                    end

                    -- MANTRA.
                    if get('mantra') and isReady('JA', "Mantra") and not buff(88) then
                        add(bp.JA["Mantra"], player)
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
                        
                    -- PERFECT COUNTER.
                    elseif get('perfect counter') and isReady('JA', "Perfect Counter") and not buff(436) then
                        add(bp.JA["Perfect Counter"], player)
    
                    -- FOOTWORK.
                    elseif get('footwork') and isReady('JA', "Footwork") and not buff(406) and (not buff(461) or get('footwork').impetus) then
                        add(bp.JA["Footwork"], player)

                    -- IMPETUS.
                    elseif get('impetus') and isReady('JA', "Impetus") and not buff(461) and (not buff(460) or get('footwork').impetus) then
                        add(bp.JA["Impetus"], player)

                    -- FORMLESS STRIKES.
                    elseif get('formless strikes') and isReady('JA', "Formless Strikes") then
                        add(bp.JA["Formless Strikes"], player)
    
                    end
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

                    -- CHAKRA.
                    if get('chakra').enabled and isReady('JA', "Chakra") and player['vitals'].hpp <= get('chakra').hpp then
                        add(bp.JA["Chakra"], player)
    
                    -- CHI BLAST.
                    elseif target and get('chi blast') and isReady('JA', "Chi Blast") then
                        add(bp.JA["Chi Blast"], target)
    
                    end
    
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
        local _act    = bp.helpers['actions'].canAct()
        local _cast   = bp.helpers['actions'].canCast()
        local _item   = bp.helpers['actions'].canItem()
        local add     = bp.helpers['queue'].addToFront
        local buffs   = T(bp.player.buffs)

        if _item then

            if buffs:contains(15) and bp.helpers['inventory'].hasItem("Holy Water", 0) then
                add(bp.IT["Holy Water"], bp.player)

            elseif buffs:contains(6) and bp.helpers['inventory'].hasItem("Echo Drops", 0) then
                add(bp.IT["Echo Drops"], bp.player)

            elseif (buffs:contains(149) or buffs:contains(558)) and bp.helpers['inventory'].hasItem("Panacea", 0) then
                add(bp.IT["Panacea"], bp.player)

            end

        end

    end

    return self

end
return job