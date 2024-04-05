local M = {}

M.map = vim.keymap.set

-- First word in desc will be used for group heading in NvChad cheatsheet
M.map_desc = function(mode, keys, cmd, desc)
    return M.map(mode, keys, cmd, { silent = true, desc = desc })
end

M.map_buf = function(bufnr, mode, keys, cmd, desc)
    return M.map(mode, keys, cmd, { noremap = true, silent = true, buffer = bufnr, desc = desc })
end

return M
