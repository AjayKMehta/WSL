local overrides = require("configs.overrides")

local load_config = require("utils").load_config

return {
    {
        -- A framework for running functions on Tree-sitter nodes, and updating the buffer with the result.
        "ckolkey/ts-node-action",
        dependencies = { "nvim-treesitter" },
        opts = {},
    },
    {
        -- Enhanced folds
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
        event = "BufRead",
        config = load_config("ufo"),
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
                        return vim.v.count == 0 and vim.fn.reg_executing() == ""  and vim.fn.reg_recording() == ""
                    end,
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
                    "Trouble",
                    "gitsigns-blame",
                    function(win)
                        -- exclude non-focusable windows
                        return not vim.api.nvim_win_get_config(win).focusable
                    end,
                },
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = overrides.treesitter,
        event = { "BufReadPre", "BufNewFile" },
        cmd = {
            "TSInstall",
            "TSInstallSync",
            "TSInstallInfo",
            "TSUpdate",
            "TSUpdateSync",
            "TSUninstall",
        },
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-refactor",
            "nvim-treesitter/nvim-treesitter-textobjects",
            "RRethy/nvim-treesitter-textsubjects",
        },
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "syntax")
            dofile(vim.g.base46_cache .. "treesitter")
            require("nvim-treesitter.configs").setup(opts)
            require("nvim-treesitter.install").compilers = { "clang" }
        end,
    },
    {
        -- Show code context.,
        "nvim-treesitter/nvim-treesitter-context",
        lazy = false,
        event = "BufReadPost",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            max_lines = 3,
            min_window_height = 0,
            patterns = {
                default = {
                    "class",
                    "function",
                    "method",
                },
            },
        },
    },
    {
        -- Syntax aware text-objects, select, move, swap, and peek support.
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {
            -- "nvim-treesitter/nvim-treesitter",
        },
        config = load_config("ts_textobjects"),
    },
    {
        -- Rainbow delimiters with Treesitter
        "HiPhish/rainbow-delimiters.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = { "BufReadPost", "BufNewFile" },
        config = load_config("rainbow"),
    },
}
