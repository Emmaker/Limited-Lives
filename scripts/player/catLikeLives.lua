function init()
    if not StarExtensions then
        self.disable = true
        return
    end

    self.defaultMode = player.getProperty("cll_defaultmode")
    if not self.defaultMode then
        self.defaultMode = player.mode()
    end

    self.lives = player.getProperty("cll_lives") or 3

    message.setHandler("cll_loseLife", loseLife)

    status.setPersistentEffects("Cat-Like Lives", "cll_life" .. self.lives)
end

function update(dt)
    if not self.disable then
        return
    end

    if self.lives <= 1 then
        player.setMode("hardcore")
    elseif player.mode() == "hardcore" then
        player.setMode(self.defaultMode)
    end
end

function uninit()
    if not self.disable then
        return
    end

    player.setProperty("cll_defaultmode", self.defaultMode)

    player.setProperty("cll_lives", self.lives)

    status.clearPersistentEffects("Cat-Like Lives")
end

function loseLife()
    self.lives = self.lives - 1

    status.clearPersistentEffects("Cat-Like Lives")
    status.setPersistentEffects("Cat-Like Lives", "cll_life" .. lives)
end