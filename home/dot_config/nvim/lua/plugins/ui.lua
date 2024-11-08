local load_config = require("utils").load_config

return {
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
        cmd = {
            "DisableHLChunk",
            "DisableHLIndent",
            "DisableLineNum",
            "EnableHLChunk",
            "EnableHLIndent",
            "EnableLineNum",
        },
        config = load_config("hlchunk"),
        dependencies = {
            {
                "nmac427/guess-indent.nvim",
                -- TODO: Specify options.
                config = function()
                    require("guess-indent").setup({
                        filetype_exclude = {
                            "netrw",
                            "tutor",
                            "terminal",
                            "startify",
                            "FTerm",
                            "no-profile",
                            "nvcheatsheet",
                            "crunner",
                            "dropbar_menu",
                            "Outline",
                            "git",
                            "VoltWindow",
                        },
                        buftype_exclude = {
                            "help",
                            "nofile",
                            "terminal",
                            "prompt",
                        },
                    })
                end,
            },
        },
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
    {
        "Isrothy/neominimap.nvim",
        enabled = true,
        event = { "BufReadPre", "BufNewFile" },
        keys = {
            -- Global Minimap Controls
            { "<leader>ntg", "<cmd>Neominimap toggle<cr>", desc = "Toggle global minimap" },
            { "<leader>nrg", "<cmd>Neominimap refresh<cr>", desc = "Refresh global minimap" },

            -- Window-Specific Minimap Controls
            { "<leader>ntw", "<cmd>Neominimap winToggle<cr>", desc = "Toggle minimap for current window" },
            { "<leader>nrw", "<cmd>Neominimap winRefresh<cr>", desc = "Refresh minimap for current window" },

            -- Tab-Specific Minimap Controls
            { "<leader>ntt", "<cmd>Neominimap tabToggle<cr>", desc = "Toggle minimap for current tab" },
            { "<leader>nrt", "<cmd>Neominimap tabRefresh<cr>", desc = "Refresh minimap for current tab" },

            -- Buffer-Specific Minimap Controls
            { "<leader>ntb", "<cmd>Neominimap bufToggle<cr>", desc = "Toggle minimap for current buffer" },
            { "<leader>nrb", "<cmd>Neominimap bufRefresh<cr>", desc = "Refresh minimap for current buffer" },

            -- Focus
            { "<leader>ntf", "<cmd>Neominimap toggleFocus<cr>", desc = "Toggle focus on minimap" },
        },
        init = function()
            vim.g.neominimap = {
                -- Enable the plugin by default
                auto_enable = true,
                minimap_width = 14,

                -- Log level
                log_level = vim.log.levels.WARN,

                -- Notification level
                notification_level = vim.log.levels.INFO,

                -- Path to the log file
                log_path = vim.fn.stdpath("data") .. "/neominimap.log",

                -- Minimap will not be created for buffers of these types
                exclude_filetypes = { "help", "" },

                -- Minimap will not be created for buffers of these types
                exclude_buftypes = {
                    "nofile",
                    "nowrite",
                    "quickfix",
                    "terminal",
                    "prompt",
                    "Outline",
                    "nvcheatsheet",
                    "git",
                    "VoltWindow",
                    "FTerm",
                },
                mark = {
                    enabled = true,
                },
            }
        end,
    },
}
