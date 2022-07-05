local caffeinate = require('hs.caffeinate')
local drawing = require('hs.drawing')
local image = require('hs.image')
local streamdeck = require('hs.streamdeck')

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

local state = { active = true, deck = nil, audio = false, video = false }


local refresh = function()
  local deck = state.deck
  if deck == nil then
    return
  end

  if state.active then
    log.i('yeah we be active')
    deck:setBrightness(40)
    deck:setButtonColor(1, drawing.color.red)
    deck:setButtonColor(2, { ["red"] = 1.000, ["green"] = 0.500, ["blue"] = 0.000, ["alpha"] = 1 })
    deck:setButtonColor(3, { ["red"] = 1.000, ["green"] = 1.000, ["blue"] = 0.000, ["alpha"] = 1 })
    -- deck:setButtonColor(4, drawing.color.green)
    deck:setButtonColor(5, drawing.color.blue)
    deck:setButtonColor(6, { ["red"] = 1.000, ["green"] = 0.500, ["blue"] = 0.000, ["alpha"] = 1 })
    deck:setButtonColor(7, { ["red"] = 1.000, ["green"] = 1.000, ["blue"] = 0.000, ["alpha"] = 1 })
    -- deck:setButtonColor(8, drawing.color.green)
    deck:setButtonColor(9, drawing.color.blue)
    -- deck:setButtonColor(10, { ["red"] = 0.500, ["green"] = 0.000, ["blue"] = 1.000, ["alpha"] = 1 })

    deck:setButtonImage(3, backImg)
    deck:setButtonImage(4, upArrowImg)
    deck:setButtonImage(8, leftArrowImg)
    deck:setButtonImage(10, rightArrowImg)
    deck:setButtonImage(14, downArrowImg)

    if state.audio then
      deck:setButtonImage(11, muteImg)
    else
      deck:setButtonImage(11, unmuteImg)
    end

    if state.video then
      deck:setButtonImage(12, startVideoImg)
    else
      deck:setButtonImage(12, stopVideoImg)
    end

    -- deck:setButtonColor(11, { ["red"] = 1.000, ["green"] = 1.000, ["blue"] = 0.000, ["alpha"] = 1 })
    -- deck:setButtonColor(12, drawing.color.green)
    deck:setButtonColor(13, drawing.color.blue)
    -- deck:setButtonColor(14, { ["red"] = 0.500, ["green"] = 0.000, ["blue"] = 1.000, ["alpha"] = 1 })
    deck:setButtonColor(15, { ["red"] = 1.000, ["green"] = 0.000, ["blue"] = 1.000, ["alpha"] = 1 })
  else
    deck:setBrightness(0)
    log.i('nope we not be active')
    deck:setButtonColor(1, drawing.color.black)
  end
end

log.i('starting streamdeck stuff')
streamdeck.init(function(connected, deck)
  if connected then
    state.deck = deck
  else
    state.deck = nil
  end

  deck:buttonCallback(function(data, button, pressed)
    if pressed then
      if button == 11 then
        state.audio = not state.audio
        refresh()
      elseif button == 12 then
        state.video = not state.video
        refresh()
      end
    end
  end)

  refresh()
end)

local watcher = caffeinate.watcher.new(function(eventType)
  if eventType == caffeinate.watcher.screensDidLock then
    log.i('screens did lock!')
    state.active = false
  elseif eventType == caffeinate.watcher.screensDidUnlock then
    log.i('screens did UNLOCK!')
    state.active = true
  end
  refresh()
end)

watcher:start()
