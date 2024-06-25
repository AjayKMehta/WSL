local load_config = require("utils").load_config

return {
    {
        -- Pretty hover messages.
        "Fildo7525/pretty_hover",
        -- Noice takes care of this now
        enabled = false,
        event = "LspAttach",
        init = function()
            local map_desc = require("utils.mappings").map_desc
            map_desc("n", "<leader>ko", function()
                require("pretty_hover").hover()
            end, "Hover Open")
            map_desc("n", "<leader>kq", function()
                require("pretty_hover").close()
            end, "Hover Close")
        end,
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
        main = "ibl",
    },
    {
        -- Use this instead of indent-blankline
        "shellRaining/hlchunk.nvim",
        enabled = true,
        event = { "BufReadPre", "BufNewFile" },
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
    {
        -- Lets you change the color of the original devicons to any color you like.
        "dgox16/devicon-colorscheme.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        -- Adds horizontal highlights for text filetypes, like markdown, orgmode, and neorg
        "lukas-reineke/headlines.nvim",
        ft = { "markdown", "norg", "org", "rmd" },
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
        -- Not specifying config because defaults are great.
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
        -- Setting these in config was not working 😦
        init = function()
            vim.opt.fillchars = {
                fold = " ",
                foldopen = "",
                foldsep = " ",
                foldclose = "",
                stl = " ",
                eob = " ",
            }
            vim.o.foldcolumn = "1"
            vim.o.foldenable = true -- enable fold for nvim-ufo
            vim.o.foldlevel = 99 -- set high foldlevel for nvim-ufo
            vim.o.foldlevelstart = 99 -- start with all code unfolded
        end,
        config = load_config("ufo"),
    },
    {
        -- Colorize text with ANSI escape sequences
        "m00qek/baleia.nvim",
        lazy = true,
        tag = "v1.4.0",
    },
}
