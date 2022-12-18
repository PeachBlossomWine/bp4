_addon.name     = 'bp4'
_addon.author   = 'Elidyr'
_addon.version  = '4.20221212'
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