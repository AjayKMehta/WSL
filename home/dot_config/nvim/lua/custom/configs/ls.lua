local ls = require("luasnip")
local ft_func = require("luasnip.extras.filetype_functions")
local extras = require("luasnip.extras")

local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local m = require("luasnip.extras").match

local s = ls.snippet
local t = ls.text_node
local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local r = ls.restore_node


-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#config-options
local opts = {
    updateevents = "TextChanged,TextChangedI",
    delete_check_events = "TextChanged,CursorMoved",
    region_check_events = "CursorMoved,CursorHold,InsertEnter",
    enable_autosnippets = true,
    history = true,
    store_selection_keys = "<Tab>",
    ft_func = ft_func.from_pos_or_filetype,
    load_ft_func = ft_func.extend_load_ft({
        markdown = { "lua", "json", "html", "yaml", "css", "html", "javascript" },
        html = { "javascript", "css", "graphql", "json" },
    }),
    ext_opts = {
        [require("luasnip.util.types").choiceNode] = {
            active = {
                virt_text = { { "●", "GruvboxOrange" } },
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
        l = extras.lamda,
        s = ls.snippet,
        sn = ls.snippet_node,
    },
}

ls.setup(opts)

local parent_path = vim.fn.stdpath("config") .. "/lua/custom/"
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load({
    paths = { parent_path .. 'snippets' }
})
require("luasnip.loaders.from_lua").lazy_load({
    paths = parent_path .. 'lua_snippets',
})
ls.add_snippets(
    "all", {
        -- Doesn't work
        s("extras1", {
            i(1), t { "", "" }, m(1, "^ABC$", "A")
        }),
        s("paren_change", {
            c(1, {
                sn(nil, { t("("), r(1, "user_text"), t(")") }),
                sn(nil, { t("["), r(1, "user_text"), t("]") }),
                sn(nil, { t("{"), r(1, "user_text"), t("}") }),
            }),
        }, {
            stored = {
                -- key passed to restoreNodes.
                ["user_text"] = i(1, "default_text")
            }
        }),
        -- s("trig", c(1, {
        --   t "some text",                    -- textNodes are just stopped at.
        --   i(nil, "test"),                   -- likewise.
        --   sn(nil, { t "some text" }),       -- this will not work!
        --   sn(nil, { i(1), t "some text" }), -- this will.
        --   -- If no 0-th InsertNode is found in a snippet, one is automatically inserted after all other nodes.
        --   i(0)                              -- When you reach here, snippet will be unlinked.
        -- })),

        -- When wordTrig is set to false, snippets may also expand inside other words.
        ls.parser.parse_snippet(
            { trig = "te", wordTrig = false },
            "${1:cond} ? ${2:true} : ${3:false}"
        ),

        -- When regTrig is set, trig is treated like a pattern, this snippet will expand after any number.
        ls.parser.parse_snippet({ trig = "%d", regTrig = true }, "A Number!!"),

        -- Using the condition, it's possible to allow expansion only in specific cases.
        s("cond", {
            t("will only expand in c-style comments"),
        }, {
            condition = function(line_to_cursor, matched_trigger, captures)
                -- optional whitespace followed by //
                return line_to_cursor:match("%s*//")
            end,
        }),

        -- printf-like notation for defining snippets. It uses format
        -- string with placeholders similar to the ones used with Python's .format().
        s(
            "fmt1",
            fmt("To {title} {} {}.", {
                i(2, "Name"),
                i(3, "Surname"),
                title = c(1, { t("Mr."), t("Ms.") }),
            })
        ),

        -- Multiline
        s(
            "ml",
            {
                i(1, "Name"),
                t { "", "A", "B", "" },
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
        s(
            "fmt5",
            fmt("use {} only", { t("this"), t("not this") }, { strict = false })
        ),

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

        s("trig2", c(1, {
            t("Ugh boring, a text node"),
            i(nil, "At least I can edit something now..."),
            f(function(args) return "Still only counts as text!!" end, {})
        }))
    }
)

-- set keybinds for both INSERT and VISUAL.
vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})
vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice")
