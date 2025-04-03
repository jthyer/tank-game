local sound = {}

local sounds = {}

sounds.sfx_shoot = love.audio.newSource("assets/sounds/sfx_shoot.wav","static")
sounds.sfx_enemyShoot = love.audio.newSource("assets/sounds/sfx_enemyShoot.wav","static")
sounds.sfx_enemyDead = love.audio.newSource("assets/sounds/sfx_enemyDead.wav","static")
sounds.sfx_wallDead = love.audio.newSource("assets/sounds/sfx_wallDead.wav","static")
sounds.sfx_playerDead = love.audio.newSource("assets/sounds/sfx_playerDead.wav","static")
sounds.sfx_win = love.audio.newSource("assets/sounds/sfx_win.wav","static")

function sound.play(snd)
  local currentSound = sounds[snd]:clone()
  currentSound:play()
end

return sound