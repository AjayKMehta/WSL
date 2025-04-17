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
}
