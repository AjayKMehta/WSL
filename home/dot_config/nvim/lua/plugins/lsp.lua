local load_config = require("utils").load_config

return {
    {
        -- Garbage collector that stops inactive LSP clients to free RAM.
        "zeioth/garbage-day.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        event = "VeryLazy",
    },
    {
        "adoyle-h/lsp-toggle.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        cmd = { "LspToggle" },
        opts = {
            create_cmds = true, -- Whether to create user commands
            telescope = true, -- Whether to load telescope extensions
        },
    },
    {
        -- Display LSP inlay hints at the end of the line, rather than within the line.
        "chrisgrieser/nvim-lsp-endhints",
        event = "LspAttach",
        opts = {}, -- required, even if empty
        keys = {
            {
                "<leader>lte",
                function()
                    require("lsp-endhints").toggle()
                end,
                desc = "Lsp Toggle hints at end of line.",
            },
        },
    },
}
