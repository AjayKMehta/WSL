local load_config = require("utils").load_config

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
                config = function()
                    local excluded_ftypes = require("utils").excluded_ftypes
                    require("guess-indent").setup({
                        filetype_exclude = excluded_ftypes,
                        buftype_exclude = {
                            "FTerm",
                            "git",
                            "help",
                            "nofile",
                            "nowrite",
                            "nvcheatsheet",
                            "Outline",
                            "prompt",
                            "quickfix",
                            "terminal",
                            "VoltWindow",
                        },
                    })
                end,
            },
        },
    },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            -- ChromaBuffer provides the color highlights you can use for configuring bufferline.
            "mei28/chromabuffer",
        },
        config = load_config("bufferline"),
    },
    {
        -- Lets you change the color of the original devicons to any color you like.
        "dgox16/devicon-colorscheme.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
            build = "make",
        },
        config = load_config("dropbar"),
    },
    {
        "kevinhwang91/nvim-ufo",
        event = "BufRead",
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
            { "<leader>mtg", "<cmd>Neominimap toggle<cr>", desc = "Toggle global minimap" },
            { "<leader>mrg", "<cmd>Neominimap refresh<cr>", desc = "Refresh global minimap" },

            -- Window-Specific Minimap Controls
            { "<leader>mtw", "<cmd>Neominimap winToggle<cr>", desc = "Toggle minimap for current window" },
            { "<leader>mrw", "<cmd>Neominimap winRefresh<cr>", desc = "Refresh minimap for current window" },

            -- Tab-Specific Minimap Controls
            { "<leader>mtt", "<cmd>Neominimap tabToggle<cr>", desc = "Toggle minimap for current tab" },
            { "<leader>mrt", "<cmd>Neominimap tabRefresh<cr>", desc = "Refresh minimap for current tab" },

            -- Buffer-Specific Minimap Controls
            { "<leader>mtb", "<cmd>Neominimap bufToggle<cr>", desc = "Toggle minimap for current buffer" },
            { "<leader>mrb", "<cmd>Neominimap bufRefresh<cr>", desc = "Refresh minimap for current buffer" },

            -- Focus
            { "<leader>mtf", "<cmd>Neominimap toggleFocus<cr>", desc = "Toggle focus on minimap" },
        },
        init = function()
            vim.g.neominimap = {
                -- Enable the plugin by default
                auto_enable = false,
                minimap_width = 12,

                -- Log level
                log_level = vim.log.levels.WARN,

                -- Notification level
                notification_level = vim.log.levels.INFO,

                -- Path to the log file
                log_path = vim.fn.stdpath("data") .. "/neominimap.log",

                -- Minimap will not be created for buffers of these types
                exclude_filetypes = {
                    "",
                    "bigfile",
                    "checkhealth",
                    "codecompanion",
                    "help",
                    "mason",
                    "startuptime",
                    "toggleterm",
                },

                -- Minimap will not be created for buffers of these types
                exclude_buftypes = {
                    "FTerm",
                    "git",
                    "help",
                    "nofile",
                    "nowrite",
                    "nvcheatsheet",
                    "Outline",
                    "prompt",
                    "quickfix",
                    "terminal",
                    "VoltWindow",
                },
                mark = {
                    enabled = true,
                },

                buf_filter = function(bufnr)
                    return vim.bo[bufnr].filetype ~= "bigfile"
                end,
            }
        end,
    },
    {
        "stevearc/stickybuf.nvim",
        opts = {},
    },
}
