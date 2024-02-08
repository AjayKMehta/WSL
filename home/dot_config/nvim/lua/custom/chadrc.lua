---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")

M.ui = {
	theme = "decay",
	theme_toggle = {
		"decay",
		"decay",
		"decay",
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

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
