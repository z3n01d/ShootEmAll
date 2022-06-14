local Image = require("classes.image")

local Bullet = require("classes.bullet")

local Collisions = require("utils.collisions")

local enemy = {}

enemy.__index = enemy

function math.clamp(low, n, high) return math.min(math.max(n, low), high) end

function enemy.new(x,y)
  local self = {}
  setmetatable(self, enemy)
  self.sprite = Image.new("assets/sprites/enemy.png")

  self.bullets = {}

  self.x = x or 0
  self.y = y or 0
  self.health = 100

  self.directionMultiplier = math.random(0,3)

  self.time = 0

  self.score = _G.player.score

  return self
end

function enemy:update(dt)
  self.time = self.time + dt

  self.sprite:update(dt)

  local mouseX,mouseY = love.mouse.getX(),love.mouse.getY()

  self.score = _G.player.score * (self.health / 100)

  self.sprite.x = self.x
  self.sprite.y = self.y
  self.sprite:scale(4)

  self.y = self.y + dt * self.score * (self.health / 100) * 150
  self.x = self.x + dt * (self.score * math.sin(self.time * 5) * 0.25) * self.directionMultiplier * (self.health / 100) * 150

  for _,i in ipairs(self.bullets) do
    i:update(dt)
  end
end

function enemy:draw()
  love.graphics.setColor(255, 255, 255, 255)
  for _,i in ipairs(self.bullets) do
    i:draw()
  end
  self.sprite:draw()
end

return enemy
