local load_config = require("utils").load_config

return {
    {
        -- Pretty hover messages.
        "Fildo7525/pretty_hover",
        -- Noice takes care of this now
        enabled = false,
        event = "LspAttach",
    },
    { "tomasiser/vim-code-dark" },
    { "samharju/synthweave.nvim" },
    {
        "nvim-lualine/lualine.nvim",
        event = "VimEnter",
        config = load_config("lualine"),
    },
    {
        -- Despite being part of NvChad, doesn't work!
        -- Tried rainbow-delimiters integration also but same story.
        "lukas-reineke/indent-blankline.nvim",
        enabled = false,
        version = "*",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        -- Use this instead of indent-blankline
        "shellRaining/hlchunk.nvim",
        enabled = true,
        event = { "UIEnter" },
        config = load_config("hlchunk"),
    },
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
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = load_config("bufferline"),
    },
    -- Adds horizontal highlights for text filetypes, like markdown, orgmode, and neorg
    {
        "lukas-reineke/headlines.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = load_config("headlines"),
    },
    {
        -- Neovim plugin to improve the default vim.ui interfaces
        "stevearc/dressing.nvim",
        lazy = false,
        config = function()
            require("dressing").setup({
                select = {
                    get_config = function(opts)
                        if opts.kind == "legendary.nvim" then
                            return {
                                telescope = {
                                    sorter = require("telescope.sorters").fuzzy_with_index_bias({}),
                                },
                            }
                        else
                            return {}
                        end
                    end,
                },
            })
        end,
    },
    {
        "Bekaboo/dropbar.nvim",
        cond = function()
            return vim.fn.has("nvim-0.10") == 1
        end,
        event = { "BufReadPost", "BufNewFile" },
        -- optional, but required for fuzzy finder support
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
        },
    },
}
