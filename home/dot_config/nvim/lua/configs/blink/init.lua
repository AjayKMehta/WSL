local u = require("utils")
local excluded_ftypes = u.excluded_ftypes

dofile(vim.g.base46_cache .. "blink")

local M = {}

M.is_enabled = function()
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == "c" then
        return true
    end
    return not vim.tbl_contains(excluded_ftypes, vim.bo.filetype)
        and vim.bo.buftype ~= "prompt"
        and vim.b.completion ~= false
end

-- https://cmp.saghen.dev/recipes.html#avoid-multi-line-completion-ghost-text
M.get_menu_direction_priority = function()
    local ctx = require("blink.cmp").get_context()
    local item = require("blink.cmp").get_selected_item()
    if ctx == nil or item == nil then
        return { "s", "n" }
    end

    local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
    local is_multi_line = item_text:find("\n") ~= nil

    -- after showing the menu upwards, we want to maintain that direction
    -- until we re-open the menu, so store the context id in a global variable
    if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
        vim.g.blink_cmp_upwards_ctx_id = ctx.id
        return { "n", "s" }
    end
    return { "s", "n" }
end

-- https://cmp.saghen.dev/recipes.html#nvim-web-devicons-lspkind
M.get_kind_icon_text = function(ctx)
    local icon = ctx.kind_icon
    if vim.tbl_contains({ "Path" }, ctx.source_name) then
        local is_loaded, nwd = u.is_loaded("nvim-web-devicons")
        if is_loaded then
            local dev_icon, _ = nwd.get_icon(ctx.label)
            if dev_icon then
                icon = dev_icon
            end
        end
    else
        local is_loaded, lk = u.is_loaded("lspkind")
        if is_loaded then
            icon = lk.symbol_map[ctx.kind] or ""
        end
    end
    if ctx.item.source_name == "LSP" then
        local is_loaded, nhc = u.is_loaded("nvim-highlight-colors")
        local color_item = nhc.format(ctx.item.documentation, { kind = ctx.kind })
        if color_item and color_item.abbr ~= "" then
            icon = color_item.abbr
        end
    end
    return icon .. ctx.icon_gap
end

-- Optionally, use the highlight groups from nvim-web-devicons
-- You can also add the same function for `kind.highlight` if you want to
-- keep the highlight groups in sync with the icons.
M.get_kind_icon_highlight = function(ctx)
    local highlight = ctx.kind_hl
    if vim.tbl_contains({ "Path" }, ctx.source_name) then
        local is_loaded, nwd = u.is_loaded("nvim-web-devicons")
        if is_loaded then
            local dev_icon, dev_hl = nwd.get_icon(ctx.label)
            if dev_icon then
                highlight = dev_hl
            end
        end
    elseif ctx.item.source_name == "LSP" then
        local is_loaded, nhc = u.is_loaded("nvim-highlight-colors")
        local color_item = nhc.format(ctx.item.documentation, { kind = ctx.kind })
        if color_item and color_item.abbr_hl_group then
            highlight = color_item.abbr_hl_group
        end
    end
    return highlight
end

return M
