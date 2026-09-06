-- Turtle inventory should be 4 by 4
-- A chest or an inventory should be present at the left of the starting position
-- The block layer at the turtle's level should be clear, fully digged for the defined mining zone
-- Fuel should be on the lower right slot
-- Any well-sealing block should be on slot 15, left of the fuel
-- Blocks not to be mined should be on the first line
 
-- Define the mining zone here
MaxForward = 16
MaxRight = 16
-- Number of holes to skip (beginning)
SkipHoles = 0
 
local pos = {0, 0, 0}
local facing = 0
local curMessage = ''
 
function tWrite(txt)
    term.clear()
    term.setCursorPos(1, 1)
    if txt then term.write(txt)
    else term.write(curMessage)
    end
end
 
function turnRight(n)
    n = n or 1
    
    while n > 0 do
        n = n - 1
        facing = (facing + 1) % 4
        turtle.turnRight()
    end
end
 
function turnLeft(n)
    n = n or 1
    
    while n > 0 do
        n = n - 1
        facing = (facing - 1) % 4
        turtle.turnLeft()
    end
end
 
function right(n)
    n = n or 1
    checkFuel(n)
 
    if facing == 0 then
        turnRight()
        while n > 0 do
            if turtle.forward() then
                n = n - 1
                pos[1] = pos[1] + 1
            end
        end
    elseif facing == 1 then
        while n > 0 do
            if turtle.forward() then
                n = n - 1
                pos[1] = pos[1] + 1
            end
        end
    elseif facing == 2 then
        turnLeft()
        while n > 0 do
            if turtle.forward() then
                n = n - 1
                pos[1] = pos[1] + 1
            end
        end
    else
        while n > 0 do
            if turtle.back() then
                n = n - 1
                pos[1] = pos[1] + 1
            end
        end
    end
end
 
function left(n)
    n = n or 1
    checkFuel(n)
    
    if facing == 0 then
        turnLeft()
        while n > 0 do
            if turtle.forward() then
                n = n - 1
                pos[1] = pos[1] - 1
            end
        end
    elseif facing == 1 then
        while n > 0 do
            if turtle.back() then
                n = n - 1
                pos[1] = pos[1] - 1
            end
        end
    elseif facing == 2 then
        turnRight()
        while n > 0 do
            if turtle.forward() then
                n = n - 1
                pos[1] = pos[1] - 1
            end
        end
    else
        while n > 0 do
            if turtle.forward() then
                n = n - 1
                pos[1] = pos[1] - 1
            end
        end
    end
end
 
function forward(n)
    n = n or 1
    checkFuel(n)
 
    if facing == 0 then
        while n > 0 do
            if turtle.forward() then
                n = n - 1
                pos[2] = pos[2] + 1
            end
        end
    elseif facing == 1 then
        turnLeft()
        while n > 0 do
            if turtle.forward() then
                n = n - 1
                pos[2] = pos[2] + 1
            end
        end
    elseif facing == 2 then
        while n > 0 do
            if turtle.back() then
                n = n - 1
                pos[2] = pos[2] + 1
            end
        end
    else
        turnRight()
        while n > 0 do
            if turtle.forward() then
                n = n - 1
                pos[2] = pos[2] + 1
            end
        end
    end
end
 
function backward(n)
    n = n or 1
    checkFuel(n)
 
    if facing == 0 then
        while n > 0 do
            if turtle.back() then
                n = n - 1
                pos[2] = pos[2] - 1
            end
        end
    elseif facing == 1 then
        turnRight()
        while n > 0 do
            if turtle.forward() then
                n = n - 1
                pos[2] = pos[2] - 1
            end
        end
    elseif facing == 2 then
        while n > 0 do
            if turtle.forward() then
                n = n - 1
                pos[2] = pos[2] - 1
            end
        end
    else
        turnLeft()
        while n > 0 do
            if turtle.forward() then
                n = n - 1
                pos[2] = pos[2] - 1
            end
        end
    end
end
 
function up(n)
    n = n or 1
    checkFuel(n)
    
    while n > 0 do
        if turtle.up() then
            n = n - 1
            pos[3] = pos[3] + 1
        end
    end
end
 
function down(n)
    n = n or 1
    checkFuel(n)
    
    while n > 0 do
        if turtle.down() then
            n = n - 1
            pos[3] = pos[3] - 1
        end
    end
end
 
function getTo(nPos)
    if not nPos[1] then nPos[1] = pos[1] end
    if not nPos[2] then nPos[2] = pos[2] end
    if not nPos[3] then nPos[3] = pos[3] end
    diff = {nPos[1] - pos[1], nPos[2] - pos[2], nPos[3] - pos[3]}
 
    -- Right / left
    if diff[1] > 0 then right(diff[1])
    elseif diff[1] < 0 then left(-diff[1])
    end
  
    -- Forward / backward
    if diff[2] > 0 then forward(diff[2])
    elseif diff[2] < 0 then backward(-diff[2])
    end
    
    -- Up / down
    if diff[3] > 0 then up(diff[3])
    elseif diff[3] < 0 then down(-diff[3])
    end
end
 
function checkFuel(n)
    if turtle.getFuelLevel() < n then
        tWrite('Refueling...')
        
        turtle.select(16)
        while turtle.getFuelLevel() < n do
            turtle.refuel(1)
        end
        
        tWrite()
    end
end
 
function startingPoint(row)
    return (2 * (row-1)) % 5 + 1
end
 
function ascend()
    curMessage = 'Ascending...'
    tWrite()
        
    while pos[3] < 0 do
        if turtle.detectUp() then turtle.digUp() end
        up()
    end
    
    turtle.select(15)
    turtle.placeDown()
    
    tWrite()
end
 
function drillSides()
    for i = 0, 3, 1 do
        local canDig = true
        
        for j = 1, 4, 1 do
            turtle.select(j)
            if turtle.compare() then canDig = false end
        end
        
        if canDig then turtle.dig() end
        if i ~=3 then turnLeft() end
    end
end
 
function drill()
    curMessage = 'Drilling...'
    tWrite()
        
    while (not turtle.detectDown()) or (turtle.detectDown() and turtle.digDown()) do
        down()
        drillSides()
    end
    
    ascend()
    
    tWrite()
end
 
function drillRow(row)
    getTo({row, startingPoint(row)})
    
    local willMove = 0
    
    while (pos[2] + willMove) <= (MaxForward - 2) do
        emptyInventory()
        
        if willMove == 0 then willMove = 5
        else forward(willMove)
        end
        
        if SkipHoles == 0 then drill()
        else SkipHoles = SkipHoles - 1
        end
    end
end
 
function emptyInventory()
    curMessage = 'Emptying inventory...'
    tWrite()
    
    local curPos = {pos[1], pos[2]}
    getTo({0,0})
    
    while facing ~= 3 do
        turnRight()
    end
    
    for i = 5, 14, 1 do
        turtle.select(i)
        turtle.drop()
    end
    
    getTo(curPos)
    
    tWrite()
end
 
tWrite('Initializing...')
 
for i = 1, MaxRight - 2, 1 do
    drillRow(i)
end
 
tWrite('Ended')