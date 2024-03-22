local overrides = require("configs.overrides")

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
        opts = overrides.mason_lsp,
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
