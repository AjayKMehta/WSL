local overrides = require("configs.overrides")

local load_config = require("utils").load_config

local haskell_ft = { "haskell", "lhaskell", "cabal", "cabalproject" }

--[[
Plugins divided into the following categories:
2. Treesitter + LSP
7. Haskell
]]

---@diagnostic disable-next-line: undefined-doc-name

local plugins = {
    --#region Treesitter + LSP

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

    -- Haskell
    {
        "hasufell/ghcup.vim",
        lazy = false,
        dependencies = {
            { "rbgrouleff/bclose.vim" },
        },
    },
    -- TODO: Comment out later when switch extensions.
    {
        "neovimhaskell/haskell-vim",
        ft = haskell_ft,
        -- https://github.com/neovimhaskell/haskell-vim#configuration
        config = function()
            -- to enable highlighting of `forall`
            vim.g.haskell_enable_quantification = 1
            -- to enable highlighting of `mdo` and `rec`
            vim.g.haskell_enable_recursivedo = 1
            -- to enable highlighting of `proc`
            vim.g.haskell_enable_arrowsyntax = 1
            -- to enable highlighting of `pattern`
            vim.g.haskell_enable_pattern_synonyms = 1
            -- to enable highlighting of type roles
            vim.g.haskell_enable_typeroles = 1
            -- to enable highlighting of `static`
            vim.g.haskell_enable_static_pointers = 1
            -- to enable highlighting of backpack keywords
            vim.g.haskell_backpack = 1
        end,
    },
    {
        "mrcjkb/haskell-snippets.nvim",
        ft = haskell_ft,
        dependencies = { "L3MON4D3/LuaSnip" },
        config = function()
            local haskell_snippets = require("haskell-snippets").all

            require("luasnip").add_snippets("haskell", haskell_snippets, { key = "haskell" })
        end,
    },
    {
        "luc-tielen/telescope_hoogle",
        ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
        dependencies = {
            { "nvim-telescope/telescope.nvim" },
        },
    },

    -- Appearance
}

return plugins
