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

-- TODO: set up <M-d>, <C-j>, <C-k>, <Down>, <Up>, <C-y> like nvim-cmp?
return {
    preset = "default",
    -- https://www.reddit.com/r/neovim/comments/1kdg687/how_do_you_reopen_completion_menu_in_blinkcmp/
    ["<C-s>"] = { "show", "show_signature", "hide_signature" },
    ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "hide", "show" },

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
