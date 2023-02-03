local job = {}
function job:init(bp, settings, __getsub)

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return
    end

    -- Public Variables.
    self.__subjob   = (__getsub and bp.__core.getJob(bp.player.sub_job):init(bp, settings, false))
    self.__events   = {}
    self.__flags    = {}
    self.__timers   = {hate=0, aoehate=0}
    self.__nukes    = T{}

    function self:useItems()

        if self.__subjob and settings.food and settings.skillup and not settings.skillup.enabled and bp.core.canItem() then

        elseif bp.core.canItem() then

            if bp.player.status == 1 then

            elseif bp.player.status == 0 then

            end

        end

        return self

    end

    function self:castNukes(target)

        if target and settings.nuke then

            for spell in self.__nukes:it() do

                if bp.core.canCast() and bp.core.ready(spell) then
                    bp.core.add(spell, target, bp.core.priority(spell))
                end

            end

        end

        return self

    end

    function self:automate()
        local target = bp.core.target()
        local pet = windower.ffxi.get_mob_by_target('pet')

        self:useItems()
        if bp.player.status == 1 then
            local target = bp.core.target() or windower.ffxi.get_mob_by_target('t') or false

            if pet then 

                if settings.ja and bp.core.canAct() then

                    -- RELEASE.
                    if settings.summon and settings.summon.enabled and pet.name ~= settings.summon.name and bp.core.ready("Release") then
                        bp.core.add("Release", bp.player, bp.core.priority("Release"))

                    -- AVATARS FAVOR.
                    elseif bp.core.ready("Avatar's Favor", 431) then
                        bp.core.add("Avatar's Favor", bp.player, bp.core.priority("Avatar's Favor"))

                    elseif pet.status == 0 and target then

                        -- ASSAULT.
                        if settings.assault and bp.core.ready("Assault") then
                            bp.core.add("Assault", target, bp.core.priority("Assault"))
                        end

                    end

                    -- BLOOD PACTS THAT PURELY DEAL DAMAGE & MEWING.
                    if pet.status == 0 and target then

                        -- ASTRAL FLOW.
                        if settings['astral flow'] and bp.core.ready("Astral Flow", 55) and settings.bpr and settings.bpr.enabled and not settings.assault then
                            bp.core.add("Astral Flow", bp.player, bp.core.priority("Astral Flow"))
                        end

                        -- USE APOGEE BEFORE ASTRAL CONDUIT.
                        if (not settings.apogee or settings.apogee and not bp.core.ready("Apogee", 583)) then

                            -- ASTRAL CONDUIT.
                            if settings['astral conduit'] and bp.core.ready("Astral Conduit", 504) and (settings.bpr and settings.bpr.enabled and not settings.assault) or (settings.bpw and settings.bpw.enabled and not settings.assault and settings.bpw.pacts[pet.name] == "Mewing Lullaby") then
                                bp.core.add("Astral Conduit", bp.player, bp.core.priority("Astral Conduit"))
                            end

                        end
                        
                        -- BLOOD PACT: RAGES.
                        if settings.bpr and settings.bpr.enabled and not settings.assault then
                            local rage = settings.bpr.pacts[pet.name] or false

                            if rage and bp.core.ready(rage) then

                                -- APOGEE.
                                if settings.apogee and bp.core.ready("Apogee", 583) then
                                    bp.core.add("Apogee", bp.player, bp.core.priority("Apogee"))

                                -- MANA CEDE.
                                elseif settings['mana cede'] and bp.core.ready("Mana Cede") then
                                    bp.core.add("Mana Cede", bp.player, bp.core.priority("Mana Cede"))

                                else
                                    bp.core.add(rage, target, bp.core.priority(rage))
                                    
                                end

                            end

                        end

                        -- MEWING LULLABY.
                        if settings.bpw and settings.bpw.enabled and not settings.assault then
                            local ward = settings.bpw.pacts[pet.name] or false

                            if ward and ward == "Mewing Lullaby" and bp.core.ready(ward) then
                                bp.core.add(ward, target, bp.core.priority(ward))
                            end

                        end

                    elseif pet.status == 1 and settings.bpr and settings.bpr.enabled and target then

                        -- ASTRAL FLOW.
                        if settings['astral flow'] and bp.core.ready("Astral Flow", 55) and settings.bpr and settings.bpr.enabled then
                            bp.core.add("Astral Flow", bp.player, bp.core.priority("Astral Flow"))
                        end

                        -- USE APOGEE BEFORE ASTRAL CONDUIT.
                        if (not settings.apogee or settings.apogee and not bp.core.ready("Apogee", 583)) then

                            -- ASTRAL CONDUIT.
                            if settings['astral conduit'] and bp.core.ready("Astral Conduit", 504) and (settings.bpr and settings.bpr.enabled) or (settings.bpw and settings.bpw.enabled and settings.bpw.pacts[pet.name] == "Mewing Lullaby") then
                                bp.core.add("Astral Conduit", bp.player, bp.core.priority("Astral Conduit"))
                            end

                        end
                        
                        -- BLOOD PACT: RAGES.
                        if settings.bpr and settings.bpr.enabled then
                            local rage = settings.bpr.pacts[pet.name] or false

                            if rage and bp.core.ready(rage) then

                                -- APOGEE.
                                if settings.apogee and bp.core.ready("Apogee", 583) then
                                    bp.core.add("Apogee", bp.player, bp.core.priority("Apogee"))

                                -- MANA CEDE.
                                elseif settings['mana cede'] and bp.core.ready("Mana Cede") then
                                    bp.core.add("Mana Cede", bp.player, bp.core.priority("Mana Cede"))

                                else
                                    bp.core.add(rage, target, bp.core.priority(rage))

                                end

                            end

                        end

                        -- MEWING LULLABY.
                        if settings.bpw and settings.bpw.enabled and not settings.assault then
                            local ward = settings.bpw.pacts[pet.name] or false

                            if ward and ward == "Mewing Lullaby" and bp.core.ready(ward) then
                                bp.core.add(ward, target, bp.core.priority(ward))
                            end

                        end

                    end

                end

                if settings.buffs then

                    if bp.core.canAct() then

                        -- BLOOD PACTS THAT GIVE A PLAYER OR PLAYERS A BUFF.
                        if pet.status == 0 and not bp.core.buff(504) then

                            -- BLOOD PACT: WARDS.
                            if settings.bpw and settings.bpw.enabled and not settings.assault then
                                local ward = settings.bpw.pacts[pet.name] or false

                                if ward and bp.JA[ward] and (bp.JA[ward].status and bp.core.ready(ward, bp.JA[ward].status) or not bp.JA[ward].status) then
                                    bp.core.add(ward, bp.player, bp.core.priority(ward))
                                end

                            end

                        elseif pet.status == 1 and not bp.core.buff(504) then

                            -- BLOOD PACT: WARDS.
                            if settings.bpw and settings.bpw.enabled then
                                local ward = settings.bpw.pacts[pet.name] or false

                                if ward and bp.JA[ward] and (bp.JA[ward].status and bp.core.ready(ward, bp.JA[ward].status) or not bp.JA[ward].status) then
                                    bp.core.add(ward, bp.player, bp.core.priority(ward))
                                end

                            end
    
                        end

                    end

                end

            elseif not pet then

                -- SUMMON.
                if settings.summon and settings.summon.enabled and bp.core.ready(settings.summon.name) and bp.core.canCast() then
                    bp.core.add(settings.summon.name, bp.player, bp.core.priority(settings.summon.name))
                end

            end

        elseif bp.player.status == 0 then

            if pet then 

                if settings.ja and bp.core.canAct() then

                    -- RELEASE.
                    if settings.summon and settings.summon.enabled and pet.name ~= settings.summon.name and bp.core.ready("Release") then
                        bp.core.add("Release", bp.player, bp.core.priority("Release"))

                    -- AVATARS FAVOR.
                    elseif bp.core.ready("Avatar's Favor", 431) then
                        bp.core.add("Avatar's Favor", bp.player, bp.core.priority("Avatar's Favor"))

                    elseif pet.status == 0 and target then

                        -- ASSAULT.
                        if settings.assault and bp.core.ready("Assault") then
                            bp.core.add("Assault", target, bp.core.priority("Assault"))
                        end

                    end

                    -- BLOOD PACTS THAT PURELY DEAL DAMAGE & MEWING.
                    if pet.status == 0 and target then

                        -- ASTRAL FLOW.
                        if settings['astral flow'] and bp.core.ready("Astral Flow", 55) and settings.bpr and settings.bpr.enabled and not settings.assault then
                            bp.core.add("Astral Flow", bp.player, bp.core.priority("Astral Flow"))
                        end

                        -- USE APOGEE BEFORE ASTRAL CONDUIT.
                        if (not settings.apogee or settings.apogee and not bp.core.ready("Apogee", 583)) then

                            -- ASTRAL CONDUIT.
                            if settings['astral conduit'] and bp.core.ready("Astral Conduit", 504) and (settings.bpr and settings.bpr.enabled and not settings.assault) or (settings.bpw and settings.bpw.enabled and not settings.assault and settings.bpw.pacts[pet.name] == "Mewing Lullaby") then
                                bp.core.add("Astral Conduit", bp.player, bp.core.priority("Astral Conduit"))
                            end

                        end
                        
                        -- BLOOD PACT: RAGES.
                        if settings.bpr and settings.bpr.enabled and not settings.assault then
                            local rage = settings.bpr.pacts[pet.name] or false

                            if rage and bp.core.ready(rage) then

                                -- APOGEE.
                                if settings.apogee and bp.core.ready("Apogee", 583) then
                                    bp.core.add("Apogee", bp.player, bp.core.priority("Apogee"))

                                -- MANA CEDE.
                                elseif settings['mana cede'] and bp.core.ready("Mana Cede") then
                                    bp.core.add("Mana Cede", bp.player, bp.core.priority("Mana Cede"))

                                else
                                    bp.core.add(rage, target, bp.core.priority(rage))
                                    
                                end

                            end

                        end

                        -- MEWING LULLABY.
                        if settings.bpw and settings.bpw.enabled and not settings.assault then
                            local ward = settings.bpw.pacts[pet.name] or false

                            if ward and ward == "Mewing Lullaby" and bp.core.ready(ward) then
                                bp.core.add(ward, target, bp.core.priority(ward))
                            end

                        end

                    elseif pet.status == 1 and settings.bpr and settings.bpr.enabled and target then

                        -- ASTRAL FLOW.
                        if settings['astral flow'] and bp.core.ready("Astral Flow", 55) and settings.bpr and settings.bpr.enabled then
                            bp.core.add("Astral Flow", bp.player, bp.core.priority("Astral Flow"))
                        end

                        -- USE APOGEE BEFORE ASTRAL CONDUIT.
                        if (not settings.apogee or settings.apogee and not bp.core.ready("Apogee", 583)) then

                            -- ASTRAL CONDUIT.
                            if settings['astral conduit'] and bp.core.ready("Astral Conduit", 504) and (settings.bpr and settings.bpr.enabled) or (settings.bpw and settings.bpw.enabled and settings.bpw.pacts[pet.name] == "Mewing Lullaby") then
                                bp.core.add("Astral Conduit", bp.player, bp.core.priority("Astral Conduit"))
                            end

                        end
                        
                        -- BLOOD PACT: RAGES.
                        if settings.bpr and settings.bpr.enabled then
                            local rage = settings.bpr.pacts[pet.name] or false

                            if rage and bp.core.ready(rage) then

                                -- APOGEE.
                                if settings.apogee and bp.core.ready("Apogee", 583) then
                                    bp.core.add("Apogee", bp.player, bp.core.priority("Apogee"))

                                -- MANA CEDE.
                                elseif settings['mana cede'] and bp.core.ready("Mana Cede") then
                                    bp.core.add("Mana Cede", bp.player, bp.core.priority("Mana Cede"))

                                else
                                    bp.core.add(rage, target, bp.core.priority(rage))

                                end

                            end

                        end

                        -- MEWING LULLABY.
                        if settings.bpw and settings.bpw.enabled and not settings.assault then
                            local ward = settings.bpw.pacts[pet.name] or false

                            if ward and ward == "Mewing Lullaby" and bp.core.ready(ward) then
                                bp.core.add(ward, target, bp.core.priority(ward))
                            end

                        end

                    end

                end

                if settings.buffs then

                    if bp.core.canAct() then

                        -- BLOOD PACTS THAT GIVE A PLAYER OR PLAYERS A BUFF.
                        if pet.status == 0 and not bp.core.buff(504) then

                            -- BLOOD PACT: WARDS.
                            if settings.bpw and settings.bpw.enabled and not settings.assault then
                                local ward = settings.bpw.pacts[pet.name] or false

                                if ward and bp.JA[ward] and (bp.JA[ward].status and bp.core.ready(ward, bp.JA[ward].status) or not bp.JA[ward].status) then
                                    bp.core.add(ward, bp.player, bp.core.priority(ward))
                                end

                            end

                        elseif pet.status == 1 and not bp.core.buff(504) then

                            -- BLOOD PACT: WARDS.
                            if settings.bpw and settings.bpw.enabled then
                                local ward = settings.bpw.pacts[pet.name] or false

                                if ward and bp.JA[ward] and (bp.JA[ward].status and bp.core.ready(ward, bp.JA[ward].status) or not bp.JA[ward].status) then
                                    bp.core.add(ward, bp.player, bp.core.priority(ward))
                                end

                            end
    
                        end

                    end

                end

            elseif not pet then

                -- SUMMON.
                if settings.summon and settings.summon.enabled and bp.core.ready(settings.summon.name) and bp.core.canCast() then
                    bp.core.add(settings.summon.name, bp.player, bp.core.priority(settings.summon.name))
                end

            end

        end

        return self

    end
    
    return self

end
return job