local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}
  
    -- Public Variables.
    self.resource = bp.files.new('core/resources/sparks.lua'):exists() and dofile(string.format('%score/resources/sparks.lua', windower.addon_path)) or {}

    -- Public Methods.
    self.buyList = function(parsed, list, callback)

        if parsed and list and #list > 0 then
            local inject = {}

            for i=1, #list do

                for item, data in pairs(self.resource) do

                    if list[i]:lower() == item:lower() then
                        table.insert(inject, {data.option, data.u1, data.u2, true})

                        if i == #list then
                            table.insert(inject, bp.__menus.done)
                        end

                    end

                end
            
            end

            if inject and #inject > 0 then
                bp.__menus.send(parsed, inject, 0, function()

                    if callback and type(callback) == 'function' then
                        callback(parsed, list)
                    end

                end)

            end

        end

    end

    return self

end
return library