---@diagnostic disable-next-line: different-requires
local cc = require("codecompanion")
local ca = require("codecompanion.adapters")

local ollama_url = "http://localhost:11434"

local comp_provider = "cmp"
if vim.g.use_blink then
    comp_provider = "blink"
end

local adapters = {
    http = {
        jina = function()
            return ca.extend("jina", {
                env = {
                    api_key = "JINA_API_KEY",
                },
            })
        end,
        copilot = function()
            return ca.extend("copilot", {
                schema = {
                    model = { default = "claude-3.5-sonnet" },
                    max_tokens = { default = 8192 },
                },
            })
        end,
        ollama = function()
            return ca.extend("ollama", {
                env = { url = ollama_url },
                headers = { ["Content-Type"] = "application/json" },
                opts = {
                    vision = true,
                    stream = true,
                },
                -- https://github.com/ollama/ollama/blob/main/docs/modelfile.md#parameter
                schema = {
                    model = {
                        default = "qwen3:8b",
                        choices = {
                            "qwen3:8b",
                            "mistral:latest",
                            "deepseek-r1:8b",
                            "codellama:13b",
                            "llama3.2:latest",
                            "qwen2.5-coder:14b",
                        },
                    },
                    num_ctx = {
                        default = 20000,
                    },
                    think = {
                        default = function(adapter)
                            local model_name = adapter.model.name:lower()
                            return vim.iter({ "qwen3:8b", "deepseek-r1:8b" }):any(function(kw)
                                return string.find(model_name, kw) ~= nil
                            end)
                        end,
                    },
                },
            })
        end,
        opts = {
            show_model_choices = true,
        },
    },
}

local display = {
    action_palette = {
        width = 95,
        height = 10,
        prompt = "Prompt ", -- Prompt used for interactive LLM calls
        provider = "snacks",
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
        fold_context = true, -- Fold context in the chat buffer?
        window = {
            sticky = true, -- when set to true and `layout` is not `"buffer"`, the chat buffer will remain opened when switching tabs
        },
    },
}

local strategies = {
    chat = {
        adapter = "ollama",
        model = "qwen2.5-coder:14b",
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
        opts = {
            -- blink|cmp|coc|default
            completion_provider = comp_provider,
        },
        slash_commands = {
            ["buffer"] = {
                opts = {
                    provider = "snacks",
                },
                keymaps = {
                    modes = {
                        i = "<C-b>",
                        n = { "<C-b>", "gb" },
                    },
                },
            },
            ["fetch"] = {
                opts = {
                    provider = "snacks",
                },
                keymaps = {
                    modes = {
                        i = "<C-f>",
                        n = { "<C-f>", "gF" },
                    },
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
                keymaps = {
                    modes = {
                        i = "<C-?>",
                        n = { "<C-?>", "g?" },
                    },
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
            next_chat = {
                modes = {
                    n = "]c",
                },
                index = 11,
                callback = "keymaps.next_chat",
                description = "Next Chat",
            },
            previous_chat = {
                modes = {
                    n = "[c",
                },
                index = 12,
                callback = "keymaps.previous_chat",
                description = "Previous Chat",
            },
        },
        variables = {
            ["buffer"] = {
                opts = {
                    default_params = "watch", -- or "pin"
                },
            },
        },
        tools = {
            ["grep_search"] = {
                ---@return boolean
                enabled = function()
                    return vim.fn.executable("rg") == 1
                end,
            },
        },
    },
    inline = {
        adapter = "ollama",
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
        adapter = "ollama",
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
    history = {
        enabled = true,
        opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            auto_save = true,
            expiration_days = 90,
            -- Automatically generate titles for new chats
            auto_generate_title = true,
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            -- "telescope", "snacks" or "default"
            picker = "snacks",
            enable_logging = true,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            -- Keymap to save the current chat manually
            save_chat_keymap = "<localleader>sc",
            title_generation_opts = {
                adapter = "copilot",
                model = "claude-3.5-sonnet",
                refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
                max_refreshes = 3,
            },
            summary = {
                -- Keymap to generate summary (default: "gcs")
                create_summary_keymap = "gcs",
                -- Keymap to browse summaries (default: "gbs")
                browse_summaries_keymap = "gbs",
                -- Keymap to preview/edit summary (default: "gps")
                preview_summary_keymap = "gps",
            },
        },
    },
    agent_rules = {
        enabled = true,
    },
}

local config = {
    memory = {
        opts = {
            chat = {
                enabled = true,
                condition = function(chat)
                    return chat.adapter.type ~= "acp"
                end,
            },
        },
    },
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
