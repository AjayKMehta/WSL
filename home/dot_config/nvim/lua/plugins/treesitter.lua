local load_config = require("utils").load_config

return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        cmd = {
            "TSInstall",
            "TSInstallSync",
            "TSInstallInfo",
            "TSUpdate",
            "TSUpdateSync",
            "TSUninstall",
        },
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-refactor",
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = load_config("treesitter"),
    },
    {
        -- Show code context.
        "nvim-treesitter/nvim-treesitter-context",
        lazy = false,
        event = "BufReadPost",
        cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            multiline_threshold = 10,
            min_window_height = 0,
            patterns = {
                default = {
                    "class",
                    "function",
                    "method",
                },
            },
        },
        init = function()
            vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true })
            vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true })
        end,
    },
    {
        -- Syntax aware text-objects, select, move, swap, and peek support.
        "nvim-treesitter/nvim-treesitter-textobjects",
        cmd = {
            "TSTextobjectSelect",
            "TSTextobjectSwapNext",
            "TSTextobjectSwapPrevious",
            "TSTextobjectGotoNextStart",
            "TSTextobjectGotoPreviousStart",
        },
    },
    {
        -- Rainbow delimiters with Treesitter
        "HiPhish/rainbow-delimiters.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = { "BufReadPost", "BufNewFile" },
        config = load_config("rainbow"),
    },
    {
        "aaronik/treewalker.nvim",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "Treewalker" },
        opts = {
            highlight = true, -- Whether to briefly highlight the node after jumping to it
            highlight_duration = 250, -- How long should above highlight last (in ms)
        },
    },
    {
        -- NeoVim plugin for jumping to the other end of the current Tree-sitter node using `%`
        "yorickpeterse/nvim-tree-pairs",
        config = function()
            require("tree-pairs").setup()
        end,
    },
}
