local load_config = require("utils").load_config

return {
    {
        -- Garbage collector that stops inactive LSP clients to free RAM.
        "zeioth/garbage-day.nvim",
        event = "VeryLazy",
    },
    {
        "icholy/lsplinks.nvim",
        config = function()
            local lsplinks = require("lsplinks")
            lsplinks.setup()
            vim.keymap.set("n", "gx", lsplinks.gx)
        end,
    },
    -- Otter.nvim provides lsp features and a code completion source for code embedded in other documents!
    {
        "jmbuhr/otter.nvim",
        ft = { "r", "rmd", "quarto" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {},
    },
}
