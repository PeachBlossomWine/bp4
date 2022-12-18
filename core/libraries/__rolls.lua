local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __midroll     = false
    local __rolling     = false
    local __shortcut    = {

        ['sam']         = "Samurai Roll",       ['stp']         = "Samurai Roll",       ['att']         = "Chaos Roll",         ['at']          = "Chaos Roll",
        ['atk']         = "Chaos Roll",         ['da']          = "Fighter's Roll",     ['dbl']         = "Fighter's Roll",     ['sc']          = "Allies' Roll",
        ['acc']         = "Hunter's Roll",      ['mab']         = "Wizard's Roll",      ['matk']        = "Wizard's Roll",      ['macc']        = "Warlock's Roll",
        ['regain']      = "Tactician's Roll",   ['tp']          = "Tactician's Roll",   ['mev']         = "Runeist's Roll",     ['meva']        = "Runeist's Roll",
        ['mdb']         = "Magus's Roll",       ['patt']        = "Beast Roll",         ['patk']        = "Beast Roll",         ['pacc']        = "Drachen Roll",
        ['pmab']        = "Puppet Roll",        ['pmatk']       = "Puppet Roll",        ['php']         = "Companion's Roll",   ['php+']        = "Companion's Roll",
        ['pregen']      = "Companion's Roll",   ['comp']        = "Companion's Roll",   ['refresh']     = "Evoker's Roll",      ['mp']          = "Evoker's Roll",
        ['mp+']         = "Evoker's Roll",      ['xp']          = "Corsair's Roll",     ['exp']         = "Corsair's Roll",     ['cp']          = "Corsair's Roll",
        ['crit']        = "Rogue's Roll",       ['def']         = "Gallant's Roll",     ['eva']         = "Ninja's Roll",       ['sb']          = "Monk's Roll",
        ['conserve']    = "Scholar's Roll",     ['fc']          = "Caster's Roll",      ['snapshot']    = "Courser's Roll",     ['delay']       = "Blitzer's Roll",
        ['counter']     = "Avenger's Roll",     ['savetp']      = "Miser's Roll",       ['speed']       = "Bolter's Roll",      ['enhancing']   = "Naturalist's Roll",
        ['regen']       = "Dancer's Roll",      ['sird']        = "Choral's Roll",      ['cure']        = "Healer's Roll",

    }

    local __lucky = {

        ["Samurai Roll"]        = 2,    ["Chaos Roll"]          = 4,
        ["Hunter's Roll"]       = 4,    ["Fighter's Roll"]      = 5,
        ["Wizard's Roll"]       = 5,    ["Tactician's Roll"]    = 5,
        ["Runeist's Roll"]      = 4,    ["Beast Roll"]          = 4,
        ["Puppet Roll"]         = 3,    ["Corsair's Roll"]      = 5,
        ["Evoker's Roll"]       = 5,    ["Companion's Roll"]    = 2,
        ["Warlock's Roll"]      = 4,    ["Magus's Roll"]        = 2,
        ["Drachen Roll"]        = 4,    ["Allies' Roll"]        = 3,
        ["Rogue's Roll"]        = 5,    ["Gallant's Roll"]      = 3,
        ["Healer's Roll"]       = 3,    ["Ninja's Roll"]        = 4,
        ["Choral Roll"]         = 2,    ["Monk's Roll"]         = 3,
        ["Dancer's Roll"]       = 3,    ["Scholar's Roll"]      = 2,
        ["Naturalist's Roll"]   = 3,    ["Avenger's Roll"]      = 4,
        ["Bolter's Roll"]       = 3,    ["Caster's Roll"]       = 2,
        ["Courser's Roll"]      = 3,    ["Blitzer's Roll"]      = 4,
        ["Miser's Roll"]        = 5,

    }

    local __unlucky = {

        ["Samurai Roll"]        = 6,    ["Chaos Roll"]          = 8,
        ["Hunter's Roll"]       = 8,    ["Fighter's Roll"]      = 9,
        ["Wizard's Roll"]       = 9,    ["Tactician's Roll"]    = 8,
        ["Runeist's Roll"]      = 8,    ["Beast Roll"]          = 8,
        ["Puppet Roll"]         = 7,    ["Corsair's Roll"]      = 9,
        ["Evoker's Roll"]       = 9,    ["Companion's Roll"]    = 10,
        ["Warlock's Roll"]      = 8,    ["Magus's Roll"]        = 6,
        ["Drachen Roll"]        = 8,    ["Allies' Roll"]        = 10,
        ["Rogue's Roll"]        = 9,    ["Gallant's Roll"]      = 7,
        ["Healer's Roll"]       = 7,    ["Ninja's Roll"]        = 8,
        ["Choral Roll"]         = 6,    ["Monk's Roll"]         = 7,
        ["Dancer's Roll"]       = 7,    ["Scholar's Roll"]      = 6,
        ["Naturalist's Roll"]   = 7,    ["Avenger's Roll"]      = 8,
        ["Bolter's Roll"]       = 9,    ["Caster's Roll"]       = 7,
        ["Courser's Roll"]      = 9,    ["Blitzer's Roll"]      = 9,
        ["Miser's Roll"]        = 7,

    }
  
    -- Public Variables.
    self.list = T(bp.res.job_abilities):map(function(ability) return ability.type == "CorsairRoll" and ability.en or nil end)

    -- Public Methods.
    self.getRolling = function() return __rolling end
    self.getMidroll = function() return __midroll end
    self.isLucky = function(name, n) return __lucky[name] and (__lucky[name] == n or n == 11) or false end
    self.isUnlucky = function(name, n) return __unlucky[name] and __unlucky[name] == n or false end
    self.getUnlucky = function(name) return __unlucky[name] and true or false end
    self.getLucky = function(name) return __lucky[name] and true or false end
    self.getShort = function(name) return __shortcut[name] and __shortcut[name] or false end
    self.active = function() return T(bp.player.buffs):map(function(id) return T{903,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,600}:contains(id) and bp.res.buffs[id].en or nil end) end
    self.getMissing = function()
        local rolls = T(bp.core.get('rolls').list):copy()
        local current = self.active()

        if rolls and #rolls > 0 then

            for ci=1, #current do
                                    
                for mi=1, 3 do

                    if rolls[mi] == current[ci] then
                        table.remove(rolls, mi)
                    end

                end

            end

        end
        return rolls

    end

    self.get = function(n)
        
        if bp.core.get('rolls') then
            local rolls = bp.core.get('rolls').list:copy()

            if n and rolls[n] then
                return rolls[n]
            end
            return rolls

        end
        return nil

    end

    -- Private Events.
    windower.register_event('incoming chunk', function(id, original)
        
        if bp and bp.rolls and id == 0x028 then
            local parsed    = bp.packets.parse('incoming', original)
            local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
            local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
            
            if parsed and bp.player and actor and target and bp.player.id == actor.id and bp.player.id == target.id and parsed['Category'] == 6 then

                if parsed['Target 1 Action 1 Param'] and bp.res.job_abilities[parsed['Param']] and self.list:contains(bp.res.job_abilities[parsed['Param']].en) then
                    __rolling, __midroll = {name=bp.res.job_abilities[parsed['Param']].en, number=parsed['Target 1 Action 1 Param']}, true

                    if __rolling.number >= bp.rolls.getStop() and not bp.__actions.isReady("Snake Eye") then
                        __midroll, __rolling = false, false

                    elseif (self.isLucky(__rolling.name, __rolling.number) or __rolling.number == 11) then
                        __midroll, __rolling = false, false

                    end

                end

            end

        end

    end)

    return self

end
return library