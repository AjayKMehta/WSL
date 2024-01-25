local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

-- https://github.com/johanvx/nvim-config/commit/6e117eb10bfd9a109f998ee8cf3f28b559a23e4c#diff-4d7eb50f84b3feefd05e927bd6992f250653dc4f22645fb93d21035f1d17c492R54
vim.opt.guifont = "DejaVuSansM Nerd Font"

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jqls
vim.cmd([[au BufRead,BufNewFile *.jq setfiletype jq]])

vim.g.dap_virtual_text = true
vim.opt.colorcolumn = "80"
vim.opt.mouse = "a"

-- Disable persistent undo for files in /private directory
autocmd("BufReadPre", { pattern = "/private/*", command = "set noundofile" })

autocmd("FileType", {
	pattern = "sh",
	callback = function()
		vim.lsp.start({
			name = "bash-language-server",
			cmd = { "bash-language-server", "start" },
		})
	end,
})

-- https://github.com/carderne/dotfiles/blob/381bc0bdfed96a5ea82b57c89517d2769dc33952/.config/nvim/init.lua#L124-L191

vim.opt.hlsearch = true
vim.opt.relativenumber = false
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.autoindent = true

-- Highlight trailing characters
vim.opt.listchars = {
	-- eol = "↲",
	tab = "▸ ",
	trail = "·",
}
vim.opt.list = true

-- https://nvchad.com/docs/config/snippets
vim.g.lua_snippets_path = vim.fn.stdpath("config") .. "/lua/custom/lua_snippets"

-- https://github.com/carderne/dotfiles/blob/381bc0bdfed96a5ea82b57c89517d2769dc33952/.config/nvim/init.lua#L124-L191
vim.opt.wrap = true
vim.opt.cursorcolumn = true

-- https://github.com/jackMort/ChatGPT.nvim/pull/266#issuecomment-1675376909
vim.env.OPENAI_API_HOST = "api.openai.com"

-- https://nanotipsforvim.prose.sh/change-vims-window-title
vim.opt.title = true
vim.opt.titlelen = 0
-- vim.opt.titlestring = '%{expand(\"%:p\")} [%{mode()}]'

-- https://nvchad.com/docs/api
for i = 1, 9, 1 do
	vim.keymap.set("n", string.format("<A-%s>", i), function()
		vim.api.nvim_set_current_buf(vim.t.bufs[i])
	end)
end

-- https://github.com/lukas-reineke/indent-blankline.nvim#with-custom-gindent_blankline_char_highlight_list
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])

vim.cmd([[
    syntax enable
    " This is enabled by default in Neovim by the way
    filetype plugin indent on
    let g:vimtex_compiler_progname = 'nvr'
]])

vim.opt.scrolloff = 5

-- https://stackoverflow.com/a/19184627/781045
vim.api.nvim_set_keymap("i", "<C-q>", "<C-k>", { noremap = true })
