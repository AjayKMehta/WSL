local ls = require("luasnip")
local ft_func = require("luasnip.extras.filetype_functions")
local extras = require("luasnip.extras")

local fmt = require("luasnip.extras.fmt").fmt

-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#config-options
local opts = {
	updateevents = "TextChanged,TextChangedI",
	delete_check_events = "TextChanged,CursorMoved",
	region_check_events = "CursorMoved,CursorHold,InsertEnter",
	enable_autosnippets = true,
	history = true,
	-- mapping for cutting selected text so it's usable as SELECT_DEDENT,
	-- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
	store_selection_keys = "<Tab>",
	ft_func = ft_func.from_pos_or_filetype,
	load_ft_func = ft_func.extend_load_ft({
		markdown = { "lua", "json", "html", "yaml", "css", "html", "javascript", "r", "python" },
		html = { "javascript", "css", "graphql", "json" },
	}),
	ext_opts = {
		[require("luasnip.util.types").choiceNode] = {
			active = {
				virt_text = { { "●", "St_SelectMode" } },
			},
		},
		[require("luasnip.util.types").insertNode] = {
			active = {
				virt_text = { { "⎀", "St_InsertMode" } },
			},
		},
	},
	snip_env = {
		fmt = fmt,
		m = extras.match,
		t = ls.text_node,
		f = ls.function_node,
		c = ls.choice_node,
		d = ls.dynamic_node,
		i = ls.insert_node,
		l = extras.lambda,
		s = ls.snippet,
		sn = ls.snippet_node,
	},
}

ls.setup(opts)

local parent_path = vim.fn.stdpath("config") .. "/lua/custom/"
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load({
	paths = { parent_path .. "snippets" },
})
require("luasnip.loaders.from_lua").lazy_load({
	paths = parent_path .. "lua_snippets",
})

-- friendly-snippets - enable standardized comments snippets
ls.filetype_extend("lua", { "luadoc" })
ls.filetype_extend("python", { "pydoc" })
ls.filetype_extend("rust", { "rustdoc" })
ls.filetype_extend("cs", { "csharpdoc" })
ls.filetype_extend("cpp", { "cppdoc" })
ls.filetype_extend("sh", { "shelldoc" })

-- set keybinds for both INSERT and VISUAL.
vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})
vim.keymap.set("i", "<c-u>", require("luasnip.extras.select_choice"))

-- Uncomment to test snippet functionality
require("snippet_examples")

-- TODO Add autocommand to show snippets.
