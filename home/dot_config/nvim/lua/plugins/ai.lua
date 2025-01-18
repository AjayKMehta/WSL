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
        { "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
        { "<leader>cA", "<cmd>CodeCompanionAdd<cr>", mode = { "v" }, desc = "CodeCompanion Add to the Chat" },
    },
    opts = {
        adapters = {
            ollama = function()
                return require("codecompanion.adapters").extend("ollama", {
                    env = {
                        url = "http://localhost:11434",
                    },
                    headers = {
                        ["Content-Type"] = "application/json",
                    },
                    parameters = {
                        sync = true,
                    },
                    schema = {
                        name = "qwen2.5-coder",
                        model = {
                            default = "qwen2.5-coder:7b",
                        },
                        num_ctx = {
                            default = 32768,
                        },
                    },
                })
            end,
        },
        strategies = {
            chat = {
                adapter = "ollama",
                slash_commands = {
                    ["buffer"] = {
                        opts = {
                            provider = "telescope",
                        },
                    },
                    ["fetch"] = {
                        opts = {
                            provider = "telescope",
                        },
                    },
                    ["file"] = {
                        opts = {
                            provider = "telescope",
                        },
                    },
                    ["symbols"] = {
                        opts = {
                            provider = "telescope",
                        },
                    },
                },
            },
            inline = {
                adapter = "ollama",
            },
            agent = {
                adapter = "ollama",
            },
        },
    },
    config = function(_, opts)
        require("codecompanion").setup(opts)
    end,
}
