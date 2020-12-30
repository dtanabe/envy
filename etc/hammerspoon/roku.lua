local samsungTvFilePath = os.getenv("HOME") .. "/.config/samsung-tv.addr"
local samsungTvFile = io.open(samsungTvFilePath, "r")
if samsungTvFile ~= nil then
    local samsungTvAddr = "http://" .. samsungTvFile:read() .. ":8060/"
    samsungTvFile:close()
else
    print(samsungTvFilePath .. " not found")
end

local rokuFilePathPath = os.getenv("HOME") .. "/.config/roku.ipaddr"
local rokuFile = io.open(rokuFilePathPath, "r")
if rokuFile ~= nil then
    local rokuAddr = "http://" .. rokuFile:read() .. ":8060/"
    rokuFile:close()

    local log = hs.logger.new("roku", "info")

    hs.hotkey.bind({"ctrl", "shift"}, "pad+", function()
        log.i("this is the thing: %s", "volume up")
        -- hs.http.asyncPost(rokuAddr .. "keypress/Play", nil, nil, ignore)
    end)

    hs.hotkey.bind({"ctrl", "shift"}, "pad-", function()
        log.i("this is the thing: %s", "volume down")
        -- hs.http.asyncPost(rokuAddr .. "keypress/Play", nil, nil, ignore)
    end)

    hs.hotkey.bind({"ctrl", "shift"}, "pad*", function()
        hs.http.asyncPost(rokuAddr .. "keypress/Fwd", nil, nil, ignore)
    end)

    hs.hotkey.bind({"ctrl", "shift"}, "pad/", function()
        hs.http.asyncPost(rokuAddr .. "keypress/Rev", nil, nil, ignore)
    end)

    hs.hotkey.bind({"ctrl", "shift"}, "padenter", function()
        hs.http.asyncPost(rokuAddr .. "keypress/Play", nil, nil, ignore)
    end)

    hs.hotkey.bind({"ctrl", "shift"}, "pad7", function()
        hs.http.asyncPost(rokuAddr .. "keypress/Back", nil, nil, ignore)
    end)

    hs.hotkey.bind({"ctrl", "shift"}, "pad8", function()
        hs.http.asyncPost(rokuAddr .. "keypress/Up", nil, nil, ignore)
    end)

    hs.hotkey.bind({"ctrl", "shift"}, "pad9", function()
        print("Sending HOME to " .. rokuAddr)
        hs.http.asyncPost(rokuAddr .. "keypress/Home", nil, nil, ignore)
    end)

    hs.hotkey.bind({"ctrl", "shift"}, "pad4", function()
        hs.http.asyncPost(rokuAddr .. "keypress/Left", nil, nil, ignore)
    end)

    hs.hotkey.bind({"ctrl", "shift"}, "pad5", function()
        hs.http.asyncPost(rokuAddr .. "keypress/Select", nil, nil, ignore)
    end)

    hs.hotkey.bind({"ctrl", "shift"}, "pad6", function()
        hs.http.asyncPost(rokuAddr .. "keypress/Right", nil, nil, ignore)
    end)

    hs.hotkey.bind({"ctrl", "shift"}, "pad1", function()
        hs.http.asyncPost(rokuAddr .. "keypress/InstantReplay", nil, nil, ignore)
    end)

    hs.hotkey.bind({"ctrl", "shift"}, "pad2", function()
        hs.http.asyncPost(rokuAddr .. "keypress/Down", nil, nil, ignore)
    end)

    hs.hotkey.bind({"ctrl", "shift"}, "pad3", function()
        hs.http.asyncPost(rokuAddr .. "keypress/Info", nil, nil, ignore)
    end)
else
    print(rokuFilePathPath .. " not found")
end
