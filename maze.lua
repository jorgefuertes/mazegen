---=[Queru's Maze]=---
-- Author: Jorge Fuertes <jorge@jorgefuertes.com> AKA Queru
-- GNU General Public License 3

-- Requires
dofile 'lib/strict.lua'
dofile 'lib/init.lua'
require 'lib/coord'
require 'lib/display'
require 'lib/aux'
require 'lib/maze_io'
require 'lib/logger'

-- Generates a new maze
function gen_maze()
  local x = 0
  local y = 0
  local d = 0

  log('Generating maze')

  -- seed the random
  math.randomseed(os.time())

  -- fill out an all-wall maze
  for x = 1, config.maze_size do
    maze[x] = {}
    for y = 1, config.maze_size do
      maze[x][y] = "#"
    end
  end

  -- place the start point
  --- always inside boundaries for no reason but programer's mental health
  current_pos.x = math.random(3, config.maze_size - 3)
  current_pos.y = math.random(3, config.maze_size - 3)
  log("START POSITION")
  -- store start_pos
  start_pos.x = current_pos.x
  start_pos.y = current_pos.y
  log(string.format("SAVED %u,%u", start_pos.x, start_pos.y))
  -- Start rectangle
  log("RECTANGLE")
  maze_write('S')
  write_up(' ')
  write_right(' ')
  write_down(' ')
  write_down(' ')
  write_left(' ')
  write_left(' ')
  write_up(' ')
  write_up(' ')
  log(string.format("SAVED %u,%u", start_pos.x, start_pos.y))
  current_pos.x = start_pos.x
  current_pos.y = start_pos.y
  log("PLAYER")
  maze_write('@')

  -- Treasure distance
  meta.gold_distance = math.random(config.min_gold_distance, config.max_gold_distance)
  gold_pos.x = 0
  gold_pos.y = 0

  -- Dig the first way
  d = math.random(4)
  cursor_move(d)
  cursor_move(d)
  maze_write(' ')
  stack_push()
  cursor_move(d)
  maze_write(' ')
  stack_push()
  last_dir = d

  -- Maze diggin algorithm
  log("START DIGGING ALGO")
  while true do
    if gold_pos.x == 0 and #travel_stack >= meta.gold_distance then
      -- we should place the treasure if we can
      if can_dig_gold_chamber(last_dir) then
        -- dig the gold here
        maze_dig_gold_chamber(last_dir)
      end
    end
    -- digging direction with config chances to be the last one
    d = random_dig_direction()
    if d then
      cursor_move(d)
      maze_dig()
      stack_push()
    else
      -- all ways blocked, backtrace
      current_pos.x, current_pos.y = stack_pop()
      if current_pos.x == start_pos.x and current_pos.y == start_pos.y then
        break -- back to start, no more to dig
      end
    end
  end -- digging while loop

end -- gen_maze()

function start_movement()
  local k = nil
  while true do
    save_pos()
    k = io.read(1)
    maze_write(' ')
    if k == 'q' then
      cursor_up()
    elseif k == 'a' then
      cursor_down()
    elseif k == 'p' then
      cursor_right()
    elseif k == 'o' then
      cursor_left()
    end
    if is_wall() then
      restore_pos()
    end
    maze_write('@')
  end
end

-- Main
new_log()
while true do
	gen_maze()
	display_maze()
	print("\n                    Generating new maze every 5 seconds...")
	sleep(5)
end
start_movement()
