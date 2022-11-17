local job = {}
function job.get(bp)
    local self = {}

    if not bp then
        print('ERROR LOADING CORE! PLEASE POST AN ISSUE ON OUR GITHUB!')
        return
    end

    -- Private Variables.
    local bp        = bp
    local private   = {events={}, config={}}
    local timers    = {warcry=0}
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
        local pet       = windower.ffxi.get_mob_by_target('pet') or false

        do
            private.items()
            if bp and bp.player and bp.player.status == 1 then
                local target  = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
                local _act    = helpers['actions'].canAct()
                local _cast   = helpers['actions'].canCast()

                if not pet and get('call wyvern') and isReady('JA', "Call Wyvern") then
                    add(bp.JA["Call Wyvern"], player)
                
                elseif (pet or not get('call wyvern') or not _act) then

                    if get('ja') and _act and target then

                        -- ANGON.
                        if get('angon') and isReady('JA', "Angon") then
                            add(bp.JA["Angon"], target)

                        -- JUMP.
                        elseif get('jump') and isReady('JA', "Jump") then
                            add(bp.JA["Jump"], target)

                        -- HIGH JUMP.
                        elseif get('high jump') and isReady('JA', "High Jump") then
                            add(bp.JA["High Jump"], target)

                        -- SUPER JUMP.
                        elseif get('super jump') and isReady('JA', "Super Jump") and helpers['enmity'].hasEnmity(player) then
                            add(bp.JA["Super Jump"], target)

                        -- SPIRIT JUMP.
                        elseif get('spirit jump') and isReady('JA', "Spirit Jump") then
                            add(bp.JA["Spirit Jump"], target)

                        -- SOUL JUMP.
                        elseif get('soul jump') and isReady('JA', "Soul Jump") then
                            add(bp.JA["Soul Jump"], target)

                        end

                        -- BREATHS
                        if pet then

                            if get('steady wing') and isReady('JA', "Steady Wing") then
                                add(bp.JA["Steady Wing"], player)

                            elseif get('smiting breath') and isReady('JA', "Smiting Breath") then
                                add(bp.JA["Smiting Breath"], target)

                            elseif get('restoring breath') and isReady('JA', "Restoring Breath") then

                                if get('deep breathing') and isReady('JA', "Deep breathing") then
                                    add(bp.JA["Deep Breathing"], player)
                                end
                                add(bp.JA["Restoring Breath"], player)

                            end

                        end

                    end
        
                    if get('buffs') and _act then

                        -- 1 HOURS.
                        if get('1hr') and not buff(126) and not buff(503) and isReady('JA', "Spirit Surge") and isReady('JA', "Fly High") and pet then
                            add(bp.JA["Spirit Surge"], player)
                            add(bp.JA["Fly High"], player)

                        end
                        helpers['buffs'].cast()
        
                    end

                    -- DEBUFFS.
                    if self.get('debuffs') then
                        helpers['debuffs'].cast()
                        
                    end

                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = helpers['actions'].canAct()
                local _cast   = helpers['actions'].canCast()

                if not pet and get('call wyvern') and isReady('JA', "Call Wyvern") then
                    add(bp.JA["Call Wyvern"], player)
                end

                -- DEBUFFS.
                if target and get('debuffs') then
                    helpers['debuffs'].cast()
                    
                end
                
            end

        end
        
    end

    private.items = function()

    end

    return self

end
return job