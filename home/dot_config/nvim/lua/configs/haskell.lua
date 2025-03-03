local lsp = require("utils.lsp")
local ht = require("haskell-tools")
local bufnr = vim.api.nvim_get_current_buf()

local function on_attach(client, bufnr)
    local map_buf = require("utils.mappings").map_buf

    lsp.on_attach(client, bufnr)
    -- haskell-language-server relies heavily on codeLenses,
    -- so auto-refresh (see advanced configuration) is enabled by default
    map_buf(bufnr, "n", "<leader>+l", vim.lsp.codelens.run, "Haskell Codelens")
    -- Hoogle search for the type signature of the definition under the cursor
    map_buf(bufnr, "n", "<leader>+s", ht.hoogle.hoogle_signature, "Haskell Hoogle Signature")
    -- Evaluate all code snippets
    map_buf(bufnr, "n", "<leader>+e", ht.lsp.buf_eval_all, "Haskell Evaluate Snippets")
    -- Toggle a GHCi repl for the current package
    map_buf(bufnr, "n", "<leader>+p", ht.repl.toggle, "Haskell Toggle GHCi (package)")
    -- Toggle a GHCi repl for the current buffer
    map_buf(bufnr, "n", "<leader>+b", function()
        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
    end, "Haskell Toggle GHCi (buffer)")
    map_buf(bufnr, "n", "<leader>+q", ht.repl.quit, "Haskell Close GHCi")
end

vim.g.haskell_tools = {
    tools = {
        hoogle = { mode = "auto" },
        definition = { hoogle_signature_fallback = true },
        hover = { auto_focus = true },
        repl = { handler = "toggleterm", prefer = "stack" },
    },
    hls = {
        auto_attach = true,
        debug = false, -- HLS debugging
        on_attach = on_attach,
        capabilities = lsp.get_capabilities(true),
        default_settings = {
            haskell = {
                cabalFormattingProvider = "cabal-fmt",
                formattingProvider = "fourmolu",
                maxCompletions = 50,
                plugin = {
                    cabalFmt = { globalOn = true },
                    explicitFixity = { globalOn = true },
                    hlint = { codeActionsOn = true, diagnosticsOn = true },
                    ormolu = { globalOn = true },
                    alternateNumberFormat = { globalOn = true },
                    cabal = {
                        codeActionsOn = true,
                        completionOn = true,
                        diagnosticsOn = true,
                    },
                    callHierarchy = { globalOn = true },
                    changeTypeSignature = { globalOn = true },
                    class = {
                        codeActionsOn = true,
                        codeLensOn = true,
                    },
                    importLens = {
                        codeActionsOn = true,
                        codeLensOn = true,
                    },
                    moduleName = { globalOn = true },
                },
            },
        },
        settings = {
            haskell = {
                formattingProvider = "fourmolu",
                checkProject = true,
            },
        },
    },
    dap = {
        logLevel = "Info",
        auto_discover = true,
    },
}

local ok, telescope = pcall(require, "telescope")
if ok then
    telescope.load_extension("ht")
end
