local map_desc = require("utils.mappings").map_desc
local actions = require("diffview.actions")

local opts = {
    enhanced_diff_hl = true,
    show_root_path = true, -- Show repository root path in panel headers.
    preferred_adapter = "git",
    watch_index = true,    -- Update views and index buffers when the git index changes.
    diffopt = { algorithm = "histogram", linematch = 60 },
    cleanup_buffers = true,
    restore_session = true, -- Restore open Diffview/FileHistory views from a sourced Vim session.
    persist_selections = { enabled = true },
    view = {
        cycle_layouts = {
            default = { "diff2_horizontal", "diff1_inline", "diff2_vertical" },
            merge_tool = { "diff4_mixed", "diff3_mixed", "diff3_vertical" },
        },
        default = {
            -- Config for changed files, and staged files in diff views.
            layout = "diff2_horizontal",
            winbar_info = true, -- See ':h diffview-config-view.x.winbar_info'
        },
        file_history = {
            -- Config for changed files in file history views.
            layout = "diff2_horizontal",
            winbar_info = true, -- See ':h diffview-config-view.x.winbar_info'
        },
        merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            layout = "diff4_mixed",
            disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
            winbar_info = true,         -- See |diffview-config-view.x.winbar_info|
        },
    },
    file_panel = {
        listing_style = "tree",         -- One of 'list' or 'tree'
        tree_options = {                -- Only applies when listing_style is 'tree'
            flatten_dirs = true,        -- Flatten dirs that only contain one single dir
            folder_statuses = "always", -- One of 'never', 'only_folded' or 'always'.
            always_show_marks = true,
            show_branch_name = true,
        },
        win_config = { -- See ':h diffview-config-win_config'
            position = "left",
            width = 35,
            win_opts = {},
        },
    },
    file_history_panel = {
        subject_highlight = "merge_aware", -- "ref_aware" (pushed vs unpushed), "merge_aware" (adds merged-to-main/master), or "plain".
        log_options = {                    -- See ':h diffview-config-log_options'
            git = {
                single_file = {
                    diff_merges = "combined",
                },
                multi_file = {
                    diff_merges = "first-parent",
                },
            },
        },
        win_config = { -- See ':h diffview-config-win_config'
            position = "bottom",
            height = 16,
            win_opts = {},
        },
        commit_subject_max_length = 72,
        date_format = "auto", -- "auto"|"relative"|"iso"
    },
    keymaps = {
        file_panel = {
            ["-"] = false,
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
            ["<leader>e"] = false,
            ["<leader>b"] = false,
            { "n", "<localleader>ff", actions.focus_files,  { desc = "DiffView Focus Files" } },
            { "n", "<localleader>ft", actions.toggle_files, { desc = "DiffView Toggle Files" } }
        },
        file_history_panel = {
            ["<leader>e"] = false,
            ["<leader>b"] = false,
            { "n", "<localleader>ff", actions.focus_files,  { desc = "DiffView Focus Files" } },
            { "n", "<localleader>ft", actions.toggle_files, { desc = "DiffView Toggle Files" } }
        },
        view = {
            -- Disable the default normal mode mapping
            ["gx"] = false,
            ["<leader>e"] = false,
            ["<leader>b"] = false,
            { "n", "<localleader>ff", actions.focus_files,  { desc = "DiffView Focus Files" } },
            { "n", "<localleader>ft", actions.toggle_files, { desc = "DiffView Toggle Files" } }
        },
    },
    hooks = {
        diff_buf_win_enter = function(bufnr, winid, ctx)
            -- https://github.com/dlyongemallo/diffview.nvim/blob/main/TIPS.md
            -- Re-trigger treesitter-context's on_attach evaluation.
            -- The group name is an internal detail of nvim-treesitter-context
            -- and may differ across versions; verify it matches your install
            -- or omit it to fire all BufReadPost handlers.
            pcall(vim.api.nvim_exec_autocmds, "BufReadPost", {
                buffer = bufnr,
                group = "treesitter_context_update",
            })
        end,
        view_closed = function()
            local ok, tsc = pcall(require, "treesitter-context")
            if ok and tsc.enabled() then
                tsc.enable()
            end
        end
    }
}

require("diffview").setup(opts)

-- Toggle diffview open/close
map_desc("n", "<leader>Dv", "<cmd>DiffviewToggle<cr>", "Toggle Diffview")

map_desc("n", "<leader>Dc", "<cmd>DiffviewClose<cr>", "Diffview close")

-- Diff working directory
map_desc("n", "<leader>Doo", "<cmd>DiffviewOpen<cr>", "Diffview open")
map_desc("n", "<leader>Don", "<cmd>DiffviewOpen -uno<cr>", "Diffview open (no untracked)")

-- File History
map_desc("n", "<leader>Dh", "<cmd>DiffviewFileHistory %<cr>", "Diffview File history (current file)")
map_desc("n", "<leader>DH", "<cmd>DiffviewFileHistory<cr>", "Diffview File history (repo)")

-- Visual mode: history for selection
map_desc("v", "<leader>dh", "<Esc><cmd>'<,'>DiffviewFileHistory --follow<CR>", "Diffview Range history")
