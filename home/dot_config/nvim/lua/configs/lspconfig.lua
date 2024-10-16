-- For info on how to configure servers, see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md.

local lsp = require("utils.lsp")
local on_attach = lsp.on_attach

-- Prevent LSP from overwriting treesitter color settings
-- https://github.com/NvChad/NvChad/issues/1907
vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

-- 💡 Uncommenting the line below would disable semantic tokens.
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/configs/lspconfig.lua#L29
-- local on_init = require("nvchad.configs.lspconfig").on_init

local capabilities = lsp.capabilities

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
    "yamlls",

    -- Graphviz
    "dotls",

    -- Python
    -- "pylyzer",

    -- R
    "r_language_server",
}

if vim.g.csharp_lsp then
    table.insert(servers, "csharp_ls")
end

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach,
        -- on_init = on_init,
        capabilities = capabilities,
    })
end

lspconfig.ast_grep.setup({
    filetypes = { "go", "java", "python", "css", "cs", "lua" }
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

lspconfig.lua_ls.setup({
    on_attach = on_attach,
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
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
        Lua = {
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

-- TODO: Look into disabling and using csharp_ls only.
if not vim.g.csharp_lsp then
    lspconfig.omnisharp.setup({
        cmd = { "dotnet", mason_path .. "/packages/omnisharp/libexec/OmniSharp.dll" },
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            FormattingOptions = {
                EnableEditorConfigSupport = true,
                OrganizeImports = true,
            },
            MsBuild = {
                LoadProjectsOnDemand = false,
            },
            RoslynExtensionsOptions = {
                EnableAnalyzersSupport = true,
                EnableImportCompletion = true,
                AnalyzeOpenDocumentsOnly = false,
                InlayHintsOptions = {
                    EnableForParameters = true,
                    ForLiteralParameters = true,
                    ForIndexerParameters = true,
                    ForObjectCreationParameters = true,
                    ForOtherParameters = true,
                    SuppressForParametersThatDifferOnlyBySuffix = false,
                    SuppressForParametersThatMatchMethodIntent = false,
                    SuppressForParametersThatMatchArgumentName = false,
                    EnableForTypes = true,
                    ForImplicitVariableTypes = true,
                    ForLambdaParameterTypes = true,
                    ForImplicitObjectCreation = true,
                },
            },
            Sdk = {
                IncludePrereleases = false,
            },
            RenameOptions = {
                RenameInComments = false,
                RenameOverloads = false,
                RenameInStrings = false,
            },
        },
    })
end

-- https://github.com/PowerShell/PowerShellEditorServices/blob/89ce0867c6b119bef8af83ab21c249e10d0e77a2/docs/guide/getting_started.md

-- The bundle_path is where PowerShell Editor Services was installed
local bundle_path = mason_path .. "/packages/powershell-editor-services"

if vim.g.use_custom_pses then
    bundle_path = "~/PowerShellEditorServices/"
end

local custom_settings_path = bundle_path .. "/PSScriptAnalyzer/1.22.0/PSScriptAnalyzer.psd1"

local command_fmt =
[[& '%s/PowerShellEditorServices/Start-EditorServices.ps1' -BundledModulesPath '%s' -SessionDetailsPath '%s/powershell_es.session.json' -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Normal]]
local temp_path = vim.fn.stdpath("cache")
local command = command_fmt:format(bundle_path, bundle_path, temp_path)

lspconfig.powershell_es.setup({
    filetypes = { "ps1" },
    bundle_path = bundle_path,
    -- Contrary to docs, LSP doesn't work without cmd specified even if bundle_path is set.
    cmd = { "pwsh", "-NoLogo", "-NoProfile", "-Command", command },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        powershell = {
            codeFormatting = {
                Preset = "OTBS",
                AddWhitespaceAroundPipe = true,
                IgnoreOneLineBlock = true,
                PipelineIndentationStyle = "IncreaseIndentationForFirstPipeline",
                TrimWhitespaceAroundPipe = true,
                UseConstantStrings = true,
                UseCorrectCasing = true,
                WhitespaceBetweenParameters = true,
            },
            scriptAnalysis = { settingsPath = custom_settings_path },
        },
    },
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
                reportUnusedVariable = false,    -- let ruff handle this
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
