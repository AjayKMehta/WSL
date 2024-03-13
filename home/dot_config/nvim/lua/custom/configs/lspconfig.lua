local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

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

	-- Misc
	"ltex",
	"ast_grep",
	-- Graphviz
	"dotls",
	-- "marksman",

	-- Python
	"ruff_lsp",
	"pylyzer",

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

vim.g.OmniSharp_start_without_solution = 1
vim.g.OmniSharp_timeout = 5

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

lspconfig.texlab.setup({
	on_attach = on_attach,
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
			-- TODO: Figuure this out
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
