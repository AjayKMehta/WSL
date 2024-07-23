local overrides = require("configs.overrides")

local load_config = require("utils").load_config

return {
    {
        "hrsh7th/nvim-cmp",
        opts = overrides.cmp,
        event = { "InsertEnter", "CmdlineEnter" },
        config = function(_, opts)
            require("cmp").setup(opts)
            load_config("cmp")()
        end,
        dependencies = {
            -- hrsh7th/cmp-nvim-lua not needed bc of neodev
            {
                -- Completion for LaTeX symbols
                "amarakon/nvim-cmp-lua-latex-symbols",
                event = "InsertEnter",
                opts = { cache = true },
                -- Necessary to avoid runtime errors
                config = function(_, opts)
                    require("cmp").setup(opts)
                end,
            },
            {
                -- Completion for fs paths (async)
                "FelipeLema/cmp-async-path",
                url = "https://codeberg.org/FelipeLema/cmp-async-path",
            },
            {
                -- nvim-cmp source for emojis
                "hrsh7th/cmp-emoji",
                event = "InsertEnter",
                enabled = function()
                    return vim.g.use_cmp_emoji
                end,
            },
            {
                -- Fuzzy buffer completion
                "tzachar/cmp-fuzzy-buffer",
                dependencies = { "tzachar/fuzzy.nvim" },
            },
            {
                -- nvim-cmp source for cmdline
                "hrsh7th/cmp-cmdline",
                lazy = false,
            },
            {
                -- Luasnip choice node completion source for nvim-cmp
                "L3MON4D3/cmp-luasnip-choice",
                config = function()
                    require("cmp_luasnip_choice").setup({
                        auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
                    })
                end,
            },
            { "amarakon/nvim-cmp-buffer-lines" },
            { "L3MON4D3/LuaSnip" },
            { "ray-x/cmp-treesitter" },
            { "jalvesaq/cmp-nvim-r" },
            { "rcarriga/cmp-dap" },
        },
    },
    {
        -- Completion plugin for git
        "petertriho/cmp-git",
        dependencies = { "hrsh7th/nvim-cmp", "nvim-lua/plenary.nvim" },
        config = load_config("cmp_git"),
        init = function()
            table.insert(require("cmp").get_config().sources, { name = "git" })
        end,
    },
    {
        -- Snippet Engine for Neovim
        "L3MON4D3/LuaSnip",
        dependencies = {
            { "rafamadriz/friendly-snippets" },
            { "onsails/lspkind.nvim" },
        },
        event = {
            "InsertEnter",
            "CmdlineEnter",
        },
        build = "make install_jsregexp",
        config = load_config("luasnip"),
    },
    {
        "allaman/emoji.nvim",
        event = "InsertEnter",
        enabled = function()
            return not vim.g.use_cmp_emoji
        end,
        dependencies = {
            "hrsh7th/nvim-cmp",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            -- default is false
            enable_cmp_integration = true,
        },
    },
}
