local overrides = require("configs.overrides")

local load_config = require("utils").load_config

return {
    {
        -- A framework for running functions on Tree-sitter nodes, and updating the buffer with the result.
        "ckolkey/ts-node-action",
        dependencies = { "nvim-treesitter" },
        opts = {},
    },
    {
        -- Enhanced folds
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
        event = "BufRead",
        config = load_config("ufo"),
    },
    {
        -- Navigate your code with search labels, enhanced character motions, and Treesitter integration.
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = { modes = { search = { enabled = true } } },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = overrides.treesitter,
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
            "RRethy/nvim-treesitter-textsubjects",
        },
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "syntax")
            dofile(vim.g.base46_cache .. "treesitter")
            require("nvim-treesitter.configs").setup(opts)
            require("nvim-treesitter.install").compilers = { "clang" }
        end,
    },
    {
        -- Show code context.,
        "nvim-treesitter/nvim-treesitter-context",
        lazy = false,
        event = "BufReadPost",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            max_lines = 3,
            min_window_height = 0,
            patterns = {
                default = {
                    "class",
                    "function",
                    "method",
                },
            },
        },
    },
    {
        -- Syntax aware text-objects, select, move, swap, and peek support.
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {
            -- "nvim-treesitter/nvim-treesitter",
        },
        config = load_config("ts_textobjects"),
    },
    {
        -- Helps you navigate and move nodes around based on Treesitter API.
        "ziontee113/syntax-tree-surfer",
        event = "BufRead",
        config = load_config("syntax_tree_surfer"),
    },
    {
        -- Rainbow delimiters with Treesitter
        "HiPhish/rainbow-delimiters.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = { "BufReadPost", "BufNewFile" },
        config = load_config("rainbow"),
    },
}
