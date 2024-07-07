local canvas = require('hs.canvas')
local styledtext = require('hs.styledtext')

local volImage = canvas.new { x = 0, y = 0, h = 72, w = 72 }
volImage[1] = {
    action = "fill",
    fillColor = { red = 0, green = 0, black = 0 },
    frame = { x = 0, y = 0, w = 72, h = 72 },
    type = "rectangle"
}

local function image(vol, muted)
    local c
    if muted then
        c = 0.5
    else
        c = 1.0
    end

    volImage[2] = {
        frame = { x = 0, y = 24, w = 72, h = 72 },
        text = styledtext.new(tostring(vol), {
            font = { name = ".AppleSystemUIFont", size = 18 },
            color = { red = c, green = c, blue = c },
            paragraphStyle = { alignment = "center" }
        }),
        type = "text"
    }
    return volImage:imageFromCanvas()
end

return { image = image }
