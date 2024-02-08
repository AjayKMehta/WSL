local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

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
	"eslint",
	"jqls",

	-- C/C++
	"clangd",
	"cmake",

	"dockerls",

	-- CICD + Shell
	"codeqlls",

	-- Misc
	"golangci_lint_ls",
	"ltex",
	"ast_grep",

	-- "marksman",
	"ruff_lsp",

	-- R
	"r_language_server",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

local jsonCapabilities = capabilities
jsonCapabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.jsonls.setup({
	capabilities = jsonCapabilities,
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

lspconfig.hls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "haskell", "lhaskell", "cabal" },
})

lspconfig.bashls.setup({
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "sh",
		callback = function()
			vim.lsp.start({ name = "bash-language-server", cmd = { "bash-language-server", "start" } })
		end,
	}),
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.lua_ls.setup({
	on_attach = on_attach,
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
	capabilities = capabilities,
	-- also needs:
	-- $home/.config/marksman/config.toml :
	-- [core]
	-- markdown.file_extensions = ["md", "markdown", "qmd"]
	filetypes = { "markdown", "quarto" },
	root_dir = require("lspconfig.util").root_pattern(".git", ".marksman.toml", "_quarto.yml"),
})

local pid = vim.fn.getpid()
vim.g.OmniSharp_start_without_solution = 1
vim.g.OmniSharp_timeout = 5

lspconfig.omnisharp.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	-- Enables support for reading code style, naming convention and analyzer
	-- settings from .editorconfig.
	enable_editorconfig_support = true,
	-- If true, MSBuild project system will only load projects for files that
	-- were opened in the editor. This setting is useful for big C# codebases
	-- and allows for faster initialization of code navigation features only
	-- for projects that are relevant to code that is being edited. With this
	-- setting enabled OmniSharp may load fewer projects and may thus display
	-- incomplete reference lists for symbols.
	enable_ms_build_load_projects_on_demand = false,
	enable_roslyn_analyzers = true,
	organize_imports_on_format = true,
	-- Enables support for showing unimported types and unimported extension
	-- methods in completion lists. When committed, the appropriate using
	-- directive will be added at the top of the current file. This option can
	-- have a negative impact on initial completion responsiveness,
	-- particularly for the first few completion sessions after opening a
	-- solution.
	enable_import_completion = true,
	-- Specifies whether to include preview versions of the .NET SDK when
	-- determining which version to use for project loading.
	sdk_include_prereleases = true,
	-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
	-- true
	analyze_open_documents_only = false,
})

lspconfig.yamlls.setup({
	on_attach = on_attach,
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

require("custom.configs.powershell")

lspconfig.pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "python" },
	settings = {
		python = {
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
			},
		},
	},
})
