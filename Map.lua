
--[[
    Contains tile data and necessary code for rendering a tile map to the
    screen.
]]

Map = Class {}

-- constructor for map object
function Map:init()

    -- map width and height in tile blocks
    self.width = 25
    self.height = 12

    -- map width and height in pixels
    self.pixelWidth = self.width * TILE_WIDTH
    self.pixelHeight = self.height * TILE_HEIGHT

    -- tile map table
    self.tiles = {}
    self:generateTiles()

    -- the snake/player
    self.snake = Snake(self)

    -- game state
    self.state = 'start'

    -- the rabbit/food
    self.rabbit = nil

    -- table for different behaviors depending on different game states
    self.behaviors = {
        ['start'] = function(dt)
            if love.keyboard.isDown('return')then
                self.state = 'play'
            end
        end,
        ['play'] = function(dt)
            if self.rabbit == nil then
                self:generateRabbit()
            end

            self.snake:update(dt)
        end,
        ['death'] = function(dt)
            if love.keyboard.isDown('return')then
                self.state = 'start'
                
                self.tiles = {}
                self:generateTiles()

                self.snake = Snake(self)
                self.rabbit = nil

            end
        end
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()
end

function Map:update(dt)
    self.behaviors[self.state](dt)
end

function Map:draw()

    -- draw reddish background screen on death
    if self.state == 'death' then
        love.graphics.clear(1, 0.1, 0.1, 0.75)
    end

    -- draw the tile map
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self:getTile(x, y)
            love.graphics.draw(spritesheet, sprites[tile],
                (x - 1) * TILE_WIDTH + MAP_OFFSET_X, (y - 1) * TILE_HEIGHT + MAP_OFFSET_Y)
        end
    end

    
    if self.state == 'start' then
        -- print instruction on start states
        love.graphics.printf('Welcome to Snake.', 4, 4, VIRTUAL_WIDTH - 4, 'center')
        love.graphics.printf('Press Enter to start, Escape to close.', 4, 16, VIRTUAL_WIDTH - 4, 'center')
    elseif self.state == 'play' then
        -- print instruction and score on play state
        love.graphics.printf('Use Arrow Keys to control the snake and eat the rabbit.', 4, 4, VIRTUAL_WIDTH - 4, 'center')
        love.graphics.printf('Score: '..tostring(self.snake.length - 3), 4, 16, VIRTUAL_WIDTH - 4, 'center')
    elseif self.state == 'death' then
        -- print final score and instruction on death state
        love.graphics.printf('You died. Final Score: '..tostring(self.snake.length - 3), 4, 4, VIRTUAL_WIDTH - 4, 'center')
        love.graphics.printf('Press Enter to re-start, Escape to close.', 4, 16, VIRTUAL_WIDTH - 4, 'center')
    end

    -- draw rabbit if defined
    if self.rabbit ~= nil then
        love.graphics.draw(spritesheet, sprites[TILE_RABBIT],
                (self.rabbit[1] - 1) * TILE_WIDTH + MAP_OFFSET_X, (self.rabbit[2] - 1) * TILE_HEIGHT + MAP_OFFSET_Y)
    end

    -- finnaly draw the snake
    self.snake:draw()
end

-- returns an integer value for the tile at a given x-y coordinate
function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.width + x]
end

-- sets a tile at a given x-y coordinate to an integer value
function Map:setTile(x, y, id)
    self.tiles[(y - 1) * self.width + x] = id
end

-- returns tile index on tile map of given x-y coordinate
function Map:getTileID(pos)
    return (pos[2] - 1) * self.width + pos[1]
end

-- generates the tile map

function Map:generateTiles()
    -- first, fill map with empty tiles
    for y = 1, self.height do
        for x = 1, self.width do
            
            -- support for multiple sheets per tile; storing tiles as tables 
            self:setTile(x, y, TILE_EMPTY)
        end
    end
end

-- generate rabbit so that snake and rabbit don't overlap
function Map:generateRabbit()
    local bodytiles = self.snake.bodyTileIDs

    local tiles = {}
    for y = 1, self.height do
        for x = 1, self.width do
            
            local tileId = self:getTileID({x, y})
            if (bodytiles[tileId] == nil) then
                table.insert(tiles, {x, y})
            end
        end
    end

    local n = math.random(#tiles)
    self.rabbit = tiles[n]
end

