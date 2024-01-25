require("syntax-tree-surfer").setup {}

local opts = { noremap = true, silent = true }

local desc_opts = function(desc)
    vim.tbl_deep_extend('force', opts, { desc = desc })
end

-- Normal Mode Swapping:
-- Swap The Master Node relative to the cursor with its siblings, Dot Repeatable
vim.keymap.set("n", "vU", function()
    vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
    return "g@l"
end, { silent = true, expr = true, desc = 'Swap master node with above' })
vim.keymap.set("n", "vD", function()
    vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
    return "g@l"
end, { silent = true, expr = true, desc = 'Swap master node with below' })

-- Swap Current Node at the Cursor with its siblings, Dot Repeatable
vim.keymap.set("n", "vu", function()
    vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
    return "g@l"
end, { silent = true, expr = true, desc = 'Swap current node with above' })
vim.keymap.set("n", "vd", function()
    vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
    return "g@l"
end, { silent = true, expr = true, desc = 'Swap current node with below' })

-- Visual Selection from Normal Mode
vim.keymap.set("n", "vx", "<cmd>STSSelectMasterNode<cr>", desc_opts 'Select master node')
vim.keymap.set("n", "vn", "<cmd>STSSelectCurrentNode<cr>", desc_opts 'Select current node')

-- Select Nodes in Visual Mode
vim.keymap.set("x", "J", "<cmd>STSSelectNextSiblingNode<cr>", desc_opts 'Select next sibling')
vim.keymap.set("x", "K", "<cmd>STSSelectPrevSiblingNode<cr>", desc_opts 'select previous sibling')
vim.keymap.set("x", "H", "<cmd>STSSelectParentNode<cr>", desc_opts 'Select parent node')
vim.keymap.set("x", "L", "<cmd>STSSelectChildNode<cr>", desc_opts 'Select child nodes.')

-- Swapping Nodes in Visual Mode
vim.keymap.set("x", "<A-j>", "<cmd>STSSwapNextVisual<cr>", desc_opts 'Swap with next sibling')
vim.keymap.set("x", "<A-k>", "<cmd>STSSwapPrevVisual<cr>", desc_opts 'Swap with previous sibling')
