return {
    {
        "kylechui/nvim-surround",
        lazy = false,
        opts = { keymaps = {
            normal_cur = "yr",
            normal_cur_line = "yR",
        } },
        config = function(_, opts)
            require("nvim-surround").setup(opts)
        end,
    },
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup()
        end,
    },
    {
        -- Move lines and blocks of code
        "echasnovski/mini.move",
        version = false,
        opts = { options = { reindent_linewise = true } },
        event = "VeryLazy",
    },
    {
        "y3owk1n/undo-glow.nvim",
        event = { "VeryLazy" },
        opts = function(_, opts)
            -- How i set up the colors using catppuccin
            local has_catppuccin, catppuccin = pcall(require, "catppuccin.palettes")

            if has_catppuccin then
                local colors = catppuccin.get_palette()
                opts.undo_hl_color = { bg = colors.red, fg = colors.base }
                opts.redo_hl_color = { bg = colors.flamingo, fg = colors.base }
            else
                opts.undo_hl_color = { fg = "#DD0000" }
                opts.redo_hl_color = { fg = "#8edd6a" }
            end
        end,
        config = function(_, opts)
            local undo_glow = require("undo-glow")

            undo_glow.setup(opts)

            vim.keymap.set("n", "u", undo_glow.undo, { noremap = true, silent = true })
            -- I like to use U to redo instead
            vim.keymap.set("n", "<c-r>", undo_glow.redo, { noremap = true, silent = true })
        end,
    },
    {
        "smoka7/multicursors.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvimtools/hydra.nvim",
        },
        opts = function()
            local U = require("multicursors.utils")
            return {
                -- Uncomment if want to show in lualine instead
                -- hint_config = false,
                hint_config = {
                    float_opts = {
                        border = "none",
                    },
                    position = "bottom-right",
                },
                generate_hints = {
                    normal = true,
                    insert = true,
                    extend = true,
                    config = {
                        column_count = 1,
                    },
                },
                normal_keys = {
                    ["/"] = {
                        method = function()
                            U.call_on_selections(function(selection)
                                vim.api.nvim_win_set_cursor(0, { selection.row + 1, selection.col + 1 })
                                local line_count = selection.end_row - selection.row + 1
                                vim.cmd("normal " .. line_count .. "gcc")
                            end)
                        end,
                        opts = { desc = "comment selections" },
                    },
                },
            }
        end,
        cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
        keys = {
            {
                mode = { "n" },
                "<Leader>ms",
                "<cmd>MCstart<cr>",
                desc = "Create a selection for selected text or word under the cursor",
            },
            {
                mode = { "v" },
                "ms",
                "<cmd>MCstart<cr>",
                desc = "Create a selection for selected text or word under the cursor",
            },
        },
    },
    -- Copy data to system clipboard only when you press 'y'. 'd', 'x' will be filtered out.
    {
        "ibhagwan/smartyank.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            highlight = {
                timeout = 1000,
            },
        },
    },
    -- Respect camelCase and the like in w,e,b motions)
    {
        "chrisgrieser/nvim-spider",
        lazy = true,
        -- Use commands to make them dot-repeatable!
        keys = {
            {
                "<M-w>",
                "<cmd>lua require('spider').motion('w')<CR>",
                desc = "Spider w",
                mode = { "n", "o", "x" },
            },
            { "<M-e>", "<cmd>lua require('spider').motion('e')<CR>", desc = "Spider e", mode = { "n", "o", "x" } },
            { "<M-b>", "<cmd>lua require('spider').motion('b')<CR>", desc = "Spider b", mode = { "n", "o", "x" } },
            { "gE", "<cmd>lua require('spider').motion('ge')<CR>", desc = "Spider ge", mode = { "n", "o", "x" } },
            -- https://github.com/chrisgrieser/nvim-spider?tab=readme-ov-file#operator-pending-mode-the-case-of-cw
            { "cw", "c<cmd>lua require('spider').motion('e')<CR>", mode = "n" },
            {
                "1",
                "<cmd>lua require('spider').motion('w', { customPatterns = {'%d+'}})<CR>",
                desc = "Spider number",
                mode = "n",
            },
        },
        opts = {
            skipInsignificantPunctuation = true,
            subwordMovement = true,
            customPatterns = {},
        },
        dependencies = {
            "theHamsta/nvim_rocks",
            build = "pip3 install --user hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
            config = function()
                require("nvim_rocks").ensure_installed("luautf8")
            end,
        },
    },
    {
        "ravibrock/spellwarn.nvim",
        event = "VeryLazy",
        opts = {
            ft_config = { -- spellcheck method: "cursor", "iter", or boolean
                alpha = false,
                help = false,
                lazy = false,
                checkhealth = false,
                cabal = false,
                lspinfo = false,
                mason = false,
                python = "iter",
                markdown = true,
                ["gitsigns-blame"] = false,
            },
            ft_default = false, -- default option for unspecified filetypes
            max_file_size = nil, -- maximum file size to check in lines (nil for no limit)
            severity = { -- severity for each spelling error type (false to disable diagnostics for that type)
                spellbad = "WARN",
                spellcap = "HINT",
                spelllocal = "HINT",
                spellrare = "INFO",
            },
            prefix = "possible misspelling(s): ", -- prefix for each diagnostic message
        },
    },
    -- Assists with discovering motions
    {
        "tris203/precognition.nvim",
        enabled = true,
        event = { "BufRead", "BufNewFile" },
        cmd = { "Precognition" },
        keys = {
            {
                "<leader>pT",
                function()
                    if require("precognition").toggle() then
                        vim.notify("precognition on")
                    else
                        vim.notify("precognition off")
                    end
                end,
                { desc = "Precognition toggle" },
            },
            {
                "<leader>pp",
                "<cmd>Precognition peek<CR>",
                { desc = "Precognition peek" },
            },
        },
        opts = {
            startVisible = true,
            showBlankVirtLine = true,
            highlightColor = { link = "Comment" },
            hints = {
                Caret = { text = "^", prio = 2 },
                Dollar = { text = "$", prio = 1 },
                MatchingPair = { text = "%", prio = 5 },
                Zero = { text = "0", prio = 1 },
                w = { text = "w", prio = 10 },
                b = { text = "b", prio = 9 },
                e = { text = "e", prio = 8 },
                W = { text = "W", prio = 7 },
                B = { text = "B", prio = 6 },
                E = { text = "E", prio = 5 },
            },
            gutterHints = {
                G = { text = "G", prio = 10 },
                gg = { text = "gg", prio = 9 },
                PrevParagraph = { text = "{", prio = 8 },
                NextParagraph = { text = "}", prio = 8 },
            },
            disabled_fts = {
                "checkhealth",
                "cmp_menu",
                "flash_prompt",
                "lazy",
                "help",
                "man",
                "mason",
                "noice",
                "notify",
                "NvimTree",
                "startify",
                "oil",
                "Outline",
                "qf",
                "startuptime",
                "TelescopePrompt",
                "toggleterm",
                "dropbar_menu",
                "trouble",
            },
        },
    },
    {
        -- Navigate your code with search labels, enhanced character motions, and Treesitter integration.
        "folke/flash.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            jump = {
                autojump = true,
            },
            highlight = {
                -- show a backdrop with hl FlashBackdrop
                backdrop = true,
                -- Highlight the search matches
                matches = true,
                -- extmark priority
                priority = 5000,
                groups = {
                    match = "FlashMatch",
                    current = "FlashCurrent",
                    backdrop = "FlashBackdrop",
                    label = "FlashLabel",
                },
            },
            label = { rainbow = { enabled = true } },
            modes = {
                -- options used when flash is activated through
                -- `f`, `F`, `t`, `T`, `;` and `,` motions
                char = {
                    enabled = true,
                    multi_line = false,
                    autohide = true,
                    jump_labels = function(motion)
                        return vim.v.count == 0 and vim.fn.reg_executing() == "" and vim.fn.reg_recording() == ""
                    end,
                    keys = { "f", "F", "t", "T"; ";", "," },
                    jump = {
                        -- Don't add to search register (/)
                        register = false,
                        autojump = true,
                    },
                },
                search = {
                    -- when `true`, flash will be activated during regular search by default.
                    -- You can always toggle when searching with `require("flash").toggle()`
                    enabled = true,
                },
                treesitter = {
                    highlight = {
                        backdrop = false,
                        matches = true,
                    },
                },
            },
            prompt = {
                enabled = true,
                prefix = { { " 󰉂 ", "FlashPromptIcon" } },
            },
            search = {
                exclude = {
                    "checkhealth",
                    "cmp_menu",
                    "flash_prompt",
                    "lazy",
                    "help",
                    "man",
                    "mason",
                    "noice",
                    "notify",
                    "NvimTree",
                    "startify",
                    "oil",
                    "Outline",
                    "qf",
                    "startuptime",
                    "TelescopePrompt",
                    "toggleterm",
                    "dropbar_menu",
                    "Trouble",
                    "gitsigns-blame",
                    "VoltWindow",
                    function(win)
                        -- exclude non-focusable windows
                        return not vim.api.nvim_win_get_config(win).focusable
                    end,
                },
            },
        },
    },
    {
        "chrisgrieser/nvim-various-textobjs",
        event = "VeryLazy",
        opts = {
            keymaps = {
                useDefaults = true,
                disabledDefaults = { "ii", "ai", "aI" },
            },
        },
    },
}
