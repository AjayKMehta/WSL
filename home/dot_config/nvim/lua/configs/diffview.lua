-- https://github.com/sindrets/diffview.nvim/issues/386#issuecomment-1614398830
local actions = require("diffview.actions")
require("diffview").setup({
    enhanced_diff_hl = true,
    view = {
        merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            layout = "diff4_mixed", -- default is diff3_horizontal
            disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
            winbar_info = true, -- See |diffview-config-view.x.winbar_info|
        },
    },
    keymaps = {
        file_panel = {
            {
                "n",
                "[c",
                actions.view_windo(function(layout_name, sym)
                    if sym == "b" then
                        vim.cmd("norm! [c")
                    end
                end),
            },
            {
                "n",
                "]c",
                actions.view_windo(function(layout_name, sym)
                    if sym == "b" then
                        vim.cmd("norm! ]c")
                    end
                end),
            },
            {
                "n",
                "x",
                actions.view_windo(function(layout_name, sym)
                    if sym == "b" then
                        vim.cmd("diffget")
                    end
                end),
            },
        },
    },
})
