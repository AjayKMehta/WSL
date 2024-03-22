local overrides = require("configs.overrides")

return {
    {
        -- Preview code with LSP code actions applied.
        "aznhe21/actions-preview.nvim",
        event = "VeryLazy",
        opts = overrides.actpreview,
    },
    {
        -- AI/search-engine powered diagnostic debugging
        "piersolenski/wtf.nvim",
        opts = {
            popup_type = "vertical",
        },
        cmd = { "WtfSearch", "Wtf" },
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },
    {
        -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
        "folke/trouble.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = { "Trouble", "TroubleToggle", "TodoTrouble" },
        config = function()
            require("trouble").setup({})
        end,
        lazy = false,
    },
}
