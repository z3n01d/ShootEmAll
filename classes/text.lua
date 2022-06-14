local text = {}

text.__index = text

function text.new(font,size)
  local self = {}
  setmetatable(self, text)
  self.size = size or 10
  self.font = love.graphics.newFont("assets/fonts/" .. font,self.size)
  self.text = ""
  return self
end

function text:draw()

end

return text
