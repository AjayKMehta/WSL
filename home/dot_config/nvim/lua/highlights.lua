-- To find any highlight groups: "<cmd> Telescope highlights"
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
}

return M
