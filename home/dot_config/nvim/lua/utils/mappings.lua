local M = {}

M.map = vim.keymap.set

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
