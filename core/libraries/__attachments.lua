local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Public Methods.
    self.getFrame = function()
        local data = T(windower.ffxi.get_mjob_data())

        if bp and bp.player and bp.player.main_job_id == 18 and data then
            return data.frame
        end
        return false

    end

    self.getHead = function()
        local data = T(windower.ffxi.get_mjob_data())

        if bp and bp.player and bp.player.main_job_id == 18 and data then
            return data.head
        end
        return false

    end

    self.getCurrent = function()
        local data = T(windower.ffxi.get_mjob_data())

        if bp and bp.player and bp.player.main_job_id == 18 and data then
            return T(data.attachments)
        end

    end

    self.getFrames = function()
        local data = T(windower.ffxi.get_mjob_data())

        if bp and bp.player and bp.player.main_job_id == 18 and data then
            return T(data.available_frames)
        end

    end

    self.getHeads = function()
        local data = T(windower.ffxi.get_mjob_data())

        if bp and bp.player and bp.player.main_job_id == 18 and data then
            return T(data.available_heads)
        end

    end

    self.getAll = function()
        local data = T(windower.ffxi.get_mjob_data())

        if bp and bp.player and bp.player.main_job_id == 18 and data then
            return T(data.available_attachments)
        end

    end

    self.equipHead = function(id)

        if self.getHead() ~= id then
            windower.ffxi.set_attachment(id)
        end

    end

    self.equipFrame = function(id)

        if self.getFrame() ~= id then
            windower.ffxi.set_attachment(id)
        end

    end

    self.equipSet = function(attachments)
        local current = self.getCurrent()

        if attachments and type(attachments) == 'table' then

            for index, id in ipairs(attachments) do

                if current[index] ~= id then
                    windower.ffxi.set_attachment:schedule((index * 0.15), id, index)
                end
                
            end

        end

    end

    self.equip = function(set)

        if set and type(set) == 'table' and set.head and set.frame and set.attachments then
            bp.__attachments.equipHead:schedule(0.00, set.head)
            bp.__attachments.equipFrame:schedule(0.10, set.frame)
            bp.__attachments.equipSet:schedule(0.20, set.attachments)

        end

    end

    return self

end
return library