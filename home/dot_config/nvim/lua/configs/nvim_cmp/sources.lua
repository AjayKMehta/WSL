local c = require("utils.nvim_cmp")
local cmp = require("cmp")
local get_buffers_by_size = require("utils").get_buffers_by_size

local function get_fuzzy_buffer_source(grp_idx, priority, kw_length)
    return {
        name = "fuzzy_buffer",
        group_index = grp_idx,
        priority = priority,
        keyword_length = kw_length,
        -- Only select visible buffers of 1 MB or less size
        option = { get_bufnrs = get_buffers_by_size },
    }
end

local M = {}

-- Default
-- name is not the name of the plugin, it's the "id" of the plugin used when creating the source.
local default_sources = {
    {
        name = "nvim_lsp",
        group_index = 1,
        priority = 100,
        keyword_length = 2, -- For C#, want to trigger when '_'
        entry_filter = c.limit_lsp_types,
    },
    {
        name = "luasnip_choice",
        group_index = 1,
        priority = 95,
        max_item_count = 100,
    },
    {
        name = "luasnip",
        group_index = 1,
        priority = 90,
        keyword_length = 2,
        max_item_count = 100,
        option = { show_autosnippets = true },
        -- https://www.reddit.com/r/neovim/comments/160vhde/comment/jxorpq9/
        entry_filter = c.not_in_string,
    },
}

M.default = default_sources

-- Lua
local lua_sources = vim.deepcopy(default_sources)
local lazydev_source = {
    name = "lazydev",
    group_index = 0, -- set group index to 0 to skip loading LuaLS completions
    priority = 100
}
table.insert(lua_sources, 1, lazydev_source)
M.lua = lua_sources

-- gitrebase
M.gitrebase = {
    { name = "git", priority = 100 },
    { name = "async_path", priority = 70, keyword_length = 3 },
    get_fuzzy_buffer_source(1, 60, 4),
}

-- search
M.search = { get_fuzzy_buffer_source(1, 60, 4) }

-- cmdline
M.cmdline = {
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
    get_fuzzy_buffer_source(2, 20, 4),
}

-- tex
local tex_sources = vim.deepcopy(default_sources)
local other_latex_sources = {
    {
        name = "async_path",
        group_index = 2,
        priority = 60,
    },
    get_fuzzy_buffer_source(2, 50, 5),
}

for _, value in ipairs(other_latex_sources) do
    table.insert(tex_sources, value)
end
M.tex = tex_sources

-- markdown
local markdown_sources = vim.deepcopy(tex_sources)
-- Completions for both checkboxes and callouts
table.insert(markdown_sources, { name = "render-markdown", group_index = 1, priority = 80 })
M.markdown = markdown_sources

-- r
local r_sources = vim.deepcopy(default_sources)
local r_source = {
    name = "cmp_r",
    priority = 100,
    keyword_length = 2,
}
table.insert(r_sources, 1, r_source)
M.r = r_sources

-- rmd/quarto
local quarto_sources = vim.deepcopy(markdown_sources)
table.insert(r_sources, 2, r_source)

cmp.register_source("easy-dotnet", require("easy-dotnet").package_completion_source)

return M
