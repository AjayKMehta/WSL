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
        event = { "BufEnter" },
        opts = {
            create_cmds = true, -- Whether to create user commands
        },
    },
}
