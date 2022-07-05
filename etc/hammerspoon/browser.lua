local urlevent = require('hs.urlevent')
local chrome = require("chrome")
local log = require("hs.logger").new('browser', 'info')

local da = {
  'daholdings.slack.com',
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
  'zoom.us',
}

local function safari(url)
  urlevent.openURLWithBundle(url, 'com.apple.safari')
end

urlevent.setDefaultHandler('http')
urlevent.setDefaultHandler('https')
urlevent.httpCallback = function(scheme, host, _, fullURL, senderPID)
  for _, k in ipairs(subdomains) do
    log.f("testing %s against %s (%s)", host, k, host:sub(- #k))

    if host:sub(- #k) == k then
      chrome.open("DA", fullURL)
      return
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
