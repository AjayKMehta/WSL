local load_config = require("utils").load_config

return {
    {
        "olimorris/codecompanion.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "ravitemer/mcphub.nvim",
                dependencies = {
                    "nvim-lua/plenary.nvim",
                },
                build = "npm install -g mcp-hub@latest",
                config = function()
                    require("mcphub").setup({
                        port = 3000,
                        config = vim.fn.expand("~/mcpservers.json"),
                        extensions = {
                            codecompanion = {
                                -- Show the mcp tool result in the chat buffer
                                show_result_in_chat = true,
                                -- Make chat #variables from MCP server resources
                                make_vars = true,
                            },
                        },
                    })
                end,
            },
        },
        cmd = {
            "CodeCompanion",
            "CodeCompanionChat",
            "CodeCompanionActions",
            "CodeCompanionCmd",
        },
        keys = {
            { "<leader>ci", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "CodeCompanion Inline Prompt" },
            { "<leader>cr", "<cmd>CodeCompanion /review<cr>", mode = { "n", "v" }, desc = "CodeCompanion Review code" },
            { "<leader>cc", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "CodeCompanion Open Chat " },
            { "<leader>cA", "<cmd>CodeCompanionChat Add<cr>", mode = { "v" }, desc = "CodeCompanion Add To Chat " },
            { "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
            { "<leader>cC", "<cmd>CodeCompanionCmd<cr>", mode = { "n", "v" }, desc = "CodeCompanion Generate Command" },
            {
                "<leader>cf",
                "<cmd>CodeCompanion /fix<cr>",
                mode = "v",
                desc = "CodeCompanion Fix Code",
            },
            {
                "<leader>cl",
                "<cmd>CodeCompanion /lsp<cr>",
                mode = "v",
                desc = "CodeCompanion LSP Diagnostics",
            },
            {
                "<leader>ct",
                "<cmd>CodeCompanion /tests<cr>",
                mode = "v",
                desc = "CodeCompanion Generate Tests",
            },
            {
                "<leader>cd",
                "<cmd>CodeCompanion /doc<cr>",
                mode = "v",
                desc = "CodeCompanion Generate Documentation",
            },
        },
        config = load_config("codecompanion"),
    },
    {
        "github/copilot.vim",
        cond = false,
        config = function()
            vim.keymap.set("i", "<M-a>", 'copilot#Accept("")', {
                expr = true,
                replace_keycodes = false,
            })

            vim.g.copilot_no_tab_map = true
            vim.g.copilot_tab_fallback = ""
        end,
    },
}
