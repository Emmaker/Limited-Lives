function init()
    if not starExtensions then
        self.disable = true
        return
    end

    self.config = root.assetJson("/limitedLives.config")

    self.defaultMode = player.getProperty("ll_defaultmode") or player.mode()
    self.lives = player.getProperty("ll_lives") or self.config.lives
    self.timer = player.getProperty("ll_timer") or self.config.timer

    sb.logInfo("Player spawned with unique ID " .. player.uniqueId() .. ". They have " .. self.lives .. " lives.")

    status.setPersistentEffects("Limited Lives", { "ll_life" .. self.lives })
end

function update(dt)
    if self.disable then
        return
    end

    self.timer = self.timer - dt
    if self.timer <= 0 then
        gainLife()
        self.timer = self.config.timer
    end

    if (self.lives or 3) <= 1 then
        player.setMode("hardcore")
    elseif player.mode() == "hardcore" then
        player.setMode(self.defaultMode)
    end


end

function uninit()
    if self.disable then
        return
    end

    if not status.resourcePositive("health") then
        loseLife()
    end

    player.setProperty("ll_defaultmode", self.defaultMode)
    player.setProperty("ll_lives", self.lives)
    player.setProperty("ll_timer", self.timer)

    status.clearPersistentEffects("Limited Lives")
end

function gainLife()
    self.lives = math.min(self.lives + 1, self.config.lives)
    sb.logInfo(player.uniqueId() .. " gained a life. Lives left: " .. self.lives)

    status.clearPersistentEffects("Limited Lives")
    status.setPersistentEffects("Limited Lives", { "ll_life" .. self.lives })
end

function loseLife()
    self.lives = self.lives - 1
    sb.logInfo(player.uniqueId() .. " lost a life. Lives left: " .. self.lives)

    -- Don't need to update persistent effects as losing a life means dying,
    -- thus init will be called later.
end
