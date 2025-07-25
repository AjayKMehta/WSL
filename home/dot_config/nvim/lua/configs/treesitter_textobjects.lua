local utils = require("utils.mappings")
local map = utils.map
local map_desc = utils.map_desc
local to = require("nvim-treesitter-textobjects")
local sel = require("nvim-treesitter-textobjects.select")
local swap = require("nvim-treesitter-textobjects.swap")
local move = require("nvim-treesitter-textobjects.move")

local config = {
    select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
        },
    },
    move = {
        -- whether to set jumps in the jumplist
        set_jumps = true,
    },
}

to.setup(config)

-- Select

map_desc({ "x", "o" }, "a=", function()
    sel.select_textobject("@assignment.outer", "textobjects")
end, "Select outer part of an assignment")

map_desc({ "x", "o" }, "i=", function()
    sel.select_textobject("@assignment.inner", "textobjects")
end, "Select inner part of an assignment")

map_desc({ "x", "o" }, "=L", function()
    sel.select_textobject("@assignment.lhs", "textobjects")
end, "Select LHS of an assignment")

map_desc({ "x", "o" }, "=R", function()
    sel.select_textobject("@assignment.rhs", "textobjects")
end, "Select RHS of an assignment")

map_desc({ "x", "o" }, "af", function()
    sel.select_textobject("@call.outer", "textobjects")
end, "Select outer part of a function call")

map_desc({ "x", "o" }, "if", function()
    sel.select_textobject("@call.inner", "textobjects")
end, "Select inner part of a function call")

map_desc({ "x", "o" }, "aM", function()
    sel.select_textobject("@function.outer", "textobjects")
end, "Select outer part of a function/method definition")

map_desc({ "x", "o" }, "iM", function()
    sel.select_textobject("@function.inner", "textobjects")
end, "Select inner part of a function/method definition")

map_desc({ "x", "o" }, "aa", function()
    sel.select_textobject("@parameter.outer", "textobjects")
end, "Select outer part of a parameter/argument")

map_desc({ "x", "o" }, "ia", function()
    sel.select_textobject("@parameter.inner", "textobjects")
end, "Select inner part of a parameter/argument")

map_desc({ "x", "o" }, "ai", function()
    sel.select_textobject("@conditional.outer", "textobjects")
end, "Select outer part of a conditional")

map_desc({ "x", "o" }, "ii", function()
    sel.select_textobject("@conditional.inner", "textobjects")
end, "Select inner part of a conditional")

map_desc({ "x", "o" }, "al", function()
    sel.select_textobject("@loop.outer", "textobjects")
end, "Select outer part of a loop")

map_desc({ "x", "o" }, "il", function()
    sel.select_textobject("@loop.inner", "textobjects")
end, "Select inner part of a loop")

map_desc({ "x", "o" }, "ac", function()
    sel.select_textobject("@class.outer", "textobjects")
end, "Select outer part of a class")

map_desc({ "x", "o" }, "ic", function()
    sel.select_textobject("@class.inner", "textobjects")
end, "Select inner part of a class")

-- Swap

map_desc("n", "<leader>na", function()
    swap.swap_next("@parameter.inner")
end, "Swap parameter with next")

map_desc("n", "<leader>pa", function()
    swap.swap_previous("@parameter.inner")
end, "Swap parameter with previous")

map_desc("n", "<leader>n:", function()
    swap.swap_next("@property.outer")
end, "Swap property with next")

map_desc("n", "<leader>p:", function()
    swap.swap_previous("@property.outer")
end, "Swap property with previous")

map_desc("n", "<leader>nm", function()
    swap.swap_next("@function.outer")
end, "Swap function with next")

map_desc("n", "<leader>pm", function()
    swap.swap_previous("@function.outer")
end, "Swap function with previous")

-- Move

map_desc("n", "]m", function()
    move.goto_next_start("@function.outer")
end, "Go to next method/function def start")

map_desc("n", "[m", function()
    move.goto_previous_start("@function.outer")
end, "Go to previous method/function def start")

map_desc("n", "]M", function()
    move.goto_next_end("@function.outer")
end, "Go to next method/function def end")

map_desc("n", "[M", function()
    move.goto_previous_end("@function.outer")
end, "Go to previous method/function def end")

map_desc("n", "]f", function()
    move.goto_next_start("@call.outer")
end, "Go to next function call start")

map_desc("n", "[f", function()
    move.goto_previous_start("@call.outer")
end, "Go to previous function call start")

map_desc("n", "]F", function()
    move.goto_next_end("@call.outer")
end, "Go to next function call end")

map_desc("n", "[F", function()
    move.goto_previous_end("@call.outer")
end, "Go to previous function call end")

map_desc("n", "]c", function()
    move.goto_next_start("@class.outer")
end, "Go to next class start")

map_desc("n", "[c", function()
    move.goto_previous_start("@class.outer")
end, "Go to previous class start")

map_desc("n", "]C", function()
    move.goto_next_end("@class.outer")
end, "Go to next class end")

map_desc("n", "[C", function()
    move.goto_previous_end("@class.outer")
end, "Go to previous class end")

map_desc("n", "]i", function()
    move.goto_next_start("@conditional.outer")
end, "Go to next conditional start")

map_desc("n", "[i", function()
    move.goto_previous_start("@conditional.outer")
end, "Go to previous conditional start")

map_desc("n", "]I", function()
    move.goto_next_end("@conditional.outer")
end, "Go to next conditional end")

map_desc("n", "[I", function()
    move.goto_previous_end("@conditional.outer")
end, "Go to previous conditional end")

map_desc("n", "]{", function()
    move.goto_next_start("@loop.outer")
end, "Go to next loop start")

map_desc("n", "[{", function()
    move.goto_previous_start("@loop.outer")
end, "Go to previous loop start")

map_desc("n", "]}", function()
    move.goto_next_end("@loop.outer")
end, "Go to next loop end")

map_desc("n", "[{", function()
    move.goto_previous_end("@loop.outer")
end, "Go to previous loop end")
