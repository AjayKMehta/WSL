return {
    {
        -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
        "folke/trouble.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = { "Trouble", "TroubleToggle", "TodoTrouble" },
        opts = {
            keys = {
                s = { -- example of a custom action that toggles the severity
                    action = function(view)
                        local f = view:get_filter("severity")
                        local severity = ((f and f.filter.severity or 0) + 1) % 5
                        view:filter({ severity = severity }, {
                            id = "severity",
                            template = "{hl:Title}Filter:{hl} {severity}",
                            del = severity == 0,
                        })
                    end,
                    desc = "Toggle Severity Filter",
                },
            },
            modes = {
                preview_float = {
                    mode = "diagnostics",
                    preview = {
                        type = "float",
                        relative = "editor",
                        border = "rounded",
                        title = "Preview",
                        title_pos = "center",
                        position = { 0, -2 },
                        size = { width = 0.3, height = 0.3 },
                        zindex = 200,
                    },
                    diagnostics = {
                        sort = { "severity", "pos", "filename", "message" },
                    },
                    snacks = {
                        sort = { "pos", "filename", "severity", "message" },
                    },
                    snacks_files = {
                        sort = { "pos", "filename", "severity", "message" },
                    },
                    quickfix = {
                        sort = { "pos", "filename", "severity", "message" },
                    },
                    loclist = {
                        sort = { "pos", "filename", "severity", "message" },
                    },
                },
            },
        },
        specs = {
            "folke/snacks.nvim",
            opts = function(_, opts)
                return vim.tbl_deep_extend("force", opts or {}, {
                    picker = {
                        actions = require("trouble.sources.snacks").actions,
                        win = {
                            input = {
                                keys = {
                                    ["<c-t>"] = {
                                        "trouble_open",
                                        mode = { "n", "i" },
                                    },
                                },
                            },
                        },
                    },
                })
            end,
        },
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "trouble")
            require("trouble").setup(opts)
        end,
        lazy = false,
        keys = {
            {
                "<leader>tb",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Trouble Buffer diagnostics",
            },
            { "<leader>td", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble Toggle diagnostics" },
            { "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Trouble Symbols" },
            {
                "<leader>tl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "Trouble LSP Definitions / references",
            },
            { "<leader>tL", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble Location List" },
            { "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble Quickfix List" },
        },
    },
}
