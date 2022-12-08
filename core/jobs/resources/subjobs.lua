local subjobs = {}
local __tools = {
        
    ["Mono"] = {cast={"Shikanofuda","Sanjaku-Tenugui"}, toolbags={"Toolbag (Shika)","Toolbag (Sanja)"}},
    ["Aish"] = {cast={"Chonofuda","Soshi"}, toolbags={"Toolbag (Cho)","Toolbag (Soshi)"}},
    ["Kato"] = {cast={"Inoshishinofuda","Uchitake"}, toolbags={"Toolbag (Ino)","Toolbag (Uchi)"}},
    ["Hyot"] = {cast={"Inoshishinofuda","Tsurara"}, toolbags={"Toolbag (Ino)","Toolbag (Tsura)"}},
    ["Huto"] = {cast={"Inoshishinofuda","Kawahori-Ogi"}, toolbags={"Toolbag (Ino)","Toolbag (Kawa)"}},
    ["Doto"] = {cast={"Inoshishinofuda","Makibishi"}, toolbags={"Toolbag (Ino)","Toolbag (Maki)"}},
    ["Rait"] = {cast={"Inoshishinofuda","Hiraishin"}, toolbags={"Toolbag (Ino)","Toolbag (Hira)"}},
    ["Suit"] = {cast={"Inoshishinofuda","Mizu-Deppo"}, toolbags={"Toolbag (Ino)","Toolbag (Mizu)"}},
    ["Utsu"] = {cast={"Shikanofuda","Shihei"}, toolbags={"Toolbag (Shika)","Toolbag (Shihe)"}},
    ["Juba"] = {cast={"Chonofuda","Jusatsu"}, toolbags={"Toolbag (Cho)","Toolbag (Jusa)"}},
    ["Hojo"] = {cast={"Chonofuda","Kaginawa"}, toolbags={"Toolbag (Cho)","Toolbag (Kagi)"}},
    ["Kura"] = {cast={"Chonofuda","Sairui-Ran"}, toolbags={"Toolbag (Cho)","Toolbag (Sai)"}},
    ["Doku"] = {cast={"Chonofuda","Kodoku"}, toolbags={"Toolbag (Cho)","Toolbag (Kodo)"}},
    ["Tonk"] = {cast={"Shikanofuda","Shinobi-Tabi"}, toolbags={"Toolbag (Shika)","Toolbag (Shino)"}},
    ["Gekk"] = {cast={"Shikanofuda","Ranka"}, toolbags={"Toolbag (Shika)","Toolbag (Ranka)"}},
    ["Yain"] = {cast={"Shikanofuda","Furusumi"}, toolbags={"Toolbag (Shika)","Toolbag (Furu)"}},
    ["Myos"] = {cast={"Shikanofuda","Kabenro"}, toolbags={"Toolbag (Shika)","Toolbag (Kaben)"}},
    ["Yuri"] = {cast={"Chonofuda","Jinko"}, toolbags={"Toolbag (Cho)","Toolbag (Jinko)"}},
    ["Kakk"] = {cast={"Shikanofuda","Ryuno"}, toolbags={"Toolbag (Shika)","Toolbag (Ryuno)"}},
    ["Miga"] = {cast={"Shikanofuda","Mokujin"}, toolbags={"Toolbag (Shika)","Toolbag (Moku)"}},

}

-- WARRIOR.
subjobs['WAR'] = {}
subjobs['WAR'].hate = function(bp, settings, core)
    local target = core.target()

    if setting.hate.enabled then

        if bp.player.status == 1 then
            local target = target or windower.ffxi.get_mob_by_target('t')

            if settings.ja and settings.provoke and core.canAct and core.isReady("Provoke") and not core.inQueue("Provoke") then
                core.add("Provoke", target, core.priority("Provoke"))
            end

        elseif bp.player.status == 0 and target then

            if settings.ja and settings.provoke and core.canAct and core.isReady("Provoke") and not core.inQueue("Provoke") then
                core.add("Provoke", target, core.priority("Provoke"))
            end

        end

    end

end

subjobs['WAR'].buffs = function(bp, settings, core)

    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end
    
end

-- MONK.
subjobs['MNK'] = {}
subjobs['MNK'].hate = function(bp, settings, core)
    local target = core.target

    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

subjobs['MNK'].buffs = function(bp, settings, core)

    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end
    
end

-- WHITE MAGE.
subjobs['WHM'] = {}
subjobs['WHM'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- BLACK MAGE.
subjobs['BLM'] = {}
subjobs['BLM'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- RED MAGE.
subjobs['RDM'] = {}
subjobs['RDM'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- THIEF.
subjobs['THF'] = {}
subjobs['THF'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- PALADIN.
subjobs['PLD'] = {}
subjobs['PLD'].hate = function(bp, settings, core)
    local target = core.target()

    if setting.hate.enabled then

        if bp.player.status == 1 then
            local target = target or windower.ffxi.get_mob_by_target('t')

            if settings.ja and settings.provoke and core.canAct and core.isReady("Provoke") and not core.inQueue("Provoke") then
                core.add("Provoke", target, core.priority("Provoke"))
            end

        elseif bp.player.status == 0 and target then

            if settings.ja and settings.provoke and core.canAct and core.isReady("Provoke") and not core.inQueue("Provoke") then
                core.add("Provoke", target, core.priority("Provoke"))
            end

        end

    end

end

-- DARK KNIGHT.
subjobs['DRK'] = {}
subjobs['DRK'].hate = function(bp, settings, core)
    local target = core.target()

    if setting.hate.enabled then

        if bp.player.status == 1 then
            local target = target or windower.ffxi.get_mob_by_target('t')

            if settings.ja and settings.provoke and core.canAct and core.isReady("Provoke") and not core.inQueue("Provoke") then
                core.add("Provoke", target, core.priority("Provoke"))
            end

        elseif bp.player.status == 0 and target then

            if settings.ja and settings.provoke and core.canAct and core.isReady("Provoke") and not core.inQueue("Provoke") then
                core.add("Provoke", target, core.priority("Provoke"))
            end

        end

    end

end

-- BEASTMASTER.
subjobs['BST'] = {}
subjobs['BST'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- BARD.
subjobs['BRD'] = {}
subjobs['BRD'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- RANGER.
subjobs['RNG'] = {}
subjobs['RNG'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- SUMMONER.
subjobs['SMN'] = {}
subjobs['SMN'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- SAMURAI.
subjobs['SAM'] = {}
subjobs['SAM'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- NINJA.
subjobs['NIN'] = {}
subjobs['NIN'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

subjobs['NIN'].buffs = function(bp, settings, core)
    local target = core.target

    if settings and settings.buffs then
    
        if bp.player.status == 1 then

        elseif bp.player.status == 0 then

            -- INNIN & YONIN.
            if settings.tank and settings.yonin and target and core.isReady("Yonin") and not core.buff(420) and bp.__actions.isFacing(target) and core.canAct() then
                core.add("Yonin", bp.player, core.priority("Yonin"))

            elseif not settings.tank and settings.innin and core.isReady("Innin") and not core.buff(421) and bp.__actions.isBehind(target) and core.canAct() then
                core.add("Innin", bp.player, core.priority("Innin"))

            end

            -- UTSUSEMI.
            if settings.utsusemi and (not core.__timers.utsusemi or (os.clock()-core.__timers.utsusemi) > 1.5) and core.canCast() then
                local tools = bp.__inventory.findByName(__tools["Utsu"].cast, 0) or false

                if tools and tools[1] then
                    local tools = tools[2] and tools[2] or tools[1]

                    if tools then
                        local index, count = table.unpack(tools)

                        if count > 0 and not bp.__buffs.hasShadows() and not bp.__queue.searchInQueue('Utsusemi') then
                            
                            if bp.__actions.isReady("Utsusemi: San") then
                                core.add("Utsusemi: San", bp.player, core.priority("Utsusemi: San"))
        
                            elseif bp.__actions.isReady("Utsusemi: Ni") then
                                core.add("Utsusemi: Ni", bp.player, core.priority("Utsusemi: Ni"))
                                    
                            elseif bp.__actions.isReady("Utsusemi: Ichi") then
                                core.add("Utsusemi: Ichi", bp.player, core.priority("Utsusemi: Ichi"))
                                    
                            end
                        
                        end

                    end

                elseif settings.items and (not tools or not tools[1]) then
                    local toolbags = bp.__inventory.findByName(__tools["Utsu"].toolbags, 0) or false

                    if toolbags and toolbags[1] then
                        local toolbag = toolbags[2] and toolbags[2] or toolbags[1]

                        if toolbag then
                            local index, count, id = table.unpack(toolbag)

                            if count > 0 and bp.res.items[id] and not bp.__queue.inQueue(bp.res.items[id], bp.player) then
                                core.add(bp.res.items[id], bp.player, core.priority(bp.res.items[id].en))
                            end

                        end

                    end

                end

            end

        end

    end

end

-- DRAGOON.
subjobs['DRG'] = {}
subjobs['DRG'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- BLUE MAGE.
subjobs['BLU'] = {}
subjobs['BLU'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- CORSAIR.
subjobs['COR'] = {}
subjobs['COR'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- PUPPETMASTER.
subjobs['PUP'] = {}
subjobs['PUP'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- DANCER.
subjobs['DNC'] = {}
subjobs['DNC'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- SCHOLAR.
subjobs['SCH'] = {}
subjobs['SCH'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- GEOMANCER.
subjobs['GEO'] = {}
subjobs['GEO'].hate = function(bp, settings, core)
    local target = core.target
    
    if bp.player.status == 1 then

    elseif bp.player.status == 0 then

    end

end

-- RUNE FENCER.
subjobs['RUN'] = {}
subjobs['RUN'].hate = function(bp, settings, core)
    local target = core.target()

    if setting.hate.enabled then

        if bp.player.status == 1 then
            local target = target or windower.ffxi.get_mob_by_target('t')

            if settings.ja and settings.provoke and core.canAct and core.isReady("Provoke") and not core.inQueue("Provoke") then
                core.add("Provoke", target, core.priority("Provoke"))
            end

        elseif bp.player.status == 0 and target then

            if settings.ja and settings.provoke and core.canAct and core.isReady("Provoke") and not core.inQueue("Provoke") then
                core.add("Provoke", target, core.priority("Provoke"))
            end

        end

    end

end

subjobs.mt = {}
subjobs.mt.__index = function(t, key)

    if rawget(t, key) ~= nil then
        return rawget(t, key)

    else
        return (function() return end)

    end

end

return subjobs