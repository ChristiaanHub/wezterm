-- Pull in the wezterm API
local wezterm = require("wezterm")
local session_manager = require("session_manager")

-- This will hold the configuration.
local config = wezterm.config_builder()
local mux = wezterm.mux

-- Use PowerShell as default terminal
config.default_prog = { "pwsh.exe" }

-- Open maximized
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- Congig Terminal
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = 12
-- config.enable_tab_bar = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

-- state management
wezterm.on("save-state", function(window, pane)
	session_manager.save_state(window)
end)

wezterm.on("restore-state", function(window, pane)
	session_manager.restore_state(window)
end)

-- Hotkeys
config.keys = {
	-- Split horizontal
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Split vertical
	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{ key = "S", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("save-state") },
	{ key = "R", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("restore-state") },
	-- Bring window into focus (corrected line)
	-- {
	-- 	key = "w",
	-- 	mods = "CTRL|ALT",
	-- 	action = wezterm.action.ActivateWindow, -- Correct action usage
	-- },
}

-- Return the configuration to wezterm
return config
