local hsLogger = require('hs.logger')
local hsScreen = require('hs.screen')
local hsWindow = require('hs.window')

-- paw: short for "position active window".
local paw = {}

local log = hsLogger.new('paw', 'info')

---Returns a function that moves the active window to the "main monitor"
---(the monitor with the biggest area).
--
---@param x number The x-offset from the left side of the main monitor, measured as a fraction of the width main monitor.
---@param y number The y-offset from the top side of the main monitor, measured as a fraction of the height main monitor.
---@param w number The desired width, measured as a fraction of the width main monitor.
---@param h number The desired height, measured as a fraction of the height main monitor.
---@return fun():nil @A function that, when called, moves the active window to the main monitor with the specified sizing parameters.
paw.mainFn = function(x, y, w, h)
  return function() paw.main(x, y, w, h) end
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
  return function() paw.tall(x, y, w, h) end
end

paw.thirdFn = function(x, y, w, h)
  return function() paw.third(x, y, w, h) end
end

-- Moves the active window to the "main monitor" (the monitor with the biggest area that is widescreen).
paw.main = function(x, y, w, h)
  local screens = paw.screens()
  paw.to(screens.wide[1], x, y, w, h)
end

-- Moves the active window to the "tall monitor" (the monitor with the highest h/w ratio).
paw.tall = function(x, y, w, h)
  local screens = paw.screens()
  paw.to(screens.tall[1], x, y, w, h)
end

paw.third = function(x, y, w, h)
  local screens = paw.screens()
  paw.to(screens.wide[2], x, y, w, h)
end

-- Moves the active window to the specified monitor and at the specified coordinates,
-- expressed as fractions of the overall screen size.
paw.to = function(screen, x, y, w, h)
  if screen == nil then
    log.wf("Tried to move the focused window to a monitor that we don't have!")
    return
  end

  local win = hsWindow.focusedWindow()

  local rect = screen:frame()
  win:setFrame({
    x = rect.x + rect.w * x,
    y = rect.y + rect.h * y,
    w = rect.w * w,
    h = rect.h * h
  }, 0)
end

local screenSize = function(screen)
  r = screen:frame()
  return r.w * r.h
end
---@class paw.Screens
---@field tall hsScreen.Screen[]
---@field wide hsScreen.Screen[]

---@class paw.Screen

---Returns a table of screens, mapped to their 'paw' names.
---
---@return paw.Screens @screens
paw.screens = function()
  local wide = {}
  local tall = {}

  for idx, screen in ipairs(hsScreen.allScreens()) do
    local r = screen:frame()
    if r.w > r.h then
      table.insert(wide, screen)
    else
      table.insert(tall, screen)
    end
  end

  table.sort(tall, function(a, b) return screenSize(a) > screenSize(b) end)
  table.sort(wide, function(a, b) return screenSize(a) > screenSize(b) end)

  return { wide = wide, tall = tall }
end


return paw
