local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
-- Very similar to functionNode, but returns a snippetNode instead of just text
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local parse = ls.parser.parse_snippet

local sniputils = require("sniputils")
local saved_text = sniputils.saved_text
local surround_with_func = sniputils.surround_with_func

local time = [[
local start = os.clock()
print(os.clock()-start.."s")
]]

local high = [[
${1:HighlightGroup} = { fg = "${2}", bg = "${3}" },${0}]]

local module_snippet = [[
local ${1:M} = {}
${0}
return $1]]

local loc_func = [[
local function ${1:name}(${2})
    ${0}
end
]]

local inspect_snippet = [[
print("${1:variable}:")
dump($1)]]

local map_cmd = [[<cmd>${0}<CR>]]

--- Creates a snippet for defining text highlighting options.
-- This function generates a snippet that allows users to specify various text highlighting
-- options such as foreground color, background color, special color, and text styles like
-- italic, bold, underline, and undercurl. The snippet is structured to support dynamic
-- expansion and repetition of these options.
--
-- @return A snippet node that, when expanded, prompts the user to input values for
-- various text highlighting options. The snippet includes dynamic nodes that allow for
-- the repetition of the highlighting options as needed.
local function highlight_choice()
    return sn(nil, {
        t({ "" }),
        c(1, {
            t({ "" }),
            sn(nil, {
                c(1, {
                    sn(nil, { t({ "fg=" }), i(1), t({ "," }) }),
                    sn(nil, { t({ "bg=" }), i(1), t({ "," }) }),
                    sn(nil, { t({ "sp=" }), i(1), t({ "," }) }),
                    sn(nil, { t({ "italic=true," }), i(1) }),
                    sn(nil, { t({ "bold=true," }), i(1) }),
                    sn(nil, { t({ "underline=true," }), i(1) }),
                    sn(nil, { t({ "undercurl=true," }), i(1) }),
                }),
                -- Dynamic node generally returns snippet node to be evaluated later
                d(2, highlight_choice, {}),
            }),
        }),
    })
end

-- args[1][1] = A.B.C then create choice node with C, B.C, A.B.C
local require_var = function(args, _)
    local text = args[1][1] or ""
    local split = vim.split(text, ".", { plain = true })

    local options = {}
    for len = 0, #split - 1 do
        table.insert(options, t(table.concat(vim.list_slice(split, #split - len, #split), "_")))
    end

    return sn(nil, {
        c(1, options),
    })
end

local types_node = function(idx)
    return c(idx, {
        i(1, "'string'"),
        i(1, "'table'"),
        i(1, "'function'"),
        i(1, "'number'"),
        i(1, "'boolean'"),
    })
end

--- Helper function to create entries for table passed to vim.validate
local function rec_val()
    return sn(nil, {
        c(1, {
            t({ "" }),
            sn(nil, {
                t({ ",", "\t" }),
                i(1, "arg"),
                t({ " = { " }),
                rep(1), -- repeat value from 1st jump index
                t({ ", " }),
                types_node(2),
                c(3, {
                    t({ "" }),
                    t({ ", true" }),
                }),
                t({ " }" }),
                d(4, rec_val, {}),
            }),
        }),
    })
end

local function require_import(_, parent, old_state)
    local nodes = {}

    local variable = parent.captures[1] == "l"

    if variable then
        table.insert(nodes, t({ "local " }))
        table.insert(
            nodes,
            f(function(module)
                local name = vim.split(module[1][1], ".", true)
                if name[#name] and name[#name] ~= "" then
                    return name[#name]
                elseif #name - 1 > 0 and name[#name - 1] ~= "" then
                    return name[#name - 1]
                end
                return name[1] or "module"
            end, { 1 })
        )
        table.insert(nodes, t({ " = " }))
    end

    table.insert(nodes, t({ "require" }))

    table.insert(nodes, t({ " '" }))
    table.insert(nodes, i(1, "module"))
    table.insert(nodes, t({ "'" }))

    local snip_node = sn(nil, nodes)
    snip_node.old_state = old_state
    return snip_node
end

local function for_nodes()
    return {
        i(1, "k"),
        i(2, "v"),
        i(3, "tbl"),
        d(4, saved_text, {}, { user_args = { { indent = true } } }),
    }
end

-- Autosnippets:
-- 1. set regTrig = true
-- 2. Hidden by default
local auto_snippets = {
    s(
        { trig = "l(l?)fun", regTrig = true, desc = "Function" },
        fmt(
            [[
        {}function {}({})
        {}
        end
        ]],
            {
                f(function(_, snip)
                    -- stylua: ignore
                    return snip.captures[1] == 'l' and 'local ' or ''
                end, {}),
                i(1, "name"),
                i(2, "args"),
                d(3, saved_text, {}, { user_args = { { indent = true } } }),
            }
        )
    ),
    s({ trig = "l(l?)req", regTrig = true, desc = "Require import" }, {
        d(1, require_import, {}, {}),
    }),
    s(
        { trig = "(n?)eq", regTrig = true, desc = "assert are.same | are_not.same" },
        fmt([[assert.{}({}, {})]], {
            f(function(_, snip)
                -- stylua: ignore
                if snip.captures[1] == 'n' then
                    -- stylua: ignore
                    return 'are_not.same('
                end
                -- stylua: ignore
                return 'are.same('
            end, {}),
            i(1, "expected"),
            i(2, "result"),
        })
    ),
    s(
        {
            trig = "is(_?)true",
            regTrig = true,
            desc = "Snippet for assert.is_true. Works on previously selected text if any.",
        },
        fmt([[assert.is_true({})]], {
            d(1, surround_with_func, {}, { user_args = { { text = "true" } } }),
        })
    ),
    s(
        {
            trig = "is(_?)false",
            regTrig = true,
            desc = "Snippet for assert.is_false. Works on previously selected text if any.",
        },
        fmt([[assert.is_false({})]], {
            d(1, surround_with_func, {}, { user_args = { { text = "false" } } }),
        })
    ),
}

local lua = {
    parse({ trig = "time_elapsed" }, time),
    parse({ trig = "M" }, module_snippet),
    parse({ trig = "lf" }, loc_func),
    parse({ trig = "cmd" }, map_cmd),
    parse({ trig = "inspect" }, inspect_snippet),

    parse("lf", "-- Defined in $TM_FILE\nlocal $1 = function($2)\n\t$0\nend"),
    parse("mf", "-- Defined in $TM_FILE\nlocal $1.$2 = function($3)\n\t$0\nend"),

    s(
        { trig = "fori", desc = "for loop using ipairs" },
        fmt(
            [[
    for {}, {} in ipairs({}) do
    {}
    end
    ]],
            for_nodes()
        )
    ),
    s(
        { trig = "forp", desc = "for loop using pairs" },
        fmt(
            [[
    for {}, {} in pairs({}) do
    {}
    end
    ]],
            for_nodes()
        )
    ),
    s(
        { trig = "for", desc = "for loop using first and last" },
        fmta(
            [[
    for <idx> = <first>, <last> do
    <body>
    end
    ]],
            {
                idx = i(1, "idx"),
                first = i(2, "0"),
                last = i(3, "10"),
                body = d(4, saved_text, {}, { user_args = { { indent = true } } }),
            }
        )
    ),
    s(
        { trig = "elif", desc = "else if" },
        fmt(
            [[
    elseif {} then
    {}
    ]],
            {
                i(1, "condition"),
                d(2, saved_text, {}, { user_args = { { indent = true } } }),
            }
        )
    ),
    s({ trig = "ign", desc = "stylua ignore" }, { t({ "-- stylua: ignore" }) }),
    s({ trig = "keymap", desc = "set keymap" }, {
        t({ "vim.keymap.set(" }),
        t({ "'" }),
        i(1, "n"),
        t({ "', " }),
        t({ "\t'" }),
        i(2, "LHS"),
        t({ "', " }),
        t({ "\t'" }),
        i(3, "RHS"),
        t({ "', " }),
        t({ "\t{" }),
        -- TODO make this a table option
        c(4, {
            i(1, "noremap = true"),
            i(1, "silent = true"),
            i(1, "expr = true"),
            i(1, "noremap = true, silent = true"),
            i(1, "noremap = true, silent = false"),
            i(1, "noremap = true, silent = true, expr = true"),
        }),
        t({ "}" }),
        t({ ")" }),
    }),
    s({ trig = "val", desc = "vim.validate" }, {
        t({ "vim.validate {" }),
        t({ "", "\t" }),
        i(1, "arg"),
        t({ " = { " }),
        rep(1),
        t({ ", " }),
        types_node(2),
        c(3, {
            t({ "" }),
            t({ ", true" }),
        }),
        t({ " }" }),
        d(4, rec_val, {}),
        t({ "", "}" }),
    }),
    s(
        {
            trig = "lext",
            desc = "Snippet for vim.list_extend. Works on previously selected text if any.",
        },
        fmt([[vim.list_extend({}, {})]], {
            d(1, surround_with_func, {}, { user_args = { { text = "tbl" } } }),
            i(2, "'node'"),
        })
    ),
    s(
        {
            trig = "text",
            desc = "Snippet for vim.tbl_extend. Works on previously selected text if any.",
        },
        fmt([[vim.tbl_extend('{}', {}, {})]], {
            c(1, {
                t({ "force" }),
                t({ "keep" }),
                t({ "error" }),
            }),
            d(2, surround_with_func, {}, { user_args = { { text = "tbl" } } }),
            i(3, "'node'"),
        })
    ),
    s(
        {
            trig = "not",
            desc = "Snippet for vim.notify. Works on previously selected text if any.",
        },
        fmt([[vim.notify("{}", "{}"{})]], {
            d(1, surround_with_func, {}, { user_args = { { text = "msg" } } }),
            c(2, {
                t({ "INFO" }),
                t({ "WARN" }),
                t({ "ERROR" }),
                t({ "DEBUG" }),
            }),
            c(3, {
                t({ "" }),
                sn(nil, { t({ ", { title = " }), i(1, "'title'"), t({ " }" }) }),
            }),
        })
    ),
    s(
        {
            trig = "pr",
            desc = "print",
        },
        fmt([[print({})]], {
            i(1, "msg"),
        })
    ),
    s({
        trig = "high",
        desc = "Snippet for vim.api.nvim_set_hl.",
    }, {
        t({ 'vim.api.nvim_set_hl(0,"' }),
        i(1, "group-name"),
        t({ '",{' }),
        d(2, highlight_choice, {}),
        t({ "})" }),
        i(0),
    }),
    s(
        { trig = "lreq", desc = "local <f> = require(<i>)" },
        fmt("local {} = require('{}')", { i(1, "default"), rep(1) })
    ),
    s(
        "req",
        fmt([[local {} = require "{}"]], {
            f(function(import_name)
                local parts = vim.split(import_name[1][1], ".", true)
                return parts[#parts] or "foo"
            end, { 1 }),
            i(1),
        })
    ),
    -- TODO: Finish reviewing.
    s("snippet_node", {
        t('s("'),
        i(1, "snippet_trigger"),
        t({ '", {', "\t" }),
        i(0, "snippet_body"),
        t({ "", "})," }),
    }),

    s("func_node", {
        t("f("),
        i(1, "fn"),
        t(", "),
        i(2, "{}"),
        t(", "),
        i(3, "arg??"),
        t("), "),
    }),
    s("fn basic", {
        t("-- @param: "),
        f(sniputils.copy, 2),
        t({ "", "local " }),
        i(1),
        t(" = function("),
        i(2, "fn param"),
        t({ ")", "\t" }),
        i(0), -- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
        t({ "", "end" }),
    }),

    s("fn module", {
        -- make new line into snippet
        t("-- @param: "),
        f(sniputils.copy, 3),
        t({ "", "" }),
        i(1, "modname"),
        t("."),
        i(2, "fnname"),
        t(" = function("),
        i(3, "fn param"),
        t({ ")", "\t" }),
        i(0),
        t({ "", "end" }),
    }),

    s({ trig = "if basic", wordTrig = true }, {
        t({ "if " }),
        i(1),
        t({ " then", "\t" }),
        i(0),
        t({ "", "end" }),
    }),
    s("for", {
        t("for "),
        c(1, {
            sn(nil, {
                i(1, "k"),
                t(", "),
                i(2, "v"),
                t(" in "),
                c(3, { t("pairs"), t("ipairs") }),
                t("("),
                i(4),
                t(")"),
            }),
            sn(nil, { i(1, "i"), t(" = "), i(2), t(", "), i(3) }),
        }),
        t({ " do", "\t" }),
        i(0),
        t({ "", "end" }),
    }),
    s("s.", {
        t("self."),
        i(1, "thing"),
        t(" = "),
        i(2),
        i(0),
    }),
    s("inc", {
        i(1, "thing"),
        t(" = "),
        f(function(args)
            return args[1][1]
        end, 1),
        t(" + "),
        i(2, "1"),
        i(0),
    }),

    s("dec", {
        i(1, "thing"),
        t(" = "),
        f(function(args)
            return args[1][1]
        end, 1),
        t(" - "),
        i(2, "1"),
        i(0),
    }),
}

return lua, auto_snippets
