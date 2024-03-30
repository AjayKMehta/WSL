local load_config = require("utils").load_config

return {
    {
        -- Show function signature as you type.
        "ray-x/lsp_signature.nvim",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    },
    {
        -- Performant LSP progress status.
        "linrongbin16/lsp-progress.nvim",
        config = load_config("lsp_progress"),
    },
    {
        -- Garbage collector that stops inactive LSP clients to free RAM.
        "zeioth/garbage-day.nvim",
        dependencies = "neovim/nvim-lspconfig",
        event = "VeryLazy",
    },
}
