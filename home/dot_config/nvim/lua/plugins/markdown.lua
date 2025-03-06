local load_config = require("utils").load_config

return {
    {
        "tadmccorkle/markdown.nvim",
        ft = { "markdown", "gitcommit", "quarto", "rmd" },
        opts = {
            mappings = {
                go_next_heading = "<leader>mh",
                go_prev_heading = "<leader>mH",
                go_parent_heading = "<leader>mp",
                go_current_heading = "<leader>mc",
            },
            on_attach = function(bufnr)
                local function toggle(key)
                    return "<Esc>gv<Cmd>lua require'markdown.inline'" .. ".toggle_emphasis_visual'" .. key .. "'<CR>"
                end
                local map_buf = require("utils.mappings").map_buf

                map_buf(bufnr, "x", "<C-b>", toggle("b"), "Toggle bold")
                map_buf(bufnr, "x", "<C-i>", toggle("i"), "Toggle italic")
                map_buf(bufnr, "x", "<C-m><C-i>", toggle("c"), "Toggle code span")
                map_buf(bufnr, "x", "<a-s>", toggle("s"), "Toggle strikethrough")

                map_buf(bufnr, "n", "<C-m><C-k>", "<Cmd>MDListItemAbove<CR>", "Insert new markdown list item above")

                map_buf(bufnr, "n", "<C-m><C-j>", "<Cmd>MDListItemBelow<CR>", "Insert new markdown list item below")

                map_buf(bufnr, "n", "<C-m><C-x>", "<Cmd>MDTaskToggle<CR>", "Toggles the task(s) on current line")
            end,
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = { "markdown", "gitcommit", "quarto", "rmd" },
        -- https://github.com/iamcco/markdown-preview.nvim/issues/616#issuecomment-1774970354
        build = function()
            local job = require("plenary.job")
            local install_path = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim/app"
            local cmd = "bash"

            if vim.fn.has("win64") == 1 then
                cmd = "pwsh"
            end

            job:new({
                command = cmd,
                args = { "-c", "npm install && git restore ." },
                cwd = install_path,
                on_exit = function()
                    print("Finished installing markdown-preview.nvim")
                end,
                on_stderr = function(_, data)
                    print(data)
                end,
            }):start()
        end,
        lazy = true,
        cmd = {
            "MarkdownPreviewToggle",
            "MarkdownPreview",
            "MarkdownPreviewStop",
        },
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        keys = { { "<leader>mP", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" } },
        config = load_config("md_preview"),
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
            file_types = { "markdown", "quarto", "rmd", "org", "norg", "codecompanion" },
            render_modes = { "n", "c", "t", "v", "V", "\22" },
            anti_conceal = {
                -- This enables hiding any added text on the line the cursor is on
                enabled = true,
                ignore = {
                    code_background = true,
                    sign = true,
                },
            },
            heading = {
                render_modes = true,
                icons = { "󰎤 ", "󰎩 ", "󰎬 ", "󰎮 ", "󰎰 ", "󰎵 " },
                position = "inline",
                signs = { "󰫎 " },
            },
            quote = { repeat_linebreak = true },
            -- Mimic org-indent-mode behavior by indenting everything under a heading based on the
            -- level of the heading. Indenting starts from level 2 headings onward.
            indent = {
                enabled = false,
            },
            win_options = {
                showbreak = { default = "", rendered = "  " },
                breakindent = { default = false, rendered = true },
                breakindentopt = { default = "", rendered = "" },
            },
            checkbox = {
                enabled = true,
                position = "inline",
                custom = {
                    later = { raw = "[>]", rendered = "󰒊 ", highlight = "Comment" }, -- nf-md-send
                    sched = { raw = "[<]", rendered = "󰃰 ", highlight = "Comment" }, -- nf-md-calendar_clock
                    cancel = { raw = "[~]", rendered = "󰂭 ", highlight = "DiagnosticInfo" },
                    info = { raw = "[i]", rendered = "󰋼 ", highlight = "DiagnosticInfo" }, -- nf-md-information
                    idea = { raw = "[I]", rendered = "󰌵 ", highlight = "DiagnosticWarn" }, -- nf-md-lightbulb
                    star = { raw = "[s]", rendered = "󰓎 ", highlight = "DiagnosticWarn" }, -- nf-md-star (asterisk * doesn't work)
                    star2 = { raw = "[*]", rendered = "󰓎 ", highlight = "DiagnosticWarn" }, -- nf-md-star (asterisk * doesn't work)
                    half = { raw = "[/]", rendered = "󰿦 ", highlight = "DiagnosticWarn" }, -- in progress, nf-md-texture_box
                },
            },
            link = {
                custom = {
                    jira = {
                        pattern = "^http[s]?://%a+.atlassian.net/browse",
                        icon = "󰌃 ",
                        highlight = "RenderMarkdownLink",
                    },
                    conf = {
                        pattern = "^http[s]?://%a+.atlassian.net/wiki",
                        icon = " ",
                        highlight = "RenderMarkdownLink",
                    }, -- nf-fa-confluence
                    slack = {
                        pattern = "^http[s]?://%a+.slack.com",
                        icon = "󰒱 ",
                        highlight = "RenderMarkdownLink",
                    }, -- nf-md-slack
                    file = {
                        pattern = "^file:",
                        icon = "'",
                        highlight = "RenderMarkdownFileLink",
                    },
                    python = { pattern = "%.py$", icon = "󰌠 ", highlight = "RenderMarkdownLink" },
                },
            },
            pipe_table = {
                preset = "round",
                cell = "trimmed",
            },
            overrides = {
                buftype = {
                    -- Particularly for LSP hover
                    nofile = {
                        code = {
                            enabled = true,
                            sign = false,
                            style = "normal",
                            width = "full",
                            left_pad = 0,
                            right_pad = 0,
                            border = "thick",
                            highlight = "RenderMarkdownCodeNoFile",
                        },
                    },
                },
            },
        },
        cmd = { "RenderMarkdown" },
        keys = {
            { "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" },
        },
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    },
}
