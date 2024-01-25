-- Use buffer source for `/` and '?'
local cmp = require("cmp")

local function limit_lsp_types(entry, ctx)
    local kind = entry:get_kind()
    local line = ctx.cursor.line
    local col = ctx.cursor.col
    local char_before_cursor = string.sub(line, col - 1, col - 1)
    local char_after_dot = string.sub(line, col, col)
    local types = require("cmp.types")

    if char_before_cursor == "." and char_after_dot:match("[a-zA-Z]") then
        return kind == types.lsp.CompletionItemKind.Method
            or kind == types.lsp.CompletionItemKind.Field
            or kind == types.lsp.CompletionItemKind.Property
    elseif string.match(line, "^%s+%w+$") then
        return kind == types.lsp.CompletionItemKind.Function or kind == types.lsp.CompletionItemKind.Variable
    end

    return kind ~= cmp.lsp.CompletionItemKind.Text
end


local function toggle_comments(enable)
    return function(entry, ctx)
        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == 'c' then
            return true
        else
            local result = ctx.in_treesitter_capture("comment")
                and ctx.in_syntax_group("Comment")
            if enable then
                return result
            else
                return not result
            end
        end
    end
end

-- Only select visible buffers of 1 MB or less size
local buffer_option = {
    get_bufnrs = function()
        local buf_size_limit = 1024 * 1024
        local bufs = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
            bufs[buf] = (byte_size <= buf_size_limit)
        end
        return vim.tbl_keys(bufs)
    end,
}

cmp.setup.cmdline({ "/", "?" }, {
    mapping = require("cmp").mapping.preset.cmdline(),
    enabled = true,
    sources = {
        {
            name = "buffer",
            option = { keyword_pattern = [[\k\+]] },
            keyword_length = 3,
            max_item_count = 10
        },
        { name = "buffer-lines" }
    }
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
    mapping = require("cmp").mapping.preset.cmdline(),
    completion = {
        keyword_length = 2, -- Otherwise, can't use :q!
    },
    enabled = true,
    sources = require("cmp").config.sources({
        { name = 'async_path' },
        { name = 'cmdline' }
    })
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "dap" },
    }),
})

cmp.setup.filetype({ "help", "minifiles", "TelescopePrompt" }, {
    enabled = false,
})

cmp.setup.filetype({ "tex", "plaintex", "markdown" }, {
    sources = {
        {
            name = "treesitter",
            group_index = 1,
            priority = 100,
        },
        {
            name = "nvim_lsp",
            group_index = 1,
            priority = 100,
            keyword_length = 3,
            entry_filter = limit_lsp_types,
        },
        {
            name = "nvim_lsp_signature_help",
            group_index = 1,
            priority = 100,
        },
        {
            name = "rg",
            group_index = 1,
            priority = 100,
            keyword_length = 3
        },
        {
            name = "luasnip",
            group_index = 1,
            priority = 90,
            keyword_length = 2,
            max_item_count = 10,
            option = { show_autosnippets = true },
        },
        {
            name = "luasnip-choice",
            group_index = 1,
            priority = 90,
            keyword_length = 2,
            max_item_count = 5,
        },
        {
            name = "lua-latex-symbols",
            group_index = 1,
            priority = 75,
            keyword_length = 2,
        },
        {
            name = "dictionary",
            group_index = 1,
            priority = 60,
            keyword_length = 2,
            max_item_count = 6,
        },
        {
            name = "async_path",
            group_index = 2,
            priority = 50,
        },
        {
            name = "buffer",
            group_index = 3,
            priority = 10,
            keyword_length = 4,
            max_item_count = 10,
            option = buffer_option,
        },
        {
            name = "buffer-lines",
            group_index = 3,
            priority = 5,
            keyword_length = 4,
            max_item_count = 10,
            option = buffer_option,
        }
    }
})

cmp.setup.filetype('r', {
    sources = cmp.config.sources({
        {
            name = 'cmp_nvim_r',
            group_index = 1,
            priority = 100,
            keyword_length = 2,
        },
        {
            name = "treesitter",
            group_index = 1,
            priority = 100,
        },
        {
            name = "nvim_lsp",
            group_index = 1,
            priority = 100,
            keyword_length = 2,
            entry_filter = limit_lsp_types,
        },
        {
            name = "nvim_lsp_signature_help",
            group_index = 1,
            priority = 100,
        },
        {
            name = "rg",
            group_index = 1,
            priority = 100,
            keyword_length = 3
        },
        {
            name = "luasnip",
            group_index = 1,
            priority = 90,
            keyword_length = 2,
            max_item_count = 10,
            option = { show_autosnippets = true },
        },
        {
            name = "luasnip-choice",
            group_index = 1,
            priority = 90,
            keyword_length = 2,
            max_item_count = 5,
        },
    })
})

cmp.setup.filetype('lua', {
    sources = cmp.config.sources({
        -- This source will complete neovim's Lua runtime API such vim.lsp.*.
        {
            name = 'nvim_lua',
            group_index = 1,
            priority = 100,
            keyword_length = 2,
        },
        {
            name = "treesitter",
            group_index = 1,
            priority = 100,
        },
        {
            name = "nvim_lsp",
            group_index = 1,
            priority = 100,
            keyword_length = 2,
            entry_filter = limit_lsp_types,
        },
        {
            name = "nvim_lsp_signature_help",
            group_index = 1,
            priority = 100,
        },
        {
            name = "rg",
            group_index = 1,
            priority = 100,
            keyword_length = 3
        },
        {
            name = "luasnip",
            group_index = 1,
            priority = 90,
            keyword_length = 2,
            max_item_count = 10,
            option = { show_autosnippets = true },
        },
        {
            name = "luasnip-choice",
            group_index = 1,
            priority = 90,
            keyword_length = 2,
            max_item_count = 5,
        },
    })
})
