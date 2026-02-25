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
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "git-conflict")
            require("git-conflict").setup(opts)
        end,
    },
    {
        -- Edit and review GitHub issues and pull requests from the Neovim.
        "pwntester/octo.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "folke/snacks.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        cmd = "Octo",
        keys = {
            {
                "<leader>Oo",
                "<cmd>Octo<cr>",
                desc = "Octo",
            },
            {
                "<leader>Oi",
                "<CMD>Octo issue list<CR>",
                desc = "octo Issues List",
            },
            {
                "<leader>Op",
                "<CMD>Octo pr list<CR>",
                desc = "Octo PR List",
            },
            {
                "<leader>Od",
                "<CMD>Octo discussion list<CR>",
                desc = "Octo Discussions List",
            },
            {
                "<leader>Or",
                "<CMD>Octo repo list<CR>",
                desc = "Octo Repo List",
            },
        },
        config = function()
            require("octo").setup({
                enable_builtin = true,
                use_local_fs = true,
                mappings_disable_default = true,
                picker = "snacks",
                -- This doesn't work: gh auth refresh -s read:project
                suppress_missing_scope = {
                    projects_v2 = true,
                },
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
            linehl = true, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = true, -- Toggle with `:Gitsigns toggle_word_diff`
            trouble = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                delay = 300,
                ignore_whitespace = false,
                virt_text_priority = 100,
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local map = function(mode, keys, cmd, desc)
                    return vim.keymap.set(mode, keys, cmd, { buffer = bufnr, desc = desc })
                end

                -- Stage

                map("n", "<leader>gsh", gs.stage_hunk, "gitsigns Stage hunk")

                map("v", "<leader>gsh", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "gitsigns Stage hunk")

                map("n", "<leader>gsb", gs.stage_buffer, "gitsigns Stage buffer")

                -- Undo stage

                -- Use stage_hunk() on staged lines

                map("n", "<leader>gU", gs.reset_buffer_index, "gitsigns Unstage all hunks for current buffer")

                -- Reset

                map("n", "<leader>gr", gs.reset_hunk, "gitsigns Reset hunk")

                map("v", "<leader>gr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "gitsigns Reset hunk")

                -- Blame

                map("n", "<leader>gBt", gs.toggle_current_line_blame, "gitsigns Toggle current line blame")

                map("n", "<leader>gBl", function()
                    gs.blame_line({ full = true, ignore_whitespace = false })
                end, "gitsigns blame line")

                map("n", "<leader>gBL", function()
                    gs.blame_line({ full = true, ignore_whitespace = true })
                end, "gitsigns blame line (ignore whitespace)")

                -- Diff

                map("n", "<leader>gdi", gs.diffthis, "gitsigns Diff with index")

                map("n", "<leader>gdp", function()
                    gs.diffthis("~1")
                end, "gitsigns Diff with previous commit")

                -- Navigation

                map({ "n", "v" }, "[h", function()
                    gs.nav_hunk("prev")
                end, "gitsigns Go to previous hunk")

                map({ "n", "v" }, "]h", function()
                    gs.nav_hunk("next")
                end, "gitsigns Go to next hunk")

                map({ "n", "v" }, "[H", function()
                    gs.nav_hunk("first")
                end, "gitsigns Go to first hunk")

                map({ "n", "v" }, "]H", function()
                    gs.nav_hunk("last")
                end, "gitsigns Go to last hunk")

                -- Preview

                map("n", "<leader>gp", gs.preview_hunk, "gitsigns Preview hunk")
                map("n", "<leader>gi", gs.preview_hunk_inline, "gitsigns Preview hunk inline")

                -- Quickfix list

                map("n", "<leader>gq", function()
                    gs.setqflist("all")
                end, "gitsigns Populate quickfix list with hunks")
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
                show_commit = "c",
                close = { "<esc>", "q" },
            },
            blame_options = { "-w", "-M", "-C", "--color-by-age" },
        },
        config = function(_, opts)
            require("blame").setup(opts)
        end,
    },
}
