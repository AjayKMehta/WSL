local conform = require("conform")

conform.setup({
	format_on_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 500, lsp_fallback = true }
	end,
	-- If you specify more than one formatter, they will be executed in the order you list them.
	formatters_by_ft = {
		bash = { "shellcheck" },
		json = { "jq", "fixjson" },
		lua = { "stylua" },
		markdown = { "markdownlint" },
		python = { "ruff" },
		sql = { "sql-formatter" },
		tex = { "latexindent" },
		toml = { "taplo" },
		yaml = { "yamlfix" },
	},
})

-- Keymap

vim.keymap.set({ "n", "v" }, "<leader>lf", function()
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	})
end, { desc = "Format file or range (in visual mode)" })

--#region Commands

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

--endregion
