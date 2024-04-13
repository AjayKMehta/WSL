local overrides = require("configs.overrides")

local load_config = require("utils").load_config

local haskell_ft = { "haskell", "lhaskell", "cabal", "cabalproject" }

--[[
Plugins divided into the following categories:
2. Treesitter + LSP
5. Snippets + completion
6. Telescope
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
        -- Advanced comment plugin with Treesitter support.
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        lazy = false,
        config = function(_, opts)
            local comment = require("Comment")
            -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#commentnvim
            local pre_hook = {
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            }
            comment.setup(vim.tbl_deep_extend("force", opts, pre_hook))
        end,
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                lazy = false,
                config = function()
                    -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#plugins-with-a-pre-comment-hook
                    require("ts_context_commentstring").setup({
                        enable_autocmd = false,
                    })
                    vim.g.skip_ts_context_commentstring_module = true
                end,
            },
        },
    },

    {
        -- Generate comments based on treesitter.
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = {
            enabled = true,
            snippet_engine = "luasnip",
            languages = {
                lua = {
                    template = {
                        annotation_convention = "emmylua",
                    },
                    -- TODO: Figure out how to fix.
                    cs = { template = { annotation_convention = "xmldoc" } },
                },
            },
        },
        -- Uncomment next line if you want to follow only stable versions
        version = "*",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
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

    --#region Snippets + completion

    -- h/t https://gist.github.com/ianchesal/93ba7897f81618ca79af01bc413d0713
    {
        "hrsh7th/nvim-cmp",
        opts = overrides.cmp,
        event = { "InsertEnter", "CmdlineEnter" },
        config = function(_, opts)
            require("cmp").setup(opts)
            load_config("cmp")()
        end,
        dependencies = {
            {
                -- Completion for LaTeX symbols
                "amarakon/nvim-cmp-lua-latex-symbols",
                event = "InsertEnter",
                opts = { cache = true },
                -- Necessary to avoid runtime errors
                config = function(_, opts)
                    require("cmp").setup(opts)
                end,
            },
            {
                -- Completion for fs paths (async)
                "FelipeLema/cmp-async-path",
                url = "https://codeberg.org/FelipeLema/cmp-async-path",
            },
            {
                -- nvim-cmp source for emojis
                "hrsh7th/cmp-emoji",
                event = "InsertEnter",
                enabled = function()
                    return vim.g.use_cmp_emoji
                end,
            },
            {
                -- Completion for Neovim's Lua runtime API.
                "hrsh7th/cmp-nvim-lua",
                event = "InsertEnter",
                -- Not needed bc of neodev
                enabled = false,
            },
            {
                -- Fuzzy buffer completion
                "tzachar/cmp-fuzzy-buffer",
                dependencies = { "tzachar/fuzzy.nvim" },
            },
            {
                -- nvim-cmp source for cmdline
                "hrsh7th/cmp-cmdline",
                lazy = false,
            },
            {
                -- Luasnip choice node completion source for nvim-cmp
                "L3MON4D3/cmp-luasnip-choice",
                config = function()
                    require("cmp_luasnip_choice").setup({
                        auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
                    })
                end,
            },
            { "amarakon/nvim-cmp-buffer-lines" },
            { "L3MON4D3/LuaSnip" },
            { "ray-x/cmp-treesitter" },
            { "jalvesaq/cmp-nvim-r" },
            { "rcarriga/cmp-dap" },
            {
                -- Completion plugin for git
                "petertriho/cmp-git",
                dependencies = { "nvim-lua/plenary.nvim" },
                config = load_config("cmp_git"),
            },
        },
    },
    {
        -- Snippet Engine for Neovim
        "L3MON4D3/LuaSnip",
        dependencies = {
            { "rafamadriz/friendly-snippets" },
            { "onsails/lspkind.nvim" },
        },
        event = {
            "InsertEnter",
            "CmdlineEnter",
        },
        build = "make install_jsregexp",
        config = load_config("luasnip"),
    },
    {
        "allaman/emoji.nvim",
        event = "InsertEnter",
        enabled = function()
            return not vim.g.use_cmp_emoji
        end,
        dependencies = {
            "hrsh7th/nvim-cmp",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            -- default is false
            enable_cmp_integration = true,
        },
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
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
        -- Setting these in config was not working 😦
        init = function()
            vim.opt.fillchars = {
                fold = " ",
                foldopen = "",
                foldsep = " ",
                foldclose = "",
                stl = " ",
                eob = " ",
            }
            vim.o.foldcolumn = "1"
            vim.o.foldenable = true -- enable fold for nvim-ufo
            vim.o.foldlevel = 99 -- set high foldlevel for nvim-ufo
            vim.o.foldlevelstart = 99 -- start with all code unfolded
        end,
        config = load_config("ufo"),
    },
}

return plugins
