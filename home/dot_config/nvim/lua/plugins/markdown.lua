local load_config = require("utils").load_config

return {
    {

        "tadmccorkle/markdown.nvim",
        ft = { "markdown", "gitcommit", "quarto", "rmd" },
        opts = {
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
        keys = { { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" } },
        config = load_config("md_preview"),
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "quarto", "rmd" } },
        cmd = { "RenderMarkdown" },
        keys = { { "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" } },
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    },
}
