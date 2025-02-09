local ca = require("codecompanion.adapters")
local ollama_url = "http://localhost:11434"

local function create_ollama_adapter(name, model, num_ctx)
    return ca.extend("ollama", {
        env = { url = ollama_url },
        name = name,
        schema = {
            model = { default = model },
            num_ctx = { default = num_ctx },
            num_predict = { default = -1 },
        },
    })
end

local adapters = {
    copilot = function()
        return ca.extend("copilot", {
            schema = {
                model = { default = "claude-3.5-sonnet" },
                max_tokens = { default = 8192 },
            },
        })
    end,
    llama3 = function()
        return create_ollama_adapter("llama3", "llama3.2:latest", 16384)
    end,
    codellama = create_ollama_adapter("codellama", "codellama:7b", 16384),
    qwen = function()
        return ca.extend("ollama", {
            env = { url = ollama_url },
            headers = { ["Content-Type"] = "application/json" },
            parameters = { sync = true },
            name = "qwen2.5-coder",
            schema = {
                model = { default = "qwen2.5-coder:7b" },
                num_ctx = { default = 8192 },
                num_predict = { default = -1 },
            },
        })
    end,
}

local display = {
    action_palette = {
        width = 95,
        height = 10,
        prompt = "Prompt ", -- Prompt used for interactive LLM calls
        provider = "default", -- default|telescope|mini_pick
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
        show_settings = false, -- Show LLM settings at the top of the chat buffer?
        show_token_count = true, -- Show the token count for each response?
        start_in_insert_mode = false, -- Open the chat buffer in insert mode?
    },
}

local strategies = {
    chat = {
        adapter = "openai", -- "copilot" OR "ollama"
        -- Below are default values - included for reference.
        roles = {
            ---The header name for the LLM's messages
            llm = function(adapter)
                return string.format(
                    " %s%s",
                    adapter.formatted_name,
                    adapter.schema.model.default and " (" .. adapter.schema.model.default .. ")" or ""
                )
            end,

            ---The header name for your messages
            user = "Me",
        },
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
        keymaps = {
            accept_change = {
                modes = { n = "<leader>ca" },
                description = "Accept the suggested change",
            },
            reject_change = {
                modes = { n = "<leader>cr" },
                description = "Reject the suggested change",
            },
        },
    },
    agent = {
        adapter = "openai",
    },
}

local prompt_library = {
    ["Documentation"] = require("prompts.documentation"),
    ["Advanced Commit Message"] = require("prompts.commit_advanced"),
    ["Review"] = require("prompts.review"),
    ["Mindmap"] = require("prompts.mindmap"),
    ["Documentation Comments"] = require("prompts.doc_comments"),
}

local config = {
    adapters = adapters,
    display = display,
    strategies = strategies,
    prompt_library = prompt_library,
}

---@diagnostic disable-next-line: different-requires
require("codecompanion").setup(config)
