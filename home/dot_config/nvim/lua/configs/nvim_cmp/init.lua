local c = require("utils.nvim_cmp")
local get_buffers_by_size = require("utils").get_buffers_by_size
-- Use buffer source for `/` and '?'
local cmp = require("cmp")

-- Only select visible buffers of 1 MB or less size
local buffer_option = {
    get_bufnrs = get_buffers_by_size,
}

dofile(vim.g.base46_cache .. "cmp")

cmp.register_source("easy-dotnet", require("easy-dotnet").package_completion_source)

-- name is not the name of the plugin, it's the "id" of the plugin used when creating the source.
local default_sources = {
    {
        name = "nvim_lsp",
        group_index = 1,
        priority = 1000,
        keyword_length = 2, -- For C#, want to trigger when '_'
        entry_filter = c.limit_lsp_types,
    },
    {
        name = "luasnip_choice",
        group_index = 1,
        priority = 650,
        max_item_count = 700,
    },
    {
        name = "luasnip",
        group_index = 1,
        priority = 700,
        keyword_length = 2,
        max_item_count = 100,
        option = { show_autosnippets = true },
        -- https://www.reddit.com/r/neovim/comments/160vhde/comment/jxorpq9/
        entry_filter = c.not_in_string,
    },
}

local opts = {
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#disabling-completion-in-certain-contexts-such-as-comments
    enabled = function()
        local context = require("cmp.config.context")
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        if filetype == "TelescopePrompt" or filetype == "snacks_picker_input" then
            return false
        end

        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == "c" then
            return true
        end

        -- disable completion in comments
        return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
    end,
    experimental = {
        ghost_text = {
            hl_group = "Comment",
        },
    },
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
        autocomplete = false,
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
        ["<Down>"] = require("cmp").mapping(require("cmp").mapping.select_next_item(), { "i", "c" }), -- Alternative `Select Previous Item`
        ["<Up>"] = require("cmp").mapping(require("cmp").mapping.select_prev_item(), { "i", "c" }), -- Alternative `Select Next Item`
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
        ["<C-u>"] = require("cmp").mapping(function(fallback)
            if require("luasnip").choice_active() then
                require("luasnip.extras.select_choice")()
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
        -- https://www.dmsussman.org/resources/neovimsetup/
        ["<C-Space>"] = require("cmp").mapping(require("cmp").mapping.complete(), { "i", "c" }),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
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
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
                require("luasnip").expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
                require("luasnip").jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
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
    -- https://github.com/hrsh7th/nvim-cmp/commit/7aa3f71932c419d716290e132cacbafbaf5bea1c
    view = {
        entries = {
            follow_cursor = true,
        },
    },
    sources = default_sources,
    formatting = { format = c.format },
}

-- Do not use cmp.config.sources():
-- https://github.com/hrsh7th/nvim-cmp/discussions/881
cmp.setup(opts)

local lua_sources = vim.deepcopy(default_sources)
local lazydev_source = {
    name = "lazydev",
    group_index = 0, -- set group index to 0 to skip loading LuaLS completions
}
table.insert(lua_sources, 1, lazydev_source)

cmp.setup.filetype({ "gitcommit", "octo" }, {
    sources = cmp.config.sources({
        { name = "git" },
    }, {
        { name = "fuzzy_buffer", keyword_length = 4 },
    }),
})

cmp.setup.filetype({ "gitrebase" }, {
    sources = cmp.config.sources({
        { name = "git", priority = 100 },
        { name = "async_path", priority = 50, keyword_length = 3 },
        { name = "fuzzy_buffer", priority = 50, keyword_length = 4 },
    }),
})

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    enabled = true,
    completion = {
        keyword_length = 2,
    },
    sources = {
        {
            name = "fuzzy_buffer",
            group_index = 1,
            priority = 60,
            keyword_length = 4,
        },
    },
    view = {
        entries = { name = "custom", selection_order = "near_cursor" },
    },
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    completion = {
        keyword_length = 2, -- Otherwise, can't use :q!
    },
    enabled = true,
    sources = {
        {
            name = "cmdline",
            group_index = 1,
            priority = 100,
        },
        {
            name = "async_path",
            group_index = 1,
            priority = 80,
        },
        {
            name = "fuzzy_buffer",
            group_index = 2,
            priority = 20,
            keyword_length = 4,
        },
    },
})

cmp.setup.filetype({ "help", "minifiles", "TelescopePrompt" }, {
    enabled = false,
})

local tex_sources = vim.deepcopy(default_sources)
local other_latex_sources = {
    {
        name = "async_path",
        group_index = 2,
        priority = 50,
    },
    {
        name = "fuzzy_buffer",
        group_index = 2,
        priority = 40,
        keyword_length = 5,
        option = buffer_option,
    },
}

for _, value in ipairs(other_latex_sources) do
    table.insert(tex_sources, value)
end

cmp.setup.filetype({ "tex", "plaintex" }, {
    sources = tex_sources,
})

local markdown_sources = vim.deepcopy(tex_sources)
-- Completions for both checkboxes and callouts
table.insert(markdown_sources, { name = "render-markdown", group_index = 1, priority = 80 })
cmp.setup.filetype({ "markdown", "rmd", "quarto", "codecompanion" }, {
    sources = markdown_sources,
})

local r_sources = vim.deepcopy(default_sources)
local r_source = {
    name = "cmp_r",
    priority = 100,
    keyword_length = 2,
}
table.insert(r_sources, 1, r_source)
table.insert(r_sources, { name = "otter", priority = 90 })
cmp.setup.filetype("r", {
    sources = r_sources,
})

-- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#add-parentheses-after-selecting-function-or-method-item
-- If you want insert `(` after select function or method item
if vim.g.use_autopairs then
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
