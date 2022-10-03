local boardData = {
  x = 0,
  y = 0,
  w = 6,
  h = 7,
  cw = 20,
  hw = 20
}
local board = {}
local render = {}
local turn = "yellow"

function string.split(string)
  local splitted = {}
  string:gmatch(".",function(char) table.insert(splitted,char) end)
  return splitted
end

function math.round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end 

for i = 1, boardData.h do
  board[i] = {}
  for z = 1, boardData.w do
    board[i][z] = {"free"}
    local mt = {}
    function mt.__call(args)
        love.graphics.circle(unpack(args))
        return nil
    end
    setmetatable(board[i][z],mt)
  end
end

function grid(width,height)
  local cellWidth, cellHeight = boardData.cw, boardData.hw
  for x, amogus in pairs(board) do
    for y, cell in pairs(amogus) do
      local cellStatus = cell[1]
      if cellStatus == "free" then
        love.graphics.setColor(255,255,255)
      elseif cellStatus == "red" then
        love.graphics.setColor(255,0,0)
      elseif cellStatus == "lred" then
        love.graphics.setColor(255,100,0.5)
      elseif cellStatus == "lyellow" then
        love.graphics.setColor(255,255,0.5)
        
      elseif cellStatus == "yellow" then
        love.graphics.setColor(255,255,0)
      end
      local data = {"fill",
        x*cellWidth*2,
        y*cellHeight*2,
        cellWidth,
      }
      table.foreach(data,function(i,v)
        cell[i] = v
      end)
      cell()
      love.graphics.setColor(0,0,0)
      cell[1] = "line"
      cell()
      
      cell[1] = cellStatus
    end
  end
end

function love.mousepressed(x,y)
  local xPos = math.floor(x/boardData.cw/2,0)-1
  local yPos = math.floor(y/boardData.hw/2,0)-1
  print(xPos,yPos)
  print(x,y) 
  if board[xPos+1] ~= nil and board[xPos+1][yPos+1] ~= nil then 
    board[xPos+1][yPos+1][1] = turn 
  end
  if turn == "yellow" then
    turn = "red"
  elseif turn == "red" then
    turn = "yellow"
  end
end

function love.mousemoved(x,y)
  local xPos = math.round(x/boardData.cw/2)-1
  local yPos = math.round(y/boardData.hw/2)-1
  print(xPos,yPos)
  print(x,y)
  for x, amogus in pairs(board) do
    for y, cell in pairs(amogus) do
      if cell[1]:sub(1,1) == "l" then
        cell[1] = "free"
      end
    end
  end
  if board[xPos+1] ~= nil and board[xPos+1][yPos+1] ~= nil then 
    board[xPos+1][yPos+1][1] = "l"..turn 
  end
end

function love.draw()
  love.graphics.setBackgroundColor(255,255,255)
  grid(boardData.w,boardData.h)
end
