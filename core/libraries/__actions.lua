function library()
    local internal = {}

    -- Private Variables.
    local categories    = {
            
        [6]     = 'JobAbility',
        [7]     = 'WeaponSkill',
        [8]     = 'Magic',
        [9]     = 'Item',
        [12]    = 'Ranged',
        [13]    = 'JobAbility',
        [14]    = 'JobAbility',
        [15]    = 'JobAbility',
    
    }

    local types = {
            
        ['Magic']       ={res='spells'},
        ['Trust']       ={res='spells'},
        ['JobAbility']  ={res='job_abilities'},
        ['WeaponSkill'] ={res='weapon_skills'},
        ['Item']        ={res='items'},
        ['Ranged']      ={res='none'},
    
    }

    local ranges = {
            
        [0]     =255,
        [2]     =3.40,
        [3]=4.47,
        [4]=5.76,
        [5]=6.89,
        [6]=7.80,
        [7]=8.40,
        [8]=10.40,
        [9]=12.40,
        [10]=14.50,
        [11]=16.40,
        [12]=20.40,
        [13]=23.4
    
    }

    -- Create a new class object.
    function internal:new(bp)
        local bp = bp

        local actions = {

            ['interact']    = 0,    ['engage']          = 2,    ['/magic']          = 3,    ['magic']           = 3,    ['/mount'] = 26,
            ['disengage']   = 4,    ['/help']           = 5,    ['help']            = 5,    ['/weaponskill']    = 7,
            ['weaponskill'] = 7,    ['/jobability']     = 9,    ['jobability']      = 9,    ['return']          = 11,
            ['/assist']     = 12,   ['assist']          = 12,   ['accept raise']    = 13,   ['/fish']           = 14,
            ['fish']        = 14,   ['switch target']   = 15,   ['/range']          = 16,   ['range']           = 16,
            ['/dismount']   = 18,   ['dismount']        = 18,   ['zone']            = 20,   ['accept tractor']  = 19,
            ['mount']       = 26,
    
        }

        local delays = {

            ['Misc']        = 1.5,  ['WeaponSkill']     = 1.2,  ['Item']            = 2.5,    ['JobAbility']    = 1.2,
            ['CorsairRoll'] = 1.2,  ['CorsairShot']     = 1.2,  ['Samba']           = 1.2,    ['Waltz']         = 1.2,
            ['Jig']         = 1.2,  ['Step']            = 1.2,  ['Flourish1']       = 1.2,    ['Flourish2']     = 1.2,
            ['Flourish3']   = 1.2,  ['Scholar']         = 1.2,  ['Effusion']        = 1.2,    ['Rune']          = 1.2,
            ['Ward']        = 1.2,  ['BloodPactRage']   = 1.2,  ['BloodPactWard']   = 1.2,    ['PetCommand']    = 1.2,
            ['Monster']     = 1.2,  ['Dismount']        = 1.2,  ['Ranged']          = 1.0,    ['WhiteMagic']    = 2.3,
            ['BlackMagic']  = 2.3,  ['BardSong']        = 2.6,  ['Ninjutsu']        = 2.3,    ['SummonerPact']  = 2.3,
            ['BlueMagic']   = 2.3,  ['Geomancy']        = 2.3,  ['Trust']           = 2.3,
    
        }

        -- Class Variables.
        self.__castlock     = true
        self.__anchored     = false
        self.__position     = false
        self.__midaction    = false
        self.__moving       = false
        self.__injecting    = false
        self.allowed        = {act=true, move=true, cast=true, item=true, move=true}
        self.position       = {x=0, y=0, z=0}
        self.unique         = {ranged = {id=65536,en='Ranged',element=-1,prefix='/ra',type='Ranged', range=13}}

        -- Class Functions.
        function self:setPosition()
            self.__moving       = (bp.me.x ~= self.position.x or bp.me.y ~= self.position.y) and true or false
            self.position.x     = bp.me.x
            self.position.y     = bp.me.y
            self.position.z     = bp.me.z

        end

        function self:do(target, param, action, x, y, z)
            local target = bp.libs.__target.get(target)
    
            if target and action and actions[action] and not self.midaction and not self.injecting and not windower.ffxi.get_info().mog_house then
                windower.packets.inject_outgoing(0x01a, ('iIHHHHfff'):pack(0x00001A00, target.id, target.index, actions[action], param or 0, 0, x, z, y))
            end
    
        end

        -- Class Events.
        windower.register_event('prerender', function()
            self:setPosition()
        
        end)

        return setmetatable({}, {__index = self})

    end

    return internal

end
return library()