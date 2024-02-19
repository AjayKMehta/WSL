local overrides = require("custom.configs.overrides")

local function load_config(plugin)
	return function()
		require("custom.configs." .. plugin)
	end
end

local haskell_ft = { "haskell", "lhaskell", "cabal", "cabalproject" }

--[[
Plugins divided into the following categories:
1. Debugging, diagnostics
2. Treesitter + LSP
3. Test
4. Utility
5. Snippets + completion
6. Telescope
7. Haskell
8. Editing
9. Languages
10. JSON + YAML
11. Markdown
12. LaTeX
13. Appearance
]]

---@diagnostic disable-next-line: undefined-doc-name
---@type NvPluginSpec[]
local plugins = {

	-- Debugging, diagnostics

	{
		"rcarriga/nvim-dap-ui",
		dependencies = "mfussenegger/nvim-dap",
		config = load_config("dap-ui"),
	},
	{
		"mfussenegger/nvim-dap",
		config = load_config("dap"),
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
		config = function(_, opts)
			local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(path)
			require("core.utils").load_mappings("dap_python")
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = load_config("mason-nvim-dap"),
	},
	{
		-- Code actions in telescope/nui
		"aznhe21/actions-preview.nvim",
		event = "VeryLazy",
		opts = overrides.actpreview,
	},
	{
		"piersolenski/wtf.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	-- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
	{
		"folke/trouble.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		cmd = { "Trouble", "TroubleToggle", "TodoTrouble" },
		config = function()
			require("trouble").setup({})
		end,
		lazy = false,
	},
	{ "jbyuki/one-small-step-for-vimkind", module = "osv" },

	--  Treesitter + LSP

	-- More readable hover message
	{
		"Fildo7525/pretty_hover",
		event = "LspAttach",
	},
	{
		"hedyhli/outline.nvim",
		cmd = { "Outline", "OutlineOpen" },
		opts = {
			outline_window = {
				auto_jump = false,
				wrap = true,
			},
			preview_window = { auto_preview = true },
			symbol_folding = {
				auto_unfold = {
					only = 2,
				},
			},
			outline_items = {
				show_symbol_lineno = false,
			},
		},
		config = function(_, opts)
			require("outline").setup(opts)
		end,
	},
	{
		"ckolkey/ts-node-action",
		dependencies = { "nvim-treesitter" },
		opts = {},
	},
	{
		-- Folds
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
		event = "BufRead",
		configg = load_config("ufo"),
	},
	-- Navigate your code with search labels, enhanced character motions, and Treesitter integration.
	{
		"folke/flash.nvim",
		event = "VeryLazy",
	},
	{
		"ray-x/lsp_signature.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		opts = {},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
	{
		"mrded/nvim-lsp-notify",
		requires = { "rcarriga/nvim-notify" },
		enabled = false,
		event = "BufReadPre",
		config = function()
			require("lsp-notify").setup({
				notify = require("notify"),
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		event = VeryLazy,
		lazy = false,
		config = load_config("comment"),
		dependencies = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				lazy = false,
				config = load_config("ts-context-commentstring"),
			},
		},
	},
	{
		"iabdelkareem/csharp.nvim",
		opts = overrides.csharp,
		ft = { "cs", "vb", "csproj", "sln", "slnx", "props" },
		dependencies = {
			"williamboman/mason.nvim", -- Required, automatically installs omnisharp
			"Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
		},
		config = function(_, opts)
			require("csharp").setup(opts)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				-- "jose-elias-alvarez/null-ls.nvim",
				-- https://github.com/craftzdog/dotfiles-public/issues/132#issuecomment-1750030050
				"nvimtools/none-ls.nvim",
				config = load_config("null-ls"),
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},
	-- Generate comments based on treesitter
	{
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		opts = overrides.neogen,
		-- Uncomment next line if you want to follow only stable versions
		version = "*",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		-- https://github.com/NvChad/NvChad/commit/282a23f4469ee305e05ec7a108a728ee389d87fb
		tag = "v0.9.2",
		opts = overrides.treesitter,
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-refactor",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "syntax")
			require("nvim-treesitter.configs").setup(opts)
			require("nvim-treesitter.install").compilers = { "clang" }
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		lazy = false,
		event = "BufReadPost",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			max_lines = 3,
			min_window_height = 0,
			patterns = {
				default = {
					"class",
					"function",
					"method",
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			-- "nvim-treesitter/nvim-treesitter",
		},
		config = load_config("ts-textobjects"),
	},
	{
		"stevearc/aerial.nvim",
		lazy = true,
		cmd = "AerialToggle",
		opts = overrides.aerial,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<Leader>ta", "<CMD>AerialToggle<CR>", mode = { "n" }, desc = "Open or close the aerial window" },
		},
	},
	{
		"ziontee113/syntax-tree-surfer",
		event = "BufRead",
		config = load_config("syntax-tree-surfer"),
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
	},

	-- Test
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
			"Issafalcon/neotest-dotnet",
			"mrcjkb/neotest-haskell",
		},
		config = load_config("neotest"),
	},

	-- Utility
	{ "akinsho/git-conflict.nvim", version = "*", config = true },
	{
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		cmd = "Octo",
		config = function()
			require("octo").setup({
				enable_builtin = true,
				use_local_fs = true,
			})
			vim.cmd([[hi OctoEditable guibg=none]])
			vim.treesitter.language.register("markdown", "octo")
		end,
	},
	-- A Neovim plugin helping you establish good command workflow and habit
	{
		"m4xshen/hardtime.nvim",
		dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = { "ToggleTerm", "ToggleTermAll", "TermExec" },
		config = load_config("toggleterm"),
	},
	{
		"ahmedkhalf/project.nvim",
		-- Even if you are pleased with the defaults, please note that setup {} must
		-- be called for the plugin to start.
		config = load_config("project"),
	},
	{ "folke/neodev.nvim" },
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"willothy/wezterm.nvim",
		config = true,
	},
	{
		"MattesGroeger/vim-bookmarks",
		cmd = {
			"BookmarkToggle",
			"BookmarkClear",
			"BookmarkClearAll",
			"BookmarkNext",
			"BookmarkPrev",
			"BookmarkShowALl",
			"BookmarkAnnotate",
			"BookmarkSave",
			"BookmarkLoad",
		},
	},
	-- https://github.com/tinyCatzilla/dots/blob/193cc61951579db692e9cc7f8f278ed33c8b52d4/.config/nvim/lua/custom/plugins.lua
	{
		"rcarriga/nvim-notify",
		keys = {
			{
				"<leader>un",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Dismiss all Notifications",
			},
		},
		opts = overrides.notify,
		config = function(_, opts)
			-- https://github.com/rcarriga/nvim-notify/wiki/Usage-Recipes#output-of-command
			local notify = require("notify")
			notify.setup(opts)
			vim.notify = notify
		end,
	},
	{
		"CRAG666/code_runner.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = overrides.code_runner,
		event = "BufEnter", -- Lazy load when entering a buffer
	},
	{
		"sindrets/diffview.nvim",
		lazy = true,
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		config = load_config("diffview"),
	},

	-- Snippets + completion
	-- h/t https://gist.github.com/ianchesal/93ba7897f81618ca79af01bc413d0713
	{
		"hrsh7th/nvim-cmp",
		opts = overrides.cmp,
		lazy = false,
		-- Doesn't work
		-- event = { "InsertEnter", "CmdlineEnter" },
		config = function(_, opts)
			require("cmp").setup(opts)
			require("custom.configs.cmp")
		end,
		dependencies = {
			{
				"uga-rosa/cmp-dictionary",
				event = "InsertEnter",
				opts = overrides.dict,
			},
			{
				"amarakon/nvim-cmp-lua-latex-symbols",
				event = "InsertEnter",
				opts = { cache = true },
				config = function(_, opts)
					require("cmp").setup()
				end,
			},
			{ "FelipeLema/cmp-async-path" },
			{
				"nat-418/cmp-color-names.nvim",
				event = "InsertEnter",
			},
			{
				"hrsh7th/cmp-emoji",
				lazy = false,
			},
			{
				"hrsh7th/cmp-nvim-lua",
				lazy = false,
			},
			-- Didn't work
			-- { "hrsh7th/cmp-nvim-lsp-document-symbol" },
			{
				"hrsh7th/cmp-cmdline",
				lazy = false,
			},
			{
				"doxnit/cmp-luasnip-choice",
				config = function()
					require("cmp_luasnip_choice").setup({
						auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
					})
				end,
			},
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "lukas-reineke/cmp-rg" },
			{ "amarakon/nvim-cmp-buffer-lines" },
			{ "L3MON4D3/LuaSnip" },
			{ "ray-x/cmp-treesitter" },
			{ "jalvesaq/cmp-nvim-r" },
			{ "rcarriga/cmp-dap" },
			{
				"petertriho/cmp-git",
				dependencies = { "nvim-lua/plenary.nvim" },
				config = load_config("cmp-git"),
			},
		},
	},
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		dependencies = {
			"rafamadriz/friendly-snippets", -- useful snippets
			"onsails/lspkind.nvim", -- vs-code like pictograms
		},
		build = "make install_jsregexp",

		config = load_config("ls"),
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		-- if you load some function or module within your opt, wrap it with a function
		opts = {
			defaults = {
				mappings = {
					i = {
						["<esc>"] = function(...)
							require("telescope.actions").close(...)
						end,
					},
				},
			},
		},
		-- https://github.com/nvim-telescope/telescope-fzf-native.nvim
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
			-- "debugloop/telescope-undo.nvim",
			"benfowler/telescope-luasnip.nvim",
			"Marskey/telescope-sg",
			"tom-anders/telescope-vim-bookmarks.nvim",
			"debugloop/telescope-undo.nvim",
		},
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("fzf")
			require("telescope").load_extension("projects")
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-media-files.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
	{
		"axieax/urlview.nvim",
		cmd = { "UrlView" },
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"stevearc/dressing.nvim",
		},
		opts = overrides.urlview,
	},

	-- Haskell
	{
		"hasufell/ghcup.vim",
		lazy = false,
		dependencies = {
			{ "rbgrouleff/bclose.vim" },
		},
	},
	-- TODO: Comment out later when switch extensions.
	{
		"neovimhaskell/haskell-vim",
		ft = haskell_ft,
		-- https://github.com/neovimhaskell/haskell-vim#configuration
		config = function()
			-- to enable highlighting of `forall`
			vim.g.haskell_enable_quantification = 1
			-- to enable highlighting of `mdo` and `rec`
			vim.g.haskell_enable_recursivedo = 1
			-- to enable highlighting of `proc`
			vim.g.haskell_enable_arrowsyntax = 1
			-- to enable highlighting of `pattern`
			vim.g.haskell_enable_pattern_synonyms = 1
			-- to enable highlighting of type roles
			vim.g.haskell_enable_typeroles = 1
			-- to enable highlighting of `static`
			vim.g.haskell_enable_static_pointers = 1
			-- to enable highlighting of backpack keywords
			vim.g.haskell_backpack = 1
		end,
	},
	{
		"mrcjkb/haskell-snippets.nvim",
		ft = haskell_ft,
		dependencies = { "L3MON4D3/LuaSnip" },
		config = load_config("haskell-snippets"),
	},
	{
		"luc-tielen/telescope_hoogle",
		ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
		dependencies = {
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			local ok, telescope = pcall(require, "telescope")
			if ok then
				telescope.load_extension("hoogle")
			end
		end,
	},

	-- Editing
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-surround").setup({
				-- configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},
	{ "junegunn/vim-peekaboo" },
	{
		-- Move lines and blocks of code
		"echasnovski/mini.move",
		version = false,
		opts = { options = { reindent_linewise = true } },
		event = "VeryLazy",
	},
	{
		-- Show all todo comments in solution
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
		event = "VeryLazy",
	},
	-- Automatically configures lua-language-server for your Neovim config, Neovim runtime and plugin directories
	-- { "folke/neodev.nvim" },

	-- Languages
	{
		"PProvost/vim-ps1",
		ft = "powershell",
	},
	{
		"jalvesaq/Nvim-R",
		lazy = false,
		ft = { "r", "rmd", "quarto" },
		config = function()
			require("cmp_nvim_r").setup({})
		end,
	},

	-- JSON + YAML
	{
		"someone-stole-my-name/yaml-companion.nvim",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("telescope").load_extension("yaml_schema")
		end,
	},
	{
		"cuducos/yaml.nvim",
		ft = { "yaml" }, -- optional
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- optional
		},
	},
	-- JSON Schemas
	{ "b0o/schemastore.nvim" },

	-- Markdown
	{
		"tadmccorkle/markdown.nvim",
		event = "VeryLazy",
		opts = {
			-- configuration here or empty for defaults
		},
	},
	{
		"AckslD/nvim-FeMaco.lua",
		config = function()
			require("femaco").setup()
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		-- https://github.com/iamcco/markdown-preview.nvim/issues/616#issuecomment-1774970354
		build = function()
			local job = require("plenary.job")
			local install_path = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim/app"
			local cmd = "bash"

			if vim.fn.has("win64") == 1 then
				cmd = "pwsh"
			end

			job:new({
				command = cmd,
				args = { "-c", "npm install && git restore ." },
				cwd = install_path,
				on_exit = function()
					print("Finished installing markdown-preview.nvim")
				end,
				on_stderr = function(_, data)
					print(data)
				end,
			}):start()

			-- Options
			vim.g.mkdp_auto_close = 0
		end,
		lazy = true,
		keys = { { "gm", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" } },
		config = load_config("md-preview"),
	},

	-- LaTeX

	{
		"lervag/vimtex",
		lazy = false,
		-- config = load_config("vimtex")
		init = load_config("vimtex"),
	},
	{
		"iurimateus/luasnip-latex-snippets.nvim",
		dependencies = { "L3MON4D3/LuaSnip" },
		ft = { "tex", "markdown" },
		config = load_config("ls-latex-snippets"),
	},

	-- Appearance
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
		-- Setting these in config was not working 😦
		init = function()
			vim.opt.fillchars = {
				fold = " ",
				foldopen = "",
				foldsep = " ",
				foldclose = "",
				stl = " ",
				eob = " ",
			}
			vim.o.foldcolumn = "1"
			vim.o.foldenable = true -- enable fold for nvim-ufo
			vim.o.foldlevel = 99 -- set high foldlevel for nvim-ufo
			vim.o.foldlevelstart = 99 -- start with all code unfolded
		end,
		config = load_config("ufo"),
	},
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		opts = overrides.lualine,
		config = function(_, opts)
			require("lualine").setup(opts)
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		enabled = false,
		opts = overrides.blankline,
		-- version = '*',
		main = "ibl",
		event = { "BufReadPre", "BufNewFile" },
		-- Uncomment after upgrade to v3
		-- config = load_config("indent-blankline")
	},
	{
		"shellRaining/hlchunk.nvim",
		event = { "UIEnter" },
		config = load_config("hlchunk"),
	},
	{
		"stevearc/dressing.nvim",
		lazy = false,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = load_config("bufferline"),
	},
	-- Adds horizontal highlights for text filetypes, like markdown, orgmode, and neorg
	{
		"lukas-reineke/headlines.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = load_config("headlines"),
	},

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
}

return plugins
