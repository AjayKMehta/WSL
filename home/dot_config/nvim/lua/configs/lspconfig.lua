-- For info on how to configure servers, see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md.

local lsp = require("utils.lsp")
local on_attach = lsp.on_attach

-- Prevent LSP from overwriting treesitter color settings
-- https://github.com/NvChad/NvChad/issues/1907
vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

-- 💡 Uncommenting the line below would disable semantic tokens.
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/configs/lspconfig.lua#L29
-- local on_init = require("nvchad.configs.lspconfig").on_init

local capabilities = lsp.get_capabilities(true)

dofile(vim.g.base46_cache .. "lsp")

local lspconfig = require("lspconfig")

local mason_path = vim.fn.stdpath("data") .. "/mason"

-- if you just want default config for the servers then put them in a table
-- for list: help lspconfig-server-configurations.
local servers = {
    -- Web
    "html",
    "cssls",
    "ts_ls",

    "dockerls",

    -- CICD + Shell
    "codeqlls",
    "bashls",

    -- Configs
    "taplo",

    -- Graphviz
    "dotls",

    -- R
    "r_language_server",
    "air",
}

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach,
        -- on_init = on_init,
        capabilities = capabilities,
    })
end

lspconfig.ast_grep.setup({
    filetypes = { "go", "java", "python", "css", "cs", "lua" },
})

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

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                path = runtime_path,
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                    vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        })
    end,

    capabilities = capabilities,
    single_file_support = true,
    settings = {
        Lua = {},
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

lspconfig.ruff.setup({
    cmd_env = { RUFF_TRACE = "messages" },
    init_options = {
        settings = {
            lint = {
                preview = true,
            },
            showSyntaxErrors = false,
        },
    },
})

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
                autoFormatStrings = true,
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
                deprecateTypingAliases = true,
                reportPropertyTypeMismatch = "warning",
                reportMissingImports = false, -- ruff handles this
                reportImportCycles = "error",
                reportConstantRedefinition = "error",
                reportUndefinedVariable = false, -- ruff handles this with F822
                reportUnusedVariable = false, -- let ruff handle this
                reportAssertAlwaysTrue = "error",
                reportInconsistentOverload = "warning",
                reportInvalidTypeArguments = "warning",
                reportNoOverloadImplementation = "warning",
                reportOptionalSubscript = "warning",
                reportOptionalIterable = "warning",
                reportUntypedNamedTuple = "warning",
                reportPrivateUsage = "warning",
                reportTypeCommentUsage = "warning", -- type comments are deprecated since Python 3.6
                reportDeprecated = "warning",
                reportInconsistentConstructor = "error",
                reportUnnecessaryCast = "warning",
                reportUntypedFunctionDecorator = "information",
                reportUnnecessaryTypeIgnoreComment = "information",
                -- Based options (not available in regular pyright)
                reportUnreachable = "warning",
                reportAny = true,
                reportIgnoreCommentWithoutRule = "warning",
                reportImplicitRelativeImport = "error",
                reportInvalidCast = "warning",
                reportUnsafeMultipleInheritance = "warning",
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

lspconfig.lemminx.setup({
    filetypes = { "xml", "xsd", "xsl", "xslt", "svg", "csproj" },
    settings = {
        xml = {
            format = {
                enabled = true,
                formatComments = true,
                joinCDATALines = false,
                joinCommentLines = false,
                joinContentLines = false,
                spaceBeforeEmptyCloseTag = true,
                splitAttributes = false,
            },
            completion = {
                autoCloseTags = true,
            },
        },
    },
})

local sc = require("schema-companion")

lspconfig.yamlls.setup(sc.setup_client({
    servers = {
        yamlls = {
            on_attach = lsp.on_attach,
            -- https://github.com/redhat-developer/yaml-language-server/issues/912#issuecomment-1797097638
            capabilities = lsp.get_capabilities(false),
            settings = {
                redhat = { telemetry = { enabled = false } },
                yaml = {
                    validate = true,
                    format = { enable = true },
                    hover = true,
                    completion = true,
                    schemaStore = {
                        enable = false,
                        url = "",
                        -- url = "https://www.schemastore.org/api/json/catalog.json",
                    },
                    schemaDownload = { enable = true },
                    schemas = require("schemastore").yaml.schemas(),
                    trace = { server = "debug" },
                },
            },
        },
    },
}))
