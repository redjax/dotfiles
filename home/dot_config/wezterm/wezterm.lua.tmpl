-- Import wezterm
local wezterm = require 'wezterm'

-- Config object
local config = wezterm.config_builder()

-- Cross-platform home directory
local function get_home_dir()
    return os.getenv("HOME") or os.getenv("USERPROFILE") or ""
end

-- Detect platform
-- \ Example: config.font_size = is_windows and 12 or is_mac and 16 or 14
local is_linux = wezterm.target_triple:find('linux') ~= nil
local is_windows = wezterm.target_triple:find('windows') ~= nil
local is_mac = wezterm.target_triple:find('darwin') ~= nil

-- Function to detect platform
local function get_platform()
    if is_linux then
        return 'linux'
    elseif is_windows then
        return 'windows'
    elseif is_mac then
        return 'mac'
    end
end

-- Function to detect dark/light system setting
local function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Dark'
end

-- Set theme based on system appearance
-- \ https://wezterm.org/config/appearance.html#color-scheme
local function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        -- return 'OneDark (base16)'
        -- return 'Ayu Mirage (Gogh)'
        -- return 'Ayu'
        -- return 'Afterglow (Gogh)'
        -- return 'Andromeda'
        -- return 'Bamboo'
        -- return 'Breeze (Gogh)'
        -- return 'Dark Pastel (Gogh)'
        -- return 'Dark+'
        return 'Eldritch'
        -- return 'Kanagawa Dragon (Gogh)'
        -- return 'Molokai'
        -- return 'Papercolor Dark (Gogh)'
    else
        return 'One Light (base16)'
    end
end

-- Function to check if wezterm terminfo exists
local function wezterm_terminfo_exists()
    local home = get_home_dir()
    local terminfo_paths = {
        home ~= "" and (home .. "/.terminfo/w/wezterm") or nil,
        "/usr/share/terminfo/w/wezterm",
        "/lib/terminfo/w/wezterm",
        "/usr/local/share/terminfo/w/wezterm",
    }

    for _, path in ipairs(terminfo_paths) do
        if path then
            local f = io.open(path, "r")
            if f then
                f:close()
                return true
            end
        end
    end

    return false
end

-- Set color scheme dynamically
config.color_scheme = scheme_for_appearance(get_appearance())

-- Set variable with platform string
local platform = get_platform()

-- Set font fallbacks per platform
local font_fallback = {
    linux = { 'DejaVu Sans Mono', 'Liberation Mono' },
    windows = { 'Consolas', 'Courier New' },
    mac = { 'SF Mono', 'Menlo', 'Monaco' },
}

-- Set initial window geometry
config.initial_cols = 110
config.initial_rows = 25

-- Set term starting directory
config.default_cwd = wezterm.home_dir

-- Disable close window prompt
config.window_close_confirmation = "NeverPrompt"

-- Set window transparency
config.window_background_opacity = 0.95
-- Set a background image for the terminal
-- config.background = {
--   { source = { File = "/path/to/image.png" }, opacity = 0.2 }
-- }

-- Change font size
config.font_size = 12

-- Try fonts, falling back through an array of fonts to find one that works
config.font = wezterm.font_with_fallback(
    {
        'Hack Nerd Font Mono',
        'JetBrains Mono',
        'FiraCode Nerd Font Mono',
        table.unpack(font_fallback[platform] or { 'DejaVu Sans Mono' })
    }
)

-- Makes fallback fonts visually consistent
config.use_cap_height_to_scale_fallback_fonts = true

-- Set shell based on platform
if is_windows then
    config.default_prog = { 'pwsh.exe' }

    -- Wezterm will use a Unix machine's default $SHELL.
    -- You can optionally override that here.
    -- elseif is_mac then
    --   config.default_prog = {'zsh', '-l'}
    -- elseif is_linux then
    --   config.default_prog = {'bash', '-l'}
end

-- Enable advanced wezterm features if wezterm terminfo exists
if wezterm_terminfo_exists() then
    config.term = "wezterm"
else
    config.term = "xterm-256color"
end

-- Set terminal scrollback memory
config.scrollback_lines = 10000

-- Vertical spacing
config.line_height = 1.1

-- Visual for insactive tabs
config.inactive_pane_hsb = { saturation = 0.8, brightness = 0.7 }

-- Remove title bar
-- \ Default: "TITLE | RESIZE"
config.window_decorations = "TITLE | RESIZE"

-- Set tab width
config.tab_max_width = 25
-- Enable 'fancy' tab bar
config.use_fancy_tab_bar = true

-- Hide tab bar when only 1 tab is open
config.hide_tab_bar_if_only_one_tab = true

-- Set max FPS for terminal
config.max_fps = 60

-- Window padding
config.window_padding = {
    left = 4, right = 4, top = 2, bottom = 2,
}

-- Enable scrollbar
config.enable_scroll_bar = true

-- Set command palette font size
config.command_palette_font_size = 13

-- ############
-- # KEYBINDS #
-- ############
config.keys = {
    -- ALT+ENTER = split horizontal
    { key = "Enter", mods = "ALT",        action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
    -- CTRL+SHIFT+ENTER = split vertical
    { key = "Enter", mods = "CTRL|SHIFT", action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },
    -- CTRL+SHIFT+P = command palette
    {
        key = 'P',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.ActivateCommandPalette,
    },
    -- Explicitly bind Home and End keys
    { key = "Home", mods = "NONE", action = wezterm.action.SendKey({ key = "Home" }) },
    { key = "End",  mods = "NONE", action = wezterm.action.SendKey({ key = "End" }) },
}

-- ##################
-- # Mouse bindings #
-- ##################
local act = wezterm.action
config.mouse_bindings = {
    {
        -- Scroll up
        event = { Down = { streak = 1, button = { WheelUp = 1 } } },
        mods = 'NONE',
        action = act.ScrollByLine(-3),
    },
    {
        -- Scroll down
        event = { Down = { streak = 1, button = { WheelDown = 1 } } },
        mods = 'NONE',
        action = act.ScrollByLine(3),
    },
    {
        -- CTRL+LeftClick = open link
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = act.OpenLinkAtMouseCursor,
    },
    {
        -- RightClick: Copy if selection, else paste
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action_callback(function(window, pane)
            local sel = window:get_selection_text_for_pane(pane)
            if sel ~= "" then
                window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
                window:perform_action(act.ClearSelection, pane)
            else
                window:perform_action(act.PasteFrom("Clipboard"), pane)
            end
        end),
    },
}

-- ################
-- # Set ENV vars #
-- ################
config.set_environment_variables = {
    -- VAR_NAME = 'value',
}

-- Set wezterm frontend dynamically
-- \ Note: WebGPU does not support transparency on some platforms
config.front_end = is_windows and "WebGpu"
    or is_linux and "OpenGL"
    or "Auto"

-- KEEP THIS AT THE BOTTOM OF YOUR CONFIG
return config
