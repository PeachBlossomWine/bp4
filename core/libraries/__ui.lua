local library = {}
function library:new(bp)
    local bp = bp

    -- Public Variables.
    self.visible = true

    -- Private Methods.
    local update = function()
        self.visible = bp and (not bp.info.mog_house or not bp.info.chat_open or (bp.info.chat_open and bp.player.status == 1)) and true or false
    end

    -- Public Methods.
    self.renderUI = function(display, render)

        if display and bp.libs.__ui.visible and type(render) == 'function' then
            render()

            if not display:visible() then
                display:show()
            end

        elseif display and bp.libs.__ui.visible and display:visible() then
            display:hide()

        end

    end

    -- Private Events.
    windower.register_event('prerender', update)

    return self

end
return library