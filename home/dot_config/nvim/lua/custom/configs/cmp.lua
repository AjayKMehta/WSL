-- Use buffer source for `/` and '?'
local cmp = require("cmp")

local function limit_lsp_types(entry, ctx)
	local kind = entry:get_kind()
	local line = ctx.cursor.line
	local col = ctx.cursor.col
	local char_before_cursor = string.sub(line, col - 1, col - 1)
	local char_after_dot = string.sub(line, col, col)
	local types = require("cmp.types")

	if char_before_cursor == "." and char_after_dot:match("[a-zA-Z]") then
		return kind == types.lsp.CompletionItemKind.Method
			or kind == types.lsp.CompletionItemKind.Field
			or kind == types.lsp.CompletionItemKind.Property
	elseif string.match(line, "^%s+%w+$") then
		return kind == types.lsp.CompletionItemKind.Function or kind == types.lsp.CompletionItemKind.Variable
	end

	return kind ~= cmp.lsp.CompletionItemKind.Text
end

-- Only select visible buffers of 1 MB or less size
local buffer_option = {
	get_bufnrs = function()
		local buf_size_limit = 1024 * 1024
		local bufs = {}
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
			bufs[buf] = (byte_size <= buf_size_limit)
		end
		return vim.tbl_keys(bufs)
	end,
}

-- name is not the name of the plugin, it's the "id" of the plugin used when creating the source.
local default_sources = {
	{
		name = "treesitter",
		group_index = 1,
		priority = 100,
	},
	{
		name = "nvim_lsp",
		group_index = 1,
		priority = 100,
		keyword_length = 3,
		entry_filter = limit_lsp_types,
	},
	{
		name = "luasnip",
		group_index = 1,
		priority = 90,
		keyword_length = 2,
		max_item_count = 100,
		option = { show_autosnippets = true },
	},
	{
		name = "luasnip_choice",
		group_index = 1,
		priority = 90,
		keyword_length = 2,
		max_item_count = 20,
	},
	{
		name = "emoji",
		group_index = 1,
		priority = 85,
	},
}

cmp.setup({ sources = cmp.config.sources(default_sources) })

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	enabled = true,
	completion = {
		keyword_length = 2,
	},
	sources = {
		{ name = "nvim_lsp_document_symbol", group_index = 1, priority = 100 },
		{ name = "fuzzy_buffer", group_index = 1, priority = 60 },
		{ name = "buffer-lines", group_index = 2, priority = 90 },
	},
	view = {
		entries = { name = "custom", selection_order = "near_cursor" },
	},
})

cmp.setup.filetype({ "markdown", "help" }, {
	window = {
		documentation = cmp.config.disable,
	},
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	completion = {
		keyword_length = 2, -- Otherwise, can't use :q!
	},
	enabled = true,
	sources = cmp.config.sources({
		{ name = "cmdline" },
		{ name = "buffer" },
		{ name = "async_path" },
	}),
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "dap" },
	}),
})

cmp.setup.filetype({ "help", "minifiles", "TelescopePrompt" }, {
	enabled = false,
})

local tex_sources = vim.deepcopy(default_sources)
local latex_source = {
	name = "lua-latex-symbols",
	priority = 100,
	keyword_length = 2,
}

table.insert(tex_sources, 1, latex_source)
local other_latex_sources = {
	{
		name = "async_path",
		priority = 50,
	},
	{
		name = "buffer",

		priority = 10,
		keyword_length = 4,
		option = buffer_option,
	},
	{
		name = "buffer-lines",
		priority = 5,
		keyword_length = 4,
		max_item_count = 50,
		option = buffer_option,
	},
}
for _, value in ipairs(other_latex_sources) do
	table.insert(tex_sources, value)
end

cmp.setup.filetype({ "tex", "plaintex", "markdown", "rmd" }, {
	sources = cmp.config.sources(tex_sources),
})

local r_sources = vim.deepcopy(default_sources)
local r_source = {
	name = "cmp_nvim_r",
	priority = 100,
	keyword_length = 2,
}
table.insert(r_sources, 1, r_source)

cmp.setup.filetype("r", {
	sources = cmp.config.sources(r_sources),
})

-- https://github.com/gitaarik/nvim-cmp-toggle/blob/b3bbf76cf6412738b7c9e48e1419f7bb78e71f99/plugin/nvim_cmp_toggle.lua
local function toggle_autocomplete()
	local current_setting = cmp.get_config().completion.autocomplete
	if current_setting and #current_setting > 0 then
		cmp.setup({ completion = { autocomplete = false } })
		vim.notify("Autocomplete disabled")
	else
		cmp.setup({ completion = { autocomplete = { cmp.TriggerEvent.TextChanged } } })
		vim.notify("Autocomplete enabled")
	end
end

vim.api.nvim_create_user_command("NvimCmpToggle", toggle_autocomplete, {})

-- Set a keymap:
vim.api.nvim_set_keymap("n", "<Leader>tc", ":NvimCmpToggle<CR>", { noremap = true, silent = true })
