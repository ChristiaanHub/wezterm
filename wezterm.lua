local wezterm = require("wezterm")
local mux = wezterm.mux
wezterm.log_info("The config was reloaded for this window!")

local function mergeTables(t1, t2)
	for key, value in pairs(t2) do
		t1[key] = value
	end
end

local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local config = {
	default_workspace = "C:/Users/User/",
	font = require("font").font,
	default_prog = { "pwsh.exe" },
	font_rules = require("font").font_rules,

	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	hide_tab_bar_if_only_one_tab = true,
	hide_mouse_cursor_when_typing = false,
	inactive_pane_hsb = {
		brightness = 0.9,
	},
	scrollback_lines = 5000,
	audible_bell = "Disabled",
	enable_scroll_bar = true,

	status_update_interval = 1000,
	xcursor_theme = "Adwaita", -- fix cursor bug on gnome + wayland
}

local dimmer = { brightness = 0.8 }

config.background = {
	-- This is the deepest/back-most layer. It will be rendered first
	{
		source = {
			File = "C:/users/user/.config/wezterm/bk.png",
		},
		repeat_x = "NoRepeat",
		hsb = dimmer,
		attachment = "Fixed",
	},
}

config.window_decorations = "RESIZE"

-- You might want to update this a bit
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = require("keybinds")
config.mouse_bindings = require("mousebinds")

config.color_scheme = "Adventure"

local resurrect = require("plugins.resurrect.plugin")
-- Enable this to save every 15 minutes or so...
-- resurrect.periodic_save()
resurrect.save_state_dir = "C:/Users/User/weztermState/"
-- resurrect.set_encryption({
-- 	enable = true,
-- 	private_key = wezterm.home_dir .. "/.age/resurrect.txt",
-- 	public_key = "age1ddyj7qftw3z5ty84gyns25m0yc92e2amm3xur3udwh2262pa5afqe3elg7",
-- })

local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.apply_to_config(config)
workspace_switcher.workspace_formatter = function(label)
	return wezterm.format({
		{ Attribute = { Italic = true } },
		{ Foreground = { Color = colors.colors.ansi[3] } },
		{ Background = { Color = colors.colors.background } },
		{ Text = "󱂬 : " .. label },
	})
end

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
	window:gui_window():set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = colors.colors.ansi[5] } },
		{ Text = basename(path) .. "  " },
	}))
	local workspace_state = resurrect.workspace_state

	workspace_state.restore_workspace(resurrect.load_state(label, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, path, label)
	window:gui_window():set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = colors.colors.ansi[5] } },
		{ Text = basename(path) .. "  " },
	}))
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
	local workspace_state = resurrect.workspace_state
	resurrect.save_state(workspace_state.get_workspace_state())
end)

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "CTRL",
		resize = "ALT",
	},
})

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = " "
	end

	local index = ""
	if #tabs > 1 then
		index = string.format("(%d/%d) ", tab.tab_index + 1, #tabs)
	end

	return zoomed .. index .. tab.active_pane.title
end)

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

tabline.setup({
	options = {
		icons_enabled = true,
		theme = "Cyberdyne",
		tabs_enabled = true,
		theme_overrides = {},
		section_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
		component_separators = {
			left = wezterm.nerdfonts.pl_left_soft_divider,
			right = wezterm.nerdfonts.pl_right_soft_divider,
		},
		tab_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
	},
	sections = {
		tabline_a = { "mode" },
		tabline_b = { "workspace" },
		tabline_c = { " " },
		tab_active = {
			"index",
			{ "parent", padding = 0 },
			"/",
			{ "cwd", padding = { left = 0, right = 1 } },
			{ "zoomed", padding = 0 },
		},
		tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
		tabline_x = { "ram", "cpu" },
		tabline_y = { "datetime", "battery" },
		tabline_z = { "domain" },
	},
	extensions = { "resurrect" },
})

tabline.apply_to_config(config)

return config
