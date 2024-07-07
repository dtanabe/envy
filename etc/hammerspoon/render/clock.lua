local canvas = require('hs.canvas')
local styledtext = require('hs.styledtext')


local clockImage = canvas.new { x = 0, y = 0, h = 72, w = 72 }
clockImage[1] = {
    action = "fill",
    fillColor = { red = 0, green = 0, black = 0 },
    frame = { x = 0, y = 0, w = 72, h = 72 },
    type = "rectangle"
}

local function nowImage()
    clockImage[2] = {
        frame = { x = 0, y = 24, w = 72, h = 72 },
        text = styledtext.new(os.date("%H:%M"), {
            font = { name = ".AppleSystemUIFont", size = 18 },
            color = { red = 1, green = 1, blue = 1 },
            paragraphStyle = { alignment = "center" }
        }),
        type = "text"
    }
    clockImage[3] = {
        frame = { x = 0, y = 0, w = 72, h = 72 },
        text = styledtext.new(os.date("%A"), {
            font = { name = ".AppleSystemUIFont", size = 18 },
            color = { red = 1, green = 0.5, blue = 1 },
            paragraphStyle = { alignment = "center" }
        }),
        type = "text"
    }
    clockImage[4] = {
        frame = { x = 0, y = 48, w = 72, h = 72 },
        text = styledtext.new(os.date("%S"), {
            font = { name = ".AppleSystemUIFont", size = 18 },
            color = { red = 1, green = 0.5, blue = 1 },
            paragraphStyle = { alignment = "center" }
        }),
        type = "text"
    }
    return clockImage:imageFromCanvas()
end

local exports    = {}
exports.nowImage = nowImage
return exports
