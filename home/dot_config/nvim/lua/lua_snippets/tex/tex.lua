local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local sn = ls.snippet_node
local d = ls.dynamic_node

local l = require("luasnip.extras").lambda
local fmta = require("luasnip.extras.fmt").fmta
local postfix = require("luasnip.extras.postfix").postfix

-- use vimtex to determine if we are in a math context
local function math()
    return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
end

-- 1+ characters that are either word characters (\w), periods (.), underscores (_), hyphens (-)
-- Trying to specify backslash too didn't work.
local pattern = "[%w%.%_%-]+$"

--test whether the parent snippet has content from a visual selection (press TAB to select). If yes, put into a text node, if no then start an insert node
local visualSelectionOrInsert = function(args, parent)
    if #parent.snippet.env.LS_SELECT_RAW > 0 then
        return sn(nil, t(parent.snippet.env.LS_SELECT_RAW))
    else -- If LS_SELECT_RAW is empty, return a blank insert node
        return sn(nil, i(1))
    end
end

-- https://www.dmsussman.org/resources/luasnippets
return {
    -- Type in math mode): ahat. Result : \hat{a}
    postfix(
        { trig = "hat", match_pattern = pattern, snippetType = "autosnippet", dscr = "postfix hat when in math mode" },
        { l("\\hat{" .. l.POSTFIX_MATCH .. "}") },
        { condition = math }
    ),
    s(
        { trig = "emph", dscr = "the emph command, either in insert mode or wrapping a visual selection" },
        fmta("\\emph{<>}", { d(1, visualSelectionOrInsert) })
    ),
}
