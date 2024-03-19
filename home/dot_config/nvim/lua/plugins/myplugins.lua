local overrides = require("configs.overrides")

local function load_config(plugin)
	return function()
		require("configs." .. plugin)
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
14. git

]]

---@diagnostic disable-next-line: undefined-doc-name

local plugins = {
	--#region Debugging, diagnostics
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
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
		end,
	},
	-- It's important that you set up the plugins in the following order:

	-- mason.nvim
	-- mason-lspconfig.nvim
	-- Setup servers via lspconfig
	{
		"williamboman/mason.nvim",
		-- https://github.com/williamboman/nvim-lsp-installer/discussions/509#discussioncomment-4009039
		opts = {
			PATH = "prepend", -- "skip" seems to cause the spawning error
		},
		config = function(_, opts)
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = overrides.mason_lsp,
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)
		end,
	},
	{
		-- It's important that you set up the plugins in the following order:

		-- 1. mason.nvim
		-- 2. mason-nvim-dap.nvim

		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = load_config("mason-nvim-dap"),
	},
	{
		"aznhe21/actions-preview.nvim",
		event = "VeryLazy",
		opts = overrides.actpreview,
		desc = "Preview code with LSP code actions applied.",
	},
	{
		"piersolenski/wtf.nvim",
		opts = {
			popup_type = "vertical",
		},
		cmd = { "WtfSearch", "Wtf" },
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		desc = "AI/search-engine powered diagnostic debugging",
	},
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
		desc = "A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.",
	},

	--#endregion

	--#region Treesitter + LSP

	{
		"Fildo7525/pretty_hover",
		event = "LspAttach",
		desc = "Pretty hover messages.",
	},
	{ "poljar/typos.nvim", lazy = false },
	{
		-- Uses LSP instead of treesitter like aerial.
		"hedyhli/outline.nvim",
		cmd = { "Outline", "OutlineOpen" },
		enabled = true, -- Seems more reliablee than aerial.
		opts = overrides.outline,
		config = function(_, opts)
			require("outline").setup(opts)
		end,
		desc = "Code outline sidebar powered by LSP.",
	},
	{
		"ckolkey/ts-node-action",
		dependencies = { "nvim-treesitter" },
		opts = {},
		desc = "A framework for running functions on Tree-sitter nodes, and updating the buffer with the result.",
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
		event = "BufRead",
		config = load_config("ufo"),
		desc = "Enhanced folds",
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		desc = "Navigate your code with search labels, enhanced character motions, and Treesitter integration.",
	},
	{
		"ray-x/lsp_signature.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		-- enabled = false,
		opts = {},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
		desc = "Show function signature as you type.",
	},
	{
		"linrongbin16/lsp-progress.nvim",
		config = load_config("lsp_progress"),
		desc = "Performant LSP progress status.",
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
		desc = "Advanced comment plugin with Treesitter support.",
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
		desc = "C# plugin powered by omnisharp-roslyn.",
	},
	-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
	{
		"folke/neodev.nvim",
		desc = "Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.",
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			require("nvchad.configs.lspconfig")
			require("configs.lspconfig")
		end,
		desc = "Quickstart configs for Neovim LSP.",
	},
	{
		"zeioth/garbage-day.nvim",
		dependencies = "neovim/nvim-lspconfig",
		event = "VeryLazy",
		desc = "Garbage collector that stops inactive LSP clients to free RAM.",
	},
	{
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		opts = overrides.neogen,
		-- Uncomment next line if you want to follow only stable versions
		version = "*",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		desc = "Generate comments based on treesitter.",
	},
	{
		"nvim-treesitter/nvim-treesitter",
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
		opts = overrides.treesitter_context,
		desc = "Show code context.",
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			-- "nvim-treesitter/nvim-treesitter",
		},
		config = load_config("ts-textobjects"),
		desc = "Syntax aware text-objects, select, move, swap, and peek support.",
	},
	{
		"stevearc/aerial.nvim",
		lazy = true,
		cmd = { "AerialToggle", "AerialOpen", "AerialInfo" },
		enabled = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<Leader>ta", "<CMD>AerialToggle<CR>", mode = { "n" }, desc = "Open or close the aerial window" },
		},
		config = load_config("aerial"),
		desc = "A code outline window for skimming and quick navigation.",
	},
	{
		"ziontee113/syntax-tree-surfer",
		event = "BufRead",
		config = load_config("syntax-tree-surfer"),
		desc = "Helps you navigate and move nodes around based on Treesitter API.",
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
		desc = "Rainbow delimiters with Treesitter",
		config = load_config("rainbow"),
	},
	{
		"mfussenegger/nvim-lint",
		enabled = true,
		event = { "BufReadPre", "BufNewFile" },
		config = load_config("lint"),
		desc = "An asynchronous linter plugin.",
	},
	{
		"stevearc/conform.nvim",
		enabled = true,
		cmd = { "ConformInfo" },
		event = { "BufReadPre", "BufNewFile" },
		config = load_config("conform"),
		desc = "Lightweight formatter plugin.",
	},

	--#endregion

	--#region Test

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
		desc = "An extensible framework for interacting with tests.",
	},
	--#endregion

	--#region Utility

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = { "ToggleTerm", "ToggleTermAll", "TermExec" },
		config = load_config("toggleterm"),
		desc = "Plugin to easily manage multiple terminal windows.",
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		desc = "A file explorer tree.",
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "nvimtree")
			require("configs.nvimtree")
			require("nvim-tree").setup(opts)
		end,
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
		desc = "Vim bookmark plugin.",
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
		desc = "Configurable, notification manager",
	},
	{
		"CRAG666/code_runner.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = overrides.code_runner,
		event = "BufEnter",
		desc = "Code runner",
	},
	{ "kevinhwang91/nvim-bqf", ft = "qf", desc = "Better quickfix window" },

	--#endregion

	--#region Snippets + completion

	-- h/t https://gist.github.com/ianchesal/93ba7897f81618ca79af01bc413d0713
	{
		"hrsh7th/nvim-cmp",
		opts = overrides.cmp,
		event = { "InsertEnter", "CmdlineEnter" },
		config = function(_, opts)
			require("cmp").setup(opts)
			load_config("cmp")()
		end,
		dependencies = {
			{
				"amarakon/nvim-cmp-lua-latex-symbols",
				event = "InsertEnter",
				opts = { cache = true },
				-- Necessary to avoid runtime errors
				config = function(_, opts)
					require("cmp").setup(opts)
				end,
				desc = "Completion for LaTeX symbols",
			},
			{
				"FelipeLema/cmp-async-path",
				url = "https://codeberg.org/FelipeLema/cmp-async-path",
				desc = "Completion for fs paths (async)",
			},
			{
				"hrsh7th/cmp-emoji",
				event = "InsertEnter",
				enabled = false,
				desc = "nvim-cmp source for emojis",
			},
			{
				"hrsh7th/cmp-nvim-lua",
				event = "InsertEnter",
				-- Not needed bc of neodev
				enabled = false,
				desc = "Completion for Neovim's Lua runtime API.",
			},
			{
				"tzachar/cmp-fuzzy-buffer",
				dependencies = { "tzachar/fuzzy.nvim" },
				desc = "Fuzzy buffer completion",
			},
			{
				"hrsh7th/cmp-cmdline",
				lazy = false,
				desc = "nvim-cmp source for cmdline",
			},
			{
				"L3MON4D3/cmp-luasnip-choice",
				config = function()
					require("cmp_luasnip_choice").setup({
						auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
					})
				end,
				desc = "Luasnip choice node completion source for nvim-cmp",
			},
			{ "lukas-reineke/cmp-rg", enabled = false },
			{ "amarakon/nvim-cmp-buffer-lines", desc = "Completion for buffer lines" },
			{ "L3MON4D3/LuaSnip" },
			{ "ray-x/cmp-treesitter", desc = "cmp source for treesitter" },
			{ "jalvesaq/cmp-nvim-r", desc = "cmp source for R" },
			{ "rcarriga/cmp-dap", desc = "cmp source for DAP" },
			{
				"petertriho/cmp-git",
				dependencies = { "nvim-lua/plenary.nvim" },
				config = load_config("cmp-git"),
			},
		},
		desc = "Completion plugin for git",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			{ "rafamadriz/friendly-snippets", desc = "Useful snippets for different languages" },
			{ "onsails/lspkind.nvim", desc = "VS Code like pictograms" },
		},
		event = {
			"InsertEnter",
			"CmdlineEnter",
		},
		build = "make install_jsregexp",
		config = load_config("ls"),
		desc = "Snippet Engine for Neovim",
	},
	{
		"allaman/emoji.nvim",
		--   ft = "markdown", -- adjust to your needs
		dependencies = {
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			-- default is false
			enable_cmp_integration = true,
		},
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
			-- "stevearc/aerial.nvim",
		},
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.load_extension("fzf")
			telescope.load_extension("emoji")
			-- telescope.load_extension("aerial")
			telescope.setup(opts)
		end,
	},
	{
		"mrjones2014/legendary.nvim",
		-- since legendary.nvim handles all your keymaps/commands,
		-- its recommended to load legendary.nvim before other plugins
		priority = 10000,
		lazy = false,
		config = function()
			require("legendary").setup({
				extensions = {
					nvim_tree = true,
					lazy_nvim = { auto_register = true },
					which_key = {
						-- Automatically add which-key tables to legendary
						-- see ./doc/WHICH_KEY.md for more details
						auto_register = true,
					},
				},
			})
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
	{
		"antonk52/markdowny.nvim",
		ft = { "markdown" },
		config = function()
			require("markdowny").setup()
		end,
		desc = " Add key bindings for markdown.",

		-- <C-k>: Adds a link to visually selected text.
		-- <C-b>: Toggles visually selected text to bold.
		-- <C-i>: Toggles visually selected text to italic.
		-- <C-e>: Toggles visually selected text to inline code, and V-LINE selected text to a multiline code block.
	},

	-- LaTeX

	{
		"lervag/vimtex",
		ft = { "tex", "rmd" },
		config = load_config("vimtex"),
		-- init = load_config("vimtex"),
	},
	{
		"iurimateus/luasnip-latex-snippets.nvim",
		dependencies = { "L3MON4D3/LuaSnip" },
		ft = { "tex", "markdown" },
		config = load_config("ls-latex-snippets"),
	},

	-- Appearance
	{ "tomasiser/vim-code-dark" },
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
		config = load_config("lualine"),
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
		config = function()
			require("dressing").setup({
				select = {
					get_config = function(opts)
						if opts.kind == "legendary.nvim" then
							return {
								telescope = {
									sorter = require("telescope.sorters").fuzzy_with_index_bias({}),
								},
							}
						else
							return {}
						end
					end,
				},
			})
		end,
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
	{
		"xiantang/darcula-dark.nvim",
		enabled = true,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		enabled = true,
		priority = 1000,
		opts = {},
	},
	{ "kepano/flexoki-neovim", enabled = false },

	--#region git

	{
		"akinsho/git-conflict.nvim",
		version = "*",
		config = true,
		desc = "A plugin to visualise and resolve merge conflicts.",
	},
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
		desc = "Edit and review GitHub issues and pull requests from the Neovim.",
	},
	{
		"sindrets/diffview.nvim",
		lazy = true,
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		config = load_config("diffview"),
	},

	--#endregion

	-- A polished, IDE-like, highly-customizable winbar for Neovim
	-- with drop-down menu support and multiple backends.

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
