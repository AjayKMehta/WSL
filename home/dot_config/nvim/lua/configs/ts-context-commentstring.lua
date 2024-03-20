-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#plugins-with-a-pre-comment-hook
require("ts_context_commentstring").setup({
    enable_autocmd = false,
})
vim.g.skip_ts_context_commentstring_module = true
vim.opt.updatetime = 100
