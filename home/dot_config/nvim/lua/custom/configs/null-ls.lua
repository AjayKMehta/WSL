local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local b = null_ls.builtins
local formatting = b.formatting
local lint = b.diagnostics
local actions = b.code_actions
local comp = b.completion

local sources = {
	formatting.prettier.with({ filetypes = { "html", "css" } }), -- so prettier works only on these filetypes

	-- Lua
	formatting.stylua,
	comp.luasnip,

	-- cpp
	formatting.clang_format,
	-- https://github.com/jose-elias-alvarez/null-ls.nvim
	actions.gitsigns,

	-- Markdown
	lint.markdownlint,
	formatting.markdownlint,

	lint.todo_comments,
	actions.refactoring,

	-- JSON, YAML, XML
	lint.yamllint,

	-- R
	formatting.format_r,

	-- https://github.com/ckolkey/ts-node-action#null-ls-integration
	null_ls.builtins.code_actions.ts_node_action,

	-- typos
	require("typos").actions,
	require("typos").diagnostics,
}

null_ls.setup({
	debug = true,
	sources = sources,
})
