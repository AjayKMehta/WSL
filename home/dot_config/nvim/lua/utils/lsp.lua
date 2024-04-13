local M = {}

local function is_diag_for_cur_pos()
    local diagnostics = vim.diagnostic.get(0)
    local pos = vim.api.nvim_win_get_cursor(0)
    if #diagnostics == 0 then
        return false
    end
    local message = vim.tbl_filter(function(d)
        return d.col == pos[2] and d.lnum == pos[1] - 1
    end, diagnostics)
    return #message > 0
end

local function hover_handler()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if winid then
        return
    end
    local ft = vim.bo.filetype
    if vim.tbl_contains({ "vim", "help" }, ft) then
        vim.cmd("silent! h " .. vim.fn.expand("<cword>"))
    elseif vim.tbl_contains({ "man" }, ft) then
        vim.cmd("silent! Man " .. vim.fn.expand("<cword>"))
    elseif is_diag_for_cur_pos() then
        vim.diagnostic.open_float()
    else
        vim.lsp.buf.hover()
    end
end

M.on_attach = function(client, bufnr)
    local map_buf = require("utils.mappings").map_buf

    map_buf(bufnr, "n", "<leader>lD", vim.lsp.buf.declaration, "Lsp Go to declaration")

    map_buf(bufnr, "n", "<leader>ld", vim.lsp.buf.definition, "Lsp Go to definition")
    map_buf(bufnr, "n", "<F12>", vim.lsp.buf.definition, "Lsp Go to definition")

    map_buf(bufnr, "n", "<leader>lr", vim.lsp.buf.references, "Lsp Show references")

    map_buf(bufnr, "n", "<leader>lT", vim.lsp.buf.type_definition, "Lsp Go to type definition")

    map_buf(bufnr, "n", "K", hover_handler, "Lsp hover information")

    map_buf(bufnr, "n", "<leader>li", vim.lsp.buf.implementation, "Lsp Go to implementation")

    map_buf(bufnr, "n", "<leader>lh", vim.lsp.buf.signature_help, "Lsp Show signature help")

    map_buf(bufnr, "n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Lsp Add workspace folder")
    map_buf(bufnr, "n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Lsp Remove workspace folder")
    map_buf(bufnr, "n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "Lsp List workspace folders")

    map_buf(bufnr, "n", "<leader>ra", function()
        require("nvchad.lsp.renamer")()
    end, "Lsp NvRenamer")

    map_buf({ "n", "v" }, "<leader>lc", vim.lsp.buf.code_action, "Lsp Code action")
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

M.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

local ok, cmp_nvim_lsp = require("utils").is_loaded("cmp_nvim_lsp")

if ok then
    -- https://github.com/hrsh7th/cmp-nvim-lsp/issues/38#issuecomment-1815265121
    M.capabilities = vim.tbl_deep_extend("force", M.capabilities, cmp_nvim_lsp.default_capabilities())
end

return M
