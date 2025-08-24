local M = {}
-- See https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/protocol.lua
local methods = vim.lsp.protocol.Methods

local mappings = require("utils.mappings")
local map_desc = mappings.map_desc

local function toggle_codelens()
    local enabled = vim.g.lsp_codelens_enable
    print((enabled and "Disabling" or "Enabling") .. " codelens globally")
    vim.g.lsp_codelens_enable = not enabled
end

map_desc("n", "<leader>lTc", toggle_codelens, "LSP Toggle (global) Codelens")

local function toggle_doc_highlight()
    local enabled = vim.g.lsp_document_highlight_enable
    print((enabled and "Disabling" or "Enabling") .. " document highlighting globally")
    vim.g.lsp_document_highlight_enable = not enabled
end

map_desc("n", "<leader>lTd", toggle_doc_highlight, "LSP Toggle (global) Document highlighting")

M.on_attach = function(client, bufnr)
    local map_buf = mappings.map_buf

    map_buf(bufnr, "n", "<leader>lD", vim.lsp.buf.declaration, "Lsp Go to declaration")

    map_buf(bufnr, "n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, "Lsp Add workspace folder")
    map_buf(bufnr, "n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, "Lsp Remove workspace folder")
    map_buf(bufnr, "n", "<leader>lwl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "Lsp List workspace folders")

    map_buf(bufnr, "n", "[e", function()
        vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
    end, "Previous error")
    map_buf(bufnr, "n", "]e", function()
        vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
    end, "Next error")

    if not client then
        return
    end

    if client.name == "ruff" then
        -- Disable hover in favor of basedpyright
        client.server_capabilities.hoverProvider = false
    end

    if client:supports_method(methods.workspace_codeLens_refresh) then
        vim.lsp.codelens.refresh()
    end
    -- Use CTRL-X_CTRL-O to invoke in INSERT mode. Use CTRL-Y to select an item from the completion menu.
    -- Probably should disable nvim-cmp before using.
    if client:supports_method(methods.textDocument_completion) then
        vim.lsp.completion.enable(true, client.id, bufnr, {
            autotrigger = true,
            convert = function(item)
                return { abbr = item.label:gsub("%b()", "") }
            end,
        })
    end

    if client:supports_method(methods.textDocument_inlayHint) then
        vim.lsp.inlay_hint.enable(true)
        local function toggle_hints()
            local enabled = vim.lsp.inlay_hint.is_enabled()
            local start_msg = enabled and "Disabling" or "Enabling"
            print(start_msg .. " inlay hints")
            vim.lsp.inlay_hint.enable(not enabled)
        end

        map_buf(bufnr, "n", "<leader>lth", toggle_hints, "Lsp Toggle inlay hints")
    end

    if client:supports_method(methods.textDocument_definition) then
        map_buf(bufnr, "n", "<leader>ld", vim.lsp.buf.definition, "Lsp Go to definition")
        map_buf(bufnr, "n", "<F12>", vim.lsp.buf.definition, "Lsp Go to definition")
    end

    if client:supports_method(methods.textDocument_signatureHelp) then
        map_buf(bufnr, "n", "<leader>lh", vim.lsp.buf.signature_help, "Lsp Show signature help")
    end

    if client:supports_method(methods.textDocument_documentHighlight) then
        local under_cursor_highlights_group = vim.api.nvim_create_augroup("cursor_highlights", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
            group = under_cursor_highlights_group,
            desc = "Highlight references under the cursor",
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
            group = under_cursor_highlights_group,
            desc = "Clear highlight references",
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

M.get_capabilities = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem = {
        contextSupport = true,
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

    -- TODO: Remove after switching to blink.
    local is_loaded = require("utils").is_loaded

    local loaded_cmp, cmp_nvim_lsp = is_loaded("cmp_nvim_lsp")
    if loaded_cmp then
        -- https://github.com/hrsh7th/cmp-nvim-lsp/issues/38#issuecomment-1815265121
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
    end

    local loaded_blink, blink = is_loaded("blink.cmp")
    if loaded_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
    end
    return capabilities
end

return M
