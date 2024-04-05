return {
    {
        "MattesGroeger/vim-bookmarks",
        cmd = {
            "BookmarkToggle",
            "BookmarkClear",
            "BookmarkClearAll",
            "BookmarkNext",
            "BookmarkPrev",
            "BookmarkShowALl",
            "BookmarkAnnotate",
            "BookmarkSave",
            "BookmarkLoad",
        },
    }, -- https://github.com/tinyCatzilla/dots/blob/193cc61951579db692e9cc7f8f278ed33c8b52d4/.config/nvim/lua/custom/plugins.lua
    {
        -- Configurable, notification manager
        "rcarriga/nvim-notify",
        lazy = false,
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss notifications.",
            },
        },
        opts = {
            timeout = 3000,
            render = "wrapped-compact",
            stages = "slide",
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
        config = function(_, opts)
            -- https://github.com/rcarriga/nvim-notify/wiki/Usage-Recipes#output-of-command
            local notify = require("notify")
            notify.setup(opts)
            -- vim.notify = notify
        end,
    },
    -- lazy.nvim
    {
        "folke/noice.nvim",
        enabled = true,
        event = "VeryLazy",
        opts = {
            cmdline = {
                format = {
                    cmdline = {
                        title = "",
                        icon = "",
                    },
                    lua = {
                        title = "",
                        icon = " 󰢱 ",
                    },
                    help = {
                        title = "",
                        icon = " 󰋖 ",
                    },
                    input = {
                        title = "",
                        icon = "❓",
                    },
                    filter = {
                        title = "",
                        icon = "  ",
                    },
                    search_up = {
                        icon = "    ",
                        view = "cmdline",
                    },
                    search_down = {
                        icon = "    ",
                        view = "cmdline",
                    },
                },
                opts = {
                    win_options = {
                        winhighlight = {
                            -- Normal = "NormalFloat",
                            FloatBorder = "FloatBorder",
                        },
                    },
                },
            },
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
                hover = {
                    enabled = true,
                    -- Do not show a message if hover is not available
                    silent = true,
                },
                signature = {
                    enabled = true,
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                lsp_doc_border = true, -- add a border to hover docs and signature help
            },
            popupmenu = {
                -- Doesn't work with cmp.
                enabled = true,
                ---@type 'nui'|'cmp'
                backend = "nui", -- backend for regular cmdline completions
            },
            routes = {
                {
                    filter = { event = "notify", find = "No information available" },
                    opts = { skip = true },
                },
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            --   `nvim-notify` is only needed, if you want to use the notification view.
            "rcarriga/nvim-notify",
        },
    },
    {
        -- Better quickfix window
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        cmds = { "BqfEnable", "BqfDisable", "BqfToggle" },
        opts = {
            auto_enable = true,
            auto_resize_height = true,
            func_map = {
                open = "<cr>",
                openc = "o",
                drop = "O",
                vsplit = "v",
                split = "s",
                tab = "t",
                tabc = "T",
                stoggledown = "<Tab>",
                stoggleup = "<S-Tab>",
                stogglevm = "<Tab>",
                sclear = "z<Tab>",
                pscrollup = "<C-u>",
                pscrolldown = "<C-d>",
                fzffilter = "zf",
                ptogglemode = "zp",
                filter = "zn",
                filterr = "zr",
            },
        },
        dependencies = {
            "junegunn/fzf",
            build = function()
                vim.fn["fzf#install"]()
            end,
        },
    },
}
