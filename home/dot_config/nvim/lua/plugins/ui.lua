local load_config = require("utils.helpers").load_config
local map_desc = require("utils.mappings").map_desc

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VimEnter",
        config = function(_, opts)
            require("configs.lualine").setup("auto")
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        enabled = vim.g.use_indent_blankline,
        main = "ibl",
        event = "User FilePost",
        opts = {
            whitespace = {
                highlight = { "CursorColumn", "Whitespace" },
                remove_blankline_trail = false,
            },
            indent = { char = "│", highlight = "IblChar" },
            scope = { char = "│", highlight = "IblScopeChar" },
        },
        config = function(_, opts)
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
            require("ibl").setup(opts)
        end,
    },
    {
        -- Use this instead of indent-blankline
        "shellRaining/hlchunk.nvim",
        enabled = not vim.g.use_indent_blankline,
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
                    local excluded_ftypes = require("utils.helpers").excluded_ftypes
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
        "WilliamHsieh/overlook.nvim",
        opts = {},

        -- Optional: set up common keybindings
        keys = {
            {
                "<leader>pd",
                function()
                    require("overlook.api").peek_definition()
                end,
                desc = "Overlook: Peek definition",
            },
            {
                "<leader>pc",
                function()
                    require("overlook.api").close_all()
                end,
                desc = "Overlook: Close all popup",
            },
            {
                "<leader>pf",
                function()
                    require("overlook.api").switch_focus()
                end,
                desc = "Overlook: Switch focus",
            },
            {
                "<leader>pt",
                function()
                    require("overlook.api").open_in_tab()
                end,
                desc = "Overlook: Open popup in tab",
            },
            {
                "<leader>pu",
                function()
                    require("overlook.api").restore_popup()
                end,
                desc = "Overlook: Restore popup",
            },
            {
                "<leader>pU",
                function()
                    require("overlook.api").restore_all_popups()
                end,
                desc = "Overlook: Restore all popups",
            },
        },
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
            vim.o.foldenable = true   -- enable fold for nvim-ufo
            vim.o.foldlevel = 99      -- set high foldlevel for nvim-ufo
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
        "nvim-mini/mini.map",
        lazy = false,
        config = function()
            local map = require("mini.map")
            require("mini.map").setup({
                integrations = {
                    map.gen_integration.builtin_search(),
                    map.gen_integration.gitsigns(),
                    map.gen_integration.diagnostic(),
                }
            })
            map_desc("n","<Leader>mc", map.close, "Minimap: Close")
            map_desc("n", "<Leader>mtf", map.toggle_focus, "Minimap: Toggle focus")
            map_desc("n", "<Leader>mo", map.open, "Minimap: Open")
            map_desc("n", "<Leader>mr", map.refresh, "Minimap: Refresh")
            map_desc("n", "<Leader>mts", map.toggle_side, "Minimap: Toggle side")
            map_desc("n", "<Leader>mT", map.toggle, "Minimap: Toggle")
        end,
    },
    {
        "stevearc/stickybuf.nvim",
        opts = {},
    },
    {
        -- Like peacock extension in VS Code
        "hampushauffman/peacock.nvim",
        lazy = false,
        enabled = false,
        config = function()
            require("peacock").setup()
        end,
    },
    {
        "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup({
                override = {
                    default_icon = { icon = "󰈚", name = "Default" },
                    lock = { icon = "󰌾", name = "lock" },
                    ["robots.txt"] = { icon = "󰚩", name = "robots" },
                },
            })
        end,
    },
}
