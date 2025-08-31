return {
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
    ["<C-d>"] = require("cmp").mapping({
        i = function()
            local cmp = require("cmp")
            if cmp.visible_docs() then
                cmp.close_docs()
            else
                cmp.open_docs()
            end
        end,
    }),
    ["<Down>"] = require("cmp").mapping(require("cmp").mapping.select_next_item(), { "i", "c" }), -- Alternative `Select Previous Item`
    ["<Up>"] = require("cmp").mapping(require("cmp").mapping.select_prev_item(), { "i", "c" }), -- Alternative `Select Next Item`
    ["<C-y>"] = require("cmp").mapping(
        require("cmp").mapping.confirm({ behavior = require("cmp").ConfirmBehavior.Insert, select = true }),
        { "i" }
    ), -- Use to select current item
    ["<C-k>"] = require("cmp").mapping(function(fallback)
        local ls = require("luasnip")
        if ls.expand_or_jumpable() then
            ls.expand_or_jump()
        else
            fallback()
        end
    end, { "i", "s" }),
    ["<C-j>"] = require("cmp").mapping(function(fallback)
        local ls = require("luasnip")
        if ls.jumpable(-1) then
            ls.jump(-1)
        else
            fallback()
        end
    end, { "i", "s" }),
    -- Tab and Shift + Tab help navigate between snippet nodes.
    -- Complete common string (similar to shell completion behavior).
    ["<C-l>"] = require("cmp").mapping(function(fallback)
        local cmp = require("cmp")
        if cmp.visible() then
            return cmp.complete_common_string()
        end
        fallback()
    end, { "i", "c" }),
    -- https://www.dmsussman.org/resources/neovimsetup/
    ["<C-Space>"] = require("cmp").mapping(require("cmp").mapping.complete(), { "i", "c" }),
    ["<C-b>"] = require("cmp").mapping.scroll_docs(-4),
    ["<C-f>"] = require("cmp").mapping.scroll_docs(4),
    ["<C-e>"] = require("cmp").mapping({
        i = require("cmp").mapping.abort(),
        c = function()
            local cmp = require("cmp")
            if cmp.visible() then
                cmp.mapping.close()
            end
        end,
    }),
    ["<C-n>"] = {
        i = function()
            local cmp = require("cmp")
            local ls = require("luasnip")
            if ls.choice_active() then
                ls.change_choice(1)
            elseif cmp.visible() then
                -- { behavior = cmp.SelectBehavior.Insert } is annoying!
                cmp.select_next_item()
            else
                cmp.complete()
            end
        end,
    },
    ["<C-p>"] = {
        i = function()
            local cmp = require("cmp")
            local ls = require("luasnip")
            if ls.choice_active() then
                ls.change_choice(-1)
            elseif cmp.visible() then
                cmp.select_prev_item()
            else
                cmp.complete()
            end
        end,
    },
    ["<Tab>"] = require("cmp").mapping(function(fallback)
        local cmp = require("cmp")
        local ls = require("luasnip")
        if cmp.visible() then
            cmp.select_next_item()
        elseif ls.expand_or_jumpable() then
            ls.expand_or_jump()
        else
            fallback()
        end
    end, { "i", "s" }),

    ["<S-Tab>"] = require("cmp").mapping(function(fallback)
        local cmp = require("cmp")
        local ls = require("luasnip")
        if cmp.visible() then
            cmp.select_prev_item()
        elseif ls.jumpable(-1) then
            ls.jump(-1)
        else
            fallback()
        end
    end, { "i", "s" }),
}
