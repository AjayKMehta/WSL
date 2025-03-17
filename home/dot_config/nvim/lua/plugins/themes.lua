return {
    { "tomasiser/vim-code-dark" },
    { "samharju/synthweave.nvim" },
    {
        -- Already included in NvChad.
        "craftzdog/solarized-osaka.nvim",
        lazy = false,
        enabled = false,
        priority = 1000,
        opts = {},
    },
    {
        -- Already included in NvChad.
        "kepano/flexoki-neovim",
        enabled = false,
    },
    {
        "xiantang/darcula-dark.nvim",
        enabled = true,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    { "nyoom-engineering/oxocarbon.nvim" },
    {
        -- Can also use as theme for lualine:
        -- options = { theme 'citruszest',}
        "zootedb0t/citruszest.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- For using default config leave this empty.
            require("citruszest").setup({
                option = {
                    transparent = false, -- Enable/Disable transparency
                    bold = true,
                    italic = true,
                },
                -- Override default highlight style in this table
                -- E.g If you want to override `Constant` highlight style
                style = {
                    -- This will change Constant foreground color and make it bold.
                    Constant = { fg = "#FFFFFF", bold = true },
                },
            })
        end,
    },
}
