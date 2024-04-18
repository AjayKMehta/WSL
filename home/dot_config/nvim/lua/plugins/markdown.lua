local load_config = require("utils").load_config

return {
    {
        "tadmccorkle/markdown.nvim",
        event = "VeryLazy",
        -- Keymaps don't really work.
        enabled = false,
        opts = {
            -- configuration here or empty for defaults
        },
    },
    {
        "AckslD/nvim-FeMaco.lua",
        config = function()
            require("femaco").setup()
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
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
        keys = { { "<leader>gm", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" } },
        config = load_config("md_preview"),
    },
    {
        "antonk52/markdowny.nvim",
        ft = { "markdown" },
        config = function()
            require("markdowny").setup()
        end,
        --  Add key bindings for markdown.,

        -- <C-k>: Adds a link to visually selected text.
        -- <C-b>: Toggles visually selected text to bold.
        -- <C-i>: Toggles visually selected text to italic.
        -- <C-e>: Toggles visually selected text to inline code, and V-LINE selected text to a multiline code block.
    },
}
