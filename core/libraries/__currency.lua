local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __timer       = 0
    local __currencies  = {}

    -- Private Methods.
    pm.force = function()

        if (os.time()-__timer) >= math.random(60, 90) then
            coroutine.schedule(function()
                windower.packets.inject_outgoing(0x10f, '0000')
                
                coroutine.schedule(function()
                    windower.packets.inject_outgoing(0x115, '0000')

                end, 1)
            
            end, 1)
            __timer = os.time()

        end

    end

    pm.update = function(id, original)
        
        if bp and id == 0x113 then
            local parsed = bp.packets.parse('incoming', original)

            do
                __currencies['Conquest Points: Bastok']       = parsed['Conquest Points (Bastok)']
                __currencies['Conquest Points: Sandoria']     = parsed['Conquest Points (San d\'Oria)']
                __currencies['Conquest Points: Windurst']     = parsed['Conquest Points (Windurst)']
                __currencies['Beastman Seals']                = parsed['Beastman Seals']
                __currencies['Kindred Seals']                 = parsed['Kindred Seals']
                __currencies['Kindred Crests']                = parsed['Kindred Crests']
                __currencies['High Kindred Crests']           = parsed['High Kindred Crests']
                __currencies['Sacred Kindred Crests']         = parsed['Sacred Kindred Crests']
                __currencies['Ancient Beastcoins']            = parsed['Ancient Beastcoins']
                __currencies['Sparks of Eminence']            = parsed['Sparks of Eminence']
                __currencies['Imperial Standing']             = parsed['Imperial Standing']
                __currencies['Nyzul Tokens']                  = parsed['Nyzul Tokens']
                __currencies['Zeni']                          = parsed['Zeni']
                __currencies['Jettons']                       = parsed['Jettons']
                __currencies['Therion Ichor']                 = parsed['Therion Ichor']
                __currencies['Unity Accolades']               = parsed['Unity Accolades']
                __currencies['Deeds']                         = parsed['Deeds']

            end

        elseif bp and id == 0x118 then
            local parsed = bp.packets.parse('incoming', original)

            do
                __currencies['Bayld']                         = parsed['Bayld']
                __currencies['Mweya Plasm Corpuscles']        = parsed['Mweya Plasm Corpuscles']
                __currencies['Escha Beads']                   = parsed['Escha Beads']
                __currencies['Escha Silt']                    = parsed['Escha Silt']
                __currencies['Potpourri']                     = parsed['Potpourri']
                __currencies['Hallmarks']                     = parsed['Hallmarks']
                __currencies['Total Hallmarks']               = parsed['Total Hallmarks']
                __currencies['Badges of Gallanrty']           = parsed['Badges of Gallanrty']
                __currencies['Crafter Points']                = parsed['Crafter Points']

            end

        end
        
    end

    -- Public Methods.
    self.get = function(name) return name and __currencies[name] or T(__currencies):copy() end

    -- Private Events.
    windower.register_event('incoming chunk', pm.update)
    windower.register_event('prerender', pm.force)

    return self

end
return library