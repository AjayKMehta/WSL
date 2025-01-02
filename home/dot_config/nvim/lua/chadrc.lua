-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

local M = {}

-- Path to overriding theme and highlights files
local highlights = require("highlights")

M.base46 = {
    theme = "chadracula-evondev",
    theme_toggle = {
        "tokyodark",
        "monekai",
        "night_owl",
        "tomorrow_night",
        "yoru",
    },
    integrations = {
        "cmp",
        "defaults",
        "devicons",
        "git",
        "lsp",
        "mason",
        "nvcheatsheet",
        "nvimtree",
        "statusline",
        "syntax",
        "telescope",
        "whichkey",
        "dap",
        "treesitter",
        "rainbowdelimiters",
        "diffview",
        "trouble",
        "notify",
    },

    hl_override = highlights.override,
    hl_add = highlights.add,
    transparency = false,
}

-- https://github.com/NvChad/NvChad/issues/1656#issuecomment-2082408141
M.lsp = { signature = false }

M.colorify = {
    enabled = true,
    mode = "virtual", -- fg, bg, virtual
    virt_text = "󱓻 ",

    highlight = {
        hex = true,
        lspvars = true,
    },
}

return M
