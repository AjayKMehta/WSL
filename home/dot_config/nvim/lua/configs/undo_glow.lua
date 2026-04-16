local undo_glow = require("undo-glow")
local m = require("utils.mappings")

local config = {
    animation = {
        enabled = true,
        duration = 300,
        animation_type = "zoom",
    },
    highlights = {
        undo = {
            hl_color = { bg = "#DD0000" },
        },
        redo = {
            hl_color = { bg = "#59dc1c" },
        },
        yank = {
            hl_color = { bg = "#F1D13C" },
        },
        paste = {
            hl_color = { bg = "#85496E" },
        },
        comment = {
            hl_color = { bg = "#605640" },
        },
        cursor = {
            hl_color = { bg = "#FA8D06" },
        },
    },
    priority = 4096, -- so that it will work with render-markdown.nvim
}

undo_glow.setup(config)

m.map_desc("n", "u", undo_glow.undo, "Undo with highlight")
m.map_desc("n", "U", undo_glow.redo, "Redo with highlight")
m.map_desc("n", "p", undo_glow.paste_below, "Paste below with highlight")
m.map_desc("n", "P", undo_glow.paste_above, "Paste above with highlight")
-- Don't create keymaps for search because interfere with flash.nvim.

m.map_desc_dynamic({ "n", "x" }, "gc", function()
    -- Restore cursor after comment
    local pos = vim.fn.getpos(".")
    vim.schedule(function()
        vim.fn.setpos(".", pos)
    end)
    return undo_glow.comment()
end, "Toggle comment with highlight")

m.map_desc("o", "gc", undo_glow.comment_textobject, "Comment textobject with highlight")

m.map_desc_dynamic("n", "gcc", undo_glow.comment_line, "Toggle comment line with highlight")

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    callback = require("undo-glow").yank,
})

vim.api.nvim_create_autocmd("CursorMoved", {
    desc = "Highlight when cursor moved significantly",
    callback = function()
        require("undo-glow").cursor_moved({
            animation = {
                animation_type = "slide",
            },
            { "mason", "lazy", "help", "git" },
        })
    end,
})
