-- Save and restore helper
function save_pos()
  saved_pos.x = current_pos.x
  saved_pos.y = current_pos.y
  log(string.format("Save position: %u,%u.\n", current_pos.x, current_pos.y))
end

function restore_pos()
  current_pos.x = saved_pos.x
  current_pos.y = saved_pos.y
  log(string.format("Restore position: %u,%u.\n", current_pos.x, current_pos.y))
end

-- CURSOR MOVEMENT
function move_to(x, y)
  current_pos.x = x
  current_pos.y = y
end

function cursor_up(n)
  if n == nil then n = 1 end
  for i = 1, n do
    if current_pos.x == 1 then
      current_pos.x = config.maze_size
    else
      current_pos.x = current_pos.x - 1
    end
  end
end

function cursor_down(n)
  if n == nil then n = 1 end
  for i = 1, n do
    if current_pos.x == config.maze_size then
      current_pos.x = 1
    else
      current_pos.x = current_pos.x + 1
    end
  end
end

function cursor_left(n)
  if n == nil then n = 1 end
  for i = 1, n do
    if current_pos.y == 1 then
      current_pos.y = config.maze_size
    else
      current_pos.y = current_pos.y - 1
    end
  end
end

function cursor_right(n)
  if n == nil then n = 1 end
  for i = 1, n do
    if current_pos.y == config.maze_size then
      current_pos.y = 1
    else
      current_pos.y = current_pos.y + 1
    end
  end
end

function cursor_move(direction)
  if direction == 1 then cursor_up() end
  if direction == 2 then cursor_down() end
  if direction == 3 then cursor_left() end
  if direction == 4 then cursor_right() end
end

-- Maze generation helpers
function stack_push(x, y)
  if not x then
    x = current_pos.x
    y = current_pos.y
  end
  log(string.format("STACK PUSH %u,%u", x, y))
  table.insert(travel_stack, {x = x, y = y})
end

function stack_pop()
  local x = 0
  local y = 0
  local r = nil
  if #travel_stack > 0 then
    r = travel_stack[#travel_stack]
    table.remove(travel_stack, #travel_stack)
    log(string.format("STACK POP %u,%u", r.x, r.y))
    return r.x, r.y
  else
    log(string.format("STACK EMPTY POP-START %u,%u", start_pos.x, start_pos.y))
    return start_pos.x, start_pos.y
  end
end

function calc_square(d)
  local sq = {}
  local i = 1

  -- Calc the raw square
  if d == 1 then -- upper square
    -- 345 Check direction
    -- 216 1 is the inmediatly upper
    --  @
    table.insert(sq, {x = current_pos.x - 1, y = current_pos.y}) ------ 1
    table.insert(sq, {x = current_pos.x - 1, y = current_pos.y - 1}) -- 2
    table.insert(sq, {x = current_pos.x - 2, y = current_pos.y - 1}) -- 3
    table.insert(sq, {x = current_pos.x - 2, y = current_pos.y}) ------ 4
    table.insert(sq, {x = current_pos.x - 2, y = current_pos.y + 1}) -- 5
    table.insert(sq, {x = current_pos.x - 1, y = current_pos.y + 1}) -- 6
  elseif d == 2 then -- down square
    --  @
    -- 612 Check direction
    -- 543 1 is the inmediatly lower
    table.insert(sq, {x = current_pos.x + 1, y = current_pos.y}) ------ 1
    table.insert(sq, {x = current_pos.x + 1, y = current_pos.y + 1}) -- 2
    table.insert(sq, {x = current_pos.x + 2, y = current_pos.y + 1}) -- 3
    table.insert(sq, {x = current_pos.x + 2, y = current_pos.y}) ------ 4
    table.insert(sq, {x = current_pos.x + 2, y = current_pos.y - 1}) -- 5
    table.insert(sq, {x = current_pos.x + 1, y = current_pos.y - 1}) -- 6
  elseif d == 3 then -- left square
    -- 56  Check direction
    -- 41@ 1 is the inmediatly left
    -- 32
    table.insert(sq, {x = current_pos.x, y = current_pos.y - 1}) ------ 1
    table.insert(sq, {x = current_pos.x + 1, y = current_pos.y - 1}) -- 2
    table.insert(sq, {x = current_pos.x + 1, y = current_pos.y - 2}) -- 3
    table.insert(sq, {x = current_pos.x, y = current_pos.y - 2}) ------ 4
    table.insert(sq, {x = current_pos.x - 1, y = current_pos.y - 2}) -- 5
    table.insert(sq, {x = current_pos.x - 1, y = current_pos.y - 1}) -- 6
  elseif d == 4 then -- right square
    --  65 Check direction
    -- @14 1 is the inmediatly right
    --  23
    table.insert(sq, {x = current_pos.x, y = current_pos.y + 1}) ------ 1
    table.insert(sq, {x = current_pos.x + 1, y = current_pos.y + 1}) -- 2
    table.insert(sq, {x = current_pos.x + 1, y = current_pos.y + 2}) -- 3
    table.insert(sq, {x = current_pos.x, y = current_pos.y + 2}) ------ 4
    table.insert(sq, {x = current_pos.x - 1, y = current_pos.y + 2}) -- 5
    table.insert(sq, {x = current_pos.x - 1, y = current_pos.y + 1}) -- 6
  end

  -- Rectify the out of bound square
  for i = 1, #sq do
    if sq[i]['x'] == 0 then sq[i]['x'] = -1 end
    if sq[i]['y'] == 0 then sq[i]['y'] = -1 end
    if sq[i]['x'] < 0 or sq[i]['x'] > config.maze_size then
      sq[i]['x'] = sq[i]['x'] % config.maze_size
    end
    if sq[i]['y'] < 0 or sq[i]['y'] > config.maze_size then
      sq[i]['y'] = sq[i]['y'] % config.maze_size
    end
  end

  return sq
end

function can_dig_to(d)
  local sq = calc_square(d)
  log(string.format("--- SQUARE DIR %u ---", d))
  -- check if all the square are walls
  for i = 1, #sq do
    if maze[sq[i]['x']][sq[i]['y']] == '#' then
      log(string.format("OK %u: %u,%u -> %s", i, sq[i]['x'], sq[i]['y'], maze[sq[i]['x']][sq[i]['y']]))
    else
      log(string.format("NO %u: %u,%u -> %s", i, sq[i]['x'], sq[i]['y'], maze[sq[i]['x']][sq[i]['y']]))
      return false -- non wall detected
    end
  end

  return true -- all are walls
end

function random_dig_direction()
  local directions = {}
  local d = 1

  -- First to the last direction if possible and the dice rolls over the
  -- configured possibilities
  if can_dig_to(last_dir) and (math.random(100) > config.dir_change_chances) then
    return last_dir
  end

  for d = 1, 4 do
    if can_dig_to(d) then table.insert(directions, d) end
  end
  if #directions < 1 then
    return false
  else
    last_dir = directions[math.random(#directions)]
    return last_dir
  end
end

-- Check if we can dig a square of 4x5 to place the treasure
function can_dig_gold_chamber(d)
  local i = 1
  local x = 0
  local y = 0

  -- Calc the square
  for i = 1, #chamber_mask[d] do
    -- Rectify and check every position
    x, y = rectify(current_pos.x + chamber_mask[d][i][1], current_pos.y + chamber_mask[d][i][2])
    if is_wall_at(x, y) == false then
      return false
    end
  end

  return true
end

function rectify(x, y)
  if x == 0 then x = -1 end
  if y == 0 then y = -1 end
  if x < 0 or x > config.maze_size then
    x = x % config.maze_size
  end
  if y < 0 or y > config.maze_size then
    y = y % config.maze_size
  end

  return x, y
end

-- for debugging purposes
function paint_square(sq)
  for i = 1, #sq do
    maze[sq[i]['x']][sq[i]['y']] = '.'
  end
  display_maze()
end
