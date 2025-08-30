local u = require("utils")
local load_config = u.load_config
local cb = require("configs.blink")

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
            "L3MON4D3/LuaSnip",
            "R-nvim/cmp-r",
            "chrisgrieser/cmp-nerdfont",
            "fionn/cmp-unitex",
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
                "hrsh7th/cmp-nvim-lsp",
                lazy = false,
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
    { "chrisgrieser/cmp-nerdfont" },
    { "fionn/cmp-unitex" },
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
        "R-nvim/cmp-r",
        config = function()
            require("cmp_r").setup({ filetypes = { "r", "rmd", "quarto" } })
        end,
    },
    {
        "saghen/blink.compat",
        cond = vim.g.use_blink,
        -- use v2.* for blink.cmp v1.*
        version = "2.*",
        lazy = true,
        -- make sure to set opts so that lazy.nvim calls blink.compat's setup
        opts = {
            -- Might be useful for troubleshooting
            debug = false,
        },
    },
    {
        "saghen/blink.cmp",
        cond = vim.g.use_blink,
        dependencies = {
            "L3MON4D3/LuaSnip",
            "R-nvim/cmp-r",
            "chrisgrieser/cmp-nerdfont",
            "fionn/cmp-unitex",
            "Kaiser-Yang/blink-cmp-git",
        },

        -- use a release tag to download pre-built binaries
        version = "1.*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {

            keymap = require("configs.blink.mappings"),

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            signature = {
                enabled = true,
                window = {
                    show_documentation = false,
                    border = "rounded",
                    winhighlight = "Normal:None,FloatBorder:None,Search:None",
                },
            },

            snippets = { preset = "luasnip" },

            -- (Default) Only show the documentation popup when manually triggered
            completion = {
                -- Fuzzy match on text before + after cursor
                keyword = { range = "full" }, -- prefix

                ghost_text = {
                    enabled = true,
                    show_with_menu = false, -- Don't show when the menu is open
                },
                documentation = {
                    auto_show = false,
                    auto_show_delay_ms = 200,
                    treesitter_highlighting = true,
                },
                trigger = { show_in_snippet = false },
                list = {
                    max_items = 20,
                    -- These can be functions with ctx param
                    selection = {
                        preselect = false, -- do not select the first item automatically
                        auto_insert = true, -- insert preview
                    },
                },
                menu = {
                    align_to = "cursor",
                    auto_show = false, -- only show menu on manual <C-space>
                    direction_priority = cb.get_menu_direction_priority,
                    draw = {
                        columns = { { "item_idx" }, { "kind_icon" }, { "label", "label_description", gap = 1 } },

                        treesitter = { "lsp" },

                        components = {
                            item_idx = {
                                text = function(ctx)
                                    return ctx.idx == 10 and "0" or ctx.idx >= 10 and " " or tostring(ctx.idx)
                                end,
                                highlight = "BlinkCmpItemIdx", -- optional
                            },

                            kind_icon = {
                                text = cb.get_kind_icon_text,

                                highlight = cb.get_kind_icon_highlight,
                            },
                        },
                    },
                },
            },

            sources = require("configs.blink.sources"),

            fuzzy = {
                implementation = "prefer_rust_with_warning",
                sorts = { "exact", "score", "sort_text", "kind", "label" },
            },
            enabled = cb.is_enabled,

            cmdline = {
                keymap = {
                    preset = "cmdline",
                },
                completion = {
                    list = {
                        selection = {
                            preselect = false,
                            auto_insert = false,
                        },
                    },
                    menu = {
                        auto_show = function(_)
                            return vim.fn.getcmdtype() == ":"
                        end,
                        draw = {
                            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
                        },
                    },
                },
            },
        },
        opts_extend = { "sources.default" },
    },
}
