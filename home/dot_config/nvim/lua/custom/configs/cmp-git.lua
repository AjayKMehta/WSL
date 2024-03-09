local cmp = require("cmp")
---@diagnostic disable-next-line: missing-fields
cmp.setup.filetype({ "gitcommit", "gitrebase" }, {
	sources = cmp.config.sources({
		{ name = "cmp_git", priority = 100 },
		{ name = "async_path", priority = 50 },
		{ name = "buffer", priority = 50 },
		{ name = "emoji", insert = true, priority = 20 },
	}),
})
