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
        -- highlight-undo will remap the u and <C-r> keys (for undo and redo, by default) to highlight changed text after Undo / Redo operations.
        "tzachar/highlight-undo.nvim",
        opts = {
            duration = 300,
            undo = {
                hlgroup = "HighlightUndo",
                mode = "n",
                lhs = "u",
                map = "undo",
                opts = {},
            },
            redo = {
                hlgroup = "HighlightUndo",
                mode = "n",
                lhs = "<C-r>",
                map = "redo",
                opts = {},
            },
            highlight_for_count = true,
        },
        -- Real mapping defined in config
        keys = { { "u" }, { "<C-r>" } },
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
                "aerial",
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
}
