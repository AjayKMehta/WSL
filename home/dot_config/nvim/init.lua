local map_desc = require("utils.mappings").map_desc

vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
-- Set these before loading lazy.nvim
vim.g.mapleader = " "
-- This is the default but being explicit :)
vim.g.maplocalleader = "\\"

vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out, "WarningMsg" },
          { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.runtimepath:prepend(lazypath)

-- New in v 0.11
vim.diagnostic.config({
    virtual_text = {
        enabled = true,
        severity = {
            max = vim.diagnostic.severity.WARN,
        },
    },
    virtual_lines = {
        enabled = true,
        severity = {
            min = vim.diagnostic.severity.ERROR,
        },
    },
    update_in_insert = false,
})

local lazy_config = require("configs.lazy")

-- Plugin toggles

-- If true, load snippet examples
vim.g.snippet_examples = true

-- lualine toggles
vim.g.show_linters = false
vim.g.show_formatters = false

-- if true, use native comment functionality added in nvim 0.10
vim.g.nvim_comment = true

-- if true, use base46 diffview integration.
vim.g.diffview_base46 = true

-- if true, use zathura_simple for viewing PDFs with vimtex
vim.g.use_zathura_simple = true

-- if true, use radian instead of R console.
vim.g.use_radian = true

require("configs.lsp")

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

dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
dofile(vim.g.base46_cache .. "syntax")

require("autocmds")

require("mappings")

-- Floating windows have rounded borders
-- vim.o.winborder = "rounded"

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#jqls
vim.cmd([[au BufRead,BufNewFile *.jq setfiletype jq]])

vim.g.dap_virtual_text = true

-- https://nvchad.com/docs/config/snippets
vim.g.lua_snippets_path = vim.fn.stdpath("config") .. "/lua/lua_snippets"

vim.g.use_autopairs = true

vim.g.use_blink = false

-- https://github.com/jackMort/ChatGPT.nvim/pull/266#issuecomment-1675376909
vim.env.OPENAI_API_HOST = "api.openai.com"

-- https://nvchad.com/docs/api
for i = 1, 9, 1 do
    map_desc("n", string.format("<A-%s>", i), function()
        vim.api.nvim_set_current_buf(vim.t.bufs[i])
    end, "Switch to buffer " .. i)
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

-- https://www.reddit.com/r/neovim/comments/1ixsk40/comment/meqnilu
-- Example: :Dump !ls -a
vim.api.nvim_create_user_command("Dump", function(x)
    vim.cmd(string.format("put =execute('%s')", x.args))
end, {
    nargs = "+",
    desc = "Dump the output of a command at the cursor position",
})

vim.api.nvim_create_user_command("DumpNew", function(x)
    local result = vim.cmd(string.format("execute('%s')", x.args))
    vim.cmd (string.format("vnew | print(%s)", result))
end, {
    nargs = "+",
    desc = "Dump the output of a command in a new tab",
})


vim.api.nvim_create_user_command("GrepWord", function(input)
    if not input.args then
        vim.notify("Error: Please provide a word to grep for")
        return
    end

    -- Execute the command sequence
    local cmd = 'vnew | 0r!grep "' .. input.args .. '" #'

    -- Try to execute the command
    local success, err = pcall(vim.cmd, cmd)
    if not success then
        vim.notify("Error executing grep command: " .. tostring(err))
    end
end, {
    desc = "Dump output of grep in a new tab (vertical split)",
    nargs = "+",
})
