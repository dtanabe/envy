local chrome = require('chrome')
local safari = require('safari')
local a = require('hs.application')

local log = hs.logger.new('ola', 'info')

-- ola: short for "open or launch application".
local ola = {}
ola.fn = function(appName)
  return function()
    hs.application.launchOrFocus(appName)
    local app = a.find(appName)
    if app ~= nil then
      for win in app:allWindows() do
        win.activate()
      end
    end
  end
end

ola.chromeProfileFn = function(number)
  return function()
    chrome.launchProfileNumbered(number)
  end
end

ola.safariNewWindowFn = function()
  return function()
    safari.newWindow()
  end
end

ola.safariNewPrivateWindowFn = function()
  return function()
    safari.newPrivateWindow()
  end
end

ola.profileFn = function()
  return function()
    hs.execute("/usr/local/bin/code " .. os.getenv("HOME") .. "/Repositories/pb-envy")
  end
end

ola.hammerspoonConsoleFn = function()
  return function()
    hs.openConsole()
  end
end

return ola
