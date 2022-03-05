local chrome = require("chrome")

local da = {
  'circleci.com',
  'console.cloud.google.com',
  'docs.google.com',
  'discuss.daml.com',
  'figma.com',
  'github.com',
  'lucid.app',
}

local function safari(url)
  hs.urlevent.openURLWithBundle(url, 'com.apple.safari')
end


hs.urlevent.setDefaultHandler('http')
hs.urlevent.setDefaultHandler('https')
hs.urlevent.httpCallback = function(scheme, host, _, fullURL, senderPID)
  for _, k in ipairs(da) do
    if k == host then
      chrome.open("DA", fullURL)
      return
    end
  end
  safari(fullURL)
end
