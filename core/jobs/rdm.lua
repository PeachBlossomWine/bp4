local job = {}
function job:init(bp, settings)

    if not bp or not settings then
        print(string.format('\\cs(%s)ERROR INITIALIZING JOB! PLEASE POST AN ISSUE ON GITHUB!\\cr', "20, 200, 125"))
        return
    end

    -- Private Variables.
    local __events    = {}
    local __nukes     = T{}
    local __sublogic  = bp.libs.__core.getSubjob(bp.player.sub_job)

    -- Public Variables.
    self.__flags     = {}
    self.__timers    = {}

    -- Public Methods.
    self.unloadEvents = function()

        for _,id in pairs(__events) do
            windower.unregister_event(id)
        end

    end

    function self:useItems()

        if settings.food and settings.skillup and not settings.skillup.enabled and self.canItem() then

        elseif self.canItem() then

            if bp.player.status == 1 then

            elseif bp.player.status == 0 then

            end

        end

    end

    function self:castNukes(target)

        if target and not settings.mb then

            for spell in __nukes:it() do

                if self.canCast() and self.isReady(spell) and not self.inQueue(spell) then
                    self.add(spell, target, self.priority(spell))
                end

            end

        end

    end

    function self:automate()
        local target = self.target()

        self:useItems()
        if self and bp.player.status == 1 then
            local target = self.target() or windower.ffxi.get_mob_by_target('t') or false

            -- NOT IN NUKE MODE.
            if not settings.nuke then

                if settings.hate then
                    __sublogic.hate(bp, settings, self)
                end

                if settings.ja and self.canAct() then

                    -- ONE-HOURS.
                    if settings['1hr'] then

                        if self.isReady("Chain Spell") then
                            self.add("Chain Spell", bp.player, self.priority("Chain Spell"))
                        end
                        
                        if self.isReady("Stymie") then
                            self.add("Stymie", bp.player, self.priority("Stymie"))
                        end

                    end

                    -- CONVERT.
                    if settings.convert and settings.convert.enabled and self.vitals.hpp >= settings.convert.hpp and self.vitals.mpp <= settings.convert.mpp then
                        local mpp, hpp = settings.convert.mpp, settings.convert.hpp
                                    
                        if self.vitals.hpp >= hpp and self.vitals.mpp <= mpp and self.isReady("Convert") then
                            self.add("Convert", bp.player, self.priority("Convert"))
                        end
                        
                    end

                    -- SABOTEUR.
                    if settings.debuffs and settings.saboteur and self.isReady("Saboteur") and not self.buff(454) then
                        self.add("Saboteur", bp.player, self.priority("Saboteur"))
                    end
                    __sublogic.ja(bp, settings, self)

                end

                if settings.buffs then

                    -- COMPOSURE.
                    if settings.composure and self.isReady("Composure") and not self.buff(419) and self.canAct() then
                        self.add("Composure", bp.player, self.priority("Composure"))

                    elseif (not settings.composure or self.buff(419)) and self.canCast() then
                    
                        -- HASTE.
                        if not self.buff(33) and self.mlevel >= 48 then
                            
                            if self.mlevel >= 96 and self.isReady("Haste II") then
                                self.add("Haste II", bp.player, self.priority("Haste II"))

                            elseif self.mlevel < 96 and self.isReady("Haste") then
                                self.add("Haste", bp.player, self.priority("Haste"))

                            end
                        
                        end

                        -- TEMPER.
                        if not self.buff(432) and self.mlevel >= 95 then

                            if self.jp >= 1200 and self.isReady("Temper II") then
                                self.add("Temper II", bp.player, self.priority("Temper II"))

                            elseif self.jp < 1200 and self.isReady("Temper") then
                                self.add("Temper", bp.player, self.priority("Temper"))

                            end

                        end

                        -- GAINS.
                        if settings.gain and settings.gain.enabled and not bp.__buffs.hasWHMBoost() and self.isReady(settings.gain.name) then
                            self.add(settings.gain.name, bp.player, self.priority(settings.gain.name))
                        end
                        
                        -- PHALANX.
                        if not self.buff(116) and self.isReady("Phalanx") then
                            self.add("Phalanx", bp.player, self.priority("Phalanx"))
                            
                        -- REFRESH.
                        elseif not self.buff(43) and (not self.buff(187) or not self.buff(188)) then

                            if self.jp >= 1200 and self.isReady("Refresh III") then
                                self.add("Refresh III", bp.player, self.priority("Refresh III"))

                            elseif self.mlevel >= 82 and self.isReady("Refresh II") then
                                self.add("Refresh II", bp.player, self.priority("Refresh II"))

                            elseif self.mlevel < 82 and self.isReady("Refresh") then
                                self.add("Refresh", bp.player, self.priority("Refresh"))
                            
                            end
        
                        -- ENSPELLS.
                        elseif settings.en and settings.en.enabled and not bp.__buffs.hasEnspell() and self.isReady(settings.en.name) then
                            self.add(settings.en.name, bp.player, self.priority(settings.en.name))
                            
                        -- BLINK.
                        elseif settings.blink and not self.buff(36) and not bp.__buffs.hasShadows() and self.isReady("Blink") then
                            self.add("Blink", bp.player, self.priority("Blink"))

                        -- AQUAVEIL.
                        elseif settings.aquaveil and not self.buff(39) and self.isReady("Aquaveil") then
                            self.add("Aquaveil", bp.player, self.priority("Aquaveil"))

                        -- STONESKIN.
                        elseif settings.stoneskin and not self.buff(37) and self.isReady("Stoneskin") then
                            self.add("Stoneskin", bp.player, self.priority("Stoneskin"))
                            
                        end
                        __sublogic.buffs(bp, settings, self)
                        bp.buffs.cast()

                    end

                end

                if settings.debuffs then
                    __sublogic.debuffs(bp, settings, self)
                end

            -- NUKE MODE ENABLED.
            elseif settings.nuke then
                
                if settings.hate and target then
                    __sublogic.hate(bp, settings, self)
                end

                if settings.ja and self.canAct() then

                    -- ONE-HOURS.
                    if settings['1hr'] and target then

                        if self.isReady("Chain Spell") then
                            self.add("Chain Spell", bp.player, self.priority("Chain Spell"))
                        end
                        
                        if self.isReady("Stymie") then
                            self.add("Stymie", bp.player, self.priority("Stymie"))
                        end

                    end

                    -- CONVERT.
                    if settings.convert and settings.convert.enabled and self.vitals.hpp >= settings.convert.hpp and self.vitals.mpp <= settings.convert.mpp then
                        local mpp, hpp = settings.convert.mpp, settings.convert.hpp
                                    
                        if self.vitals.hpp >= hpp and self.vitals.mpp <= mpp and self.isReady("Convert") then
                            self.add("Convert", bp.player, self.priority("Convert"))
                        end
                        
                    end

                    -- SABOTEUR.
                    if settings.debuffs and settings.saboteur and self.isReady("Saboteur") and not self.buff(454) and target then
                        self.add("Saboteur", bp.player, self.priority("Saboteur"))
                    end
                    __sublogic.ja(bp, settings, self)

                end

                if settings.buffs then

                    -- COMPOSURE.
                    if settings.composure and self.isReady("Composure") and not self.buff(419) and self.canAct() then
                        self.add("Composure", bp.player, self.priority("Composure"))

                    elseif (not settings.composure or self.buff(419)) and self.canCast() then
                    
                        -- HASTE.
                        if settings.haste and not self.buff(33) and self.mlevel >= 48 then

                            if self.mlevel >= 96 and self.isReady("Haste II") then
                                self.add("Haste II", bp.player, self.priority("Haste II"))

                            elseif self.mlevel < 96 and self.isReady("Haste") then
                                self.add("Haste", bp.player, self.priority("Haste"))

                            end
                        
                        end

                        -- GAINS.
                        if settings.gain and settings.gain.enabled and not bp.__buffs.hasWHMBoost() and self.isReady(settings.gain.name) and target then
                            self.add(settings.gain.name, bp.player, self.priority(settings.gain.name))
                        end
                        
                        -- PHALANX.
                        if settings.phalanx and not self.buff(116) and self.isReady("Phalanx") then
                            self.add("Phalanx", bp.player, self.priority("Phalanx"))
                            
                        -- REFRESH.
                        elseif settings.refresh and not self.buff(43) and (not self.buff(187) or not self.buff(188)) then

                            if self.jp >= 1200 and self.isReady("Refresh III") then
                                self.add("Refresh III", bp.player, self.priority("Refresh III"))

                            elseif self.mlevel >= 82 and self.isReady("Refresh II") then
                                self.add("Refresh II", bp.player, self.priority("Refresh II"))

                            elseif self.mlevel < 82 and self.isReady("Refresh") then
                                self.add("Refresh", bp.player, self.priority("Refresh"))
                            
                            end

                        -- BLINK.
                        elseif settings.blink and not self.buff(36) and not bp.__buffs.hasShadows() and self.isReady("Blink") then
                            self.add("Blink", bp.player, self.priority("Blink"))

                        -- AQUAVEIL.
                        elseif settings.aquaveil and not self.buff(39) and self.isReady("Aquaveil") then
                            self.add("Aquaveil", bp.player, self.priority("Aquaveil"))

                        -- STONESKIN.
                        elseif settings.stoneskin and not self.buff(37) and self.isReady("Stoneskin") then
                            self.add("Stoneskin", bp.player, self.priority("Stoneskin"))
                            
                        end
                        __sublogic.buffs(bp, settings, self)
                        bp.buffs.cast()

                    end

                end

                if settings.debuffs then
                    __sublogic.debuffs(bp, settings, self)
                end
                self:castNukes(target)

            end

        elseif self and bp.player.status == 0 then

            if not settings.nuke then

                if settings.hate and target then
                    __sublogic.hate(bp, settings, self)
                end

                if settings.ja and self.canAct() then

                    -- ONE-HOURS.
                    if settings['1hr'] and target then

                        if self.isReady("Chain Spell") then
                            self.add("Chain Spell", bp.player, self.priority("Chain Spell"))
                        end
                        
                        if self.isReady("Stymie") then
                            self.add("Stymie", bp.player, self.priority("Stymie"))
                        end

                    end

                    -- CONVERT.
                    if settings.convert and settings.convert.enabled and self.vitals.hpp >= settings.convert.hpp and self.vitals.mpp <= settings.convert.mpp then
                        local mpp, hpp = settings.convert.mpp, settings.convert.hpp
                                    
                        if self.vitals.hpp >= hpp and self.vitals.mpp <= mpp and self.isReady("Convert") then
                            self.add("Convert", bp.player, self.priority("Convert"))
                        end
                        
                    end

                    -- SABOTEUR.
                    if settings.debuffs and settings.saboteur and self.isReady("Saboteur") and not self.buff(454) and target then
                        self.add("Saboteur", bp.player, self.priority("Saboteur"))
                    end
                    __sublogic.ja(bp, settings, self)

                end

                if settings.buffs then

                    -- COMPOSURE.
                    if settings.composure and self.isReady("Composure") and not self.buff(419) and self.canAct() then
                        self.add("Composure", bp.player, self.priority("Composure"))

                    elseif (not settings.composure or self.buff(419)) and self.canCast() then
                    
                        -- HASTE.
                        if not self.buff(33) and self.mlevel >= 48 then

                            if self.mlevel >= 96 and self.isReady("Haste II") then
                                self.add("Haste II", bp.player, self.priority("Haste II"))

                            elseif self.mlevel < 96 and self.isReady("Haste") then
                                self.add("Haste", bp.player, self.priority("Haste"))

                            end
                        
                        end

                        -- TEMPER.
                        if not self.buff(432) and self.mlevel >= 95 and target then

                            if self.jp >= 1200 and self.isReady("Temper II") then
                                self.add("Temper II", bp.player, self.priority("Temper II"))

                            elseif self.jp < 1200 and self.isReady("Temper") then
                                self.add("Temper", bp.player, self.priority("Temper"))

                            end

                        end

                        -- GAINS.
                        if settings.gain and settings.gain.enabled and not bp.__buffs.hasWHMBoost() and self.isReady(settings.gain.name) and target then
                            self.add(settings.gain.name, bp.player, self.priority(settings.gain.name))
                        end
                        
                        -- PHALANX.
                        if not self.buff(116) and self.isReady("Phalanx") then
                            self.add("Phalanx", bp.player, self.priority("Phalanx"))
                            
                        -- REFRESH.
                        elseif not self.buff(43) and (not self.buff(187) or not self.buff(188)) then

                            if self.jp >= 1200 and self.isReady("Refresh III") then
                                self.add("Refresh III", bp.player, self.priority("Refresh III"))

                            elseif self.mlevel >= 82 and self.isReady("Refresh II") then
                                self.add("Refresh II", bp.player, self.priority("Refresh II"))

                            elseif self.mlevel < 82 and self.isReady("Refresh") then
                                self.add("Refresh", bp.player, self.priority("Refresh"))
                            
                            end
        
                        -- ENSPELLS.
                        elseif settings.en and settings.en.enabled and not bp.__buffs.hasEnspell() and self.isReady(settings.en.name) and target then
                            self.add(settings.en.name, bp.player, self.priority(settings.en.name))

                        -- BLINK.
                        elseif settings.blink and not self.buff(36) and not bp.__buffs.hasShadows() and self.isReady("Blink") then
                            self.add("Blink", bp.player, self.priority("Blink"))

                        -- AQUAVEIL.
                        elseif settings.aquaveil and not self.buff(39) and self.isReady("Aquaveil") then
                            self.add("Aquaveil", bp.player, self.priority("Aquaveil"))

                        -- STONESKIN.
                        elseif settings.stoneskin and not self.buff(37) and self.isReady("Stoneskin") then
                            self.add("Stoneskin", bp.player, self.priority("Stoneskin"))
                            
                        end
                        __sublogic.buffs(bp, settings, self)
                        bp.buffs.cast()

                    end

                end

                if settings.debuffs then
                    __sublogic.debuffs(bp, settings, self)
                end

            -- NUKE MODE ENABLED.
            elseif settings.nuke then

                if settings.hate and target then
                    __sublogic.hate(bp, settings, self)
                end

                if settings.ja and self.canAct() then

                    -- ONE-HOURS.
                    if settings['1hr'] and target then

                        if self.isReady("Chain Spell") then
                            self.add("Chain Spell", bp.player, self.priority("Chain Spell"))
                        end
                        
                        if self.isReady("Stymie") then
                            self.add("Stymie", bp.player, self.priority("Stymie"))
                        end

                    end

                    -- CONVERT.
                    if settings.convert and settings.convert.enabled and self.vitals.hpp >= settings.convert.hpp and self.vitals.mpp <= settings.convert.mpp then
                        local mpp, hpp = settings.convert.mpp, settings.convert.hpp
                                    
                        if self.vitals.hpp >= hpp and self.vitals.mpp <= mpp and self.isReady("Convert") then
                            self.add("Convert", bp.player, self.priority("Convert"))
                        end
                        
                    end

                    -- SABOTEUR.
                    if settings.debuffs and settings.saboteur and self.isReady("Saboteur") and not self.buff(454) and target then
                        self.add("Saboteur", bp.player, self.priority("Saboteur"))
                    end
                    __sublogic.ja(bp, settings, self)

                end

                if settings.buffs then

                    -- COMPOSURE.
                    if settings.composure and self.isReady("Composure") and not self.buff(419) and self.canAct() then
                        self.add("Composure", bp.player, self.priority("Composure"))

                    elseif (not settings.composure or self.buff(419)) and self.canCast() then
                    
                        -- HASTE.
                        if not self.buff(33) and self.mlevel >= 48 then

                            if self.mlevel >= 96 and self.isReady("Haste II") then
                                self.add("Haste II", bp.player, self.priority("Haste II"))

                            elseif self.mlevel < 96 and self.isReady("Haste") then
                                self.add("Haste", bp.player, self.priority("Haste"))

                            end
                        
                        end

                        -- GAINS.
                        if settings.gain and settings.gain.enabled and not bp.__buffs.hasWHMBoost() and self.isReady(settings.gain.name) and target then
                            self.add(settings.gain.name, bp.player, self.priority(settings.gain.name))
                        end
                        
                        -- PHALANX.
                        if not self.buff(116) and self.isReady("Phalanx") then
                            self.add("Phalanx", bp.player, self.priority("Phalanx"))
                            
                        -- REFRESH.
                        elseif not self.buff(43) and (not self.buff(187) or not self.buff(188)) then

                            if self.jp >= 1200 and self.isReady("Refresh III") then
                                self.add("Refresh III", bp.player, self.priority("Refresh III"))

                            elseif self.mlevel >= 82 and self.isReady("Refresh II") then
                                self.add("Refresh II", bp.player, self.priority("Refresh II"))

                            elseif self.mlevel < 82 and self.isReady("Refresh") then
                                self.add("Refresh", bp.player, self.priority("Refresh"))
                            
                            end

                        -- BLINK.
                        elseif settings.blink and not self.buff(36) and not bp.__buffs.hasShadows() and self.isReady("Blink") then
                            self.add("Blink", bp.player, self.priority("Blink"))

                        -- AQUAVEIL.
                        elseif settings.aquaveil and not self.buff(39) and self.isReady("Aquaveil") then
                            self.add("Aquaveil", bp.player, self.priority("Aquaveil"))

                        -- STONESKIN.
                        elseif settings.stoneskin and not self.buff(37) and self.isReady("Stoneskin") then
                            self.add("Stoneskin", bp.player, self.priority("Stoneskin"))
                            
                        end
                        __sublogic.buffs(bp, settings, self)
                        bp.buffs.cast()

                    end

                end

                if settings.debuffs then
                    __sublogic.debuffs(bp, settings, self)
                end
                self:castNukes(target)

            end

        end

    end

    -- Private Events.
    __events.jobchange = windower.register_event('job change', self.unloadEvents)
    __events.commands = windower.register_event('addon command', function(...)
        local commands  = T{...}
        local command   = table.remove(commands, 1)
        
        if bp and command and command:lower() == 'core' and #commands > 0 then
            local command = commands[1] and table.remove(commands, 1):lower() or false

            if ("nukes"):startswith(command) then
                local option = commands[1] and table.remove(commands, 1):lower() or false

                if option == '+' and #commands > 0 then
                    bp.core.addNuke(__nukes, commands)

                elseif option == '-' and #commands > 0 then
                    bp.core.deleteNuke(__nukes, commands)

                elseif option == 'clear' then
                    bp.core.clearNukes(__nukes)

                end

            end

        end

    end)

    __events.incoming = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
        
        if bp and id == 0x028 then
            local parsed    = bp.packets.parse('incoming', original)
            local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
            local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
            local count     = parsed['Target Count']
            local category  = parsed['Category']
            local param     = parsed['Param']
            
            if bp.player and actor and target then

            end

        end

    end)
    
    return self

end
return job