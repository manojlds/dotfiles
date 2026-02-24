local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

-- Appearance
config.color_scheme = 'AdventureTime'
config.font = wezterm.font('FiraCode Nerd Font', { weight = 'Medium' })
config.font_size = 10
config.line_height = 1.1
config.cell_width = 0.9

config.initial_cols = 140
config.initial_rows = 35

config.window_padding = {
  left = 12,
  right = 12,
  top = 8,
  bottom = 8,
}

config.window_decorations = 'TITLE | RESIZE'
config.window_background_opacity = 0.97
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 500

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 40

config.colors = {
  tab_bar = {
    background = '#1a1a2e',
    active_tab = {
      bg_color = '#2d2d44',
      fg_color = '#c0caf5',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#1a1a2e',
      fg_color = '#565f89',
    },
    inactive_tab_hover = {
      bg_color = '#2d2d44',
      fg_color = '#c0caf5',
    },
    new_tab = {
      bg_color = '#1a1a2e',
      fg_color = '#565f89',
    },
    new_tab_hover = {
      bg_color = '#2d2d44',
      fg_color = '#c0caf5',
    },
  },
}

-- Custom tab title
wezterm.on('format-tab-title', function(tab, tabs, panes, conf, hover, max_width)
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end

  if #title > max_width - 4 then
    title = wezterm.truncate_right(title, max_width - 4)
  end

  return ' ' .. title .. ' '
end)

-- Status bar - show cwd and time
wezterm.on('update-right-status', function(window, pane)
  local cwd = ''
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local path = cwd_uri.file_path
    local home = os.getenv('HOME') or ''
    if path and home ~= '' and path:sub(1, #home) == home then
      path = '~' .. path:sub(#home + 1)
    end
    cwd = path or ''
  end

  local time = wezterm.strftime '%H:%M'

  window:set_right_status(wezterm.format {
    { Foreground = { Color = '#565f89' } },
    { Text = ' ' .. cwd .. '  ' .. time .. ' ' },
  })
end)

-- Kitty keyboard protocol (needed for oh-my-pi)
config.enable_kitty_keyboard = true

-- Scrollback
config.scrollback_lines = 10000

-- Leader key (Ctrl+Space)
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- Clipboard
  { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
  { key = 'C', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },

  -- Pane splitting
  { key = '\\', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },

  -- Pane navigation
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

  -- Pane resizing
  { key = 'H', mods = 'LEADER', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'J', mods = 'LEADER', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = 'K', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'L', mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 5 } },

  -- Tab management
  { key = 't', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },

  -- Misc
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'f', mods = 'LEADER', action = act.ToggleFullScreen },
  { key = 'y', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = 'Space', mods = 'LEADER', action = act.QuickSelect },
  { key = '/', mods = 'LEADER', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = 'r', mods = 'LEADER', action = act.PromptInputLine {
    description = 'Rename tab:',
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  }},
}

-- Triple-click selects command output (works with shell integration)
config.mouse_bindings = {
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = act.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
}

-- Hyperlink rules (clickable paths in terminal)
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Make file paths clickable (e.g. ./src/main.rs:10:5)
table.insert(config.hyperlink_rules, {
  regex = [[[./~][\w./\-]+(?::\d+)?(?::\d+)?]],
  format = '$0',
})

return config
