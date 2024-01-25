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
	-- webdev stuff
	formatting.deno_fmt, -- chose deno for ts/js files cuz its very fast!
	formatting.prettier.with({ filetypes = { "html", "css" } }), -- so prettier works only on these filetypes

	-- Lua
	formatting.stylua,
	comp.luasnip,
	lint.luacheck.with({ extra_args = { "--globals", "vim" } }),

	-- cpp
	formatting.clang_format,
	-- https://github.com/jose-elias-alvarez/null-ls.nvim
	actions.gitsigns,

	-- cspell
	lint.cspell.with({ filetypes = { "markdown", "text" } }),
	actions.cspell,
	formatting.trim_whitespace,

	-- Shell
	actions.shellcheck,
	lint.shellcheck,

	-- LaTeX
	lint.chktex,
	formatting.latexindent,

	-- Markdown
	lint.markdownlint,
	formatting.markdownlint,
	formatting.markdown_toc,

	-- Python
	lint.mypy,
	lint.ruff,
	formatting.ruff,

	lint.todo_comments,
	actions.refactoring,

	-- JSON, YAML, XML
	lint.yamllint,
	formatting.jq,
	formatting.xq,
	formatting.yq,

	-- Haskell
	formatting.brittany,

	formatting.format_r,

	-- https://github.com/ckolkey/ts-node-action#null-ls-integration
	null_ls.builtins.code_actions.ts_node_action,
}

null_ls.setup({
	debug = true,
	sources = sources,
})
