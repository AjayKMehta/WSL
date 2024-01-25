-- https://github.com/sindrets/diffview.nvim/issues/386#issuecomment-1614398830
local actions = require("diffview.actions")
require("diffview").setup({
    keymaps = {
        file_panel = {
            {
                "n", "[c",
                actions.view_windo(function(layout_name, sym)
                    if sym == "b" then
                        vim.cmd("norm! [c")
                    end
                end)
            },
            {
                "n", "]c",
                actions.view_windo(function(layout_name, sym)
                    if sym == "b" then
                        vim.cmd("norm! ]c")
                    end
                end)
            },
            {
                "n", "x",
                actions.view_windo(function(layout_name, sym)
                    if sym == "b" then
                        vim.cmd("diffget")
                    end
                end)
            },
        }
    },
})
