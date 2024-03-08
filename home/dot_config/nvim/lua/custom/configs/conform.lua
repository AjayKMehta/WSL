local conform = require("conform")

conform.setup({
	formatters = {
		-- stack install cabal-fmt
		-- Not listed in Mason registry.
		cabal_fmt = {
			meta = {
				url = "https://hackage.haskell.org/package/cabal-fmt",
				description = "Format cabal files with cabal-fmt",
			},
			command = "cabal-fmt",
		},
		cbfmt = {
			prepend_args = {
				"--config",
				vim.env.HOME .. "/.cbfmt.toml",
			},
		},
		["markdownlint-cli"] = {
			prepend_args = {
				"--config",
				vim.env.HOME .. "/.markdownlint.json",
			},
		},
	},
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
		-- TODO: Figure out how to use dotnet format instead
		-- cs = { "csharpier" },
		cabal = { "cabal_fmt" },
		haskell = { "fourmolu" },
		json = { "fixjson" },
		json5 = { "fixjson" },
		jsonc = { "fixjson" },
		lua = { "stylua" },
		markdown = { "markdownlint", "cbfmt" },
		python = { "ruff" },
		sql = { "sql-formatter" },
		tex = { "latexindent" },
		toml = { "taplo" },
		yaml = { "yamlfix" },
		-- Use the "*" filetype to run formatters on all filetypes.
		-- ["*"] = { },
		-- Use the "_" filetype to run formatters on filetypes that don't
		-- have other formatters configured.
		["_"] = { "trim_whitespace" },
	},
})

-- Keymap

-- In normal mode it will apply to the whole file, in visual mode it will apply to the current selection.
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
