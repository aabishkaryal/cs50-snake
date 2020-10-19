--[[
    Contains data and necessary code for rendering a snake to the
    screen.
]]

Snake = Class {}

-- constructor for snake object
function Snake:init(map)
    self.map = map
    -- initial length of snake
    self.length = 3
    -- starting position of snake
    self.body = {{3, 1}, {2, 1}, {1, 1}}
    self.bodyTileIDs = {[3]=true, [2]=true, [1]=true}

    -- accumulator for dt in update
    self.time = 0
    -- direction of snake head
    self.direction = 'right'
    -- future direction for when key is pressed to change direction
    self.Fdirection = nil

    

end

function Snake:update(dt)
    -- accumulate dts over multiple updates
    self.time = self.time + dt
    -- keyboard input for snake control
    self:keyControls()

    -- reduce frame Rate for the classic experience
    if self.time > (1 / 6) then
        self.time = self.time - (1 / 6)

        if self.Fdirection ~= nil then
            self.direction = self.Fdirection
            self.Fdirection = nil
        end

        -- move the snake head towards direction
        local newHead = self:moveHead()
        local headTileID = self.map:getTileID(newHead)

        -- add it to body
        table.insert(self.body, 1, newHead)     


        if headTileID == self.map:getTileID(self.map.rabbit) then
            -- if rabbit was eaten, play the eat sound and increase snake length
            sounds['eat']:play()
            self.length = self.length + 1
            self.map.rabbit = nil
        end

        -- move rest of the body
        if #self.body > self.length then 
            local last = table.remove(self.body)
            self.bodyTileIDs[self.map:getTileID(last)] = nil
        end

        -- check for self collision or map edge collision

        if (self.bodyTileIDs[headTileID] ~= nil) or 
            (newHead[1] > self.map.width or newHead[1] < 1 or 
            newHead[2] < 1 or newHead[2] > self.map.height) then
            self.map.state = 'death'
            sounds['die']:play()
            return
        end 

        -- //finally approve the new head location
        self.bodyTileIDs[headTileID] = true  

    end
end

-- moves head in the direction
function Snake:moveHead()
    local head = { self.body[1][1], self.body[1][2] }
    if self.direction == 'up' then
        head[2] = head[2] - 1
    elseif self.direction == 'right' then
        head[1] = head[1] + 1
    elseif self.direction == 'left' then
        head[1] = head[1] - 1
    elseif self.direction == 'down' then
        head[2] = head[2] + 1
    end

    return head
end

-- draw the snake
function Snake:draw()
    for i = #self.body, 1, -1 do
        local sprite = self:getSprite(i)
        local pos = self.body[i]
        love.graphics.draw(spritesheet, sprites[sprite], 
                (pos[1] - 1) * TILE_WIDTH + MAP_OFFSET_X, (pos[2] - 1) * TILE_HEIGHT + MAP_OFFSET_Y)
    end
end

-- get sprites for different snake parts
function Snake:getSprite(i)
    if i == 1 then
        return self:getHeadSprite()
    elseif  i == self.length then
        return self:getTailSprite()
    else 
        return self:getBodySprite(i)
    end
end

-- get sprite of snake body part respect to preciding and next body part
function Snake:getBodySprite(i)

    local bodyPart = self.body[i]
    local next = self.body[i - 1]
    local previous = self.body[i + 1]

    if previous[2] == bodyPart[2] and bodyPart[2] == next[2] then
        return SNAKE_BODY_HORIZONTAL
    elseif previous[1] == bodyPart[1] and bodyPart[1] == next[1] then
        return SNAKE_BODY_VERTICAL
    elseif (bodyPart[1] - previous[1] == 1 and next[2] - bodyPart[2] == 1) or
            (bodyPart[2] - previous[2] == -1 and next[1] - bodyPart[1] == -1) then
                return SNAKE_TURN_1
    elseif (bodyPart[2] - previous[2] == 1 and next[1] - bodyPart[1] == -1) or
            (bodyPart[1] - previous[1] == 1 and next[2] - bodyPart[2] == -1) then
                return SNAKE_TURN_2
    elseif (bodyPart[1] - previous[1] == -1 and next[2] - bodyPart[2] == -1) or
            (bodyPart[2] - previous[2] == 1 and next[1] - bodyPart[1] == 1) then
                return SNAKE_TURN_3
    elseif (bodyPart[2] - previous[2] == -1 and next[1] - bodyPart[1] == 1) or
            (bodyPart[1] - previous[1] == -1 and next[2] - bodyPart[2] == 1) then
                return SNAKE_TURN_4

    end
    
end

-- get sprite of snake head according to the direction
function Snake:getHeadSprite()
    if self.direction == 'up' then
        return SNAKE_HEAD_UP
    elseif self.direction == 'right' then
        return SNAKE_HEAD_RIGHT
    elseif self.direction == 'left' then
        return SNAKE_HEAD_LEFT
    elseif self.direction == 'down' then
        return SNAKE_HEAD_DOWN
    end

end

-- get tail sprite according to preceding body part
function Snake:getTailSprite()
    local tailEnd = self.body[self.length]
    local previous = self.body[self.length - 1]

    if previous[1] - tailEnd[1] == 1 then 
        return SNAKE_TAIL_LEFT
    elseif previous[1] - tailEnd[1] == -1 then
        return SNAKE_TAIL_RIGHT
    elseif previous[2] - tailEnd[2] == 1 then
        return SNAKE_TAIL_UP
    elseif previous[2] - tailEnd[2] == -1 then
        return SNAKE_TAIL_DOWN
    end

end

-- define key controls for the snake and assign future direction for update
function Snake:keyControls()
    if love.keyboard.isDown('up')  and self.direction ~= 'down' then
        self.Fdirection = 'up'
    elseif love.keyboard.isDown('down') and self.direction ~= 'up' then
        self.Fdirection = 'down'
    elseif love.keyboard.isDown('left') and self.direction ~= 'right' then
        self.Fdirection = 'left'
    elseif love.keyboard.isDown('right') and self.direction ~= 'left' then
        self.Fdirection = 'right'
    end
end
