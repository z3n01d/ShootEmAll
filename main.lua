function love.load()

  love.mouse.setVisible(false)

  love.graphics.setDefaultFilter("nearest", "nearest")

  -- Classes
  Player = require("classes.player")
  Enemy = require("classes.enemy")
  Image = require("classes.image")
  HealthBar = require("classes.healthBar")
  Flux = require("classes.flux")
  Flash = require("classes.flash")

  -- Utils

  Collisions = require("utils.collisions")

  -- Tables

  _G.enemies = {}
  bar = HealthBar.new(250,10)
  background = {Image.new("assets/sprites/background.png"),Image.new("assets/sprites/background.png"),Image.new("assets/sprites/background.png")}

  -- Objects
  _G.player = Player.new()
  flash = Flash.new()
  title = Image.new("assets/sprites/title.png")
  press_space = Image.new("assets/sprites/pressSpace.png")

  -- Sounds

  explode = love.audio.newSource("assets/sounds/explode.wav", "static")

  -- Values

  _G.state = "menu"

  _G.time = 0

  blinkTime = 0

  enemySpawnTime = 0

  -- Code

  title.x = love.graphics.getWidth() / 2
  title.y = love.graphics.getHeight() / 2

  background[1].x = love.graphics.getWidth() / 2
  background[1].y = love.graphics.getHeight() / 2
  background[2].x = love.graphics.getWidth() / 2
  background[2].y = background[1].y + background[2].image:getHeight()
  background[3].x = love.graphics.getWidth() / 2
  background[3].y = background[1].y - background[3].image:getHeight()
end

function love.update(dt)

  Flux.update(dt)
  flash:update()

  _G.time = _G.time + dt
  blinkTime = blinkTime + dt

  -- Background

  background[1].y = background[1].y + dt * player.score * 100
  if background[1].y >= love.graphics.getHeight() then
    background[1].y = 0
  end
  background[2].x = love.graphics.getWidth() / 2
  background[2].y = background[1].y + background[2].image:getHeight()
  background[3].x = love.graphics.getWidth() / 2
  background[3].y = background[1].y - background[3].image:getHeight()

  -- Object updates

  _G.player:update(dt)

  title:scale(1.25)

  press_space:scale(0.75)

  press_space.x = love.graphics.getWidth() / 2
  press_space.y = love.graphics.getHeight() / 2

  if _G.state == "menu" then
    if blinkTime >= 0.5 then
      press_space.visible = not press_space.visible
      blinkTime = 0
    end
  elseif _G.state == "game" then
    for i,enemy in ipairs(_G.enemies) do
      if Collisions:checkCollisions(enemy.x,enemy.y,enemy.sprite.width,enemy.sprite.height,_G.player.x,_G.player.y,_G.player.sprite.width,_G.player.sprite.height) then
        player:damage(15)
        table.remove(_G.enemies,i)
      end

      if enemy.health <= 0 then
        explode:setPitch(math.random(9,11) / 10)
        explode:play()
        flash:play(enemy.x,enemy.y)
        _G.player.score = _G.player.score + 0.2
        table.remove(_G.enemies,i)
      end

      if enemy.y >= love.graphics.getHeight() then
        table.remove(_G.enemies,i)
      end

      enemy:update(dt)
    end

    bar.fill = _G.player.health
  end

  -- Enemy spawn

  if _G.state == "game" then
    enemySpawnTime = enemySpawnTime + dt

    if enemySpawnTime >= 1 then
      table.insert(_G.enemies,Enemy.new(math.random(10,love.graphics.getWidth() * 0.7),-50,player.score))
      enemySpawnTime = 0
    end
  end

  -- Title screen stuff

  title.x = love.graphics.getWidth() / 2
  title.y = (love.graphics.getHeight() * 0.35) + 7 * math.sin(_G.time * 3)
end

function love.draw()

  -- Object draws

  love.graphics.print(tostring(1 * os.clock() % 2))

  love.graphics.setColor(255, 255, 255, 255)
  for _,image in ipairs(background) do
    image:draw()
  end

  for _,enemy in ipairs(_G.enemies) do
    enemy:draw()
  end

  _G.player:draw()

  if _G.state == "menu" then
    title:draw()
    press_space:draw()
  elseif _G.state == "game" then
    bar:draw()
  end

  flash:draw()
end

function love.keypressed(key, scancode, isrepeat)
  if key == "space" then
    if _G.state == "menu" then
      love.mouse.setX(love.graphics.getWidth() / 2)
      love.mouse.setY(love.graphics.getHeight() * 0.85)
      _G.state = "game"
    end
  end
end
