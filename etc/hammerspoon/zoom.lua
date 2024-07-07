local application = require('hs.application')
local timer = require('hs.timer')
local uielemw = require('hs.uielement').watcher

local zoom = {}

local APP_NAME = "zoom.us"

---@class ZoomState
---@field app boolean whether the app is running
---@field meeting boolean whether a meeting is running
---@field audio boolean whether the mic is on
---@field video boolean whether the camera is on
---@field share boolean whether screen sharing is on

local state = {
  app = false,
  meeting = false,
  audio = false,
  video = false,
  share = false,
}

local printDebugState = function()
  hs.printf("app: %s, meeting: %s, audio: %s, video: %s, share: %s", state.app, state.meeting, state.audio, state.video,
    state.share)
end

-- a timer that periodically checks Zoom's menu items to determine
-- the current audio/video/share state
local menuPollCheck = timer.new(1, function()
  local app = application.get(APP_NAME)
  if app ~= nil then
    if app:findMenuItem({ "Meeting", "Mute Audio" }) ~= nil then
      state.audio = true
    elseif app:findMenuItem({ "Meeting", "Unmute Audio" }) ~= nil then
      state.audio = false
    end

    if app:findMenuItem({ "Meeting", "Start Video" }) ~= nil then
      state.video = false
    elseif app:findMenuItem({ "Meeting", "Stop Video" }) ~= nil then
      state.video = true
    end
  end
  printDebugState()
end)

local checkMeetingEnd = timer.delayed.new(0.2, function()
  local app = application.get(APP_NAME)
  if app ~= nil then
    if app:findMenuItem({ "Meeting", "Invite" }) == nil then
      state.meeting = false
      menuPollCheck:stop()
    end
  end
end)

local didLaunch = function(app)
  state.app = true

  app:newWatcher(function(element, event, _, _)
    local windowTitle = ""
    if element['title'] ~= nil then
      windowTitle = element:title()
    end

    if event == uielemw.windowCreated then
      if windowTitle == "Zoom Meeting" then
        menuPollCheck:start()
        state.meeting = true
        state.share = false
      elseif windowTitle:sub(1, #"zoom share") == "zoom share" then
        menuPollCheck:start()
        state.meeting = true
        state.share = true
      end
    elseif event == uielemw.titleChanged then
      if windowTitle == "Zoom Meeting" then
        menuPollCheck:start()
        state.meeting = true
        state.share = false
      end
    elseif event == uielemw.elementDestroyed then
      checkMeetingEnd:start()
    end
  end)
      :start({ uielemw.elementDestroyed, uielemw.titleChanged, uielemw.windowCreated })
end

local didExit = function(app)
  state.app = false
  menuPollCheck:stop()
  printDebugState()
end

local init = function()
  local aw = application.watcher.new(function(appName, eventType, app)
    if appName == APP_NAME then
      if eventType == application.watcher.launched then
        didLaunch(app)
      elseif eventType == application.watcher.terminated then
        didExit(app)
      end
    end
  end)

  aw:start()
end
init()

local init2 = function()
  local app = application.get(APP_NAME)
  if app ~= nil then
    didLaunch(app)
  end
end
init2()

---Set a status callback that is invoked whenever anything about Zoom changes:
---whether it's running, muted/unmuted, video change, or window sharing changes.
---
---@param fn fun(state: ZoomState)
function zoom.statusCallback(fn)
  fn(state)
end

return zoom
