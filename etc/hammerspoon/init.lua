local exec = hs.execute
local hotkey = require('hs.hotkey')
local keycodes = require('hs.keycodes')

local notHyper = { "ctrl", "alt" }

local display = {
  D1 = 'B9287DD1-E152-4643-8423-0C7E3CB620F1',
  D2 = 'BB18D2F2-E192-414A-B944-44299D6376B8',
}

-- CTRL+ALT+ESC to reload configuration. This is high up in the file so that if we screw something
-- up below, at least this binding will still work.
hotkey.bind(notHyper, "escape", function() hs.reload() end)

require("browser")
require("roku")
local ola = require('ola')
local paw = require('paw')

local log = hs.logger.new('envy', 'info')

-- List of keys here:
-- https://github.com/Hammerspoon/hammerspoon/blob/master/extensions/keycodes/internal.m#L365

-- hs.hotkey.bind({"ctrl", "alt"}, "q", function()
--   local ok,result = hs.applescript([[
--     tell application "Safari"
--       make new document
--       activate
--     end tell
--   ]])
-- end)

for i = 1, 9, 1 do
  hotkey.bind(notHyper, tostring(i), ola.chromeProfileFn(i))
end

hotkey.bind(notHyper, "TAB", ola.fn("iTerm"))
hotkey.bind(notHyper, "F", ola.fn("OmniFocus"))
hotkey.bind(notHyper, "S", ola.fn("Slack"))
hotkey.bind(notHyper, "M", ola.fn("Mail"))
hotkey.bind(notHyper, "R", ola.fn("Reeder"))
hotkey.bind(notHyper, "Z", ola.fn("zoom.us.app"))
hotkey.bind(notHyper, "Q", ola.safariNewPrivateWindowFn())
hotkey.bind(notHyper, "W", ola.fn("Orion"))
hotkey.bind(notHyper, "P", ola.profileFn())
hotkey.bind(notHyper, "/", ola.hammerspoonConsoleFn())

hotkey.bind(notHyper, "return", paw.mainFn(0.00, 0.00, 1.00, 1.00))
hotkey.bind(notHyper, "left", paw.mainFn(0.00, 0.00, 0.50, 1.00))
hotkey.bind(notHyper, "right", paw.mainFn(0.50, 0.00, 0.50, 1.00))
hotkey.bind(notHyper, "up", paw.mainFn(0.00, 0.00, 1.00, 0.50))
hotkey.bind(notHyper, "down", paw.mainFn(0.00, 0.50, 1.00, 0.50))
hotkey.bind(notHyper, "=", paw.mainFn(0.15, 0.00, 0.70, 1.00))
hotkey.bind(notHyper, "I", paw.mainFn(0.00, 0.00, 0.50, 0.50))
hotkey.bind(notHyper, "O", paw.mainFn(0.50, 0.00, 0.50, 0.50))
hotkey.bind(notHyper, "K", paw.mainFn(0.00, 0.50, 0.50, 0.50))
hotkey.bind(notHyper, "L", paw.mainFn(0.50, 0.50, 0.50, 0.50))
hotkey.bind(notHyper, "[", paw.mainFn(0.00, 0.00, 0.70, 1.00))
hotkey.bind(notHyper, "]", paw.mainFn(0.30, 0.00, 0.70, 1.00))

hotkey.bind(notHyper, "padenter", paw.tallFn(0.00, 0.00, 1.00, 1.00))
hotkey.bind(notHyper, "pad7", paw.tallFn(0.00, 0.00, 1.00, 0.50))
hotkey.bind(notHyper, "pad4", paw.tallFn(0.00, 0.25, 1.00, 0.50))
hotkey.bind(notHyper, "pad1", paw.tallFn(0.00, 0.50, 1.00, 0.50))
hotkey.bind(notHyper, "pad8", paw.tallFn(0.00, 0.00, 1.00, 0.33))
hotkey.bind(notHyper, "pad5", paw.tallFn(0.00, 0.33, 1.00, 0.33))
hotkey.bind(notHyper, "pad2", paw.tallFn(0.00, 0.66, 1.00, 0.34))
hotkey.bind(notHyper, "pad9", paw.tallFn(0.00, 0.00, 1.00, 0.66))
hotkey.bind(notHyper, "pad6", paw.tallFn(0.00, 0.16, 1.00, 0.66))
hotkey.bind(notHyper, "pad3", paw.tallFn(0.00, 0.33, 1.00, 0.67))

hotkey.bind(notHyper, "\\", paw.builtInFn(0.00, 0.00, 1.00, 1.00))

hotkey.bind(notHyper, "F1", function()
  keycodes.currentSourceID('com.apple.keylayout.US')
end)
hotkey.bind(notHyper, "F2", function()
  keycodes.currentSourceID('com.apple.keylayout.Greek')
end)
hotkey.bind(notHyper, "F3", function()
  keycodes.currentSourceID('com.apple.inputmethod.SCIM.ITABC')
end)
hotkey.bind(notHyper, "F4", function()
  keycodes.currentSourceID('com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese')
end)
hotkey.bind("", "F16", function()
  exec('/opt/homebrew/bin/m1ddc display ' .. display.D1 .. ' set input 15')
end)
hotkey.bind("shift", "F16", function()
  exec('/opt/homebrew/bin/m1ddc display ' .. display.D2 .. ' set input 27')
end)
hotkey.bind("", "F17", function()
  exec('/opt/homebrew/bin/m1ddc display ' .. display.D1 .. ' set input 17')
end)
hotkey.bind("shift", "F17", function()
  exec('/opt/homebrew/bin/m1ddc display ' .. display.D2 .. ' set input 15')
end)
hotkey.bind("", "F18", function()
  exec('/opt/homebrew/bin/m1ddc display ' .. display.D1 .. ' set input 18')
end)

require("streamdeck")
require("zoom")
