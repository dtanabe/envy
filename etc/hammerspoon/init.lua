require("roku")
local chrome = require('chrome')

local log = hs.logger.new("envy", 'info')

-- List of keys here:
-- https://github.com/Hammerspoon/hammerspoon/blob/master/extensions/keycodes/internal.m#L365

local function wideMonitor()
  local screens = hs.screen.allScreens()
  return screens[1]
end

local function tallMonitor()
  local screens = hs.screen.allScreens()
  return screens[2]
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Y", function()
  local win = hs.window.focusedWindow()
  local f = wideMonitor():frame()
  f.w = f.w / 2
  win:setFrame(f, 0)
end)

hs.hotkey.bind({"ctrl", "alt"}, "q", function()
  local ok,result = hs.applescript([[
    tell application "Safari"
      make new document
      activate
    end tell
  ]])
end)

for i = 1, 9, 1 do
  hs.hotkey.bind({"ctrl", "alt"}, tostring(i), function()
    chrome.launchProfileNumbered(i)
  end)
end

hs.hotkey.bind({"ctrl", "alt"}, "S", function()
  hs.application.launchOrFocus("Slack")
end)

hs.hotkey.bind({"ctrl", "alt"}, "Z", function()
  hs.application.launchOrFocus("zoom.us.app")
end)

hs.hotkey.bind({"ctrl", "alt"}, "TAB", function()
  hs.application.launchOrFocus("iTerm")
end)

hs.hotkey.bind({"ctrl", "alt"}, "P", function()
  hs.execute("/usr/local/bin/code " .. os.getenv("HOME") .. "/Repositories/pb-envy")
end)

hs.hotkey.bind({"ctrl", "alt"}, "return", function()
  local win = hs.window.focusedWindow()
  local rect = wideMonitor():frame()
  win:setFrame(rect, 0)
end)

hs.hotkey.bind({"ctrl", "alt"}, "left", function()
  local win = hs.window.focusedWindow()
  local rect = wideMonitor():frame()
  rect.w = rect.w / 2
  win:setFrame(rect, 0)
end)

hs.hotkey.bind({"ctrl", "alt"}, "right", function()
  local win = hs.window.focusedWindow()
  local rect = wideMonitor():frame()
  local halfWidth = rect.w / 2
  rect.x = rect.x + halfWidth
  rect.w = halfWidth
  win:setFrame(rect, 0)
end)

hs.hotkey.bind({"ctrl", "alt"}, "up", function()
  local win = hs.window.focusedWindow()
  local rect = wideMonitor():frame()
  local halfHeight = rect.h / 2
  rect.h = halfHeight
  win:setFrame(rect, 0)
end)

hs.hotkey.bind({"ctrl", "alt"}, "down", function()
  local win = hs.window.focusedWindow()
  local rect = wideMonitor():frame()
  local halfHeight = rect.h / 2
  rect.y = rect.y + halfHeight
  rect.h = halfHeight
  win:setFrame(rect, 0)
end)

hs.hotkey.bind({"ctrl", "alt"}, "padenter", function()
  local win = hs.window.focusedWindow()
  local rect = tallMonitor():frame()
  win:setFrame(rect, 0)
end)

hs.hotkey.bind({"ctrl", "alt"}, "pad8", function()
  local win = hs.window.focusedWindow()
  local rect = tallMonitor():frame()
  local thirdHeight = rect.h / 3
  rect.h = thirdHeight
  win:setFrame(rect, 0)
end)

hs.hotkey.bind({"ctrl", "alt"}, "pad5", function()
  local win = hs.window.focusedWindow()
  local rect = tallMonitor():frame()
  local thirdHeight = rect.h / 3
  rect.y = rect.y + thirdHeight
  rect.h = thirdHeight
  win:setFrame(rect, 0)
end)

hs.hotkey.bind({"ctrl", "alt"}, "pad2", function()
  local win = hs.window.focusedWindow()
  local rect = tallMonitor():frame()
  local thirdHeight = rect.h / 3
  rect.y = rect.y + thirdHeight * 2
  rect.h = thirdHeight
  win:setFrame(rect, 0)
end)
