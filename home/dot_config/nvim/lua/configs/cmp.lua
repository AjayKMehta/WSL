-- Use buffer source for `/` and '?'
local cmp = require("cmp")
local lspkind = require("lspkind")

local function limit_lsp_types(entry, ctx)
    local kind = entry:get_kind()

    local has_dot = {
        cs = true,
        lua = true,
        java = true,
        python = true,
    }
    if has_dot[vim.bo.filetype] then
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
    end
    return kind ~= cmp.lsp.CompletionItemKind.Text
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

dofile(vim.g.base46_cache .. "cmp")

cmp.register_source("easy-dotnet", require("easy-dotnet").package_completion_source)

-- name is not the name of the plugin, it's the "id" of the plugin used when creating the source.
local default_sources = {
    {
        name = "nvim_lsp",
        group_index = 1,
        priority = 1000,
        keyword_length = 1, -- For C#, want to trigger when '_'
        entry_filter = limit_lsp_types,
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
    },
    { name = "easy-dotnet", group_index = 1 },
    {
        name = "treesitter",
        group_index = 2,
        keyword_length = 2,
        priority = 750,
    },
}

-- Do not use cmp.config.sources():
-- https://github.com/hrsh7th/nvim-cmp/discussions/881
cmp.setup({
    sources = default_sources,
    formatting = {
        -- https://github.com/brenoprata10/nvim-highlight-colors#lspkind-integration
        format = function(entry, item)
            local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
            local dups = { fuzzy_buffer = 1, async_path = 1, nvim_lsp = 0, luasnip = 1, treesitter = 1 }
            item = lspkind.cmp_format({
                mode = "text_symbol",
                maxwidth = {
                    -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    -- can also be a function to dynamically calculate max width such as
                    -- menu = function() return math.floor(0.45 * vim.o.columns) end,
                    menu = 50, -- leading text (labelDetails)
                    abbr = 50, -- actual suggestion item
                },
                ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                show_labelDetails = false, -- show labelDetails in menu. Disabled by default
                preset = "default", --codicons",

                -- The function below will be called before any actual modifications from lspkind
                -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                before = function(entry, vim_item)
                    local menu_icon = {
                        treesitter = "🌲",
                        luasnip = "⋗",
                        buffer = "Ω",
                        path = "🖫",
                        emoji = "✨",
                        cmp_nvim_r = "R",
                    }

                    local source = menu_icon[entry.source.name] or entry.source.name
                    if entry.source.name == "nvim_lsp" then
                        local client = entry.source.source.client
                        if client then
                            source = string.format("λ [%s]", client.name)
                        else
                            source = "λ"
                        end
                    end
                    vim_item.menu = source
                    vim_item.dup = dups[entry.source.name] or 0
                    return vim_item
                end,
            })(entry, item)
            if color_item.abbr_hl_group then
                item.kind_hl_group = color_item.abbr_hl_group
                item.kind = color_item.abbr
            end
            return item
        end,
    },
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
        { name = "fuzzy_buffer" },
    }),
})

cmp.setup.filetype({ "gitrebase" }, {
    sources = cmp.config.sources({
        { name = "git", priority = 100 },
        { name = "async_path", priority = 50 },
        { name = "fuzzy_buffer", priority = 50 },
        { name = "emoji", insert = true, priority = 20 },
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
            name = "nvim_lsp_document_symbol",
            group_index = 1,
            priority = 100,
        },
        {
            name = "fuzzy_buffer",
            group_index = 1,
            priority = 60,
        },
        {
            name = "buffer-lines",
            group_index = 2,
            priority = 90,
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
        },
    },
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

local tex_sources = vim.deepcopy(default_sources)
local latex_source = {
    name = "lua-latex-symbols",
    group_index = 1,
    priority = 100,
    keyword_length = 2,
}
table.insert(tex_sources, 1, latex_source)

-- TODO: Do we need to list vimtex as source? Seems to work fine without it.
-- table.insert(tex_sources, 2, {
--     name = "vimtex",
--     group_index = 1,
--     priority = 95
-- })

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
    {
        name = "buffer-lines",
        group_index = 2,
        priority = 5,
        keyword_length = 4,
        max_item_count = 50,
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
    name = "cmp_nvim_r",
    priority = 100,
    keyword_length = 2,
}
table.insert(r_sources, 1, r_source)

cmp.setup.filetype("r", {
    sources = r_sources,
})

-- https://github.com/gitaarik/nvim-cmp-toggle/blob/b3bbf76cf6412738b7c9e48e1419f7bb78e71f99/plugin/nvim_cmp_toggle.lua
local function toggle_autocomplete()
    local current_setting = cmp.get_config().completion.autocomplete
    if current_setting and #current_setting > 0 then
        cmp.setup({ completion = { autocomplete = false } })
        vim.notify("Autocomplete disabled")
    else
        cmp.setup({ completion = { autocomplete = { cmp.TriggerEvent.TextChanged } } })
        vim.notify("Autocomplete enabled")
    end
end

vim.api.nvim_create_user_command("NvimCmpToggle", toggle_autocomplete, { desc = "Toggle nvim-cmp autocomplete." })

-- Set a keymap:
vim.api.nvim_set_keymap("n", "<Leader>tc", "<cmd>NvimCmpToggle<CR>", { noremap = true, silent = true })

-- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#add-parentheses-after-selecting-function-or-method-item
-- If you want insert `(` after select function or method item
if vim.g.use_autopairs then
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
