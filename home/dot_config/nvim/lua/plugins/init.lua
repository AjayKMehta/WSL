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
        },
        config = function()
            require("nvchad.configs.lspconfig")
            require("configs.lspconfig")
        end,
    },
}
