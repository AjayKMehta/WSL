-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

-- https://github.com/NvChad/NvChad/issues/1752
---@type HLTable
M.override = {
    CursorLine = {
        bg = "black2",
    },
    Comment = {
        italic = true,
    },
}

---@type HLTable
M.add = {
    NvimTreeOpenedFolderName = { fg = "green", bold = true },
    -- -- latex https://github.com/lervag/vimtex/blob/master/doc/vimtex.txt#L4724
    texCmd = { fg = "sun" },
    texCmdEnv = { fg = "sun" },
    texOpt = { fg = "pink" },
    texFileOpt = { fg = "pink" },
    texFilesOpt = { fg = "pink" },
    texArg = { fg = "pink" },
    texArgNew = { fg = "pink" },
    texDefArgName = { fg = "pink" },
    texFileArg = { fg = "pink" },
    texBoxOptPosVal = { fg = "pink" },
    texBoxOptIPosVal = { fg = "pink" },
    texFilesArg = { fg = "pink" },
    texCmdAccent = { fg = "pink" },
    texCmdParbox = { fg = "pink" },
    texCmdItem = { fg = "pink" },
    texParm = { fg = "pink" },
    texMathOper = { fg = "red" },
    texDelim = { fg = "blue" },
    texMathDelim = { fg = "blue" },
    texMathDelimMod = { fg = "blue" },
    texMathDelimZone = { fg = "blue" },
    texMathDelimZoneLI = { fg = "blue" },
    texMathDelimZoneLD = { fg = "blue" },
    texMathDelimZoneTI = { fg = "blue" },
    texMathDelimZoneTD = { fg = "blue" },
    texMathZone = { fg = "cyan" },
    texEnvArgName = { fg = "green" },
    texMathEnvArgName = { fg = "green" },
    texError = { fg = "red" },
    texLigature = { fg = "purple" },
    texLength = { fg = "white" },
    -- RenderMarkdown
    RenderMarkdownH1Bg = { fg = "vibrant_green", bg = "lightbg" },
    RenderMarkdownH2Bg = { fg = "yellow", bg = "lightbg" },
    RenderMarkdownH3Bg = { fg = "orange", bg = "lightbg" },
    RenderMarkdownH4Bg = { fg = "red", bg = "lightbg" },
    RenderMarkdownH5Bg = { fg = "blue", bg = "lightbg" },
    RenderMarkdownH6Bg = { fg = "teal", bg = "lightbg" },
    RenderMarkdownH1 = { fg = "vibrant_green" },
    RenderMarkdownH2 = { fg = "yellow" },
    RenderMarkdownH3 = { fg = "orange" },
    RenderMarkdownH4 = { fg = "red" },
    RenderMarkdownH5 = { fg = "blue" },
    RenderMarkdownH6 = { fg = "teal" },
}

return M
