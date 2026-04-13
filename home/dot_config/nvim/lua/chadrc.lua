-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua
---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("highlights")

M.base46 = {
    theme = "carbonfox",
    theme_toggle = {
        "tokyonight",
        "carbonfox",
        "night_owl",
        "tomorrow_night",
        "yoru",
    },
    integrations = {
        "blink",
        "bufferline",
        "cmp",
        "dap",
        "defaults",
        "devicons",
        "diffview",
        "flash",
        "git",
        "grug_far",
        "lsp",
        "mason",
        "notify",
        "nvcheatsheet",
        "nvimtree",
        "rainbowdelimiters",
        "render-markdown",
        "semantic_tokens",
        "statusline",
        "syntax",
        "telescope",
        "treesitter",
        "trouble",
        "whichkey",
    },

    hl_override = highlights.override,
    hl_add = highlights.add,
    transparency = false,
}

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

M.ui = {
    tabufline = {
        enabled = false,
    },
    statusline = {
        enabled = false,
    },
}

return M
