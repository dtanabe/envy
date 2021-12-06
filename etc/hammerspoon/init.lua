local notHyper = {"ctrl", "alt"}

-- CTRL+ALT+ESC to reload configuration. This is high up in the file so that if we screw something
-- up below, at least this binding will still work.
hs.hotkey.bind(notHyper, "escape", function() hs.reload() end)

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
  hs.hotkey.bind(notHyper, tostring(i), ola.chromeProfileFn(i))
end

hs.hotkey.bind(notHyper, "TAB",      ola.fn("iTerm"))
hs.hotkey.bind(notHyper, "S",        ola.fn("Slack"))
hs.hotkey.bind(notHyper, "M",        ola.fn("Mail"))
hs.hotkey.bind(notHyper, "Z",        ola.fn("zoom.us.app"))
hs.hotkey.bind(notHyper, "Q",        ola.safariNewPrivateWindowFn())
hs.hotkey.bind(notHyper, "P",        ola.profileFn())
hs.hotkey.bind(notHyper, "/",        ola.hammerspoonConsoleFn())

hs.hotkey.bind(notHyper, "return",   paw.mainFn(0.00, 0.00, 1.00, 1.00))
hs.hotkey.bind(notHyper, "left",     paw.mainFn(0.00, 0.00, 0.50, 1.00))
hs.hotkey.bind(notHyper, "right",    paw.mainFn(0.50, 0.00, 0.50, 1.00))
hs.hotkey.bind(notHyper, "up",       paw.mainFn(0.00, 0.00, 1.00, 0.50))
hs.hotkey.bind(notHyper, "down",     paw.mainFn(0.00, 0.50, 1.00, 0.50))
hs.hotkey.bind(notHyper, "=",        paw.mainFn(0.15, 0.00, 0.70, 1.00))
hs.hotkey.bind(notHyper, "I",        paw.mainFn(0.00, 0.00, 0.50, 0.50))
hs.hotkey.bind(notHyper, "O",        paw.mainFn(0.50, 0.00, 0.50, 0.50))
hs.hotkey.bind(notHyper, "K",        paw.mainFn(0.00, 0.50, 0.50, 0.50))
hs.hotkey.bind(notHyper, "L",        paw.mainFn(0.50, 0.50, 0.50, 0.50))
hs.hotkey.bind(notHyper, "[",        paw.mainFn(0.00, 0.00, 0.70, 1.00))
hs.hotkey.bind(notHyper, "]",        paw.mainFn(0.30, 0.00, 0.70, 1.00))

hs.hotkey.bind(notHyper, "padenter", paw.tallFn(0.00, 0.00, 1.00, 1.00))
hs.hotkey.bind(notHyper, "pad8",     paw.tallFn(0.00, 0.00, 1.00, 0.33))
hs.hotkey.bind(notHyper, "pad5",     paw.tallFn(0.00, 0.33, 1.00, 0.33))
hs.hotkey.bind(notHyper, "pad2",     paw.tallFn(0.00, 0.66, 1.00, 0.34))
hs.hotkey.bind(notHyper, "pad6",     paw.tallFn(0.00, 0.00, 1.00, 0.66))
hs.hotkey.bind(notHyper, "pad3",     paw.tallFn(0.00, 0.33, 1.00, 0.67))
