local wezterm = require("wezterm")
local act = wezterm.action
local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
local resurrect = require("plugins.resurrect.plugin")
local keys = {
	{ key = "[", mods = "CTRL|ALT", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "CTRL|ALT", action = act.ActivateTabRelative(1) },
	{
		key = "a",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter workspace name:",
			-- initial_value = "workspace",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					wezterm.log_info(line)
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
				end
			end),
		}),
	},

	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.save_state(resurrect.workspace_state.get_workspace_state())
		end),
	},
	{
		key = "W",
		mods = "LEADER",
		action = resurrect.window_state.save_window_action(),
	},
	{
		key = "t",
		mods = "LEADER",
		action = resurrect.tab_state.save_tab_action(),
	},
	{
		key = "s",
		mods = "ALT",
		description = "Saving Workspace",
		action = wezterm.action.PromptInputLine({
			description = "Save workspace:" .. wezterm.mux.get_active_workspace() .. "? (Y/N)",
			action = wezterm.action_callback(function(win, pane, line)
				if line == "Y" then
					resurrect.save_state(resurrect.workspace_state.get_workspace_state())
					resurrect.window_state.save_window_action()
				end
			end),
		}),
	},
	{
		key = "-",
		mods = "ALT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 30 },
		}),
	},
	{
		key = "_",
		mods = "ALT|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 25 },
		}),
	},
	{
		key = "z",
		mods = "CTRL|ALT",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "o",
		mods = "ALT",
		action = wezterm.action.ActivateLastTab,
	},
	{
		key = "t",
		mods = "ALT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "x",
		mods = "ALT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "p",
		mods = "ALT",
		action = act.PaneSelect({}),
	},
	{
		key = "p",
		mods = "ALT|SHIFT",
		action = act.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	{
		key = "d",
		mods = "ALT",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id)
				resurrect.delete_state(id)
			end, {
				title = "Delete State",
				description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
				fuzzy_description = "Search State to Delete: ",
				is_fuzzy = true,
			})
		end),
	},
	{
		key = "e",
		mods = "LEADER",
		action = wezterm.action.CharSelect({
			copy_on_select = true,
			copy_to = "ClipboardAndPrimarySelection",
		}),
	},
	{
		key = "b",
		mods = "ALT",
		action = wezterm.action.Multiple({
			wezterm.action_callback(function(win, pane)
				-- wezterm.mux.write_session_state("/tmp/wezterm/session_state.json")
				local workspace_switcher = wezterm.plugin.require_as_alias(
					"https://github.com/MLFlexer/smart_workspace_switcher.wezterm/",
					"some_alias"
				)

				wezterm.log_info(workspace_switcher.a)
				-- local ws = require("some_alias.plugin.init")
				-- wezterm.log_info(ws)
				wezterm.log_info(require("some_alias"))
			end),
		}),
	},
	{
		key = "v",
		mods = "ALT",
		action = wezterm.action.Multiple({
			wezterm.action_callback(function(win, pane)
				wezterm.reload_configuration()
			end),
		}),
	},
	{
		key = "m",
		mods = "ALT",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id, label)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extention
				local opts = {
					relative = true,
					restore_text = true,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				}
				if type == "workspace" then
					local state = resurrect.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = resurrect.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = resurrect.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end)
		end),
	},
	{ key = "L", mods = "CTRL|SHIFT|ALT", action = wezterm.action.ShowDebugOverlay },

	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			local tab, window = pane:move_to_new_tab()
		end),
	},
	{
		key = "N",
		mods = "LEADER | SHIFT",
		action = wezterm.action_callback(function(win, pane)
			local tab, window = pane:move_to_new_window()
		end),
	},
}

local function tab_switch_keys(key_table, modifier)
	for i = 1, 9 do
		table.insert(key_table, {
			key = tostring(i),
			mods = modifier,
			action = act.ActivateTab(i - 1),
		})
	end
	table.insert(key_table, {
		key = "0",
		mods = modifier,
		action = act.ActivateTab(9),
	})
end

tab_switch_keys(keys, "ALT")

return keys
