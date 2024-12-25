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
        { "cc", "CodeCompanion", mode = "ca" },
        { "ccc", "CodeCompanionChat", mode = "ca" },
        { "cca", "CodeCompanionAction", mode = "ca" },
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
