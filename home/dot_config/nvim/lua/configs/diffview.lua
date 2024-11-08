-- https://github.com/sindrets/diffview.nvim/issues/386#issuecomment-1614398830
local actions = require("diffview.actions")

local config = {
    enhanced_diff_hl = not vim.g.diffview_base46,
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
                ---@diagnostic disable-next-line: unused-local
                actions.view_windo(function(layout_name, sym)
                    if sym == "b" then
                        vim.cmd("norm! [c")
                    end
                end),
            },
            {
                "n",
                "]c",
                ---@diagnostic disable-next-line: unused-local
                actions.view_windo(function(layout_name, sym)
                    if sym == "b" then
                        vim.cmd("norm! ]c")
                    end
                end),
            },
            {
                "n",
                "x",
                --- @diagnostic disable-next-line: unused-local
                actions.view_windo(function(layout_name, sym)
                    if sym == "b" then
                        vim.cmd("diffget")
                    end
                end),
            },
        },
    },
}

if vim.g.diffview_base46 then
    config.hooks = {
        diff_buf_read = function()
            vim.opt_local.wrap = false
        end,
        ---@diagnostic disable-next-line: unused-local
        diff_buf_win_enter = function(bufnr, winid, ctx)
            -- Highlight 'DiffChange' as 'DiffDelete' on the left, and 'DiffAdd' on
            -- the right.
            if ctx.layout_name:match("^diff2") then
                if ctx.symbol == "a" then
                    vim.opt_local.winhl = table.concat({
                        "DiffAdd:DiffviewDiffAddAsDelete",
                        "DiffDelete:DiffviewDiffDelete",
                        "DiffChange:DiffviewDiffAddAsDelete",
                        "DiffText:DiffviewDiffDelete",
                    }, ",")
                elseif ctx.symbol == "b" then
                    vim.opt_local.winhl = table.concat({
                        "DiffAdd:DiffviewDiffAdd",
                        "DiffDelete:DiffviewDiffDelete",
                        "DiffChange:DiffviewDiffAdd",
                        "DiffText:DiffviewDiffText",
                    }, ",")
                end
            end
        end,
    }
end

require("diffview").setup(config)
dofile(vim.g.base46_cache .. "git")
dofile(vim.g.base46_cache .. "diffview")
