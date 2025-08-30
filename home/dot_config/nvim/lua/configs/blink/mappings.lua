-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
-- 'super-tab' for mappings similar to vscode (tab to accept)
-- 'enter' for enter to accept
-- 'none' for no mappings
--
-- All presets have the following mappings:
-- C-space: Open menu or open docs if already open
-- C-n/C-p or Up/Down: Select next/previous item
-- C-e: Hide menu
-- C-k: Toggle signature help (if signature.enabled = true)
--
-- See :h blink-cmp-config-keymap for defining your own keymap

return {
    preset = "default",
    -- https://www.reddit.com/r/neovim/comments/1kdg687/how_do_you_reopen_completion_menu_in_blinkcmp/
    ["<C-s>"] = { "show", "show_signature", "hide_signature" },
    ["<C-d>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "hide", "show" },
    ["<C-Space>"] = { "show" },
    ["<CR>"] = { "accept", "fallback" },

    ["<C-k>"] = {
        function(cmp)
            local ls = require("luasnip")
            if ls.expand_or_jumpable() then
                return ls.expand_or_jump()
            end
        end,
        "fallback",
    },
    ["<C-j>"] = {
        function(cmp)
            local ls = require("luasnip")
            if ls.jumpable(-1) then
                return ls.jump(-1)
            end
        end,
        "fallback",
    },
    ["<C-u>"] = {
        function(cmp)
            local ls = require("luasnip")
            if ls.choice_active() then
                return require("luasnip.extras.select_choice")()
            end
        end,
        "fallback",
    },
    ["<C-n>"] = {
        function(cmp)
            local bc = require("blink.cmp")
            local ls = require("luasnip")
            if ls.choice_active() then
                ls.change_choice(1)
            elseif bc.is_visible() then
                bc.select_next()
            end
        end,
        "fallback",
    },
    ["<C-p>"] = {
        function(cmp)
            local bc = require("blink.cmp")
            local ls = require("luasnip")
            if ls.choice_active() then
                ls.change_choice(-1)
            elseif bc.is_visible() then
                bc.select_prev()
            end
        end,
        "fallback",
    },

    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

    -- Select Nth item from the list
    ["<A-1>"] = {
        function(cmp)
            cmp.accept({ index = 1 })
        end,
    },
    ["<A-2>"] = {
        function(cmp)
            cmp.accept({ index = 2 })
        end,
    },
    ["<A-3>"] = {
        function(cmp)
            cmp.accept({ index = 3 })
        end,
    },
    ["<A-4>"] = {
        function(cmp)
            cmp.accept({ index = 4 })
        end,
    },
    ["<A-5>"] = {
        function(cmp)
            cmp.accept({ index = 5 })
        end,
    },
    ["<A-6>"] = {
        function(cmp)
            cmp.accept({ index = 6 })
        end,
    },
    ["<A-7>"] = {
        function(cmp)
            cmp.accept({ index = 7 })
        end,
    },
    ["<A-8>"] = {
        function(cmp)
            cmp.accept({ index = 8 })
        end,
    },
    ["<A-9>"] = {
        function(cmp)
            cmp.accept({ index = 9 })
        end,
    },
    ["<A-0>"] = {
        function(cmp)
            cmp.accept({ index = 10 })
        end,
    },
}
