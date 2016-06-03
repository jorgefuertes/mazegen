-- Maze input/output

function maze_write(c)
  maze[current_pos.x][current_pos.y] = c
  display_maze()
end

function maze_write_at(x, y, c)
  maze[x][y] = c
  display_maze()
end

function maze_read()
  return maze[current_pos.x][current_pos.y]
end

function maze_read_at(x, y)
  return maze[x][y]
end

function is_wall()
  if maze_read() == '#' then
    return true
  else
    return false
  end
end

function is_wall_at(x, y)
  if maze_read_at(x, y) == '#' then
    return true
  else
    return false
  end
end

function is_way()
  if maze_read() == ' ' then
    return true
  else
    return false
  end
end

function write_up(c)
  cursor_up()
  maze_write(c)
end

function write_down(c)
  cursor_down()
  maze_write(c)
end

function write_left(c)
  cursor_left()
  maze_write(c)
end

function write_right(c)
  cursor_right()
  maze_write(c)
end

function maze_dig()
  -- local anim = '#*'
  -- for n = 1, #anim do
  --   maze_write(string.sub(anim, n, n))
  --   sleep(0.000001)
  -- end
  maze_write(' ')
end

function maze_dig_gold_chamber(d)
  local i = 1
  local x = 0
  local y = 0

  save_pos()

  if d == 1 then
    cursor_up(); maze_dig()
    cursor_up(); maze_dig(); maze_write('G')
    gold_pos.x = current_pos.x; gold_pos.y = current_pos.y
    cursor_up(); maze_dig()
    cursor_left(); maze_dig()
    cursor_down(); maze_dig()
    cursor_down(); maze_dig()
    cursor_right()
    cursor_right(); maze_dig()
    cursor_up(); maze_dig()
    cursor_up(); maze_dig()
  elseif d == 2 then
    cursor_down(); maze_dig()
    cursor_down(); maze_dig(); maze_write('G')
    gold_pos.x = current_pos.x; gold_pos.y = current_pos.y
    cursor_down(); maze_dig()
    cursor_left(); maze_dig()
    cursor_up(); maze_dig()
    cursor_up(); maze_dig()
    cursor_right()
    cursor_right(); maze_dig()
    cursor_down(); maze_dig()
    cursor_down(); maze_dig()
  elseif d == 3 then
    cursor_left(); maze_dig()
    cursor_left(); maze_dig(); maze_write('G')
    gold_pos.x = current_pos.x; gold_pos.y = current_pos.y
    cursor_left(); maze_dig()
    cursor_down(); maze_dig()
    cursor_right(); maze_dig()
    cursor_right(); maze_dig()
    cursor_up()
    cursor_up(); maze_dig()
    cursor_left(); maze_dig()
    cursor_left(); maze_dig()
  elseif d == 4 then
    cursor_right(); maze_dig()
    cursor_right(); maze_dig(); maze_write('G')
    gold_pos.x = current_pos.x; gold_pos.y = current_pos.y
    cursor_right(); maze_dig()
    cursor_down(); maze_dig()
    cursor_left(); maze_dig()
    cursor_left(); maze_dig()
    cursor_up()
    cursor_up(); maze_dig()
    cursor_right(); maze_dig()
    cursor_right(); maze_dig()
  end

  restore_pos()
  return true
end
