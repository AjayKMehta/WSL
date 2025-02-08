local load_config = require("utils").load_config

return {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim",
        "stevearc/dressing.nvim",
        "github/copilot.vim",
    },
    cmd = {
        "CodeCompanion",
        "CodeCompanionChat",
        "CodeCompanionActions",
        "CodeCompanionCmd",
    },
    keys = {
        { "<leader>ci", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "CodeCompanion Inline Prompt" },
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
}
