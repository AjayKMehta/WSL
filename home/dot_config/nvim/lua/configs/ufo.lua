local map_desc = require("utils.mappings").map_desc

-- https://github.com/kevinhwang91/nvim-ufo#customize-fold-text
local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (" 󰁂 %d "):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may be less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, "MoreMsg" })
    return newVirtText
end

-- global handler
-- `handler` is the 2nd parameter of `setFoldVirtTextHandler`,
-- check out `./lua/ufo.lua` and search `setFoldVirtTextHandler` for detail.
require("ufo").setup({
    open_fold_hl_timeout = 150,
    close_fold_kinds_for_ft = {
        default = { "imports", "comment" },
        json = { "array" },
        cs = { "comment" },
    },
    provider_selector = function(bufnr, filetype, buftype)
        if filetype == "lua" then -- Not sure why this gives error with LSP!
            return { "treesitter", "indent" }
        end
        return { "lsp", "indent" }
    end,
    fold_virt_text_handler = handler,
    preview = {
        -- https://github.com/kevinhwang91/nvim-ufo?tab=readme-ov-file#preview-function-table
        mappings = {
            scrollB = "<C-b>",
            scrollF = "<C-f>",
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
        },
    },
})

map_desc("n", "]Z", function()
    require("ufo").goNextClosedFold()
end, "UFO Go to next closed fold")
map_desc("n", "[Z", function()
    require("ufo").goPreviousClosedFold()
end, "UFO Go to previous closed fold")
map_desc("n", "zK", function()
    require("ufo").peekFoldedLinesUnderCursor()
end, "UFO Peek fold")
