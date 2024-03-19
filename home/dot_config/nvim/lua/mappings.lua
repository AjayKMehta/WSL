require "nvchad.mappings"
---@diagnostic disable: undefined-doc-name, inject-field
---@type MappingsTable
local M = {}

-- To disable mappings:
M.disabled = {
	n = {
		["<C-b>"] = "",
		["gi"] = "", -- Clashes with Treesitter keymap
		["<leader>lf"] = "", -- Clashes with conform keymap
	},
}

M.general = {
	n = {
		-- [";"] = { ":", "enter command mode", opts = { nowait = true } },
		-- https://nvchad.com/docs/api
		["<A-left>"] = {
			function()
				-- move buffer left
				require("nvchad.tabufline").move_buf(-1)
			end,
			"Move buffer left",
		},
		["<A-right>"] = {
			function()
				-- move buffer right
				require("nvchad.tabufline").move_buf(1)
			end,
			"Move buffer right",
		},
		["<leader>tt"] = {
			function()
				require("base46").toggle_theme()
			end,
			"Toggle theme",
		},
		["gli"] = {
			function()
				vim.lsp.buf.implementation()
			end,
			"LSP implementation",
		},

		["<leader>lF"] = {
			function()
				vim.diagnostic.open_float({ border = "rounded" })
			end,
			"Floating diagnostic",
		},
	},
}

-- more keybinds!
M.gitsigns = {
	n = {
		-- Actions
		["<leader>sh"] = {
			function()
				require("gitsigns").stage_hunk()
			end,
			"Stage hunk",
		},

		["<leader>uh"] = {
			function()
				require("gitsigns").undo_stage_hunk()
			end,
			"Undo stage hunk",
		},

		["<leader>tb"] = {
			function()
				package.loaded.gitsigns.toggle_current_line_blame()
			end,
			"Toggle current line blame",
		},
	},
	v = {
		["<leader>sh"] = {
			function()
				require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end,
			"Stage hunk",
		},
		["<leader>rh"] = {
			function()
				require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end,
			"Reset hunk",
		},
	},
}

M.ghcup = {
	plugin = true,
	n = {
		["<leader>gg"] = { "<cmd>GHCup <CR>", "ghcup" },
	},
}

M.telescope = {
	plugin = true,
	n = {
		-- find
		["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "Telescope: Find files" },
		["<leader>fa"] = {
			"<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
			"Telescope: Find all",
		},
		["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "Telescope: Live grep" },
		["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "Telescope: Find buffers" },
		["<leader>f?"] = { "<cmd> Telescope help_tags <CR>", "Telescope: Help page" },
		["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "Telescope: Find oldfiles" },
		["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Telescope: Find in current buffer" },
		["<leader>fh"] = { "<cmd> Telescope file_browser cwd=$HOME <CR>", "Telescope: Search home" },
		["<leader>fc"] = { "<cmd> Telescope find_files cwd=$HOME/.config <CR>", "Telescope: Search config" },
		["<leader>fk"] = { "<cmd> Telescope keymaps <CR>", "Telescope: Keymap" },
		["<leader>fu"] = { "<cmd>Telescope undo<CR>", "Telescope:  Undo tree" },
		["<leader>fy"] = {
			function()
				require("telescope.builtin").buffers()
			end,
			"Telescope: Search buffers",
		},
		["<leader>fd"] = { "<cmd>Telescope lsp_document_symbols<CR>", "Telescope: Search Document Symbols" },
		["leader>sw"] = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Search Workspace Symbols" },
		["<leader>fe"] = { "<cmd>Telescope emoji<CR>", "Telescope: Search emojis" },
	},
}

M.minimove = {
	plugin = true,
	n = {
		["<A-Left>"] = {
			function()
				require("mini.move").move_line("left")
			end,
			"move line left",
		},
		["<A-Right>"] = {
			function()
				require("mini.move").move_line("right")
			end,
			"move line right",
		},
		["<A-Down>"] = {
			function()
				require("mini.move").move_line("down")
			end,
			"move line down",
		},
		["<A-Up>"] = {
			function()
				require("mini.move").move_line("up")
			end,
			"move line up",
		},
	},
	v = {
		["<A-Left>"] = {
			function()
				require("mini.move").move_line("left")
			end,
			"move selection left",
		},
		["<A-Right>"] = {
			function()
				require("mini.move").move_line("right")
			end,
			"move selection right",
		},
		["<A-Down>"] = {
			function()
				require("mini.move").move_line("down")
			end,
			"move selection down",
		},
		["<A-Up>"] = {
			function()
				require("mini.move").move_line("up")
			end,
			"move selection up",
		},
	},
}

M.trouble = {
	n = {
		["<leader>tw"] = {
			"<cmd>TroubleToggle workspace_diagnostics <CR>",
			"Workspace diagnostics",
		},
		["<leader>td"] = {
			"<cmd>TroubleToggle document_diagnostics <CR>",
			"Document diagnostics",
		},
		["<leader>tL"] = { "<cmd> TroubleToggle loclist <CR>", "Location List (Trouble)" },
		["<leader>tQ"] = { "<cmd> TroubleToggle quickfix <CR>", "Quickfix List (Trouble)" },
		["<leader>tS"] = { "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme" },
	},
}

M.bookmark = {
	n = {
		-- ["<leader>mt"] = { "<cmd> BookmarkToggle<CR>", "󰃅 Toggle bookmark" },
		-- ["<leader>mn"] = { "<cmd> BookmarkNext<CR>", "󰮰 Next bookmark" },
		-- ["<leader>mp"] = { "<cmd> BookmarkPrev<CR>", "󰮲 Prev bookmark" },
		-- ["<leader>mc"] = { "<cmd> BookmarkClear<CR>", "󰃢 Clear bookmarks" },
		["<leader>mm"] = { "<cmd>Telescope vim_bookmarks all<CR>", " Bookmark Menu" },
	},
}

M.hover = {
	n = {
		["<leader>ko"] = {
			function()
				require("pretty_hover").hover()
			end,
			"Open hover",
		},
		["<leader>kq"] = {
			function()
				require("pretty_hover").close()
			end,
			"Close hover",
		},
	},
}

M.dap = {
	plugin = true,
	-- Keep same as VS + VS Code
	n = {
		["<F9>"] = { "<cmd> DapToggleBreakpoint <CR>", "Toggle breakpoint" },
		["<F5>"] = { "<cmd> CapContinute<CR>", "Launch debugger" },
		["<F10>"] = { "<cmd> DapStepOver <CR>", "Step over" },
		["<F11>"] = { "<cmd> DapStepInto <CR>", "Step into" },
		["<S-F11>"] = { "<cmd> DapStepOut <CR>", "Step out" },
		["<leader>rb"] = {
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			"Set conditional breakpoint",
		},
		["<leader>rl"] = {
			function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end,
			"Log message",
		},
	},
}

M.dap_python = {
	plugin = true,
	n = {
		["<leader>rt"] = {
			function()
				require("dap-python").test_method()
			end,
			"Debug the closest method to cursor",
		},
	},
}

M.luasnip = {
	n = {
		["<leader><space>l"] = {
			function(...)
				local sl = require("luasnip.extras.snippet_list")
				-- keeping the default display behavior but modifying window/buffer
				local modified_default_display = sl.options.display({
					buf_opts = { filetype = "lua" },
					win_opts = { foldmethod = "manual" },
					get_name = function(buf)
						return "Custom Display buf " .. buf
					end,
				})

				-- using it
				sl.open({ display = modified_default_display })
			end,
			"List snippets",
		},
	},
	-- This doesn't work!
	-- i = {
	--   ["<C-n>"] = { "<cmd> luasnip-next-choice <CR>", "Next choice" },
	--   ["<C-p>"] = { "<cmd> luasnip-prev-choice <CR>", "Previous choice" }
	-- },
	-- s = {
	--   ["<C-n>"] = { "<cmd> luasnip-next-choice <CR>", "Next choice" },
	--   ["<C-p>"] = { "<cmd> luasnip-prev-choice <CR>", "Previous choice" }
	-- },
}

M.urlview = {
	n = {
		["<leader>uu"] = { "<cmd>UrlView<CR>", "Show local URLs" },
	},
}

-- This doesn't work! Get error about missing global STSSwapUpNormal_Dot.

-- M.treesurfer = {
--   n = {

--     ["vU"] = {
--       function()
--         vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
--         return "g@l"
--       end,
--       'Swap master node with above',
--       opts = { silent = true, expr = true }
--     },
--     ["vD"] = {
--       function()
--         vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
--         return "g@l"
--       end,
--       'Swap master node with below',
--     }
--   }
-- }

M.code_runner = {
	n = {
		["<leader>rc"] = { "<cmd>RunCode<CR>" },
		["<leader>rf"] = { "<cmd>RunFile<CR>" },
		["<leader>rp"] = { "<cmd>RunProject<CR>" },
		["<leader>rx"] = { "<cmd>RunClose<CR>" },
		["<leader>crf"] = { "<cmd>CRFiletype<CR>" },
		["<leader>crp"] = { "<cmd>CRProjects<CR>" },
	},
}

M.neogen = {
	n = {
		["<leader>nc"] = {
			function()
				require("neogen").generate({
					type = "class",
				})
			end,
			"Generate annotation for class",
		},
		["<leader>nf"] = {
			function()
				require("neogen").generate({
					type = "func",
				})
			end,
			"Generate annotation for function",
		},
	},
}

M.wtf = {
	n = {
		["gw"] = {
			function()
				require("wtf").ai()
			end,
			"Debug diagnostic with AI",
		},
		["gW"] = {
			function()
				require("wtf").search()
			end,
			"Search diagnostic with Google",
		},
	},
	x = {
		["gw"] = {
			function()
				require("wtf").ai()
			end,
			"Debug diagnostic with AI",
		},
	},
}

M.actpreview = {
	n = {
		["ga"] = {
			function()
				require("actions-preview").code_actions()
			end,
			"Preview code actions.",
		},
	},
	v = {
		["ga"] = {
			function()
				require("actions-preview").code_actions()
			end,
			"Preview code actions.",
		},
	},
}

M.flash = {
	[{ "n", "o", "x" }] = {
		["<leader>ss"] = {
			function()
				require("flash").jump()
			end,
			"Flash",
		},
		["<leader>sS"] = {
			function()
				require("flash").treesitter()
			end,
			"Flash Treesitter",
		},
		["<leader>sf"] = {
			function()
				require("flash").jump({
					search = { forward = true, wrap = false, multi_window = false },
				})
			end,
			"Flash forward",
		},
		["<leader>sb"] = {
			function()
				require("flash").jump({
					search = { forward = false, wrap = false, multi_window = false },
				})
			end,
			"Flash backward",
		},
		["<leader>sc"] = {
			function()
				require("flash").jump({
					search = { continue = true },
				})
			end,
			"Continue search",
		},
		["<leader>sd"] = {
			function()
				-- More advanced example that also highlights diagnostics:
				require("flash").jump({
					matcher = function(win)
						---@param diag Diagnostic
						return vim.tbl_map(function(diag)
							return {
								pos = { diag.lnum + 1, diag.col },
								end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
							}
						end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
					end,
					action = function(match, state)
						vim.api.nvim_win_call(match.win, function()
							vim.api.nvim_win_set_cursor(match.win, match.pos)
							vim.diagnostic.open_float()
						end)
						state:restore()
					end,
				})
			end,
			"Flash diagnostics",
		},
	},
	o = {
		["r"] = {
			function()
				require("flash").remote()
			end,
			"Remote Flash",
		},
	},
	[{ "o", "x" }] = {
		["R"] = {
			function()
				require("flash").treesitter_search()
			end,
			"Treesitter Search",
		},
	},
	c = {
		["<c-s>"] = {
			function()
				require("flash").toggle()
			end,
			"Toggle Flash Search",
		},
	},
}

M.neotest = {
	n = {
		["<leader>tr"] = {
			function()
				vim.notify_once("Running single test", vim.log.levels.INFO, {
					title = "Neotest",
				})
				require("neotest").run.run()
			end,
			"Run test",
		},
		["<leader>to"] = {
			function()
				require("neotest").output.open({
					enter = true,
					open_win = function(settings)
						local height = math.min(settings.height, vim.o.lines - 2)
						local width = math.min(settings.width, vim.o.columns - 2)
						return vim.api.nvim_open_win(0, true, {
							relative = "editor",
							row = 7,
							col = (vim.o.columns - width) / 2,
							width = width,
							height = height,
							style = "minimal",
							border = vim.g.floating_window_border,
							noautocmd = true,
						})
					end,
				})
			end,
			"Show test output",
		},
		["<leader>ts"] = {
			function()
				require("neotest").summary.toggle()
			end,
			"Show test summary",
		},
	},
}

M.ufo = {
	n = {
		["]z"] = {
			function()
				require("ufo").goNextClosedFold()
			end,
			"Go to next closed fold",
		},
		["[z"] = {
			function()
				require("ufo").goPreviousClosedFold()
			end,
			"Go to previous closed fold",
		},
		-- ["zp"] = {
		-- 	function()
		-- 		local winid = require("ufo").peekFoldedLinesUnderCursor()
		-- 		if winid then
		-- 			local bufnr = vim.api.nvim_win_get_buf(winid)
		-- 			local keys = { "a", "i", "o", "A", "I", "O", "gd", "gr" }
		-- 			for _, k in ipairs(keys) do
		-- 				-- Add a prefix key to fire `trace` action,
		-- 				-- if Neovim is 0.8.0 before, remap yourself
		-- 				vim.keymap.set("n", k, "<CR>" .. k, { noremap = false, buffer = bufnr })
		-- 			end
		-- 		end
		-- 	end,
		-- 	"Peek folded lines under cursor",
		-- },
	},
}

M.node_action = {
	n = {
		["gA"] = {
			function()
				require("ts-node-action").node_action()
			end,
			"Trigger Node Action",
		},
	},
}

M.legend = {
	n = {
		["<leader>lk"] = {
			function()
				local filters = require("legendary.filters")
				require("legendary").find({
					filters = {
						filters.current_mode(),
						filters.keymaps(),
					},
				})
			end,
			"Legendary keymap (current mode)",
		},
	},
}

M.outline = {
	n = {
		["<leader>go"] = { "<cmd>Outline<cr>", "Toggle Outline" },
	},
}

M.octo = {
	n = {
		["<leader>gO"] = { "<cmd>Octo<cr>", "Octo" },
		["<leader>gp"] = { "<cmd>Octo pr list<cr>", "Octo PR list" },
	},
}

return M
