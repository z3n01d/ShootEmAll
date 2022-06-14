local healthBar = {}

healthBar.__index = healthBar

function math.clamp(low, n, high) return math.min(math.max(n, low), high) end

function healthBar.new(width,height)
  local self = {}

  setmetatable(self, healthBar)

  self.fill = 100
  self.width = width
  self.height = height

  return self
end

function healthBar:update(dt)

end

function healthBar:draw()
  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.rectangle("fill", math.clamp(0,(_G.player.x - self.width / 2),love.graphics.getWidth() - self.width),math.clamp(0,_G.player.y + 100,love.graphics.getHeight() - self.height), self.width, self.height,5,5,100)
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.rectangle("fill", math.clamp(0,(_G.player.x - self.width / 2),love.graphics.getWidth() - self.width),math.clamp(0,_G.player.y + 100,love.graphics.getHeight() - self.height), (self.fill / 100) * self.width, self.height,5,5,100)
end

return healthBar
