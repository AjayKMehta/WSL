local overrides = require("configs.overrides")

local load_config = require("utils").load_config

local haskell_ft = { "haskell", "lhaskell", "cabal", "cabalproject" }

--[[
Plugins divided into the following categories:
2. Treesitter + LSP
3. Test
4. Utility
5. Snippets + completion
6. Telescope
7. Haskell
8. Editing
9. Languages
10. JSON + YAML
11. Markdown
14. git

]]

---@diagnostic disable-next-line: undefined-doc-name

local plugins = {
    --#region Treesitter + LSP

    {
        -- Pretty hover messages.
        "Fildo7525/pretty_hover",
        event = "LspAttach",
    },
    { "poljar/typos.nvim", lazy = false },

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
        -- Show function signature as you type.
        "ray-x/lsp_signature.nvim",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        opts = {},
        config = function(_, opts)
            require("lsp_signature").setup(opts)
        end,
    },
    {
        -- Performant LSP progress status.
        "linrongbin16/lsp-progress.nvim",
        config = load_config("lsp_progress"),
    },
    {
        -- Advanced comment plugin with Treesitter support.
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        lazy = false,
        config = load_config("comment"),
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
    -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
    {
        -- Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
        "folke/neodev.nvim",
    },
    {
        -- Garbage collector that stops inactive LSP clients to free RAM.
        "zeioth/garbage-day.nvim",
        dependencies = "neovim/nvim-lspconfig",
        event = "VeryLazy",
    },
    {
        -- Generate comments based on treesitter.
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = overrides.neogen,
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
        opts = overrides.treesitter_context,
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
    {
        -- Lightweight formatter plugin
        "stevearc/conform.nvim",
        enabled = true,
        cmd = { "ConformInfo" },
        event = { "BufReadPre", "BufNewFile" },
        config = load_config("conform"),
    },

    --#endregion

    {
        "CRAG666/code_runner.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = overrides.code_runner,
        event = "BufEnter",
    },
    {
        -- Better quickfix window
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        cmds = { "BqfEnable", "BqfDisable", "BqfToggle" },
        opts = {
            auto_enable = true,
            auto_resize_height = true,
            func_map = {
                open = "<cr>",
                openc = "o",
                drop = "O",
                vsplit = "v",
                split = "s",
                tab = "t",
                tabc = "T",
                stoggledown = "<Tab>",
                stoggleup = "<S-Tab>",
                stogglevm = "<Tab>",
                sclear = "z<Tab>",
                pscrollup = "<C-u>",
                pscrolldown = "<C-d>",
                fzffilter = "zf",
                ptogglemode = "zp",
                filter = "zn",
                filterr = "zr",
            },
        },
        dependencies = {
            "junegunn/fzf",
            build = function()
                vim.fn["fzf#install"]()
            end,
        },
    },

    --#endregion

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
                enabled = false,
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
        config = load_config("ls"),
    },
    {
        "allaman/emoji.nvim",
        --   ft = "markdown", -- adjust to your needs
        dependencies = {
            "hrsh7th/nvim-cmp",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            -- default is false
            enable_cmp_integration = true,
        },
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        -- if you load some function or module within your opt, wrap it with a function
        opts = function()
            local conf = require("nvchad.configs.telescope")
            conf.defaults.mappings.i = {
                ["<C-j>"] = require("telescope.actions").move_selection_next,
                ["<esc>"] = require("telescope.actions").close,
            }
            conf.extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            }
            return conf
        end,
        -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
        dependencies = {
            {
                -- Use fzf syntax in Telescope.
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
            },
            "benfowler/telescope-luasnip.nvim",
            "tom-anders/telescope-vim-bookmarks.nvim",
            "debugloop/telescope-undo.nvim",
            "nvim-telescope/telescope-frecency.nvim",
            -- "stevearc/aerial.nvim",
        },
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "telescope")
            local telescope = require("telescope")
            telescope.setup(opts)

            telescope.load_extension("fzf")
            telescope.load_extension("emoji")
            telescope.load_extension("themes")
            telescope.load_extension("terms")
            telescope.load_extension("notify")
            telescope.load_extension("luasnip")
            telescope.load_extension("undo")
            -- telescope.load_extension("aerial")
        end,
    },

    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },
    {
        "axieax/urlview.nvim",
        cmd = { "UrlView" },
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "stevearc/dressing.nvim",
        },
        opts = {
            default_title = "URLs",
            default_picker = "telescope",
            default_action = "clipboard",
            sorted = false,
            jump = {
                ["prev"] = "[u",
                ["next"] = "]u",
            },
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
        config = function()
            local ok, telescope = pcall(require, "telescope")
            if ok then
                telescope.load_extension("hoogle")
            end
        end,
    },

    -- Editing
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim-surround").setup({
                -- configuration here, or leave empty to use defaults
            })
        end,
    },
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup()
        end,
    },
    { "junegunn/vim-peekaboo" },
    {
        -- Move lines and blocks of code
        "echasnovski/mini.move",
        version = false,
        opts = { options = { reindent_linewise = true } },
        event = "VeryLazy",
    },
    {
        -- Show all todo comments in solution
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup({})
        end,
        event = "VeryLazy",
    },

    -- Markdown
    {
        "tadmccorkle/markdown.nvim",
        event = "VeryLazy",
        opts = {
            -- configuration here or empty for defaults
        },
    },
    {
        "AckslD/nvim-FeMaco.lua",
        config = function()
            require("femaco").setup()
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        -- https://github.com/iamcco/markdown-preview.nvim/issues/616#issuecomment-1774970354
        build = function()
            local job = require("plenary.job")
            local install_path = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim/app"
            local cmd = "bash"

            if vim.fn.has("win64") == 1 then
                cmd = "pwsh"
            end

            job:new({
                command = cmd,
                args = { "-c", "npm install && git restore ." },
                cwd = install_path,
                on_exit = function()
                    print("Finished installing markdown-preview.nvim")
                end,
                on_stderr = function(_, data)
                    print(data)
                end,
            }):start()
        end,
        lazy = true,
        cmd = {
            "MarkdownPreviewToggle",
            "MarkdownPreview",
            "MarkdownPreviewStop",
        },
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        keys = { { "gm", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" } },
        config = load_config("md_preview"),
    },
    {
        "antonk52/markdowny.nvim",
        ft = { "markdown" },
        config = function()
            require("markdowny").setup()
        end,
        --  Add key bindings for markdown.,

        -- <C-k>: Adds a link to visually selected text.
        -- <C-b>: Toggles visually selected text to bold.
        -- <C-i>: Toggles visually selected text to italic.
        -- <C-e>: Toggles visually selected text to inline code, and V-LINE selected text to a multiline code block.
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
