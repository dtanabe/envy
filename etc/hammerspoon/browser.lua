local chrome = require("chrome")

local da = {
  'digitalasset1.lightning.force.com',
  'digitalasset.zoom.us',
  'discuss.daml.com',
  'figma.com',
  'github.com',
  'lucid.app',
}
local subdomains = {
  'circleci.com',
  'datadoghq.com',
  'google.com',
}

local function safari(url)
  hs.urlevent.openURLWithBundle(url, 'com.apple.safari')
end


hs.urlevent.setDefaultHandler('http')
hs.urlevent.setDefaultHandler('https')
hs.urlevent.httpCallback = function(scheme, host, _, fullURL, senderPID)
  for _, k in ipairs(subdomains) do
    if host:sub(-#k) == k then
      chrome.open("DA", fullURL)
    end
  end

  for _, k in ipairs(da) do
    if k == host then
      chrome.open("DA", fullURL)
      return
    end
  end

  safari(fullURL)
end
