local flux = require("classes.flux")

local flash = {}
flash.__index = flash

function flash.new()
  local self = {}
  setmetatable(self, flash)

  self.flashes = {}

  return self
end

function flash:update(dt)
  for _,circle in ipairs(self.flashes) do
    flux.to(circle,0.3,{radius = 0,transparency = 0})
  end
end

function flash:play(x,y)
  table.insert(self.flashes,{
    radius = 125,
    transparency = 1,
    x = x,
    y = y,
  })
end

function flash:draw()
  for _,circle in ipairs(self.flashes) do
    love.graphics.setColor(255, 255, 255, circle.transparency)
    love.graphics.circle("fill", circle.x, circle.y, circle.radius)
  end
end

return flash
