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
    },
    opts = {
        adapters = {
            copilot = function()
                return require("codecompanion.adapters").extend("copilot", {
                    schema = {
                        model = { default = "claude-3.5-sonnet" },
                        max_tokens = { default = 8192 },
                    },
                })
            end,
            llama3 = function()
                return require("codecompanion.adapters").extend("ollama", {
                    name = "llama3", -- Give this adapter a different name to differentiate it from the default ollama adapter
                    schema = {
                        model = {
                            default = "llama3.2:latest",
                        },
                        num_ctx = {
                            default = 16384,
                        },
                        num_predict = {
                            default = -1,
                        },
                    },
                })
            end,
            codellama = function()
                return require("codecompanion.adapters").extend("ollama", {
                    name = "llama3",
                    schema = {
                        model = {
                            default = "codellama:13b",
                        },
                        num_ctx = {
                            default = 16384,
                        },
                        num_predict = {
                            default = -1,
                        },
                    },
                })
            end,
            qwen = function()
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
                    name = "qwen2.5-coder",
                    schema = {
                        model = {
                            default = "qwen2.5-coder:latest",
                        },
                        num_ctx = {
                            default = 8192,
                        },
                        num_predict = {
                            default = -1,
                        },
                    },
                })
            end,
        },
        display = {
            action_palette = {
                width = 95,
                height = 10,
                prompt = "Prompt ", -- Prompt used for interactive LLM calls
                provider = "telescope", -- default|telescope|mini_pick
                opts = {
                    show_default_actions = true, -- Show the default actions in the action palette?
                    show_default_prompt_library = true, -- Show the default prompt library in the action palette?
                },
            },
            chat = {
                intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
                show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
                separator = "─", -- The separator between the different messages in the chat buffer
                show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
                show_settings = true, -- Show LLM settings at the top of the chat buffer?
                show_token_count = true, -- Show the token count for each response?
                start_in_insert_mode = false, -- Open the chat buffer in insert mode?
            },
        },
        strategies = {
            chat = {
                adapter = "openai", -- "copilot" OR "ollama"
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
                adapter = "openai",
            },
            agent = {
                adapter = "openai",
            },
        },
    },
    config = function(_, opts)
        require("codecompanion").setup(opts)
    end,
}
