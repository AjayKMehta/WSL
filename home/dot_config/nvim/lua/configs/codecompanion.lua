---@diagnostic disable-next-line: different-requires
local cc = require("codecompanion")
local ca = require("codecompanion.adapters")

local ollama_url = "http://localhost:11434"

local function create_ollama_adapter(name, model, num_ctx)
    return ca.extend("ollama", {
        env = { url = ollama_url },
        name = name,
        schema = {
            model = { default = model, choices = false },
            num_ctx = { default = num_ctx },
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
    codellama = create_ollama_adapter("codellama", "codellama:13b", 16384),
    mixtral = create_ollama_adapter("mixtral", "mixtral:8x7b", 32768),
    deepseek = create_ollama_adapter("deepseek", "deepseek-r1:8b", 32768),
    qwen = function()
        return ca.extend("ollama", {
            env = { url = ollama_url },
            headers = { ["Content-Type"] = "application/json" },
            parameters = { sync = true },
            name = "qwen",
            -- https://github.com/ollama/ollama/blob/main/docs/modelfile.md#parameter
            schema = {
                model = { default = "qwen2.5-coder:14b" },
                num_ctx = { default = 16384 },
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
        provider = "default",
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
        adapter = "copilot",
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
                    provider = "snacks",
                },
            },
            ["fetch"] = {
                opts = {
                    provider = "snacks",
                },
            },
            ["file"] = {
                opts = {
                    provider = "snacks",
                },
            },
            ["help"] = {
                opts = {
                    provider = "snacks",
                },
            },
            ["symbols"] = {
                opts = {
                    provider = "snacks",
                },
            },
            -- https://codecompanion.olimorris.dev/configuration/chat-buffer.html#slash-commands
            ["git_files"] = {
                description = "List git files",
                callback = function(chat)
                    local handle = io.popen("git ls-files")
                    if handle ~= nil then
                        local result = handle:read("*a")
                        handle:close()
                        chat:add_reference({ content = result }, "git", "<git_files>")
                    else
                        return vim.notify("No git files available", vim.log.levels.INFO, { title = "CodeCompanion" })
                    end
                end,
                opts = {
                    contains_code = false,
                },
            },
        },
        keymaps = {
            -- Adapted from https://github.com/olimorris/codecompanion.nvim/discussions/1153#discussioncomment-12560883
            send_to_deepseek = {
                modes = { n = "<S-CR>" },
                description = "Send to deepseek",
                callback = function(chat)
                    chat:apply_model("deepseek-r1:8b")
                    chat:submit()
                end,
            },
        },
    },
    inline = {
        adapter = "qwen",
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
        adapter = "llama3",
    },
}

local prompt_library = {
    ["Documentation"] = require("prompts.documentation"),
    ["Advanced Commit Message"] = require("prompts.commit_advanced"),
    ["Review"] = require("prompts.review"),
    ["Mindmap"] = require("prompts.mindmap"),
    ["Documentation Comments"] = require("prompts.doc_comments"),
}

local extensions = {
    mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
        },
    },
}

local config = {
    extensions = extensions,
    adapters = adapters,
    display = display,
    strategies = strategies,
    prompt_library = prompt_library,
}

cc.setup(config)

-- https://github.com/olimorris/codecompanion.nvim/discussions/1090#discussioncomment-12439302

local function compact_reference(messages)
    local refs = {}
    local result = {}

    -- First loop to find last occurrence of each reference
    for i, msg in ipairs(messages) do
        if msg.opts and msg.opts.reference then
            refs[msg.opts.reference] = i
        end
    end

    -- Second loop to keep messages with unique references
    for i, msg in ipairs(messages) do
        local ref = msg.opts and msg.opts.reference
        if not ref or refs[ref] == i then
            table.insert(result, msg)
        end
    end

    return result
end

local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(request)
        if request.data.strategy ~= "chat" then
            return
        end
        local current_chat = cc.last_chat()
        if not current_chat then
            return
        end
        current_chat.messages = compact_reference(current_chat.messages)
    end,
})

-- https://github.com/olimorris/codecompanion.nvim/discussions/1236#discussioncomment-12815303
vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestStarted",
    callback = function()
        vim.defer_fn(function()
            vim.cmd("stopinsert")
        end, 1)
    end,
})
