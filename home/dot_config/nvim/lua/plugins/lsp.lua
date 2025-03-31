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
        config = function()
            -- default settings
            require("lsp-endhints").setup({
                icons = {
                    type = "󰜁 ",
                    parameter = "󰏪 ",
                    offspec = " ", -- hint kind not defined in official LSP spec
                    unknown = " ", -- hint kind is nil
                },
                label = {
                    truncateAtChars = 20,
                    padding = 1,
                    marginLeft = 0,
                    sameKindSeparator = ", ",
                },
                extmark = {
                    priority = 50,
                },
                autoEnableHints = true,
            })
        end,
    },
}
