local overrides = require("configs.overrides")
local load_config = require("utils").load_config

return {
    -- It's important that you set up the plugins in the following order:

    -- mason.nvim
    -- mason-lspconfig.nvim
    -- Setup servers via lspconfig
    {
        "williamboman/mason.nvim",
        -- https://github.com/williamboman/nvim-lsp-installer/discussions/509#discussioncomment-4009039
        opts = {
            PATH = "prepend", -- "skip" seems to cause the spawning error
        },
        -- Use config from NvChad
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- You can also add plugins you always want to have loaded.
                -- Useful if the plugin has globals or types you want to use
                -- Library paths can be absolute
                -- Or relative, which means they will be resolved from the plugin dir.
                "lazy.nvim",
                -- It can also be a table with trigger words / mods
                -- Only load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                -- always load the LazyVim library
                "LazyVim",
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            -- https://mason-registry.dev/registry/list
            ensure_installed = {
                -- lua stuff
                "lua_ls",

                -- web dev
                "cssls",
                "html",
                "tsserver",
                "denols",
                "jsonls",
                "jqls",

                -- docker
                "docker_compose_language_service",
                "dockerls",

                -- Python
                "basedpyright",
                "ruff",
                "pylyzer",

                --Haskell
                "hls",

                -- .NET
                "csharp_ls",
                "omnisharp",
                "powershell_es",

                -- DevOps + Shell
                "bashls",
                "yamlls",
                -- required for bash LSP
                "codeqlls",

                -- R
                "r_language_server",

                -- SQL
                "sqls",

                -- Misc
                "ast_grep",
                "vimls",

                -- Markdown
                "marksman",

                -- LaTeX
                "texlab",

                -- XML
                "lemminx",
            },
            automatic_installation = true,
        },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)
        end,
    },
    {
        -- Quickstart configs for Neovim LSP.
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason-lspconfig.nvim" },
            {
                "b0o/SchemaStore.nvim",
                version = false, -- last release is way too old
            },
        },
        config = function()
            require("configs.lspconfig")
        end,
    },
    {
        "mrjones2014/legendary.nvim",
        -- since legendary.nvim handles all your keymaps/commands,
        -- its recommended to load legendary.nvim before other plugins
        priority = 10000,
        lazy = false,
        config = function()
            require("legendary").setup({
                extensions = {
                    nvim_tree = true,
                    -- automatically load keymaps from lazy.nvim's `keys` option
                    lazy_nvim = true,
                    diffview = true,
                    which_key = {
                        -- Automatically add which-key tables to legendary
                        -- see ./doc/WHICH_KEY.md for more details
                        auto_register = true,
                    },
                },
            })
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        opts = overrides.nvimtree,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "nvimtree")
            require("configs.nvimtree")
            require("nvim-tree").setup(opts)
        end,
    },
    {
        -- Plugin to easily manage multiple terminal windows.
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm", "ToggleTermAll", "TermExec" },
        config = load_config("toggleterm"),
    },
}
