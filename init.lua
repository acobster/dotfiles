require 'lfs'

-- general purpose function for Growl notifications
function notify(message)
	hs.applescript('display notification "'..message..'"')
end


-- Fancy configuration reloading
function reloadConfig(files)
	doReload = false
	for _,file in pairs(files) do
	  if file:sub(-4) == ".lua" then
      doReload = true
	  end
	end
	if doReload then
	  hs.reload()
	end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
notify("Config loaded")



-- nudge window API


function nudgeFocusedWindow(pixels, axis)
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f[axis] = f[axis] + pixels
  win:setFrame(f)
end

function nudger(pixels, axis)
	return function()
		nudgeFocusedWindow(pixels, axis)
	end
end

hs.hotkey.bind({"cmd", "ctrl"}, "Left", 	nudger(-10, "x"))
hs.hotkey.bind({"cmd", "ctrl"}, "Right", 	nudger(10, "x"))
hs.hotkey.bind({"cmd", "ctrl"}, "Up", 		nudger(-10, "y"))
hs.hotkey.bind({"cmd", "ctrl"}, "Down", 	nudger(10, "y"))

hs.hotkey.bind({"cmd", "ctrl", "shift"}, "Left", 		nudger(-50, "x"))
hs.hotkey.bind({"cmd", "ctrl", "shift"}, "Right", 	nudger(50, "x"))
hs.hotkey.bind({"cmd", "ctrl", "shift"}, "Up", 			nudger(-50, "y"))

