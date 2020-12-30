require("roku")

function ignore()
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Y", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  f.y = f.y - 10
  win:setFrame(f)
end)
