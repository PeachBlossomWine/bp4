local buildHelper = function(bp, hmt)
    local bp        = bp
    local helper    = setmetatable({events={}}, hmt)

    helper.new = function()
        local new = setmetatable({events={}}, hmt)
        local pvt = {}
        
        -- Public Methods.
        new.loadLibraries = function()
            local directory = string.format('"%s%s"', windower.addon_path, 'core/user/libraries/')

            for filename in io.popen(string.format('dir %s /b', directory)):lines() do 
                
                if filename:match('.lua') then
                    local name = filename:gsub('.lua', '')

                    if name then
                        local library = dofile(string.format('%s%s.lua', directory:gsub("\"", ''), name))

                        if library and library.new then
                            bp.libs[name] = library:new(bp)

                        else
                            bp.libs[name] = library

                        end
                        
                    end

                end

            end

        end

        new.loadHelpers = function()
            local directory = string.format('"%s%s"', windower.addon_path, 'core/user/helpers/')

            for filename in io.popen(string.format('dir %s /b', directory)):lines() do 
                
                if filename:match('.lua') then
                    local name = filename:gsub('.lua', '')

                    if name then
                        local helper = dofile(string.format('%s%s.lua', directory:gsub("\"", ''), name))

                        if helper then
                            bp.helpers:add(helper, name)
                        end

                    end

                end

            end

        end

        return new

    end

    return helper

end
return buildHelper