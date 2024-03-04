local lualine = require("lualine")

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
	lightblue = "#7fd6ee",
	red = "#ec5f67",
}

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

local has_filename = function()
	return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
end

local config = {
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
				sources = { "nvim_diagnostic" },

				-- Displays diagnostics for the defined severity types
				sections = { "error", "warn", "info", "hint" },

				symbols = { error = "", warn = "", info = "", hint = "󰌶" },
				update_in_insert = true, -- Update diagnostics in insert mode.
				always_visible = false, -- Show diagnostics even if there are none.s
				diagnostics_color = {
					color_error = { fg = colors.red },
					color_warn = { fg = colors.yellow },
					color_info = { fg = colors.darkblue },
					color_hint = { fg = colors.yellow },
				},
			},
		},
		lualine_b = {
			{
				"branch",
				color = {
					fg = colors.lightblue,
					-- gui = "bold",
				},
			},
			{
				"diff",
				padding = { left = 2, right = 1 },
				colored = true,
				diff_color = {
					-- Same color values as the general color option can be used here.
					added = { fg = colors.green },
					modified = { fg = colors.yellow },
					removed = { fg = colors.red },
				},
				symbols = { added = "+", modified = "~", removed = "-" },
				source = diff_source,
			},
			-- {
			-- 	function(msg)
			-- 		msg = msg or "LS Inactive"
			-- 		local buf_clients = vim.lsp.buf_get_clients()
			-- 		if next(buf_clients) == nil then
			-- 			-- TODO: clean up this if statement
			-- 			if type(msg) == "boolean" or #msg == 0 then
			-- 				return "LS Inactive"
			-- 			end
			-- 			return msg
			-- 		end
			-- 		local buf_ft = vim.bo.filetype
			-- 		local buf_client_names = {}

			-- 		-- add client
			-- 		for _, client in pairs(buf_clients) do
			-- 			if client.name ~= "null-ls" and client.name ~= "copilot" then
			-- 				table.insert(buf_client_names, client.name)
			-- 			end
			-- 		end
			-- 		-- add formatter
			-- 		local supported_formatters = formatters.list_registered(buf_ft)
			-- 		vim.list_extend(buf_client_names, supported_formatters)

			-- 		-- add linter
			-- 		local supported_linters = linters.list_registered(buf_ft)
			-- 		vim.list_extend(buf_client_names, supported_linters)

			-- 		local unique_client_names = vim.fn.uniq(buf_client_names)
			-- 		local language_servers = "[ " .. table.concat(unique_client_names, ", ") .. "]"
			-- 		return language_servers
			-- 	end,
			-- },
		},
		lualine_c = {
			{
				"filename",
				cond = has_filename,
				file_status = true,
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
	extensions = { "nvim-tree", "lazy", "mason", "nvim-dap-ui", "trouble", "toggleterm", "quickfix" },
}

lualine.setup(config)
