local image = {}

image.__index = image

function image.new(imagePath)
  local self = {}

  setmetatable(self, image)

  self.image = love.graphics.newImage(imagePath)
  self.x = 0
  self.y = 0
  self.width = 0
  self.height = 0
  self.scaleX = 1
  self.scaleY = 1
  self.rotation = 0
  self.visible = true

  return self
end

function image:update()
  self.width = self.image:getWidth() * self.scaleX / 2
  self.height = self.image:getHeight() * self.scaleY / 2
end

function image:scale(n)
  self.scaleX = n
  self.scaleY = n
end

function image:draw()
  if self.visible then
    love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scaleX, self.scaleY, self.image:getWidth() / 2,self.image:getHeight() / 2)
  end
end

return image
