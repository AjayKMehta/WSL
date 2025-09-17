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

            snippets = {
                preset = "luasnip",
                expand = function(snippet)
                    require("luasnip").lsp_expand(snippet)
                end,
                active = function(filter)
                    if filter and filter.direction then
                        return require("luasnip").jumpable(filter.direction)
                    end
                    return require("luasnip").in_snippet()
                end,
                jump = function(direction)
                    require("luasnip").jump(direction)
                end,
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = {
                -- Fuzzy match on text before + after cursor
                keyword = { range = "full" }, -- prefix

                ghost_text = {
                    enabled = true,
                    show_without_selection = true,
                    show_with_menu = false,
                },
                documentation = {
                    auto_show = false,
                    auto_show_delay_ms = 200,
                    treesitter_highlighting = true,
                },
                trigger = { show_in_snippet = false }, --  do not show the completion window automatically when in a snippet
                list = {
                    max_items = 20,
                    -- These can be functions with ctx param
                    selection = {
                        preselect = true, -- select the first item automatically
                        auto_insert = true, -- insert preview
                    },
                },
                menu = {
                    auto_show = false, -- only show menu on manual <C-space>
                    auto_show_delay_ms = function(ctx, items)
                        return vim.bo.filetype == "markdown" and 500 or 200
                    end,
                    direction_priority = cb.get_menu_direction_priority,
                    draw = {
                        align_to = "cursor",
                        columns = { { "item_idx" }, { "kind_icon" }, { "label", "label_description", gap = 1 } },

                        -- This is the default but being explicit :)
                        snippet_indicator = "~",
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
                    -- https://cmp.saghen.dev/modes/cmdline.html#keymap-preset
                    preset = "cmdline",
                    ["<Tab>"] = { "show_and_insert_or_accept_single", "select_next" },
                    ["<S-Tab>"] = { "show_and_insert_or_accept_single", "select_prev" },
                    ["<CR>"] = { "accept", "fallback" },
                },
                completion = {
                    ghost_text = { enabled = true },
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
                sources = function()
                    local type = vim.fn.getcmdtype()
                    -- Search
                    if type == "/" or type == "?" then
                        return { "buffer" }
                    end
                    -- Commands
                    if type == ":" or type == "@" then
                        return { "cmdline", "path", "buffer" }
                    end
                    return {}
                end,
            },
        },
        opts_extend = { "sources.default" },
    },
}
