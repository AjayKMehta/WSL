local M = {}

M.on_attach = function(client, bufnr)
    local map_buf = require("utils.mappings").map_buf

    map_buf(bufnr, "n", "gD", vim.lsp.buf.declaration, "Lsp Go to declaration")
    map_buf(bufnr, "n", "gd", vim.lsp.buf.definition, "Lsp Go to definition")
    map_buf(bufnr, "n", "<leader>D", vim.lsp.buf.type_definition, "Lsp Go to type definition")
    map_buf(bufnr, "n", "gr", vim.lsp.buf.references, "Lsp Show references")

    map_buf(bufnr, "n", "K", vim.lsp.buf.hover, "Lsp hover information")

    map_buf(bufnr, "n", "gi", vim.lsp.buf.implementation, "Lsp Go to implementation")

    map_buf(bufnr, "n", "<leader>sh", vim.lsp.buf.signature_help, "Lsp Show signature help")

    map_buf(bufnr, "n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Lsp Add workspace folder")
    map_buf(bufnr, "n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Lsp Remove workspace folder")
    map_buf(bufnr, "n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "Lsp List workspace folders")

    map_buf(bufnr, "n", "<leader>ra", function()
        require("nvchad.lsp.renamer")()
    end, "Lsp NvRenamer")

    map_buf({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Lsp Code action")
end

return M
