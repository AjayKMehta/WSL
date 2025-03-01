local M = {}

M.map = vim.keymap.set

-- First word in desc will be used for group heading in NvChad cheatsheet
M.map_desc = function(mode, keys, cmd, desc)
    return M.map(mode, keys, cmd, { silent = true, desc = desc, noremap = true })
end

M.map_desc_dynamic = function(mode, keys, cmd, desc)
    return M.map(mode, keys, cmd, { noremap = true, silent = true, desc = desc, expr = true })
end

M.map_buf = function(bufnr, mode, keys, cmd, desc)
    return M.map(mode, keys, cmd, { noremap = true, silent = true, desc = desc, buffer = bufnr })
end

return M
