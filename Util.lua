-- SpriteSheet constants

SNAKE_HEAD_UP = 1
SNAKE_HEAD_RIGHT = 2
SNAKE_HEAD_DOWN = 3
SNAKE_HEAD_LEFT = 4

SNAKE_TAIL_DOWN = 5
SNAKE_TAIL_LEFT = 6
SNAKE_TAIL_UP = 7
SNAKE_TAIL_RIGHT = 8

SNAKE_TURN_1 = 11
SNAKE_TURN_2 = 12
SNAKE_TURN_3 = 9
SNAKE_TURN_4 = 10

SNAKE_BODY_VERTICAL = 13
SNAKE_BODY_HORIZONTAL = 14


TILE_RABBIT = 15
TILE_EMPTY = 16

-- takes a texture, width, and height of tiles and splits it into quads
-- that can be individually drawn
function generateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local quads = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            -- this quad represents a square cutout of our atlas that we can
            -- individually draw instead of the whole atlas
            quads[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return quads
end


