local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")

local has_treesitter, ts = pcall(require, "vim.treesitter")
local _, query = pcall(require, "vim.treesitter.query")

local MATH_ENVIRONMENTS = {
	displaymath = true,
	eqnarray = true,
	equation = true,
	math = true,
	array = true,
}

local MATH_NODES = {
	displayed_equation = true,
	inline_formula = true,
}

local utils = {}

-- Partially apply func until no args left
utils.part = function(func, ...)
	local args = { ... }
	return function()
		return func(table.unpack(args))
	end
end

-- TODO: Update this with TS support
function utils.get_comment(text)
	vim.validate({
		text = {
			text,
			function(x)
				return not x or type(x) == type("") or vim.tbl_islist(x)
			end,
			"text must be either a string or an array of lines",
		},
	})
	local comment = vim.opt_local.commentstring:get()
	if not comment:match("%s%%s") then
		comment = comment:format(" %s")
	end
	local comment_str
	if text then
		if vim.tbl_islist(text) then
			comment_str = {}
			for _, line in ipairs(text) do
				table.insert(comment_str, comment:format(line))
			end
			comment_str = table.concat(comment_str, "\n")
		else
			comment_str = comment:format(text)
		end
	end
	return comment_str or comment
end

function utils.saved_text(_, snip, old_state, user_args)
	local nodes = {}
	old_state = old_state or {}
	user_args = user_args or {}

	local indent = user_args.indent and "\t" or ""

	if snip.snippet.env and snip.snippet.env.SELECT_DEDENT and #snip.snippet.env.SELECT_DEDENT > 0 then
		local lines = vim.deepcopy(snip.snippet.env.SELECT_DEDENT)
		-- local indent_level = require'utils.buffers'.get_indent_block_level(lines)
		-- lines = require'utils.buffers'.indent(lines, -indent_level)

		for idx = 1, #lines do
			local line = string.format("%s%s", indent, lines[idx] or "")
			local node = idx == #lines and { line } or { line, "" }
			table.insert(nodes, t(node))
		end
	else
		local text = user_args.text or utils.get_comment("code")
		if indent ~= "" then
			table.insert(nodes, t(indent))
		end
		table.insert(nodes, i(1, text))
	end

	local snip_node = sn(nil, nodes)
	snip_node.old_state = old_state
	return snip_node
end

function utils.surround_with_func(args, snip, old_state, user_args)
	local nodes = {}
	old_state = old_state or {}
	user_args = user_args or {}

	if snip.snippet.env and snip.snippet.env.SELECT_RAW and #snip.snippet.env.SELECT_RAW == 1 then
		local node = snip.snippet.env.SELECT_RAW[1]
		table.insert(nodes, t(node))
	else
		local text = user_args.text or "placeholder"
		table.insert(nodes, i(1, text))
	end

	local snip_node = sn(nil, nodes)
	snip_node.old_state = old_state
	return snip_node
end

function utils.copy(args)
	return args[1]
end

function utils.return_value()
	local clike = {
		c = true,
		cpp = true,
		java = true,
		cs = true,
	}

	local snippet = { t({ "return " }), i(1, "value") }

	if clike[vim.bo.filetype] then
		table.insert(snippet, t({ ";" }))
	end

	return snippet
end

function utils.else_clause(args, snip, old_state, placeholder)
	local nodes = {}
	local ft = vim.opt_local.filetype:get()

	if snip.captures[1] == "e" then
		if ft == "lua" then
			table.insert(nodes, t({ "", "else", "\t" }))
			table.insert(nodes, i(1, utils.get_comment("code")))
		elseif ft == "python" then
			table.insert(nodes, t({ "", "else", "\t" }))
			table.insert(nodes, i(1, "pass"))
		elseif ft == "sh" or ft == "bash" or ft == "zsh" then
			table.insert(nodes, t({ "else", "\t" }))
			table.insert(nodes, i(1, ":"))
			table.insert(nodes, t({ "", "" }))
		elseif ft == "go" or ft == "rust" then
			table.insert(nodes, t({ " else {", "\t" }))
			table.insert(nodes, i(1, utils.get_comment("code")))
			table.insert(nodes, t({ "", "}" }))
		else
			table.insert(nodes, t({ "", "else {", "\t" }))
			table.insert(nodes, i(1, utils.get_comment("code")))
			table.insert(nodes, t({ "", "}" }))
		end
	else
		table.insert(nodes, t({ "" }))
	end

	local snip_node = sn(nil, nodes)
	snip_node.old_state = old_state
	return snip_node
end

return utils
