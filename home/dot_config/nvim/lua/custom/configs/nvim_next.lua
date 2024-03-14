local nvim_next_builtins = require("nvim-next.builtins")
require("nvim-next").setup({
	default_mappings = {
		repeat_style = "directional",
	},
	items = {
		nvim_next_builtins.f,
		nvim_next_builtins.t,
	},
})
