local canvas = require('hs.canvas')
local styledtext = require('hs.styledtext')

local now = os.date('*t')
local db = {}
local monthImages = {}
for m = 1, 12 do
    local monthStart = os.time { year = now.year, month = m, day = 1 }
    local monthEndDay = os.date("*t", os.time { year = now.year, month = m + 1, day = 0 }).day
    db[m] = {}
    db[m].canvas = canvas.new { x = 0, y = 0, h = 72, w = 72 }
    db[m].canvas[1] = {
        action = "fill",
        fillColor = { red = 0, green = 0, black = 0 },
        frame = { x = 0, y = 0, w = 72, h = 72 },
        type = "rectangle"
    }
    db[m].canvas[2] = {
        frame = { x = 0, y = -1, w = 72, h = 11 },
        text = styledtext.new(os.date('%B', monthStart), {
            font = { name = ".AppleSystemUIFont", size = 10 },
            color = { red = 1, green = 0.5, blue = 1 },
            paragraphStyle = { alignment = "center" }
        }),
        type = "text"
    }

    local weekday = os.date("%w", monthStart)
    for d = 1, monthEndDay do
        local cell = (d - 1 + weekday)
        local dx = cell % 7
        local dy = math.floor(cell / 7)
        local c = (dx == 0 or dx == 6) and 0.5 or 1
        db[m].canvas[2 + d] = {
            frame = { x = dx * 10 + 1, y = dy * 11 + 11, h = 10, w = 10 },
            text = styledtext.new(tostring(d), {
                font = { name = "PT Sans Narrow", size = 11 },
                color = { red = 1, green = c, blue = c },
                paragraphStyle = { alignment = "center" },
                kerning = -1,
            }),
            type = "text"
        }
    end

    monthImages[m] = db[m].canvas:imageFromCanvas()
end

return { monthImages = monthImages }
