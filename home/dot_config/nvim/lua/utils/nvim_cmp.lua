local cmp = require("cmp")
local types = require("cmp.types")
local is_loaded = require("utils").is_loaded

local M = {}

M.limit_lsp_types = function(entry, ctx)
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

M.not_in_string = function()
    local context = require("cmp.config.context")
    return not context.in_treesitter_capture("string") and not context.in_syntax_group("String")
end

-- https://github.com/brenoprata10/nvim-highlight-colors#lspkind-integration
M.format = function(entry, item)
    local dups = { fuzzy_buffer = 1, async_path = 1, nvim_lsp = 0, luasnip = 1 }
    local _, lspkind = is_loaded("lspkind")
    if lspkind ~= nil then
        item = lspkind.cmp_format({
            maxwidth = {
                -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                -- can also be a function to dynamically calculate max width such as
                -- menu = function() return math.floor(0.45 * vim.o.columns) end,
                menu = 50,             -- leading text (labelDetails)
                abbr = 50,             -- actual suggestion item
            },
            ellipsis_char = "...",     -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = false, -- show labelDetails in menu. Disabled by default
            preset = "default",        --codicons",

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
                local menu_icon = {
                    latex_symbols = "",
                    otter = "o",
                    luasnip = "⋗",
                    nvim_lsp = "",
                    buffer = "",
                    cmdline = ":",
                    path = "",
                    cmp_r = "R",
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
    end
    local _, nhc = is_loaded("nvim-highlight-colors")
    if nhc ~= nil then
        local color_item = nhc.format(entry, { kind = item.kind })
        if color_item.abbr_hl_group then
            item.kind_hl_group = color_item.abbr_hl_group
            item.kind = color_item.abbr
        end
    end
    return item
end

return M
