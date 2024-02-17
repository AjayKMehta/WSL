-- https://github.com/2KAbhishek/nvim2k/blob/5d2b725c1d6313f9c3bc6877d8835da03e51606e/lua/plugins/ui/lualine.lua

local colors = {
	bg = "#202328",
	fg = "#bbc2cf",
	yellow = "#ECBE7B",
	cyan = "#008080",
	darkblue = "#081633",
	green = "#98be65",
	orange = "#FF8800",
	violet = "#a9a1e1",
	magenta = "#c678dd",
	blue = "#51afef",
	red = "#ec5f67",
}

local M = {}
M.devicons = {
	override_by_filename = {
		["makefile"] = {
			icon = "",
			color = "#f1502f",
			name = "Makefile",
		},
		[".gitignore"] = {
			icon = "",
			color = "#e24329",
			cterm_color = "196",
			name = "GitIgnore",
		},
		["js"] = {
			icon = "",
			color = "#cbcb41",
			cterm_color = "185",
			name = "Js",
		},
		["lock"] = {
			icon = "",
			color = "#bbbbbb",
			cterm_color = "250",
			name = "Lock",
		},
		["package.json"] = {
			icon = "",
			color = "#e8274b",
			name = "PackageJson",
		},
		[".eslintignore"] = {
			icon = "󰱺",
			color = "#e8274b",
			name = "EslintIgnore",
		},
		["tags"] = {
			icon = "",
			color = "#bbbbbb",
			cterm_color = "250",
			name = "Tags",
		},
		["http"] = {
			icon = "󰖟",
			color = "#519aba",
			name = "Http",
		},
	},
}

M.treesitter = {
	-- ensure_installed = "all",
	ensure_installed = {
		"vim",
		"lua",
		"luadoc",
		"luap",
		"query",
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"c",
		"markdown",
		"markdown_inline",
		"mermaid",
		"comment",
		"c_sharp",
		"diff",
		"git_config",
		"gitcommit",
		"gitattributes",
		"gitignore",
		"haskell",
		-- "haskell_persistent",
		"json",
		"jsonc",
		"jq",
		"latex",
		"bash",
		"python",
		"r",
		"toml",
		"xml",
		"yaml",
		"dockerfile",
		"diff",
	},
	auto_install = true,
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "python", "css" } },
	autotag = {
		enable = true,
	},
	tree_setter = {
		enable = true,
	},
	-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/issues/82#issuecomment-1817659634
	-- context_commentstring = { enable = true },
	matchup = { enable = true },
	-- https://github.com/nvim-treesitter/nvim-treesitter-refactor
	refactor = {
		highlight_current_scope = { enable = true },
		highlight_definitions = {
			enable = true,
			-- Set to false if you have an `updatetime` of ~100.
			clear_on_cursor_move = true,
		},
		smart_rename = {
			enable = true,
			-- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
			keymaps = {
				smart_rename = false, -- "grr"
			},
		},
		navigation = {
			enable = true,
			-- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
			keymaps = {
				goto_definition = "gd",
				list_definitions = "gld",
				list_definitions_toc = "glt",
				goto_next_usage = "<a-*>",
				goto_previous_usage = "<a-#>",
			},
		},
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gi",
			node_incremental = "gk",
			scope_incremental = "gs",
			node_decremental = "gj",
		},
	},
	textobjects = {
		select = {
			enable = true,
			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["=a"] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
				["=i"] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
				["=l"] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
				["=r"] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
				["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
				["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

				["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
				["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

				["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
				["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

				["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
				["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

				["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
				["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

				["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },

				["aq"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]f"] = { query = "@call.outer", desc = "Next function call start" },
				["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
				-- ["]c"] = { query = "@class.outer", desc = "Next class start" },
				["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
				["]l"] = { query = "@loop.outer", desc = "Next loop start" },
			},
			goto_next_end = {
				["]F"] = { query = "@call.outer", desc = "Next function call end" },
				["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
				["]C"] = { query = "@class.outer", desc = "Next class end" },
				["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
				["]L"] = { query = "@loop.outer", desc = "Next loop end" },
			},
			goto_previous_start = {
				["[f"] = { query = "@call.outer", desc = "Prev function call start" },
				["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
				-- ["[c"] = { query = "@class.outer", desc = "Prev class start" },
				["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
				["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
			},
			goto_previous_end = {
				["[F"] = { query = "@call.outer", desc = "Prev function call end" },
				["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
				["[C"] = { query = "@class.outer", desc = "Prev class end" },
				["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
				["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
				["<leader>n:"] = "@property.outer", -- swap object property with next
				["<leader>nm"] = "@function.outer", -- swap function with next
			},
			swap_previous = {
				["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
				["<leader>p:"] = "@property.outer", -- swap object property with prev
				["<leader>pm"] = "@function.outer", -- swap function with previous
			},
		},
		lsp_interop = {
			enable = true,
			border = "none",
			floating_preview_opts = {},
			peek_definition_code = {
				["<leader>pf"] = "@function.outer",
				["<leader>pF"] = "@class.outer",
			},
		},
	},
}

M.mason = {
	-- https://mason-registry.dev/registry/list
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",
		"luacheck",

		-- web dev
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"deno",
		"json-lsp",
		"jq-lsp",
		"fixjson",

		-- c/cpp
		"clangd",
		"clang-format",
		"cmake-language-server",

		-- docker
		"docker-compose-language-service",
		"dockerfile-language-server",
		"hadolint",

		-- Go
		"golangci-lint-langserver",
		"golangci-lint",
		"go-debug-adapter",

		-- Python
		"pyright",
		"ruff-lsp",
		"debugpy",
		"docformatter",
		"isort",
		"mypy",
		"ruff",
		"pylyzer",

		--Haskell
		"haskell-language-server",
		"haskell-debug-adapter",

		-- .NET
		"csharp-language-server",
		"csharpier",
		"omnisharp",
		"powershell-editor-services",
		"netcoredbg",

		-- DevOps + Shell
		"bash-language-server",
		"yaml-language-server",
		"yamllint",
		"shellcheck",
		"codeql",
		"yq",
		"gh",

		-- R
		"r-languageserver",

		-- SQL
		"sqlls",
		"sql-formatter",

		-- Misc
		"cspell",
		"tree-sitter-cli",
		"ast-grep",
		"dot-language-server",

		-- Markdown
		"markdown-toc",
		"markdownlint",
		"marksman",

		-- LaTeX
		"ltex-ls",
		"latexindent",
		"texlab",
	},
	automatic_installation = true,
	-- ui = {
	-- icons = {
	--   package_pending = " ",
	--   package_installed = "󰄳 ",
	--   package_uninstalled = "󰇚 ",
	-- },
}

local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.6 -- You can change this too

M.nvimtree = {
	filters = {
		dotfiles = false,
		custom = { "node_modules" },
	},
	-- git support in nvimtree
	git = {
		enable = true,
		timeout = 10000,
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = true,
		debounce_delay = 50,
		severity = {
			min = vim.diagnostic.severity.HINT,
			max = vim.diagnostic.severity.ERROR,
		},
	},

	modified = {
		enable = true,
	},
	renderer = {
		root_folder_label = ":~:s?$?/..?",
		add_trailing = true,
		highlight_opened_files = "name",
		highlight_git = "icon",
		highlight_diagnostics = "icon",
		highlight_modified = "name",
		highlight_bookmarks = "icon",
		special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
		symlink_destination = true,
		indent_markers = {
			enable = true,
		},
		icons = {
			git_placement = "before",
			modified_placement = "after",
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
				modified = true,
				diagnostics = true,
				bookmarks = true,
			},
			web_devicons = {
				file = {
					enable = true,
					color = true,
				},
				folder = {
					enable = false,
					color = true,
				},
			},
			-- glyphs = {
			-- 	git = {
			-- 		unstaged = "",
			-- 		-- unstaged = "",
			-- 		staged = "",
			-- 		unmerged = "",
			-- 		renamed = "➜",
			-- 		-- untracked = "",
			-- 		untracked = "",
			-- 		deleted = "",
			-- 		ignored = "◌",
			-- 	},
			-- },
		},
	},
	-- https://vonheikemen.github.io/devlog/tools/neovim-plugins-to-get-started/
	hijack_cursor = false,
	on_attach = function(bufnr)
		-- See :help nvim-tree.api
		local api = require("nvim-tree.api")

		local bufmap = function(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
		end

		local function edit_or_open()
			local node = api.tree.get_node_under_cursor()

			if node.nodes ~= nil then
				-- expand or collapse folder
				api.node.open.edit()
			else
				-- open file
				api.node.open.edit()
				-- Close the tree if file was opened
				api.tree.close()
			end
		end

		-- open as vsplit on current node
		local function vsplit_preview()
			local node = api.tree.get_node_under_cursor()

			if node.nodes ~= nil then
				-- expand or collapse folder
				api.node.open.edit()
			else
				-- open file as vsplit
				api.node.open.vertical()
			end

			-- Finally refocus on tree if it was lost
			api.tree.focus()
		end

		-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#h-j-k-l-style-navigation-and-editing
		bufmap("l", edit_or_open, "Expand folder or go to file")
		bufmap("L", vsplit_preview, "VSplit Preview")
		bufmap("h", api.node.navigate.parent_close, "Close parent folder")
		bufmap("H", api.tree.collapse_all, "Collapse All")
		bufmap("gh", api.tree.toggle_hidden_filter, "Toggle hidden files")
		bufmap("Y", api.fs.copy.relative_path, "Copy Relative Path")

		-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#git-stage-unstage-files-and-directories-from-the-tree
		-- WARN: Code in above link causes null-ls to keep spinning. DON'T USE.

		-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#change-root-to-global-current-working-directory
		local function change_root_to_global_cwd()
			local global_cwd = vim.fn.getcwd(-1, -1)
			api.tree.change_root(global_cwd)
		end
		bufmap("<C-c>", change_root_to_global_cwd, "Change Root To Global CWD")
	end,
	-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#center-a-floating-nvim-tree-window
	view = {
		float = {
			enable = true,
			open_win_config = function()
				local screen_w = vim.opt.columns:get()
				local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
				local window_w = screen_w * WIDTH_RATIO
				local window_h = screen_h * HEIGHT_RATIO
				local window_w_int = math.floor(window_w)
				local window_h_int = math.floor(window_h)
				local center_x = (screen_w - window_w) / 2
				local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
				return {
					border = "rounded",
					relative = "editor",
					row = center_y,
					col = center_x,
					width = window_w_int,
					height = window_h_int,
				}
			end,
		},
		width = function()
			return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
		end,
	},
}

M.gitsigns = {
	attach_to_untracked = true,
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
	},
	-- https://vonheikemen.github.io/devlog/tools/neovim-plugins-to-get-started/
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "➤" },
		topdelete = { text = "➤" },
		changedelete = { text = "▎" },
	},
}

M.lualine = {
	options = {
		ignore_focus = { "NvimTree", "lspInfo" },
		theme = "dracula",
		icons_enabled = true,
		component_separators = "|",
		disabled_filetypes = {
			statusline = { "NvimTree", "dashboard" },
		},
	},
	-- This clobbers bufferline!
	-- tabline = {
	--     lualine_y = { "searchcount", "selectioncount" },
	-- },
	sections = {
		lualine_a = {
			{
				"diagnostics",

				-- Table of diagnostic sources, available sources are:
				--   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
				-- or a function that returns a table as such:
				--   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
				sources = { "nvim_diagnostic", "nvim_lsp", "nvim_workspace_diagnostic" },

				-- Displays diagnostics for the defined severity types
				sections = { "error", "warn", "info", "hint" },

				symbols = { error = "E", warn = "W", info = "I", hint = "H" },
				update_in_insert = false, -- Update diagnostics in insert mode.
				always_visible = false, -- Show diagnostics even if there are none.
				diagnostics_color = {
					color_error = { fg = colors.red },
					color_warn = { fg = colors.yellow },
					color_info = { fg = colors.blue },
					color_hint = { fg = colors.yellow },
				},
			},
		},
		lualine_b = {
			"branch",
			{
				"diff",
				colored = true,
				diff_color = {
					-- Same color values as the general color option can be used here.
					added = "DiffAdd", -- Changes the diff's added color
					modified = "DiffChange", -- Changes the diff's modified color
					removed = "DiffDelete", -- Changes the diff's removed color you
				},
				symbols = { added = "+", modified = "~", removed = "-" }, -- Changes the symbols used by the diff.
				source = nil, -- A function that works as a data source for diff.
				-- It must return a table as such:
				--   { added = add_count, modified = modified_count, removed = removed_count }
				-- or nil on failure. count <= 0 won't be displayed.
			},
			{
				function(msg)
					msg = msg or "LS Inactive"
					local buf_clients = vim.lsp.buf_get_clients()
					if next(buf_clients) == nil then
						-- TODO: clean up this if statement
						if type(msg) == "boolean" or #msg == 0 then
							return "LS Inactive"
						end
						return msg
					end
					local buf_ft = vim.bo.filetype
					local buf_client_names = {}

					-- add client
					for _, client in pairs(buf_clients) do
						if client.name ~= "null-ls" and client.name ~= "copilot" then
							table.insert(buf_client_names, client.name)
						end
					end
					-- add formatter
					local supported_formatters = formatters.list_registered(buf_ft)
					vim.list_extend(buf_client_names, supported_formatters)

					-- add linter
					local supported_linters = linters.list_registered(buf_ft)
					vim.list_extend(buf_client_names, supported_linters)

					local unique_client_names = vim.fn.uniq(buf_client_names)
					local language_servers = "[ " .. table.concat(unique_client_names, ", ") .. "]"
					return language_servers
				end,
			},
		},
		lualine_c = {
			{
				"filename",
				cond = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
				file_status = true, -- Displays file status (readonly status, modified status)
				newfile_status = true, -- Display new file status (new file means no write after created)
			},
		},
		lualine_x = {
			{
				"encoding",
				cond = function()
					return vim.fn.winwidth(0) > 80
				end,
			},
			{
				"fileformat",
				symbols = {
					unix = "", -- e712
					dos = "", -- e70f
					mac = "", -- e711
				},
			},
			"filetype",
			{ "aerial" },
			-- https://github.com/cuducos/yaml.nvim#showing-the-yaml-path-and-value
			{
				function(msg)
					msg = require("yaml_nvim").get_yaml_key_and_value()
					if msg == nil then
						return ""
					else
						return msg
					end
				end,
			},
		},
	},
	extensions = { "nvim-tree", "lazy", "mason", "nvim-dap-ui", "trouble" },
}

M.cmp = {
	-- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#disabling-completion-in-certain-contexts-such-as-comments
	enabled = function()
		-- disable completion in comments
		local context = require("cmp.config.context")
		-- keep command mode completion enabled when cursor is in a comment
		if vim.api.nvim_get_mode().mode == "c" then
			return true
		else
			return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
		end
	end,
	experimental = {
		ghost_text = {
			hl_group = "Comment",
		},
	},
	performance = {
		debounce = 300,
		throttle = 60,
		max_view_entries = 10,
		fetching_timeout = 200,
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	matching = {
		disallow_fuzzy_matching = true,
		disallow_fullfuzzy_matching = true,
		disallow_partial_fuzzy_matching = true,
		disallow_partial_matching = false,
		disallow_prefix_unmatching = true,
	},
	completion = {
		completeopt = "menu,menuone,noinsert,noselect",
		keyword_length = 2,
	},
	-- name is not the name of the plugin, it's the "id" of the plugin used when creating the source.
	sources = {
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
		},
		{
			name = "rg",
			group_index = 1,
			priority = 100,
			keyword_length = 3,
		},
		{
			name = "nvim_lsp_signature_help",
			group_index = 1,
			priority = 100,
		},
		{
			name = "luasnip",
			group_index = 1,
			priority = 90,
			keyword_length = 2,
			max_item_count = 10,
			option = { show_autosnippets = true },
		},
		{
			name = "luasnip-choice",
			group_index = 1,
			priority = 90,
			keyword_length = 2,
			max_item_count = 5,
		},
		{
			name = "emoji",
			group_index = 2,
			priority = 85,
		},
		{
			name = "color_names",
			group_index = 2,
			priority = 80,
		},
	},
	mapping = {
		-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#safely-select-entries-with-cr
		["<CR>"] = require("cmp").mapping({
			i = function(fallback)
				if require("cmp").visible() and require("cmp").get_active_entry() then
					require("cmp").confirm({ behavior = require("cmp").ConfirmBehavior.Replace, select = false })
				else
					fallback()
				end
			end,
			s = require("cmp").mapping.confirm({ select = true }),
			c = require("cmp").mapping.confirm({ behavior = require("cmp").ConfirmBehavior.Replace, select = true }),
		}),
	},
	window = {
		completion = require("cmp.config.window").bordered({
			winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
		}),
		documentation = false,
	},
}

M.dict = {
	exact_length = 2,
	first_case_insensitive = false,
	document = {
		document_command = "wn %s -over",
		enable = true,
	},
	async = true,
	max_number_items = -1,
	-- capacity = 5,
	debug = false,
}

M.blankline = {
	use_treesitter = true,
	space_char_blankline = " ",
	show_current_context = true,
	show_current_context_start = true,
	char_highlight_list = {
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
		"IndentBlanklineIndent3",
		"IndentBlanklineIndent4",
		"IndentBlanklineIndent5",
		"IndentBlanklineIndent6",
	},
}

M.telescope = {
	defaults = {
		preview = {
			mime_hook = function(filepath, bufnr, opts)
				local is_image = function(filepath)
					local image_extensions = { "png", "jpg" } -- Supported image formats
					local split_path = vim.split(filepath:lower(), ".", { plain = true })
					local extension = split_path[#split_path]
					return vim.tbl_contains(image_extensions, extension)
				end
				if is_image(filepath) then
					local term = vim.api.nvim_open_term(bufnr, {})
					local function send_output(_, data, _)
						for _, d in ipairs(data) do
							vim.api.nvim_chan_send(term, d .. "\r\n")
						end
					end
					vim.fn.jobstart({
						"catimg",
						filepath, -- Terminal image viewer command
					}, { on_stdout = send_output, stdout_buffered = true, pty = true })
				else
					require("telescope.previewers.utils").set_preview_message(
						bufnr,
						opts.winid,
						"Binary cannot be previewed"
					)
				end
			end,
		},
		file_ignore_patterns = {
			"node_modules",
			".docker",
			"yarn.lock",
			"go.sum",
			"go.mod",
			"tags",
			"mocks",
			"refactoring",
		},
		layout_config = {
			horizontal = {
				prompt_position = "bottom",
			},
		},
	},
	extensions_list = {
		"notify",
		"frecency",
		"undo",
		"vim_bookmarks",
		"harpoon",
		-- "noice",
		"ctags_plus",
		"luasnip",
		"dir",
		"media_files",
		"cder",
		"file_browser",
		"themes",
		"terms",
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		lazy = {
			show_icon = true,
			mappings = {
				open_in_browser = "<C-o>",
				open_in_file_browser = "<M-b>",
				open_in_find_files = "<C-f>",
				open_in_live_grep = "<C-g>",
				-- open_plugins_picker = "<C-b>",
				open_lazy_root_find_files = "<C-r>f",
				open_lazy_root_live_grep = "<C-r>g",
			},
		},
		media_files = {
			-- filetypes whitelist
			-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
			filetypes = { "png", "webp", "jpg", "jpeg" },
			-- find command (defaults to `fd`)
			find_cmd = "rg",
		},
		file_browser = {
			hidden = { file_browser = true, folder_browser = true },
		},
	},
}

M.urlview = {
	default_title = "URLs",
	default_picker = "telescope",
	default_action = "clipboard",
	sorted = false,
	jump = {
		["prev"] = "[u",
		["next"] = "]u",
	},
}

M.code_runner = {
	filetype = {
		bash = "$dir/$fileName",
		cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
		haskell = "stack runhaskell",
		java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
		javascript = "node",
		lua = "lua",
		python = "python3 -u",
		r = "Rscript",
		shell = "$dir/$fileName",
		typescript = "deno run",
		zsh = "$dir/$fileName",
		excluded_buftypes = { "message" },
		-- Using tectonic compiler
		tex = function(...)
			local latexCompileOptions = {
				"Single",
				"Project",
			}
			local preview = require("code_runner.hooks.preview_pdf")
			local cr_au = require("code_runner.hooks.autocmd")
			vim.ui.select(latexCompileOptions, {
				prompt = "Select compile mode:",
			}, function(opt, _)
				if opt then
					if opt == "Single" then
						-- Single preview for latex files
						preview.run({
							command = "tectonic",
							args = { "$fileName", "--keep-logs", "-o", "/tmp" },
							preview_cmd = preview_cmd,
							overwrite_output = "/tmp",
						})
					elseif opt == "Project" then
						-- Create command for stop job
						cr_au.stop_job() -- CodeRunnerJobPosWrite
						-- Compile
						os.execute("tectonic -X build --keep-logs --open &> /dev/null &")
						-- Command for hotreload
						local fn = function()
							os.execute("tectonic -X build --keep-logs &> /dev/null &")
						end
						-- Create Job for hot reload latex compiler
						-- Execute after write
						cr_au.create_au_wirte(fn)
					end
				else
					local warn = require("utils").warn
					warn("Not Preview", "Preview")
				end
			end)
		end,
		markdown = function(...)
			local markdownCompileOptions = {
				Normal = "pdf",
				Presentation = "beamer",
			}
			vim.ui.select(vim.tbl_keys(markdownCompileOptions), {
				prompt = "Select preview mode:",
			}, function(opt, _)
				if opt then
					require("code_runner.hooks.preview_pdf").run({
						command = "pandoc",
						args = { "$fileName", "-o", "$tmpFile", "-t", markdownCompileOptions[opt] },
						preview_cmd = "/bin/zathura --fork",
					})
				else
					print("Not Preview")
				end
			end)
		end,
	},
	mode = "float",
	startinsert = true,
	float = {
		close_key = "q",
		border = "rounded",
		height = 0.8,
		width = 0.8,
		x = 0.5,
		y = 0.5,
		-- Highlight group for floating window/border (see ':h winhl')
		border_hl = "FloatBorder",
		float_hl = "Normal",
		-- Transparency (see ':h winblend')
		blend = 0,
	},
}

M.aerial = {
	backends = { "treesitter", "lsp", "markdown", "man" },
	layout = {
		default_direction = "prefer_right",
		placement = "edge",
	},
	attach_mode = "window", -- 'window' | 'global'
	nerd_font = "auto",
	show_guides = true,
	-- Highlight the symbol in the source buffer when cursor is in the aerial win
	highlight_on_hover = true,
	ignore = {
		-- Ignore unlisted buffers. See :help buflisted
		unlisted_buffers = true,
	},
}

M.neogen = {
	enabled = true,
	snippet_engine = "luasnip",
	languages = {
		lua = {
			template = {
				annotation_convention = "emmylua", -- for more template configurations, see the language's configuration file in configurations/{lang}.lua
			},
			cs = { template = { annotation_convention = "xmldoc" } },
		},
	},
}

M.actpreview = {
	telescope = {
		sorting_strategy = "ascending",
		layout_strategy = "vertical",
		layout_config = {
			width = 0.8,
			height = 0.9,
			prompt_position = "top",
			preview_cutoff = 20,
			preview_height = function(_, _, max_lines)
				return max_lines - 15
			end,
		},
	},
}

M.notify = {
	timeout = 3000,
	max_height = function()
		return math.floor(vim.o.lines * 0.75)
	end,
	max_width = function()
		return math.floor(vim.o.columns * 0.75)
	end,
}

M.csharp = {
	lsp = {
		enable = true,
		-- When set, csharp.nvim won't install omnisharp automatically and use it via mason.
		-- Instead, the omnisharp instance in the cmd_path will be used.
		-- cmd_path = "/home/ajay/.local/share/nvim/mason/packages/omnisharp/omnisharp",
		-- Settings that'll be passed to the omnisharp server
		enable_editor_config_support = true,
		organize_imports = true,
		load_projects_on_demand = false,
		enable_analyzers_support = true,
		enable_import_completion = true,
		include_prerelease_sdks = true,
		analyze_open_documents_only = false,
		enable_package_auto_restore = true,
		-- If true, MSBuild project system will only load projects for files that
		-- were opened in the editor. This setting is useful for big C# codebases
		-- and allows for faster initialization of code navigation features only
		-- for projects that are relevant to code that is being edited. With this
		-- setting enabled OmniSharp may load fewer projects and may thus display
		-- incomplete reference lists for symbols.
		enable_ms_build_load_projects_on_demand = false,
		capabilities = vim.lsp.protocol.make_client_capabilities(),
	},
}

return M
