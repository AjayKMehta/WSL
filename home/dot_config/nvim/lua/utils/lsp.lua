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

M.on_attach = function(client, bufnr)
    local map_buf = require("utils.mappings").map_buf
    local has_client = client ~= nil
    if has_client and client.supports_method("codeLensProvider") then
        vim.lsp.codelens.refresh()
    end
    if has_client and client.supports_method("inlayHintProvider") then
        vim.lsp.inlay_hint.enable(true)
        local function toggle_hints()
            local enabled = vim.lsp.inlay_hint.is_enabled()
            local start_msg = enabled and "Disabling" or "Enabling"
            print(start_msg .. " inlay hints")
            vim.lsp.inlay_hint.enable(not enabled)
        end

        map_buf(bufnr, "n", "<leader>lth", toggle_hints, "Lsp Toggle inlay hints")
    end

    map_buf(bufnr, "n", "<leader>lD", vim.lsp.buf.declaration, "Lsp Go to declaration")

    map_buf(bufnr, "n", "<leader>ld", vim.lsp.buf.definition, "Lsp Go to definition")
    map_buf(bufnr, "n", "<F12>", vim.lsp.buf.definition, "Lsp Go to definition")

    map_buf(bufnr, "n", "<leader>lr", vim.lsp.buf.references, "Lsp Show references")

    map_buf(bufnr, "n", "<leader>lT", vim.lsp.buf.type_definition, "Lsp Go to type definition")

    map_buf(bufnr, "n", "<leader>li", vim.lsp.buf.implementation, "Lsp Go to implementation")

    map_buf(bufnr, "n", "<leader>lh", vim.lsp.buf.signature_help, "Lsp Show signature help")

    map_buf(bufnr, "n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, "Lsp Add workspace folder")
    map_buf(bufnr, "n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, "Lsp Remove workspace folder")
    map_buf(bufnr, "n", "<leader>lwl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "Lsp List workspace folders")

    map_buf(bufnr, "n", "<leader>ra", function()
        require("nvchad.lsp.renamer")()
    end, "Lsp NvRenamer")

    map_buf(bufnr, { "n", "v" }, "<leader>lc", vim.lsp.buf.code_action, "Lsp Code action")

    if client.name == "ruff" then
        -- Disable hover in favor of basedpyright
        client.server_capabilities.hoverProvider = false
    end
end

M.get_capabilities = function(register_dynamic)
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
    -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
    capabilities.textDocument.foldingRange = {
        -- https://github.com/seblyng/roslyn.nvim/issues/147#issuecomment-2655112596
        dynamicRegistration = register_dynamic,
        lineFoldingOnly = true,
    }

    capabilities.textDocument.completion.completionItem = {
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

    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" },
    }

    local ok, cmp_nvim_lsp = require("utils").is_loaded("cmp_nvim_lsp")

    if ok then
        -- https://github.com/hrsh7th/cmp-nvim-lsp/issues/38#issuecomment-1815265121
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
    end

    ---@diagnostic disable-next-line: redefined-local
    local ok, cmp_lsp_file_ops = require("utils").is_loaded("lsp-file-operations")
    if ok then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp_file_ops.default_capabilities())
    end
    return capabilities
end

return M
