-- paw: short for "position active window".
local paw = {}

local log = hs.logger.new('paw', 'info')

---Returns a function that moves the active window to the "main monitor"
---(the monitor with the biggest area).
--
---@param x number The x-offset from the left side of the main monitor, measured as a fraction of the width main monitor.
---@param y number The y-offset from the top side of the main monitor, measured as a fraction of the height main monitor.
---@param w number The desired width, measured as a fraction of the width main monitor.
---@param h number The desired height, measured as a fraction of the height main monitor.
---@return fun():nil @A function that, when called, moves the active window to the main monitor with the specified sizing parameters.
paw.mainFn = function(x, y, w, h)
  return function () paw.main(x, y, w, h) end
end

---Returns a function that moves the active window to the "tall monitor"
---(the monitor with the highest h/w ratio).
--
---@param x number The x-offset from the left side of the tall monitor, measured as a fraction of the width tall monitor.
---@param y number The y-offset from the top side of the tall monitor, measured as a fraction of the height tall monitor.
---@param w number The desired width, measured as a fraction of the width tall monitor.
---@param h number The desired height, measured as a fraction of the height tall monitor.
---@return fun():nil @A function that, when called, moves the active window to the tall monitor with the specified sizing parameters.
paw.tallFn = function(x, y, w, h)
  return function () paw.tall(x, y, w, h) end
end

-- Moves the active window to the "main monitor" (the monitor with the biggest area).
paw.main = function(x, y, w, h)
  return paw.to(paw.screens().main, x, y, w, h)
end

-- Moves the active window to the "tall monitor" (the monitor with the highest h/w ratio).
paw.tall = function(x, y, w, h)
  local screens = hs.screen.allScreens()
  return paw.to(paw.screens().tall, x, y, w, h)
end

-- Moves the active window to the specified monitor and at the specified coordinates,
-- expressed as fractions of the overall screen size.
paw.to = function(screen, x, y, w, h)
  local win = hs.window.focusedWindow()
  local rect = screen:frame()
  win:setFrame({
    x = rect.x + rect.w * x,
    y = rect.y + rect.h * y,
    w = rect.w * w,
    h = rect.h * h
  }, 0)
end

---@class paw.Screens
---@field main paw.Screen
---@field tall paw.Screen?

---@class paw.Screen

---Returns a table of screens, mapped to their 'paw' names.
---
---@return paw.Screens @screens
paw.screens = function()
  local allScreens = {}
  local count = 0
  for idx, screen in ipairs(hs.screen.allScreens()) do
    count = count + 1
    local r = screen:frame()
    allScreens[idx] = {
      screen = screen,
      size = r.w * r.h,
      ratio = r.w / r.h
    }
  end

  if count == 1 then
    return { main=allScreens[1].screen }
  end

  table.sort(allScreens, function (a, b) return a.size < b.size end)

  local mainScreen = allScreens[count].screen
  allScreens[count] = nil

  table.sort(allScreens, function (a, b) return a.ratio > b.ratio end)
  local tallScreen = allScreens[count - 1].screen

  return {main=mainScreen, tall=tallScreen}
end

return paw
