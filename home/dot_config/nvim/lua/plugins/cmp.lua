local overrides = require("configs.overrides")

local load_config = require("utils").load_config

return {
    {
        "hrsh7th/nvim-cmp",
        opts = {
            -- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#disabling-completion-in-certain-contexts-such-as-comments
            enabled = function()
                local context = require("cmp.config.context")
                if vim.api.nvim_buf_get_option(0, "filetype") == "TelescopePrompt" then
                    return false
                -- keep command mode completion enabled when cursor is in a comment
                elseif vim.api.nvim_get_mode().mode == "c" then
                    return true
                else
                    -- disable completion in comments
                    return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
                end
            end,
            experimental = {
                ghost_text = {
                    hl_group = "Comment",
                },
            },
            -- https://github.com/Aumnescio/dotfiles/blob/758be23d2f064a480915d1fc8339a6c0d2a71b77/nvim/lua/plugins/autocompletion.lua
            performance = {
                debounce = 25,
                throttle = 50,
                max_view_entries = 30,
                fetching_timeout = 200,
                async_budget = 50,
            },
            -- Enable luasnip to handle snippet expansion for nvim-cmp
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            matching = {
                disallow_fuzzy_matching = false,
                disallow_fullfuzzy_matching = true,
                disallow_partial_fuzzy_matching = false,
                disallow_partial_matching = false,
                disallow_prefix_unmatching = false,
            },
            completion = {
                completeopt = "menu,menuone,noinsert,noselect",
                keyword_length = 2,
            },
            mapping = {
                -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#safely-select-entries-with-cr
                ["<CR>"] = require("cmp").mapping({
                    i = function(fallback)
                        local cmp = require("cmp")
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end,
                    s = require("cmp").mapping.confirm({ select = true }),
                    c = require("cmp").mapping.confirm({
                        behavior = require("cmp").ConfirmBehavior.Replace,
                        select = false,
                    }),
                }),
                ["<M-d>"] = require("cmp").mapping({
                    i = function()
                        local cmp = require("cmp")
                        if cmp.visible_docs() then
                            cmp.close_docs()
                        else
                            cmp.open_docs()
                        end
                    end,
                }),
                ["<Down>"] = require("cmp").mapping(
                    require("cmp").mapping.select_next_item({ behavior = require("cmp").SelectBehavior.Insert }),
                    { "i", "c" }
                ), -- Alternative `Select Previous Item`
                ["<Up>"] = require("cmp").mapping(
                    require("cmp").mapping.select_prev_item({ behavior = require("cmp").SelectBehavior.Insert }),
                    { "i", "c" }
                ), -- Alternative `Select Next Item`
                ["<C-y>"] = require("cmp").mapping(
                    require("cmp").mapping.confirm({ behavior = require("cmp").ConfirmBehavior.Insert, select = true }),
                    { "i", "c" }
                ), -- Use to select current item
                ["<C-k>"] = require("cmp").mapping(function(fallback)
                    if require("luasnip").expand_or_jumpable() then
                        require("luasnip").expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-j>"] = require("cmp").mapping(function(fallback)
                    if require("luasnip").jumpable(-1) then
                        require("luasnip").jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                -- Tab and Shift + Tab help navigate between snippet nodes.
                -- Complete common string (similar to shell completion behavior).
                ["<C-l>"] = require("cmp").mapping(function(fallback)
                    if require("cmp").visible() then
                        return require("cmp").complete_common_string()
                    end
                    fallback()
                end, { "i", "c" }),
            },
            sorting = {
                comparators = {
                    require("cmp").config.compare.offset,
                    require("cmp").config.compare.exact,
                    require("cmp").config.compare.score,
                    require("cmp").config.compare.receently_used,
                    require("cmp").config.compare.kind,
                    require("cmp").config.compare.sort_text,
                    require("cmp").config.compare.length,
                    require("cmp").config.compare.order,
                },
            },
            window = {
                completion = require("cmp.config.window").bordered({
                    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
                }),
                -- TODO: Figure out if this can be toggled.
                -- documentation = false,
            },
            -- https://github.com/hrsh7th/nvim-cmp/commit/7aa3f71932c419d716290e132cacbafbaf5bea1c
            view = {
                entries = {
                    follow_cursor = true,
                },
            },
        },
        event = { "InsertEnter", "CmdlineEnter" },
        config = function(_, opts)
            -- For NvChad-specified settings, see https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/configs/cmp.lua
            require("cmp").setup(opts)
            load_config("cmp")()
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
