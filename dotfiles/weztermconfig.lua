-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
   config = wezterm.config_builder()
end

config.color_scheme = 'DoomOne'
config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 19.0

config.window_close_confirmation = 'NeverPrompt'

config.front_end = "WebGpu"

-- and finally, return the configuration to wezterm
return config
