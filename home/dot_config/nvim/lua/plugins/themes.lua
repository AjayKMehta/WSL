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
    {
        "projekt0n/github-nvim-theme",
        name = "github-theme",
        enabled = true,
        lazy = false,
        priority = 1000,
        config = function()
            require("github-theme").setup({
                options = {
                    terminal_colors = true,
                    styles = {
                        comments = "italic",
                        keywords = "italic",
                        variables = "bold",
                        types = "italic,bold",
                    },
                },
            })
        end,
    },
    {
        "miikanissi/modus-themes.nvim",
        priority = 1000,
        opts = {
            -- Theme comes in two styles `modus_operandi` and `modus_vivendi`
            -- `auto` will automatically set style based on background set with vim.o.background
            style = "auto",
            variant = "default", -- `default`, `tinted`, `deuteranopia` or `tritanopia`
            transparent = false,
            dim_inactive = true, -- "non-current" windows are dimmed
            hide_inactive_statusline = false,
            line_nr_column_background = true, -- Distinct background colors in line number column.
            sign_column_background = true, -- Distinct background colors in sign column.
            styles = {
                -- Style to be applied to different syntax groups
                -- Value is any valid attr-list value for `:help nvim_set_hl`
                comments = { italic = true },
                keywords = { italic = true },
                functions = {},
                variables = {},
            },
        },
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
    },
}
