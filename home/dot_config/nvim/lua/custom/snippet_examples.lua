local ls = require("luasnip")

local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local m = require("luasnip.extras").match

local s = ls.snippet
-- Will error out if text node contains newline!
local t = ls.text_node
local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local r = ls.restore_node

local function fn(
	args, -- text from i(2) in this example i.e. { { "456" } }
	parent, -- parent snippet or parent node
	user_args -- user_args from opts.user_args
)
	return "[" .. args[1][1] .. user_args .. "]"
end

-- <@> denotes cursor position.

-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#functionnode
-- <i1><-i(1)<f(fn, {2}, { user_args = { "test" }})>i(2)-><i2><-i(2) i(0)->
-- <i1> = "A", <i2> = "B" leads to
-- A<-i(1)[Btest]i(2)->B<-i(2) i(0)->
local trig_snippet = s({ trig = "trig", desc = "Example using function node" }, {
	i(1), -- insert node
	t("<-i(1) "), -- text node
	f(
		fn, -- callback (args, parent, user_args) -> string
		{ 2 }, -- node indice(s) whose text is passed to fn, i.e. i(2)
		{ user_args = { "test" } } -- opts
	),
	t(" i(2)->"),
	i(2),
	t("<-i(2) i(0)->"),
	i(0),
})

-- 1. When you expand this snippet, the cursor will be placed at the first insert node. The text node will insert two newlines after the cursor, moving the cursor to the next line.
-- <@>\n\n
-- 2. If you type "ABC" and then press the trigger key, the match node will check if the text "ABC" was entered.
-- ABC<@>\n\n
-- 3. If the text matches the pattern, the match node will expand, inserting the text "A" after the cursor.
-- Result: ABC<@>\nA\n
local match_snippet = s({ trig = "cond_match", desc = "Example using conditional logic. Type ABC to witness ✨" }, {
	i(1),
	t({ "", "" }),
	m(1, "^ABC$", "A"),
})

-- Press Ctrl-N/P to go to next/prev choice
-- TODO: Describe how this works.
local paren_snippet = s({ trig = "paren_change", desc = "Example of choice node" }, {
	c(1, {
		sn(nil, { t("("), r(1, "user_text"), t(")") }),
		sn(nil, { t("["), r(1, "user_text"), t("]") }),
		sn(nil, { t("{"), r(1, "user_text"), t("}") }),
	}),
}, {
	stored = {
		-- key passed to restoreNodes.
		["user_text"] = i(1, "default_text"),
	},
})

-- Type b followed by number and then Tab to trigger.
local num_capture_snippet = s(
	{ trig = "b(%d)", regTrig = true, desc = "Example of regex triggered snippet" },
	f(function(args, snip)
		return "Captured Text: " .. snip.captures[1] .. "."
	end, {})
)

-- printf-like notation for defining snippets. It uses format
-- string with placeholders similar to the ones used with Python's .format().
local fmt1_snippet = s(
	"fmt1",
	fmt("To {title} {} {}.", {
		i(2, "Name"),
		i(3, "Surname"),
		title = c(1, { t("Mr."), t("Ms.") }),
	})
)

-- Using the condition, it's possible to allow expansion only in specific cases.
-- TODO: Figure out why this is not working properly.
local cond_snippet = s("cond", {
	t("will only expand in c-style comments"),
}, {
	condition = function(line_to_cursor, matched_trigger, captures)
		-- optional whitespace followed by //
		return line_to_cursor:match("^%s*//")
	end,
})

ls.add_snippets("all", {
	trig_snippet,
	match_snippet,
	paren_snippet,
	num_capture_snippet,
	-- s("trig", c(1, {
	--   t "some text",                    -- textNodes are just stopped at.
	--   i(nil, "test"),                   -- likewise.
	--   sn(nil, { t "some text" }),       -- this will not work!
	--   sn(nil, { i(1), t "some text" }), -- this will.
	--   -- If no 0-th InsertNode is found in a snippet, one is automatically inserted after all other nodes.
	--   i(0)                              -- When you reach here, snippet will be unlinked.
	-- })),

	-- When wordTrig is set to false, snippets may also expand inside other words.
	ls.parser.parse_snippet({ trig = "te", wordTrig = false }, "${1:cond} ? ${2:true} : ${3:false}"),

	-- When regTrig is set, trig is treated like a pattern, this snippet will expand after any number.
	-- Type number then Tab to activate.
	ls.parser.parse_snippet({ trig = "%d", regTrig = true }, "A Number!!"),

	cond_snippet,
	fmt1_snippet,

	-- Multiline
	s("ml", {
		i(1, "Name"),
		t({ "", "A", "B", "" }),
		i(2, "Surname"),
	}),

	-- Empty placeholders are numbered automatically starting from 1 or the last
	-- value of a numbered placeholder. Named placeholders do not affect numbering.
	s(
		"fmt2",
		fmt("{} {a} {} {1} {}", {
			i(1),
			t("1"),
			a = t("A"),
		})
	),

	-- The delimiters can be changed from the default `{}` to something else.
	s("fmt3", fmt("foo() { return []; }", i(1, "x"), { delimiters = "[]" })),

	-- `fmta` is a convenient wrapper that uses `<>` instead of `{}`.
	s("fmt4", fmta("foo() { return <>; }", i(1, "x"))),

	-- By default all args must be used. Use strict=false to disable the check
	s("fmt5", fmt("use {} only", { t("this"), t("not this") }, { strict = false })),

	-- Set store_selection_keys = "<Tab>" (for example) in your
	-- luasnip.config.setup() call to populate
	-- TM_SELECTED_TEXT/SELECT_RAW/SELECT_DEDENT.
	-- In this case: select a URL (Shift + V to select line), hit Tab, then expand this snippet.
	s("link_url", {
		t('<a href="'),
		f(function(_, snip)
			-- TM_SELECTED_TEXT is a table to account for multiline-selections.
			-- In this case only the first line is inserted.
			return snip.env.TM_SELECTED_TEXT[1] or {}
		end, {}),
		t('">'),
		i(1),
		t("</a>"),
		i(0),
	}),

	-- Shorthand for repeating the text in a given node.
	s("repeat", { i(1, "text"), t({ "", "" }), rep(1) }),

	s(
		"trig2",
		c(1, {
			t("Ugh boring, a text node"),
			i(nil, "At least I can edit something now..."),
			f(function(args)
				return "Still only counts as text!!"
			end, {}),
		})
	),
})
