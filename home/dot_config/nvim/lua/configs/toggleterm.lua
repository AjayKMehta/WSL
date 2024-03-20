require("toggleterm").setup({
    direction = "float",
    open_mapping = [[<c-\>]],
    size = function(term)
        if term.direction == "horizontal" then
            return vim.o.lines * 0.5
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
    persist_size = true,
    persist_mode = true,
})

-- https://github.com/akinsho/toggleterm.nvim#terminal-window-mappings
function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
