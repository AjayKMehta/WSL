local lsp = require("utils.lsp")

return {
    {
        "PProvost/vim-ps1",
        ft = "powershell",
    },
    {
        "jalvesaq/Nvim-R",
        lazy = false,
        ft = { "r", "rmd", "quarto" },
        config = function()
            require("cmp_nvim_r").setup({})
        end,
    },
    {
        -- C# plugin powered by omnisharp-roslyn.
        "iabdelkareem/csharp.nvim",
        opts = {
            lsp = {
                -- Need to manually set up omnisharp LSP if false
                enable = false,
                -- Settings that'll be passed to the omnisharp server
                enable_editor_config_support = true,
                organize_imports = true,
                load_projects_on_demand = false,
                enable_analyzers_support = true,
                enable_import_completion = true,
                include_prerelease_sdks = true,
                analyze_open_documents_only = false,
                enable_package_auto_restore = true,
                -- If true, MSBuild project system will only load projects for files that
                -- were opened in the editor. This setting is useful for big C# codebases
                -- and allows for faster initialization of code navigation features only
                -- for projects that are relevant to code that is being edited.
                enable_ms_build_load_projects_on_demand = false,
                capabilities = lsp.capabilities,
                on_attach = lsp.on_attach,
            },
            dap = {
                adapter_name = "netcoredbg",
            },
        },
        ft = { "cs", "vb", "csproj", "sln", "slnx", "props" },
        dependencies = {
            "williamboman/mason.nvim", -- Required, automatically installs omnisharp
             "mfussenegger/nvim-dap",
            "Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
        },
        config = function(_, opts)
            require("csharp").setup(opts)
        end,
    },
}
