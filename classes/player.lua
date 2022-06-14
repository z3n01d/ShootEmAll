local Image = require("classes.image")

local Bullet = require("classes.bullet")

local Collisions = require("utils.collisions")

local hit = love.audio.newSource("assets/sounds/hurt.wav", "static")
local shoot = love.audio.newSource("assets/sounds/shoot.wav", "static")
local explode = love.audio.newSource("assets/sounds/explode.wav", "static")
hit:setVolume(0.5)
shoot:setVolume(0.5)

local player = {}

player.__index = player

function math.clamp(low, n, high) return math.min(math.max(n, low), high) end

function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function player.new()
  local self = {}
  setmetatable(self, player)
  self.sprite = Image.new("assets/sprites/player.png")

  self.bullets = {}

  self.spawnTime = 0

  self.switchTurret = false

  self.x = 0
  self.y = 0

  self.score = 1
  self.health = 100

  return self
end

function player:update(dt)
  self.sprite:update(dt)

  local mouseX,mouseY = love.mouse.getX(),love.mouse.getY()

  self.sprite.x = self.x
  self.sprite.y = self.y
  self.sprite:scale(4)

  if _G.state == "game" then
    self.score = self.score + dt * 0.05

    if love.mouse.isDown(1) then
      spawnTime = spawnTime + dt
      if spawnTime >= 0.1 then
        self.switchTurret = not self.switchTurret
        if self.switchTurret then
          table.insert(self.bullets,{Bullet.new(self.x - self.sprite.image:getWidth(),self.y,dt * 400),0})
        else
          table.insert(self.bullets,{Bullet.new(self.x + self.sprite.image:getWidth(),self.y,dt * 400),0})
        end
        shoot:setPitch(math.random(9,10) / 10)
        shoot:play()
        spawnTime = 0
      end
    else
      spawnTime = 0
    end

    for i,x in ipairs(self.bullets) do
      x[1]:update(dt)
      x[2] = x[2] + dt

      for enemyI,enemy in pairs(_G.enemies) do
        if Collisions:checkCollisions(x[1].x,x[1].y,x[1].sprite.width,x[1].sprite.height,enemy.x,enemy.y,enemy.sprite.width,enemy.sprite.height) then
          table.remove(self.bullets,i)
          hit:setPitch(math.random(9,10) / 10)
          hit:play()
          enemy.y = enemy.y - 25
          enemy.health = enemy.health - 25
        end
      end

      if x[2] >= 1 then
        table.remove(self.bullets,i)
      end
    end

    self.x = mouseX
    self.y = mouseY

    if self.health <= 0 then
      self:reset()
      _G.state = "menu"
    end
  else
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() * 0.85
  end
end

function player:draw()
  love.graphics.setColor(255, 255, 255, 255)
  for _,i in ipairs(self.bullets) do
    i[1]:draw()
  end
  self.sprite:draw()
end

function player:reset()
  self.score = 1
  self.health = 100
  for enemyI,enemy in pairs(_G.enemies) do
    table.remove(_G.enemies,enemyI)
  end
  for bulletI,bullet in pairs(self.bullets) do
    table.remove(self.bullets,bulletI)
  end
  self.spawnTime = 0
end

function player:damage(hp)
  self.health = self.health - hp
  explode:setPitch(math.random(9,11) / 10)
  explode:play()
end

return player
