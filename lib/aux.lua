-- sleep
function sleep(n)  -- seconds
  local t0 = os.clock()
  while os.clock() - t0 <= n do end
end
