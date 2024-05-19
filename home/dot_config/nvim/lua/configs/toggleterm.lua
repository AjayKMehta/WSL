require("toggleterm").setup({
    direction = "horizontal",
    open_mapping = [[<c-\>]],
    size = function(term)
        if term.direction == "horizontal" then
            return vim.o.lines * 0.4
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
        end
    end,
    float_opts = {
        border = "rounded",
        width = function(term)
            local columns = vim.api.nvim_get_option("columns")
            local w = math.floor(columns * 0.7)
            return (w < 20) and 20 or w
        end,
        height = function(term)
            local lines = vim.api.nvim_get_option("lines")
            local h = math.floor(lines * 0.8)
            return (h < 35) and 35 or h
        end,
    },
    persist_size = false,
    persist_mode = false,
    -- https://github.com/akinsho/toggleterm.nvim/wiki/Per-file-type-shell
    shell = function()
        local ft = vim.bo.filetype
        vim.print("File type: " .. ft)
        if ft == "r" then
            Shell = "radian"
        elseif ft == "ps1" then
            Shell = "pwsh"
        elseif ft == "python" then
            Shell = "ipython"
        elseif ft == "toggleterm" then
            return Shell
        else
            Shell = vim.o.shell
        end
        return Shell
    end,
})

-- https://github.com/akinsho/toggleterm.nvim#terminal-window-mappings
-- There seems to be a weird interaction between these mappings and those from tmux-navigator. The latter will cause terminal windows to be non-modifiable.
-- Works again after changing persist_* to false in setup 🤷‍♂️
function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

-- if you want these mappings for all terms use term://* instead
vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
