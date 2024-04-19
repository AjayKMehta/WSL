local load_config = require("utils").load_config

return {
    {
        -- Code outline sidebar powered by LSP.
        -- Differs from aerial as it uses LSP instead of treesitter.
        -- Seems more reliable than aerial.
        "hedyhli/outline.nvim",
        cmd = { "Outline", "OutlineOpen" },
        enabled = function()
            return not vim.g.use_aerial
        end,
        opts = {
            outline_window = {
                auto_jump = false,
                wrap = true,
            },
            -- Auto-open preview was annoying. `live = true` allows editing in preview window!
            preview_window = { auto_preview = false, live = true },
            symbol_folding = {
                auto_unfold = {
                    only = 2,
                },
            },
            outline_items = {
                show_symbol_lineno = false,
            },
        },
        config = function(_, opts)
            require("outline").setup(opts)
        end,
    },
    {
        -- A code outline window for skimming and quick navigation.
        "stevearc/aerial.nvim",
        lazy = true,
        cmd = { "AerialToggle", "AerialOpen", "AerialInfo" },
        enabled = function()
            return vim.g.use_aerial
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<Leader>ta", "<CMD>AerialToggle<CR>", mode = { "n" }, desc = "Toggle the aerial window" },
        },
        config = load_config("aerial"),
    },
}
