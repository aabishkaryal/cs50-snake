Class = require 'class'
push = require 'push'

require 'Util'
require 'Snake'
require 'Map'

-- close resolution to NES but 16:9
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 240

-- actual window resolution
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

MAP_OFFSET_X = 16
MAP_OFFSET_Y = 32

TILE_WIDTH = 16
TILE_HEIGHT = 16

-- seed RNG
math.randomseed(os.time())

-- makes upscaling look pixel-y instead of blurry
love.graphics.setDefaultFilter('nearest', 'nearest')

-- performs initialization of all objects and data needed by program
function love.load()

    -- sets up a different, better-looking retro font as our default
    love.graphics.setFont(love.graphics.newFont('fonts/font.ttf', 8))

    -- sets up virtual screen resolution for an authentic retro feel
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    love.window.setTitle('Snake 50')

    -- sprites from opengameart.org
    spritesheet = love.graphics.newImage('graphics/spritesheet.png')
    sprites = generateQuads(spritesheet, 16, 16)

    sounds = {
        ['eat'] = love.audio.newSource('sounds/eat.wav', 'static'),
        ['die'] = love.audio.newSource('sounds/die.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/music.mp3', 'static')
    }
    
    sounds['music']:setVolume(0.2)

    map = Map()
end
-- called whenever window is resized
function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    map:update(dt)
end

function love.draw()

    push:apply('start')

    love.graphics.clear(0, 0.9, 0.5, 0.5)
    
    map:draw()

    push:apply('end')
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end