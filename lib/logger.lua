-- Basic logger

function new_log(msg)
  if config.debug then
    log_file = assert(io.open('maze.log', 'w'))
    log('----- Start -----\n')
  end
end

function log(msg)
  if config.debug then
    log_file:write(string.format("[%u,%u] %s\n", current_pos.x, current_pos.y, msg))
    log_file:flush()
  end
end
