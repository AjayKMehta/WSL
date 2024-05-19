require("syntax-tree-surfer").setup({})

local opts = { noremap = true, silent = true }

local desc_opts = function(desc)
    vim.tbl_deep_extend("force", opts, { desc = desc })
end

-- NOTE: Moving to mappings.lua didn't work!

-- Normal Mode Swapping:
-- Swap The Master Node relative to the cursor with its siblings, Dot Repeatable
vim.keymap.set("n", "vU", function()
    vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
    return "g@l"
end, { silent = true, expr = true, desc = "Swap master node with above" })
vim.keymap.set("n", "vD", function()
    vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
    return "g@l"
end, { silent = true, expr = true, desc = "Swap master node with below" })

-- Swap Current Node at the Cursor with its siblings, Dot Repeatable
vim.keymap.set("n", "vu", function()
    vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
    return "g@l"
end, { silent = true, expr = true, desc = "Swap current node with above" })
vim.keymap.set("n", "vd", function()
    vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
    return "g@l"
end, { silent = true, expr = true, desc = "Swap current node with below" })

-- Visual Selection from Normal Mode
vim.keymap.set("n", "vx", "<cmd>STSSelectMasterNode<cr>", desc_opts("Select master node"))
vim.keymap.set("n", "vn", "<cmd>STSSelectCurrentNode<cr>", desc_opts("Select current node"))

-- Select Nodes in Visual Mode
vim.keymap.set("x", "J", "<cmd>STSSelectNextSiblingNode<cr>", desc_opts("Select next sibling"))
vim.keymap.set("x", "K", "<cmd>STSSelectPrevSiblingNode<cr>", desc_opts("Select previous sibling"))
vim.keymap.set("x", "H", "<cmd>STSSelectParentNode<cr>", desc_opts("Select parent node"))
vim.keymap.set("x", "L", "<cmd>STSSelectChildNode<cr>", desc_opts("Select child node."))

-- Swapping Nodes in Visual Mode
vim.keymap.set("x", "<A-j>", "<cmd>STSSwapNextVisual<cr>", desc_opts("Swap with next sibling"))
vim.keymap.set("x", "<A-k>", "<cmd>STSSwapPrevVisual<cr>", desc_opts("Swap with previous sibling"))

-- Syntax Tree Surfer V2 Mappings
-- Targeted Jump with virtual_text
local sts = require("syntax-tree-surfer")
vim.keymap.set("n", "gjv", function()
    sts.targeted_jump({ "variable_declaration" })
end, { silent = true, expr = true, desc = "Select variable declaration." })
vim.keymap.set("n", "gjf", function()
    -- Lua uses "function" while Python uses "function_definition"
    sts.targeted_jump({ "function", "arrrow_function", "function_definition" })
end, { silent = true, expr = true, desc = "Select function definition." })
vim.keymap.set("n", "gji", function()
    sts.targeted_jump({ "if_statement" })
end, { silent = true, expr = true, desc = "Select if statements." })
vim.keymap.set("n", "gjl", function()
    sts.targeted_jump({ "for_statement", "while_statement" })
end, { silent = true, expr = true, desc = "Select loop statements." })
vim.keymap.set("n", "gja", function() -- jump to all that you specify
    sts.targeted_jump({
        "function",
        "if_statement",
        "else_clause",
        "else_statement",
        "elseif_statement",
        "for_statement",
        "while_statement",
        "switch_statement",
    })
end, { noremap = true, silent = true, desc = "Select any statement." })

-- filtered_jump --
-- "default" means that you jump to the default_desired_types or your last jump types
vim.keymap.set("n", "<A-n>", function()
    sts.filtered_jump("default", true) --> true means jump forward
end, opts)
vim.keymap.set("n", "<A-p>", function()
    sts.filtered_jump("default", false) --> false means jump backwards
end, opts)

-- Holds a node, or swaps the held node
vim.keymap.set("n", "gh", "<cmd>STSSwapOrHold<cr>", { noremap = true, silent = true, desc = "Hold or swap node." })
vim.keymap.set(
    "x",
    "gnh",
    "<cmd>STSSwapOrHoldVisual<cr>",
    { noremap = true, silent = true, desc = "Hold or swap node." }
)
