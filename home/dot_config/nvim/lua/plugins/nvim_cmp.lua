local load_config = require("utils").load_config

return {
    {
        "hrsh7th/nvim-cmp",
        cond = not vim.g.use_blink,
        event = { "InsertEnter", "CmdlineEnter" },
        config = function(_, opts)
            -- For NvChad-specified settings, see https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/configs/cmp.lua
            require("cmp").setup(opts)
            load_config("nvim_cmp")
        end,
        dependencies = {
            -- hrsh7th/cmp-nvim-lua not needed bc of neodev
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
                -- Completion for fs paths (async)
                "FelipeLema/cmp-async-path",
                url = "https://codeberg.org/FelipeLema/cmp-async-path",
                cond = not vim.g.use_blink,
            },
            {
                -- Fuzzy buffer completion
                "tzachar/cmp-fuzzy-buffer",
                dependencies = { "tzachar/fuzzy.nvim" },
                cond = not vim.g.use_blink,
            },
            {
                -- nvim-cmp source for cmdline
                "hrsh7th/cmp-cmdline",
                lazy = false,
                cond = not vim.g.use_blink,
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
        },
    },
    {
        -- Completion plugin for git
        "petertriho/cmp-git",
        dependencies = { "hrsh7th/nvim-cmp", "nvim-lua/plenary.nvim" },
        cond = not vim.g.use_blink,
        config = load_config("cmp_git"),
        init = function()
            table.insert(require("cmp").get_config().sources, { name = "git" })
        end,
    },
    {
        "allaman/emoji.nvim",
        cmd = "Emoji",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "folke/snacks.nvim",
            "nvim-telescope/telescope.nvim",
        },
    },
}
