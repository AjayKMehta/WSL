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
                -- TODO: Configure
                "basedpyright",
                "ruff_lsp",
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
                "typos_lsp",
                "ast_grep",
                "vimls",

                -- Markdown
                "marksman",

                -- LaTeX
                "ltex",
                "texlab",
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
            require("nvchad.configs.lspconfig")
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
            lazy_nvim = { auto_register = true },
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
        -- Plugin to easily manage multiple terminal windows.
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = { "ToggleTerm", "ToggleTermAll", "TermExec" },
        -- TODO: Is this needed if NvChad already has nvterm module?
        config = load_config("toggleterm"),
    },
}
