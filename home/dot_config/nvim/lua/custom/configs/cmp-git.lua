local cmp = require("cmp")
---@diagnostic disable-next-line: missing-fields
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git", priority = 50 },
		{ name = "async_path", priority = 40 },
	}, {
		{ name = "buffer", priority = 50 },
		{ name = "emoji", insert = true, priority = 20 },
	}),
})
