_addon.name     = 'bp4'
_addon.author   = 'Elidyr'
_addon.version  = '4.20221130'
_addon.command  = 'bp'
--[[ From all your friends on Lakshmi, RIP Kanobrown, and you will be forever missed in the FFXI Community. ]]--

--local pal = assert(package.loadlib(string.format("%s__buddypal.dll", windower.addon_path):gsub('\\', '/'), "luaopen_Buddypal"))()
local bp = require('/core/bootstrap')

do -- Initial add-on settings.
    bp.accounts = T{'Eliidyr'}

    -- Keybinds.
    bp.__keybinds.register({

        '@b bp toggle',
        '@f bp follow',
        '@s bp request_stop',
        '@a bp assist',
        '@p poke',
        '@m ord p bp mount',
        '@t bp target t',
        '@p bp target pt',
        '@, bp target lt',
        '@. bp target et',
        '@up ord p bp controls up',
        '@down ord p bp controls down',
        '@left ord p bp controls left',
        '@right ord p bp controls right',
        '@escape ord p bp controls escape',
        '@enter ord p bp controls enter',
        '@[ ord p bp on',
        '@] ord p bp off',
        '@/ bp mode',

    })

end

--[[
bp.libs.__queue.add(bp.IT["Wind Crystal"], bp.player, 2)
bp.libs.__queue.add(bp.IT["Frayed Sack (D)"], bp.player, 1)
bp.libs.__queue.add(bp.IT["Frayed Pouch (G)"], bp.player, 3)
bp.libs.__queue.add(bp.IT["Pluton Box"], bp.player, 5)
bp.libs.__queue.add(bp.IT["Wind Cluster"], bp.player, 10)
]]

--print(bp.JA["Shikikoyo"].targets)
--print(bp.MA["Protect"].targets)
--print(bp.MA["Victory March"].targets)

--print(bp.__songs.hasHonorMarch())