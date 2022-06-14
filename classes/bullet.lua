local Image = require("classes.image")

local bullet = {}

bullet.__index = bullet

function bullet.new(x,y,speed)
  local self = {}
  setmetatable(self, bullet)
  self.sprite = Image.new("assets/sprites/bullet.png")

  self.x = x
  self.y = y
  self.speed = speed or 150

  return self
end

function bullet:update(dt)
  self.sprite:update(dt)

  self.sprite:scale(1.5)

  self.sprite.x = self.x
  self.sprite.y = self.y

  self.y = self.y - self.speed
end

function bullet:draw()
  love.graphics.setColor(255, 255, 255, 255)
  self.sprite:draw()
end

function bullet:destroy()
  setmetatable(self, nil)
end

return bullet
