local c = require("utils.nvim_cmp")
local cmp = require("cmp")

local M = {}

-- Default
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

M.default = default_sources

-- Lua
local lua_sources = vim.deepcopy(default_sources)
local lazydev_source = {
    name = "lazydev",
    group_index = 0, -- set group index to 0 to skip loading LuaLS completions
}
table.insert(lua_sources, 1, lazydev_source)
M.lua = lua_sources

cmp.register_source("easy-dotnet", require("easy-dotnet").package_completion_source)

return M
