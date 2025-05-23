local ls = require("luasnip")

local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local m = require("luasnip.extras").match

local s = ls.snippet
-- Will error out if text node contains newline!
local t = ls.text_node
-- SnippetNodes directly insert their contents into the surrounding snippet. Syntax similar to s but require jump index.
local sn = ls.snippet_node
-- These Nodes contain editable text and can be jumped to and from
local i = ls.insert_node
-- Function Nodes insert text based on the content of other nodes using a user-defined function
local f = ls.function_node
-- ChoiceNodes allow choosing between multiple nodes.
local c = ls.choice_node
-- By default, all nodes are indented at least as deep as the trigger. With these nodes it's possible to override that behavior.
local isn = ls.indent_snippet_node
-- This node can store and restore a snippetNode as is.
local r = ls.restore_node
local ai = require("luasnip.nodes.absolute_indexer")
-- Better than referencing by jump index as allows referencing non-sibling nodes
local k = require("luasnip.nodes.key_indexer").new_key
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local dl = require("luasnip.extras").dynamic_lambda
-- local conds_expand = require("luasnip.extras.conditions.expand")

-- s("foo") same as s({trig = "foo"})

-- <@> denotes cursor position.
-- <iN> denotes Nth insert node.

--#region ChoiceNode

local trigger_snippet = s(
    {
        trig = "trigger",
        desc = "Example using choice node with text nodes and highlighting for 1st 2 choices and entire node. Press Ctrl+ U to select choice.",
    },
    c(1, {
        t("Default Option 1"), -- First default choice
        t("Default Option 2"), -- Second default choice
        t("Other Option"),
    }, {
        active = {
            -- Set the entire node as highlighted with "Search" highlight group.
            -- Highlight the first two options specifically with "IncSearch" group.
            hl_group = "Search",
            [1] = { hl_group = "IncSearch" },
            [2] = { hl_group = "IncSearch" },
        },
    })
)

--#endregion

--#region FunctionNode
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#functionnode

local function fn(
    args, -- text from i(2) in this example i.e. { { "456" } }
    parent, -- parent snippet or parent node
    user_args -- user_args from opts.user_args
)
    return "[" .. args[1][1] .. user_args .. "]"
end

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

-- absolute_indexer allows accessing nodes by their unique jump-index path from the snippet-root.
-- More error-prone. Use key indexer instead.
local trig_ai_snippet = s({ trig = "trig_ai", desc = "Example using absolute indexer" }, {
    i(1, "123"),
    t({ "", "" }),
    i(2, { "abc", "def" }),
    t({ "", "" }),
    f(function(args, snip)
        -- just concat first lines of both.
        return args[1][1] .. args[2][1]
    end, { ai[2], ai[1] }),
})

local trig2_snippet = s(
    {
        trig = "trig2",
        desc = "Example using choice node with text, insert, and function child nodes. Press Ctrl+ U to select choice.",
    },
    c(1, {
        t("Ugh boring, a text node"),
        -- Jumpable nodes that normally expect an index as their first parameter
        -- don't need one inside a choiceNode; their jump-index is the same as
        -- the choiceNode's.
        i(nil, "At least I can edit something now..."),
        f(function(args)
            return "Still only counts as text!!"
        end, {}),
    })
)

--#endregion

--#region SnippetNode
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#snippetnode

-- SnippetNodes directly insert their contents into the surrounding snippet.

-- In `sn(nil, {...nodes...})` nodes has to contain e.g. an i(1), otherwise luasnip will just "jump through" the nodes, making it impossible to change the choice.
s(
    {
        trig = "trig",
        desc = "Example using choice node with text, insert, and snippet child nodes. Press Ctrl+ U to select choice.",
    },
    c(1, {
        t("some text"), -- textNodes are just stopped at.
        i(nil, "test"), -- likewise.
        sn(nil, { t("some text") }), -- this will not work!
        sn(nil, { i(1), t("some text") }), -- this will.
        -- If no 0-th InsertNode is found in a snippet, one is automatically inserted after all other nodes.
        i(0), -- When you reach here, snippet will be unlinked.
    })
)

--#endregion

--#region Match
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#match

-- Match can insert text based on a predicate

-- 1. When you expand this snippet, the cursor will be placed at the first insert node. The text node will insert two newlines after the cursor, moving the cursor to the next line.
-- <@>\n\n
-- 2. If you type "ABC" and then press the trigger key, the match node will check if the text "ABC" was entered.
-- ABC<@>\n\n
-- 3. If the text matches the pattern, the match node will expand, inserting the text "A" after the cursor.
-- Result: ABC<@>\nA\n
local match_snippet = s({ trig = "cond_match", desc = "Example using conditional logic. Type ABC to witness ✨" }, {
    i(1),
    -- Pass table with 2 entries to t() creates 2 lines with those entries!
    t({ "", "" }),
    m(1, "^ABC$", "A"),
})

local match2_snippet = s(
    { trig = "palindrome", desc = "Example using conditional logic. Type a palindrome to witness ✨" },
    {
        i(1),
        -- Pass table with 2 entries to t() creates 2 lines with those entries!
        t({ "", "" }),
        -- match(argnodes, condition, then, else)
        m(1, l._1:match(l._1:reverse()), "PALINDROME", "NORMAL"),
    }
)

--#endregion

--#region Dynamic Lambda

-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#dynamic-lambda

-- Pretty much the same as lambda, but it inserts the resulting text as an insertNode, and, as such, it can be quickly overridden.

local dl_snippet = s("dl", { i(1), t({ "", "" }), dl(2, l._1 .. l._1, 1) })

--#endregion

--#region RestoreNode
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#restorenode

-- Press Ctrl-N/P to go to next/prev choice
-- Here the text entered into user_text is preserved upon changing choice.
local paren_snippet = s({ trig = "paren_change", desc = "Example of choice node with restore node." }, {
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

-- This works but default value is not there when triggered.
local paren2_snippet = s({ trig = "paren_change2", desc = "Example of choice node with restore node" }, {
    c(1, {
        sn(nil, { t("("), r(1, "user_text"), t(")") }),
        sn(nil, { t("["), r(1, "user_text"), t("]") }),
        sn(nil, { t("{"), r(1, "user_text"), t("}") }),
    }),
}, {
    {
        -- key passed to restoreNodes.
        ["user_text"] = i(1, "default_text"),
    },
})

--#endregion

--#region DynamicNode
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#dynamicnode

-- Similar to functionNode, but returns a snippetNode instead of just text.

local dynamic_snippet = s({ trig = "dyn", desc = "Dynamic snippet" }, {
    t("original: "),
    i(1),
    t({ "", "copy: " }),
    d(2, function(args)
        return sn(nil, {
            -- jump-indices are local to each snippetNode, so restart at 1.
            i(1, args[1]),
        })
    end, { 1 }),
})

local dynamic2_snippet = s({
    trig = "dyn_choice",
    desc = "Dynamic snippet with choice. Press Ctrl + U to select from dropdown for choice node.",
}, {
    t("original: "),
    i(1),
    t({ "", "copy: " }),
    d(2, function(args)
        return sn(nil, {
            c(1, { i(1, args[1]), t("Test") }),
        })
    end, { 1 }),
})
--#endregion

--#region KeyIndexer
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#key-indexer

-- Allows you to address nodes by key and even works for non-sibling nodes.

local key_snippet = s({ trig = "key", desc = "Snippet with key. Converts insertion to lower-case!" }, {
    i(1, "", { key = "first" }),
    c(2, {
        sn(nil, {
            i(1),
            t({ "", "" }),
            t("can access the argnode :"),
            f(function(args)
                return string.lower(args[1][1])
            end, k("first")),
        }),
        t("sample_text"),
    }),
})

--#endregion

--#region Regex

-- Type b followed by number and then Tab to trigger.
local num_capture_snippet = s(
    { trig = "b(%d)", regTrig = true, desc = "Example of regex triggered snippet" },
    f(function(args, snip)
        return "Captured Text: " .. snip.captures[1] .. "."
    end, {})
)

--#endregion

--#region fmt

-- printf-like notation for defining snippets. It uses format
-- string with placeholders similar to the ones used with Python's .format().
local fmt1_snippet = s(
    { trig = "fmt1", desc = "Example using fmt with choice node (Mr.| Ms.)" },
    -- Escape {} by doubling
    fmt("To {title} {} {}. {{This is escaped.}}", {
        i(2, "Name"),
        i(3, "Surname"),
        title = c(1, { t("Mr."), t("Ms.") }),
    }, { active = { hl_group = "Search" } })
)

-- Empty placeholders are numbered automatically starting from 1 or the last
-- value of a numbered placeholder. Named placeholders do not affect numbering.

-- <i2> A 1 <i1> 1
local fmt2_snippet = s(
    { trig = "fmt2", desc = "Example using fmt with named and numbered placeholders" },
    fmt("{} {a} {} {1} {}", {
        i(1),
        t("1"),
        a = t("A"),
    })
)

-- The delimiters can be changed from the default `{}` to something else.
local fmt3_snippet = s({
    trig = "fmt3",
    desc = "Example using fmt with custom delimiters",
    hidden = false, -- Default. Set to true to hide from cmp!
}, fmt("foo() { return []; }", i(1, "x"), { delimiters = "[]" }))

--#endregion

--#region IndentSnippetNode
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#indentsnippetnode

-- No indent
local multiline_snippet = s({
    trig = "ml",
    desc = "Example of multiline snippet",
}, {
    i(1, "Name"),
    t({ "", "A", "B", "" }),
    i(2, "Surname"),
})

-- Use InsertSnippetNode to add indent.
local multiline2_snippet = s({
    trig = "ml2",
    desc = "Example of multiline snippet using IndentSnippetNode",
}, {
    -- All occurrences of "$PARENT_INDENT" are replaced with the actual indent of the parent.
    isn(1, t({ "//This is", "A multiline", "comment" }), "$PARENT_INDENT//"),
})

-- Even works with insert node.
local multiline3_snippet = s({
    trig = "ml3",
    desc = "Example of multiline snippet using IndentSnippetNode with insert node",
}, {
    -- All occurrences of "$PARENT_INDENT" are replaced with the actual indent of the parent.
    isn(1, { t({ "//This is", "A multiline", "comment", "" }), i(1, "Hi!") }, "$PARENT_INDENT//"),
})

--#endregion

--#region Condition

-- Using the condition, it's possible to allow expansion only in specific cases.
-- TODO: Figure out why this is not working properly.
-- local cond_snippet = s("cond_beg", {
-- 	t("will only expand at the beginning of the line"),
-- }, {
-- 	condition = conds_expand.line_begin,
-- })

--#endregion

ls.add_snippets("all", {
    trigger_snippet,
    trig_snippet,
    trig_ai_snippet,
    match_snippet,
    match2_snippet,

    paren_snippet,
    paren2_snippet,

    num_capture_snippet,

    -- When wordTrig is set to false, snippets may also expand inside other words.
    ls.parser.parse_snippet({ trig = "te", wordTrig = false }, "${1:cond} ? ${2:true} : ${3:false}"),

    -- When regTrig is set, trig is treated like a pattern, this snippet will expand after any number.
    -- Type number then Tab to activate.
    ls.parser.parse_snippet({ trig = "%d", regTrig = true }, "A Number!!"),

    fmt1_snippet,

    -- Multiline
    multiline_snippet,
    multiline2_snippet,
    multiline3_snippet,

    dynamic_snippet,
    dynamic2_snippet,

    fmt2_snippet,
    fmt3_snippet,

    -- `fmta` is a convenient wrapper that uses `<>` instead of `{}`.
    s("fmt4", fmta("foo() { return <>; }", i(1, "x"))),

    -- By default all args must be used. Use strict=false to disable the check
    s("fmt5", fmt("use {} only", { t("this"), t("not this") }, { strict = false })),

    key_snippet,

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

    trig2_snippet,
    dl_snippet,
    -- cond_snippet,
    s(
        "indent_space",
        fmt(
            [[
        line1: no indent
          line3: 2 space -> 1 indent ('\t')
            line4: 4 space -> 2 indent ('\t\t')
      ]],
            {},
            {
                indent_string = "  ",
            }
        )
    ),
    -- indent_string
    -- NOTE: [[\t]] means '\\t'
    s(
        "indent_tab",
        fmt(
            [[
    line1: no indent
    \tline3: '\\t' -> 1 indent ('\t')
    \t\tline4: '\\t\\t' -> 2 indent ('\t\t')
  ]],
            {},
            {
                indent_string = [[\t]],
            }
        )
    ),
})
