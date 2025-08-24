local cmp = require("cmp")
local ls = require("luasnip")
return {
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#safely-select-entries-with-cr
    ["<CR>"] = cmp.mapping({
        i = function(fallback)
            local cmp = cmp
            if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
                fallback()
            end
        end,
        s = cmp.mapping.confirm({ select = true }),
        c = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }),
    }),
    ["<M-d>"] = cmp.mapping({
        i = function()
            local cmp = cmp
            if cmp.visible_docs() then
                cmp.close_docs()
            else
                cmp.open_docs()
            end
        end,
    }),
    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }), -- Alternative `Select Previous Item`
    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }), -- Alternative `Select Next Item`
    ["<C-y>"] = cmp.mapping(
        cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
        { "i", "c" }
    ), -- Use to select current item
    ["<C-k>"] = cmp.mapping(function(fallback)
        if ls.expand_or_jumpable() then
            ls.expand_or_jump()
        else
            fallback()
        end
    end, { "i", "s" }),
    ["<C-j>"] = cmp.mapping(function(fallback)
        if ls.jumpable(-1) then
            ls.jump(-1)
        else
            fallback()
        end
    end, { "i", "s" }),
    ["<C-u>"] = cmp.mapping(function(fallback)
        if ls.choice_active() then
            require("luasnip.extras.select_choice")()
        else
            fallback()
        end
    end, { "i", "s" }),
    -- Tab and Shift + Tab help navigate between snippet nodes.
    -- Complete common string (similar to shell completion behavior).
    ["<C-l>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            return cmp.complete_common_string()
        end
        fallback()
    end, { "i", "c" }),
    -- https://www.dmsussman.org/resources/neovimsetup/
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = function()
            local cmp = cmp
            if cmp.visible() then
                cmp.mapping.close()
            end
        end,
    }),
    ["<C-n>"] = {
        i = function()
            local cmp = cmp
            local ls = ls

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
            local cmp = cmp
            local ls = ls

            if ls.choice_active() then
                ls.change_choice(-1)
            elseif cmp.visible() then
                cmp.select_prev_item()
            else
                cmp.complete()
            end
        end,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif ls.expand_or_jumpable() then
            ls.expand_or_jump()
        else
            fallback()
        end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif ls.jumpable(-1) then
            ls.jump(-1)
        else
            fallback()
        end
    end, { "i", "s" }),
}
