return {
    -- Press " to see registers' contents
    { "junegunn/vim-peekaboo" },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim-surround").setup({
                -- configuration here, or leave empty to use defaults
            })
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
        event = { "BufReadPre" },
    },
    {
        "smoka7/multicursors.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "smoka7/hydra.nvim",
        },
        opts = function()
            local N = require("multicursors.normal_mode")
            local I = require("multicursors.insert_mode")
            local U = require("multicursors.utils")
            return {
                -- Uncomment if want to show in lualine instead
                -- hint_config = false,
                hint_config = {
                    border = "rounded",
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
                    ["u"] = { method = N.upper_case, opts = { desc = "Upper case" } },
                    ["l"] = { method = N.lower_case, opts = { desc = "lower case" } },
                    -- https://github.com/smoka7/multicursors.nvim/issues/85
                    ["<C-z>"] = {
                        method = function()
                            vim.cmd("normal U")
                        end,
                        opts = { desc = "Undo" },
                    },
                },
            }
        end,
        cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
        keys = {
            {
                mode = { "v", "n" },
                "<Leader>ms",
                "<cmd>MCstart<cr>",
                desc = "Create a selection for selected text or word under the cursor",
            },
        },
    },
}
