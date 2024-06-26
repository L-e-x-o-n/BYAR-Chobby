function widget:GetInfo()
	return {
		name    = 'Keys Panel',
		desc    = 'Shows static pictures of key bindings.',
		author  = 'Fireball',
		date    = '2023-03-16',
		license = 'GNU GPL v2',
		layer   = 0,
		enabled = true,
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Local Variables

local keysWindow

local images = {}
images[1] = LUA_DIRNAME .. "images/keybinds/grid_keys.png"
images[2] = LUA_DIRNAME .. "images/keybinds/grid_keys_CTRL.png"
images[3] = LUA_DIRNAME .. "images/keybinds/grid_keys_ALT.png"
images[4] = LUA_DIRNAME .. "images/keybinds/legacy_keys.png"
images[5] = LUA_DIRNAME .. "images/keybinds/legacy_keys_CTRL.png"
images[6] = LUA_DIRNAME .. "images/keybinds/legacy_keys_ALT.png"

local imgCaptions = {}
imgCaptions[1] = "Keys"
imgCaptions[2] = "CTRL Keys"
imgCaptions[3] = "ALT Keys"
imgCaptions[4] = "Legacy Keys"
imgCaptions[5] = "Legacy CTRL Keys"
imgCaptions[6] = "Legacy ALT Keys"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Utilities
local function ShowImg(image)
	keysWindow.SetImage(image)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Controls

local function InitializeControls()
	local Configuration = WG.Chobby.Configuration
	local ww, wh = Spring.GetWindowGeometry()

	local keysWindow = Window:New {
		classname = "main_window",
		parent = WG.Chobby.lobbyInterfaceHolder,
		width = ww - 100,
		height = wh - 100,
		resizable = false,
		draggable = false,
		padding = {0, 0, 0, 0},
	}

	local function CloseFunc()
		keysWindow:Hide()
	end

	-------------------------
	-- Buttons
	-------------------------

	local offsetX = 20
	local imgBtns = {}

	local buttonsHolder = Control:New {
		x = 0,
		y = 0,
		right = 100,
		bottom = 0,
		name = "buttonsHolder",
		parent = keysWindow,
		padding = {0, 0, 0, 0},
		children = {}
    }

	for i, img in ipairs(images) do
		imgBtns[imgCaptions[i]] = Button:New {
			x = offsetX,
			y = 13,
			width = 180,
			height = 35,
			caption = imgCaptions[i],
			objectOverrideFont = WG.Chobby.Configuration:GetFont(2),
			classname = "negative_button",
			parent = buttonsHolder,
			backgroundColor = {0.8, 0.8, 1, 0.4},
			OnClick = {
				function()
					ShowImg(img)
				end
			},
		}
		offsetX = offsetX + 180
	end

	local btnClose = Button:New {
		right = 18,
		y = 13,
		width = 80,
		height = 35,
		caption = i18n("close"),
		objectOverrideFont = WG.Chobby.Configuration:GetFont(2),
		classname = "negative_button",
		parent = keysWindow,
		OnClick = {
			function()
				CloseFunc()
			end
		},
	}

	-------------------------
	-- Key Binding Image
	-------------------------

	local buttonsHeight = 13+35
	local imKeys = Image:New {
		x = 1,
		y = buttonsHeight+3,
		name = "imKeys",
		width = ww - 120,
		height = wh - 120,
		parent = keysWindow,
		keepAspect = true,
		file = images[1],
	}

	WG.Chobby.lobbyInterfaceHolder.OnResize = WG.Chobby.lobbyInterfaceHolder.OnResize or {}
	WG.Chobby.lobbyInterfaceHolder.OnResize[#WG.Chobby.lobbyInterfaceHolder.OnResize +1] = function()
		local ww, wh = Spring.GetWindowGeometry()

		local neww = ww - 100
		local newx = (ww - neww) / 2

		local newh = wh - 100
		local newy = (wh - newh) / 2

		keysWindow:SetPos(
			newx,
			newy,
			neww,
			newh
		)

		local neww = ww - 120
		local newx = (WG.Chobby.lobbyInterfaceHolder.width - ww) / 2

		local newh = wh - 120
		local newy = (WG.Chobby.lobbyInterfaceHolder.height - wh) / 2

		imKeys:SetPos(
			newx,
			newy,
			neww,
			newh
		)
	end

	-------------------------
	-- External Funcs
	-------------------------

	local externalFunctions = {}
	-- 
	function externalFunctions.Show()
		if not keysWindow.visible then
			keysWindow:Show()
		end
		WG.Chobby.PriorityPopup(keysWindow, CloseFunc)
	end

	function externalFunctions.SetImage(image)
		imKeys.file = image
		imKeys:Invalidate()
	end

	function externalFunctions.Dispose()
		keysWindow:Dispose()
	end

	return externalFunctions
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- External Interface

local KeysPanel = {}

function KeysPanel.Show()
	if not keysWindow then
		keysWindow = InitializeControls()
	end
	keysWindow.Show()
end

function KeysPanel.Preload()
	if not keysWindow then
		keysWindow = InitializeControls()
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Widget Interface

function widget:Initialize()
	CHOBBY_DIR = LUA_DIRNAME .. "widgets/chobby/"
	VFS.Include(LUA_DIRNAME .. "widgets/chobby/headers/exports.lua", nil, VFS.RAW_FIRST)
	WG.KeysPanel = KeysPanel
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
