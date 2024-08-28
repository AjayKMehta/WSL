vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
-- Set these before loading lazy.nvim
vim.g.mapleader = " "
-- This is the default but being explicit :)
vim.g.maplocalleader = "\\"

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- Plugin toggles

-- If true, use aerial instead of outline
vim.g.use_aerial = false
vim.g.use_cmp_emoji = false
-- If true, csharp.nvim enables LSP.
vim.g.csharp_lsp = false
-- If true, use lsp_signature else noice
vim.g.use_lsp_sig = true

-- If true, load snippet examples
vim.g.snippet_examples = true

-- lualine toggles
vim.g.show_linters = false
vim.g.show_formatters = false

-- if true, use native comment functionality added in nvim 0.10
vim.g.nvim_comment = true

-- if true, use custom PowerShelleditorServices instead of mason's.
vim.g.use_custom_pses = false

-- load plugins
require("lazy").setup({
    {
        "NvChad/NvChad",
        lazy = false,
        branch = "v2.5",
        -- Default plugins: https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/plugins/init.lua
        import = "nvchad.plugins",
        config = function()
            require("options")
        end,
    },

    { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("autocmds")

vim.schedule(function()
    require("mappings")
end)

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

-- Misc

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

-- https://www.youtube.com/watch?v=NecszftvMFI
vim.filetype.add({
    extension = {
        csproj = "xml",
    },
    filename = {
        ["Directory.Build.targets"] = "xml",
    },
    pattern = {
        ["Directory.*.props"] = "xml",
    },
})
