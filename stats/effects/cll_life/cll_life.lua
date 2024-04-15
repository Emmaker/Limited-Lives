function init() end

function update(dt)
    if self.doOnce then return end

    if not status.resourcePositive("health") then
        world.sendEntityMessage(entity.id(), "cll_loseLife")

        self.doOnce = true
    end
end

function uninit() end