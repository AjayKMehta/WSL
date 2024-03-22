local load_config = require("utils").load_config

return {
    { "tomasiser/vim-code-dark" },
    { "samharju/synthweave.nvim" },
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        config = load_config("lualine"),
    },
    {
        -- Despite being part of NvChad, doesn't really work.
        -- Tried rainbow-delimiters integration but no luck.
        "lukas-reineke/indent-blankline.nvim",
        enabled = false,
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "shellRaining/hlchunk.nvim",
        -- Use this instead of indent-blankline
        enabled = true,
        event = { "UIEnter" },
        config = load_config("hlchunk"),
    },
    {
        "craftzdog/solarized-osaka.nvim",
        -- Already included in NvChad.
        lazy = false,
        enabled = false,
        priority = 1000,
        opts = {},
    },
    {
        "kepano/flexoki-neovim",
        -- Already included in NvChad.
        enabled = false,
    },
    {
        "xiantang/darcula-dark.nvim",
        enabled = true,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = load_config("bufferline"),
    },
}
