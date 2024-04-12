local load_config = require("utils").load_config

return {
    {
        -- Performant LSP progress status.
        "linrongbin16/lsp-progress.nvim",
        config = load_config("lsp_progress"),
    },
    {
        -- Garbage collector that stops inactive LSP clients to free RAM.
        "zeioth/garbage-day.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        event = "VeryLazy",
    },
    {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("lsp_lines").setup()
            require("lsp_lines").toggle()
        end,
        keys = {
            {
                "<leader>lt",
                function()
                    require("lsp_lines").toggle()
                end,
                desc = "LSP Toggle inline diagnostics",
            },
        },
    },
    {
        "adoyle-h/lsp-toggle.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        cmd = { "ToggleLSP" },
        opts = {
            create_cmds = true, -- Whether to create user commands
            telescope = true, -- Whether to load telescope extensions
        },
    },
    {
        -- Show function signature as you type.
        "ray-x/lsp_signature.nvim",
        -- Displays overload info!
        ft = { "cs", "python" },
        -- Disabling this and setting lsp.signature.enabled for Noice to true doesn't work :(
        enabled = true,
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    },
}
