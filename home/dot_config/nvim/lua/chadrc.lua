---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("highlights")

M.ui = {
    theme = "rosepine",
    theme_toggle = {
        "rosepine",
        "catppuccin",
        "github_light",
        "night_owl",
        "tomorrow_night",
        "yoru",
    },

    -- TODO: Figuure out if still need these settings.
    hl_override = highlights.override,
    hl_add = highlights.add,
    transparency = false,
}

return M
