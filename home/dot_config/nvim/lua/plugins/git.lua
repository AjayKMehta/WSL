local load_config = require("utils").load_config

return {
    {
        "sindrets/diffview.nvim",
        lazy = true,
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh" },
        config = load_config("diffview"),
    },
    {
        -- A plugin to visualise and resolve merge conflicts.
        "akinsho/git-conflict.nvim",
        version = "*",
        config = true,
    },
    {
        -- Edit and review GitHub issues and pull requests from the Neovim.
        "pwntester/octo.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        cmd = "Octo",
        config = function()
            require("octo").setup({
                enable_builtin = true,
                use_local_fs = true,
            })
            vim.cmd([[hi OctoEditable guibg=none]])
            vim.treesitter.language.register("markdown", "octo")
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "┃" },
                change = { text = "▎" },
                delete = { text = "󰍵" },
                topdelete = { text = "➤" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            show_deleted = false, -- Toggle with `:Gitsigns toggle_deleted`
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local map = function(mode, keys, cmd, desc)
                    return vim.keymap.set(mode, keys, cmd, { buffer = bufnr, desc = desc })
                end

                -- Stage

                map("n", "<leader>gs", gs.stage_hunk, "gitsigns Stage hunk")

                map("v", "<leader>gs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "gitsigns Stage hunk")

                map("n", "<leader>gS", gs.stage_buffer, "gitsigns Stage buffer")

                -- Undo stage

                map("n", "<leader>gu", gs.undo_stage_hunk, "gitsigns Undo stage hunk")

                map("n", "<leader>gU", gs.reset_buffer_index, "gitsigns Unstage all hunks for current buffer")

                -- Reset

                map("n", "<leader>gr", gs.reset_hunk, "gitsigns Reset hunk")

                map("v", "<leader>gr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "gitsigns Reset hunk")

                -- Blame

                map("n", "<leader>tb", gs.toggle_current_line_blame, "gitsigns Toggle current line blame")

                map("n", "<leader>gb", function()
                    gs.blame_line({ full = true, ignore_whitespace = false })
                end, "gitsigns blame line")

                map("n", "<leader>gB", function()
                    gs.blame_line({ full = true, ignore_whitespace = true })
                end, "gitsigns blame line (ignore whitespace)")

                -- Diff

                map("n", "<leader>gd", gs.diffthis, "gitsigns Diff with index")

                -- Navigation

                map({ "n", "v" }, "]h", gs.prev_hunk, "gitsigns Go to previous hunk")

                map({ "n", "v" }, "[h", gs.next_hunk, "gitsigns Go to next hunk")

                -- Preview

                map("n", "<leader>gp", gs.preview_hunk, "gitsigns Preview hunk")
            end,
        },
    },
    {
        -- fugitive.vim style git blame visualizer for Neovim.
        "FabijanZulj/blame.nvim",
        cmd = {
            "BlameToggle",
        },
        opts = {
            date_format = "%d.%m.%Y",
            virtual_style = "right",
            merge_consecutive = true,
            max_summary_width = 30,
            colors = nil,
            commit_detail_view = "vsplit",
            mappings = {
                commit_info = "i",
                stack_push = "<TAB>",
                stack_pop = "<BS>",
                show_commit = "c", -- TODO: Fix. Doesn't work.
                close = { "<esc>", "q" },
            },
        },
        config = function(_, opts)
            require("blame").setup(opts)
        end,
    },
}
