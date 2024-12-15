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

                vim.keymap.set("x", "<C-b>", toggle("b"), { buffer = bufnr, desc = "Toggle bold" })
                vim.keymap.set("x", "<C-i>", toggle("i"), { buffer = bufnr, desc = "Toggle italic" })
                vim.keymap.set("x", "<C-m><C-i>", toggle("c"), { buffer = bufnr, desc = "Toggle code span" })
                vim.keymap.set("x", "<a-s>", toggle("s"), { buffer = bufnr, desc = "Toggle strikethrough" })

                vim.keymap.set(
                    "n",
                    "<C-m><C-k>",
                    "<Cmd>MDListItemAbove<CR>",
                    { buffer = bufnr, desc = "Insert new markdown list item above" }
                )

                vim.keymap.set(
                    "n",
                    "<C-m><C-j>",
                    "<Cmd>MDListItemBelow<CR>",
                    { buffer = bufnr, desc = "Insert new markdown list item below" }
                )

                vim.keymap.set(
                    "n",
                    "<C-m><C-x>",
                    "<Cmd>MDTaskToggle<CR>",
                    { buffer = bufnr, desc = "Toggles the task(s) on current line" }
                )
            end,
        },
    },
    {
        -- Call :FeMaco with your cursor on a code-block. Edit the content, then save and/or close the popup to update the original buffer.
        "AckslD/nvim-FeMaco.lua",
        ft = { "markdown", "quarto" },
        config = function()
            require("femaco").setup()
        end,
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
            file_types = { "markdown", "quarto", "rmd", "org", "norg",  "codecompanion" },
            quote = { repeat_linebreak = true },
            -- Mimic org-indent-mode behavior by indenting everything under a heading based on the
            -- level of the heading. Indenting starts from level 2 headings onward.
            indent = {
                enabled = true,
                -- Amount of additional padding added for each heading level
                per_level = 2,
                -- Heading levels <= this value will not be indented
                -- Use 0 to begin indenting from the very first level
                skip_level = 1,
                -- Do not indent heading titles, only the body
                skip_heading = false,
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
                    todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
                    important = { raw = "[~]", rendered = "󰓎 ", highlight = "DiagnosticWarn" },
                },
            },
            link = {
                custom = {
                    python = { pattern = "%.py$", icon = "󰌠 ", highlight = "RenderMarkdownLink" },
                },
            },
            pipe_table = {
                preset = "round",
                cell = "trimmed",
            },
        },
        cmd = { "RenderMarkdown" },
        keys = {
            { "<leader>md", "<cmd>RenderMarkdown disable<cr>", desc = "Toggle Markdown Disable" },
            { "<leader>me", "<cmd>RenderMarkdown enable<cr>", desc = "Toggle Markdown Enable" },
            { "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" },
        },
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    },
}
