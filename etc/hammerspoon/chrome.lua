local chrome = {}

local log = hs.logger.new("chrome", "info")
local __dir__ = debug.getinfo(1).source:match("@?(.*/)")


local function dirname(str)
  if str:sub(-1) == "/" then
    str = str:sub(1, str:len() - 1)
  end
    return str:gsub("(.*)/(.*)", "%1")
end

local chromeTabsFile = os.getenv("HOME") .. "/.config/chrome-tabs"
local whichChromeProfile = dirname(dirname(__dir__)) .. "/libexec/which-chrome-profile"

---Returns the path of the Chrome profile corresponding to the specified number.
---
---@param name string
---@return string?
function chrome.profile(name)
  local cmd = whichChromeProfile .. ' ' .. ('%q'):format(name)
  log.i(cmd)

  local f = io.popen(cmd)
  for line in f:lines() do
    log.i(line)
    return line
  end

  log.w("Nothing came back!")
  return nil
end

function chrome.launchProfileNumbered(number)
  log.i("Launching Chrome profile numbered: "..tostring(number))
  local profile = chrome.profileNumbered(number)
  if profile ~= nil then
    local cmd = "\"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome\" --profile-directory=\""..profile.."\""
    log.i("Running: "..cmd)
    hs.execute(cmd)
  end
end

function chrome.profileNumbered(number)
  local name = chrome.numberToName(number)
  if name ~= nil then
    local p = chrome.profile(name)
    if p ~= nil then
      log.i("Profile "..tostring(number).." is: "..p)
      return p
    else
      log.w("Could not find a profile named "..name)
    end
  end
  log.w("Could not find a profile numbered "..tostring(number))
  return nil
end

function chrome.numberToName(number)
  local f = io.open(chromeTabsFile)
  for line in f:lines() do
    local idx, _ = line:find(tostring(number) .. ':')
    if idx == 1 then
      return line:sub(3)
    end
  end
  log:w("No Chrome profile numbered "..tostring(number))
end

return chrome