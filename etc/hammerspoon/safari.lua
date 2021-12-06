local safari = {}

local log = hs.logger.new('envysafari', 'info')

safari.newWindow = function()
  log.i('Launching new Safari window...')

  hs.applescript([[
    tell application "Safari" to activate

    delay 1

    tell application "System Events"
      keystroke "n" using {command down}
    end tell
  ]])
end

safari.newPrivateWindow = function()
  log.i('Launching new Safari private window...')

  local ok, output, err = hs.osascript.applescript([[
    tell application "Safari" to activate

    delay 0.5

    tell application "System Events"
      keystroke "n" using {shift down, command down}
    end tell
  ]])

  if not(ok) then
    log.e(output)
    log.e(err)
  end
end

return safari
