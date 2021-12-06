local chrome = require('chrome')
local safari = require('safari')

local log = hs.logger.new('ola', 'info')

-- ola: short for "open or launch application".
local ola = {}
ola.fn = function(appName)
  return function()
    hs.application.launchOrFocus(appName)
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

return ola
