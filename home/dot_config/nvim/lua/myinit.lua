-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jqls
vim.cmd([[au BufRead,BufNewFile *.jq setfiletype jq]])

vim.g.dap_virtual_text = true

-- https://nvchad.com/docs/config/snippets
vim.g.lua_snippets_path = vim.fn.stdpath("config") .. "/lua/lua_snippets"

-- https://github.com/jackMort/ChatGPT.nvim/pull/266#issuecomment-1675376909
vim.env.OPENAI_API_HOST = "api.openai.com"

-- https://nvchad.com/docs/api
for i = 1, 9, 1 do
    vim.keymap.set("n", string.format("<A-%s>", i), function()
        vim.api.nvim_set_current_buf(vim.t.bufs[i])
    end)
end

vim.cmd([[
    syntax enable
    " This is enabled by default in Neovim by the way
    filetype plugin indent on
    let g:vimtex_compiler_progname = 'nvr'
]])

-- https://stackoverflow.com/a/19184627/781045
vim.api.nvim_set_keymap("i", "<C-q>", "<C-k>", { noremap = true })

-- Resolve issue with lazy complaining!
-- https://github.com/folke/lazy.nvim/pull/1326
-- This is the default but being explicit :)
-- vim.g.maplocalleader = "\\"

-- Plugin toggles

-- If true, use aerial instead of outline
vim.g.use_aerial = false
vim.g.use_cmp_emoji = false
-- If true, csharp.nvim enables LSP.
vim.g.csharp_lsp = false

-- lualinne toggles
vim.g.show_linters = false
vim.g.show_formatters = false

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

-- https://www.youtube.com/watch?v=NecszftvMFI

vim.filetype.add({
	extension = {
		csproj = 'xml',
	},
	filename = {
	['Directory.Build.targets'] = 'xml',
},
pattern = {
	['Directory.*.props'] = 'xml'
}
})
