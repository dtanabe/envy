local exec = hs.execute
local caffeinate = require('hs.caffeinate')
local canvas = require('hs.canvas')
local drawing = require('hs.drawing')
local image = require('hs.image')
local streamdeck = require('hs.streamdeck')
local keycodes = require('hs.keycodes')
local timer = require('hs.timer')
local audiodevice = require('hs.audiodevice')
local styledtext = require('hs.styledtext')

local calendar = require('./render/calendar')
local clock = require('./render/clock')
local audiovolume = require('./render/audiovolume')

local log = hs.logger.new('streamdeck', 'info')

local function script_path()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)")
end

local iconsPath = script_path() .. "/icons/"

local muteImg = image.imageFromPath(iconsPath .. "mute.png")
local unmuteImg = image.imageFromPath(iconsPath .. "unmute.png")
local stopVideoImg = image.imageFromPath(iconsPath .. "stop-video.png")
local startVideoImg = image.imageFromPath(iconsPath .. "start-video.png")

local backImg = image.imageFromPath(iconsPath .. "back.png")
local leftArrowImg = image.imageFromPath(iconsPath .. "left-arrow.png")
local downArrowImg = image.imageFromPath(iconsPath .. "down-arrow.png")
local rightArrowImg = image.imageFromPath(iconsPath .. "right-arrow.png")
local upArrowImg = image.imageFromPath(iconsPath .. "up-arrow.png")

local state = {
  active = true,
  deck = nil,
  ime = nil,
  audio = false,
  video = false,
  volume = audiodevice.defaultOutputDevice():volume(),
  muted = audiodevice.defaultOutputDevice():muted(),
  layer = nil,
  display = 'D1',
}

local display = {
  D1 = 'B9287DD1-E152-4643-8423-0C7E3CB620F1',
  D2 = 'BB18D2F2-E192-414A-B944-44299D6376B8',
}

local c = 1.0
local displaySelector = canvas.new { x = 0, y = 0, w = 72, h = 72 }
displaySelector[1] = {
  action = "fill",
  fillColor = { red = 0, green = 0, black = 0 },
  frame = { x = 0, y = 0, w = 72, h = 72 },
  type = "rectangle"
}
displaySelector[2] = {
  frame = { x = 0, y = 24, w = 72, h = 72 },
  text = styledtext.new(state.display, {
    font = { name = ".AppleSystemUIFont", size = 18 },
    color = { red = c, green = c, blue = c },
    paragraphStyle = { alignment = "center" }
  }),
  type = "text"
}

local refresh = function()
  local deck = state.deck
  if deck == nil then
    return
  end

  if state.active then
    deck:setBrightness(40)

    if state.ime == 'com.apple.keylayout.US' then
      deck:setButtonColor(1, { ["red"] = 1, ["green"] = 1, ["blue"] = 1, ["alpha"] = 1 })
    elseif state.ime == 'com.apple.keylayout.Greek' then
      deck:setButtonColor(1, { ["red"] = 0, ["green"] = 0, ["blue"] = 1, ["alpha"] = 1 })
    elseif state.ime == 'com.apple.keylayout.UnicodeHexInput' then
      deck:setButtonColor(1, { ["red"] = 0.500, ["green"] = 0.500, ["blue"] = 0.500, ["alpha"] = 1 })
    elseif state.ime == 'com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese' then
      deck:setButtonColor(1, { ["red"] = 1, ["green"] = 0.750, ["blue"] = 0.750, ["alpha"] = 1 })
    elseif state.ime == 'com.apple.inputmethod.SCIM.ITABC' then
      deck:setButtonColor(1, { ["red"] = 1, ["green"] = 0, ["blue"] = 0, ["alpha"] = 1 })
    else
      deck:setButtonColor(1, { ["red"] = 0, ["green"] = 0, ["blue"] = 0, ["alpha"] = 1 })
    end

    if state.layer == 'ime-select' then
      deck:setButtonColor(2, { ["red"] = 1, ["green"] = 0, ["blue"] = 0, ["alpha"] = 1 })
      deck:setButtonColor(3, { ["red"] = 1, ["green"] = 0.750, ["blue"] = 0.750, ["alpha"] = 1 })
    elseif state.layer == 'year-calendar' then
      for m = 1, 12 do
        deck:setButtonImage(m + math.floor((m - 1) / 4), calendar.monthImages[m])
      end
      deck:setButtonColor(5, { red = 0, green = 0, blue = 0 })
      deck:setButtonColor(10, { red = 0, green = 0, blue = 0 })
      deck:setButtonColor(15, { red = 0, green = 0, blue = 0 })
    else
      local black = { red = 0, green = 0, blue = 0 }
      deck:setButtonColor(2, black)
      deck:setButtonColor(3, black)
      deck:setButtonColor(4, black)
      deck:setButtonImage(5, clock.nowImage())
      -- deck:setButtonImage(6, audiovolume.image(state.volume, state.muted))
      displaySelector[2] = {
        frame = { x = 0, y = 24, w = 72, h = 72 },
        text = styledtext.new(state.display, {
          font = { name = ".AppleSystemUIFont", size = 18 },
          color = { red = c, green = c, blue = c },
          paragraphStyle = { alignment = "center" }
        }),
        type = "text"
      }

      deck:setButtonImage(6, displaySelector:imageFromCanvas())
      deck:setButtonColor(7, black)
      deck:setButtonColor(8, black)
      deck:setButtonColor(9, black)
      deck:setButtonImage(10, calendar.monthImages[os.date("*t").month])

      if state.audio then
        deck:setButtonImage(11, muteImg)
      else
        deck:setButtonImage(11, unmuteImg)
      end

      if state.video then
        deck:setButtonImage(12, stopVideoImg)
      else
        deck:setButtonImage(12, startVideoImg)
      end

      deck:setButtonColor(13, black)
      deck:setButtonColor(14, black)
      deck:setButtonColor(15, black)
    end
  else
    deck:setBrightness(0)
    log.i('nope we not be active')
    deck:setButtonColor(1, drawing.color.black)
  end
end


state.ime = keycodes.currentSourceID()
keycodes.inputSourceChanged(function()
  state.ime = keycodes.currentSourceID()
  refresh()
end)

streamdeck.init(function(connected, deck)
  if connected then
    state.deck = deck
  else
    state.deck = nil
  end

  deck:buttonCallback(function(data, button, pressed)
    if pressed then
      if button == 1 then
        state.layer = 'ime-select'
      elseif button == 2 then
        if state.layer == 'ime-select' then
          keycodes.currentSourceID('com.apple.inputmethod.SCIM.ITABC')
          state.layer = nil
        end
      elseif button == 6 then
        if state.display == 'D1' then
          state.display = 'D2'
        else
          state.display = 'D1'
        end
      elseif button == 7 then
        if state.display == 'D1' then
          exec('/opt/homebrew/bin/m1ddc display ' .. display.D1 .. ' set input 15')
        else
          exec('/opt/homebrew/bin/m1ddc display ' .. display.D2 .. ' set input 27')
        end
      elseif button == 8 then
        if state.display == 'D1' then
          exec('/opt/homebrew/bin/m1ddc display ' .. display.D1 .. ' set input 17')
        else
          exec('/opt/homebrew/bin/m1ddc display ' .. display.D2 .. ' set input 15')
        end
      elseif button == 9 then
        if state.display == 'D1' then
          exec('/opt/homebrew/bin/m1ddc display ' .. display.D1 .. ' set input 18')
        else
          exec('/opt/homebrew/bin/m1ddc display ' .. display.D2 .. ' set input 17')
        end
      elseif button == 10 then
        state.layer = 'year-calendar'
      elseif button == 11 then
        state.audio = not state.audio
      elseif button == 12 then
        state.video = not state.video
      elseif button == 15 then
        exec("/Users/dtanabe/.bin/_hub-zoom")
      end
    else
      if button == 1 then
        if state.layer == 'ime-select' then
          keycodes.currentSourceID('com.apple.keylayout.US')
          state.layer = nil
        end
      elseif button == 10 then
        state.layer = nil
      end
    end
    refresh()
  end)

  refresh()
end)


local Device = audiodevice.defaultOutputDevice()
if Device ~= nil then
  Device:watcherCallback(function(deviceUID, eventName, scope, num)
    if eventName == "vmvc" or eventName == "mute" then
      local ad = audiodevice.findDeviceByUID(deviceUID)
      if ad ~= nil then
        state.volume = ad:volume()
        state.muted = ad:muted()
        refresh()
      end
    end
  end):watcherStart()
end

Watcher = caffeinate.watcher.new(function(eventType)
  if eventType == caffeinate.watcher.screensDidLock then
    state.active = false
  elseif eventType == caffeinate.watcher.screensDidUnlock then
    state.active = true
  end
  refresh()
end)

Watcher:start()

-- MyTimer = timer.new(1, refresh)
-- MyTimer:start()
