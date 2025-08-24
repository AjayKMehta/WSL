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
    { name = "easy-dotnet", group_index = 1 },
}

-- Do not use cmp.config.sources():
-- https://github.com/hrsh7th/nvim-cmp/discussions/881
cmp.setup({
    sources = default_sources,
    formatting = { format = c.format },
})

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
        { name = "emoji", insert = true, priority = 50 },
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
        priority = 10,
        keyword_length = 4,
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
table.insert(markdown_sources, {
    name = "emoji",
    group_index = 1,
    priority = 100,
})
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
