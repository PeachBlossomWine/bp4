local subjobs = {}

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