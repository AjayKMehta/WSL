-- For info on how to configure servers, see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md.

-- This clashes with noice: https://github.com/NvChad/NvChad/issues/1656#issuecomment-1304671629
-- local on_attach = require("nvchad.configs.lspconfig").on_attach

local on_attach = require("utils.lsp").on_attach

-- 💡 Uncommenting the line below would disable semantic tokens.
-- https://github.com/NvChad/NvChad/blob/6833c60694a626615911e379d201dd723511546d/lua/nvchad/configs/lspconfig.lua#L39
-- local on_init = require("nvchad.configs.lspconfig").on_init

local capabilities = require("nvchad.configs.lspconfig").capabilities

dofile(vim.g.base46_cache .. "lsp")

capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- https://github.com/hrsh7th/cmp-nvim-lsp/issues/38#issuecomment-1815265121
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

local lspconfig = require("lspconfig")

-- if you just want default config for the servers then put them in a table
-- for list: help lspconfig-server-configurations.
local servers = {
    -- Web
    "html",
    "cssls",
    "tsserver",
    "jqls",

    "dockerls",

    -- CICD + Shell
    "codeqlls",
    "bashls",

    -- Misc
    "ltex",
    "ast_grep",

    -- TOML
    "taplo",

    -- Graphviz
    "dotls",

    -- Python
    "ruff_lsp",
    -- TODO: Re-enable in future?
    -- "pylyzer",
    "basedpyright",

    -- R
    "r_language_server",
}

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach,
        -- on_init = on_init,
        capabilities = capabilities,
    })
end

lspconfig.jsonls.setup({
    on_attach = on_attach,
    -- on_init = on_init,
    capabilities = capabilities,
    settings = {
        json = {
            -- https://github.com/b0o/SchemaStore.nvim#usage
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
})

lspconfig.hls.setup({
    on_attach = on_attach,
    -- on_init = on_init,
    capabilities = capabilities,
    filetypes = { "haskell", "lhaskell", "cabal" },
})

lspconfig.lua_ls.setup({
    on_attach = on_attach,
    -- on_init = on_init,
    capabilities = capabilities,
    flags = {
        debounce_text_changes = 150,
    },
    single_file_support = true,
    -- https://github.com/NvChad/NvChad/issues/817
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            telemetry = {
                enable = false,
            },
            completion = {
                callSnippet = "Replace",
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    [vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types"] = true,
                    [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
            hint = {
                enable = true,
                setType = false,
                paramType = true,
            },
            type = {
                castNumberToInteger = true,
            },
        },
    },
})

lspconfig.marksman.setup({
    on_attach = on_attach,
    -- on_init = on_init,
    capabilities = capabilities,
    -- also needs:
    -- $home/.config/marksman/config.toml :
    -- [core]
    -- markdown.file_extensions = ["md", "markdown", "qmd"]
    filetypes = { "markdown", "quarto" },
    root_dir = require("lspconfig.util").root_pattern(".git", ".marksman.toml", "_quarto.yml"),
})

vim.g.OmniSharp_start_without_solution = 1
vim.g.OmniSharp_timeout = 5

lspconfig.yamlls.setup({
    on_attach = on_attach,
    -- on_init = on_init,
    capabilities = capabilities,
    settings = {
        yaml = {
            completion = true,
            customTags = {
                "!reference sequence", -- necessary for gitlab-ci.yaml files        "!And",
                "!And sequence",
                "!If",
                "!If sequence",
                "!Not",
                "!Not sequence",
                "!Equals",
                "!Equals sequence",
                "!Or",
                "!Or sequence",
                "!FindInMap",
                "!FindInMap sequence",
                "!Base64",
                "!Join",
                "!Join sequence",
                "!Cidr",
                "!Ref",
                "!Sub",
                "!Sub sequence",
                "!GetAtt",
                "!GetAZs",
                "!ImportValue",
                "!ImportValue sequence",
                "!Select",
                "!Select sequence",
                "!Split",
                "!Split sequence",
            },
            hover = true,
            schemaStore = { enable = true },
            validate = true,
        },
    },
})

require("configs.powershell")

lspconfig.basedpyright.setup({
    on_attach = on_attach,
    -- on_init = on_init,
    capabilities = capabilities,
    filetypes = { "python" },
    settings = {
        basedpyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "standard",
            },
            -- https://detachhead.github.io/basedpyright/#/configuration?id=type-check-diagnostics-settings
            -- Severity level can be boolean or a string value of "none", "warning", "information", or "error".
            diagnosticSeverityOverrides = {
                -- https://github.com/DetachHead/basedpyright/issues/168
                reportMissingSuperCall = false,
                reportUnusedImport = "warning",
                reportUnnecessaryIsInstance = "warning",
                reportImplicitStringConcatenation = "warning",
                analyzeUnannotatedFunctions = false,
                strictDictionaryInference = true,
                strictListInference = true,
                strictParameterNoneValue = true,
                deprecateTypingAliases = true,
                reportPropertyTypeMismatch = "warning",
                true,
                reportMissingImports = "warning",
                reportDuplicateImport = "error",
                reportImportCycles = "error",
                reportConstantRedefinition = "error",
                reportIncompatibleMethodOverride = "error",
                reportUndefinedVariable = false, -- ruff handles this with F822
                reportUnusedVariable = false, -- let ruff handle this
                reportAssertAlwaysTrue = "error",
                reportInconsistentOverload = "warning",
                reportInvalidTypeArguments = "warning",
                reportNoOverloadImplementation = "warning",
                reportRedeclaration = "error",
                reportUntypedNamedTuple = "warning",
                reportPrivateUsage = "warning",
                reportTypeCommentUsage = "warning", -- type comments are deprecated since Python 3.6
                reportDeprecated = "warning",
                reportInconsistentConstructor = "error",
                reportUnnecessaryCast = "warning",
                reportUntypedFunctionDecorator = "information",
                reportSelfClsParameterName = "error",
                reportUnnecessaryTypeIgnoreComment = "information",
                -- Based options (not available in regular pyright)
                reportUnreachable = "warning",
                reportAny = true,
                reportIgnoreCommentWithoutRule = "warning",
                reportImplicitRelativeImport = "error",
            },
        },
    },
})

lspconfig.texlab.setup({
    on_attach = on_attach,
    -- on_init = on_init,
    capabilities = capabilities,
    -- https://github.com/latex-lsp/texlab/wiki/configurations
    settings = {
        texlab = {
            bibtexFormatter = "texlab",
            build = {
                auxDirectory = ".",
                executable = "tectonic",
                -- Use V1 CLI. See https://tectonic-typesetting.github.io/book/latest/ref/v2cli.html.
                args = { "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
                forwardSearchAfter = false,
                onSave = false,
            },
            chktex = {
                onEdit = false,
                onOpenAndSave = true,
            },
            diagnosticsDelay = 300,
            -- TODO: Figure this out
            diagnostics = {
                -- allowedPatterns = {},
                -- ignoredPatterns = {"^22:"},
            },
            formatterLineLength = 80,
            forwardSearch = {
                executable = "zathura",
                args = { "--synctex-forward", "%l:1:%f", "%p" },
            },
            latexFormatter = "latexindent",
            latexindent = {
                modifyLineBreaks = false,
            },
        },
    },
})
