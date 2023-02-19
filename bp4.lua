_addon.name     = 'bp4'
_addon.author   = 'Elidyr'
_addon.version  = '4.20230218'
_addon.command  = 'bp'
--[[ From all your friends on Lakshmi, RIP Kanobrown, and you will be forever missed in the FFXI Community. ]]--
local bp = nil
windower.register_event('logout', function() windower.send_command('lua u bp4') end)
windower.register_event('login', function()
    bp = require('/core/bootstrap')

end)

if windower.ffxi.get_info() and windower.ffxi.get_info().logged_in then
    bp = require('/core/bootstrap')
end