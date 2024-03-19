---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("highlights")

M.ui = {
	theme = "rosepine",
	theme_toggle = {
		"rosepine",
		"rosepine",
		"rosepine",
		"catppuccin",
		"github_light",
		"night_owl",
		"tomorrow_night",
		"yoru",
	},

	hl_override = highlights.override,
	hl_add = highlights.add,
	transparency = false,
}

-- M.plugins = "plugins"

-- check core.mappings for table structure
-- M.mappings = require("mappings")

return M
