local library = {}
function library:new(bp)
    local bp = bp

    -- Public Variables.
    self.visible = true

    -- Private Methods.
    local update = function()
        self.visible = bp and (not bp.info.mog_house and not bp.info.chat_open and (not bp.info.menu_open or (bp.info.menu_open and bp.player.status == 1))) and true or false
    end

    -- Public Methods.
    self.renderUI = function(display, render)

        if bp and display and self.visible then

            if render and type(render) == 'function' then
                render()
            end

            if not display:visible() and display:text() ~= "" then
                display:bg_visible(true)
                display:show()

            end

        elseif display and not self.visible and display:visible() then
            display:bg_visible(false)
            display:hide()

        end

    end

    -- Private Events.
    windower.register_event('prerender', update)

    return self

end
return library