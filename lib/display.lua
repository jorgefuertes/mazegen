-- ASCII ART!

local margin = '                    '

function display_maze()
  local x = 0
  local y = 0
  io.write("\27[?25l") -- Hide the cursor
  if not meta.display_init then
    os.execute('clear')
    meta.display_init = true
    io.write("\27[s")
  else
    io.write("\27[u")
  end

  io.write("\n\n")
  io.write(margin)
  io.write('   |')
  io.write(string.format("SIZE:%ux%u|", config.maze_size, config.maze_size))
  io.write(string.format("START:%s,%s|", start_pos.x, start_pos.y))
  io.write(string.format("GOLD:%s,%s|", gold_pos.x, gold_pos.y))
  io.write(string.format("GFAR:%s|", meta.gold_distance))
  io.write("\n")
  vertical_frame(true)
  for x = 1, config.maze_size do
    io.write(margin)
    if x == current_pos.x then
      io.write(string.format("\27[31m%03u\27[33m|\27[37m", x))
    else
      io.write(string.format("\27[36m%03u\27[33m|\27[37m", x))
    end
    for y = 1, config.maze_size do
      if maze[x][y] == '#' then
        io.write("\27[44m \27[0m")
      elseif maze[x][y] == '@' then
        io.write("\27[35m@\27[37m")
      elseif maze[x][y] == 'G' then
        io.write("\27[33mG\27[37m")
      elseif maze[x][y] == ' ' then
        io.write("\27[47m \27[0m")
      else
        io.write(maze[x][y])
      end
    end
    io.write("\27[33m|\27[37m\n")
  end
  vertical_frame(false)
  io.write("\27[?25h") -- Show the cursor
end

-- display an horizonal external wall
function vertical_frame(top)
  if not top then ruler() end
  local count = 0
  local ord = 1
  io.write(margin)
  io.write('   |\27[36m')
  while count < config.maze_size do
    if ord == 10 then ord = 0 end
    if count == current_pos.y then
      io.write('\27[31m')
    else
      io.write('\27[36m')
    end
    io.write(ord)
    count = count + 1
    ord = ord + 1
  end
  io.write('\27[37m|\n')
  if top then ruler() end
end

function ruler()
  io.write(margin)
  io.write('   \27[33m+')
  for i = 1, config.maze_size do
    io.write('-')
  end
  io.write('+\27[37m\n')
end
