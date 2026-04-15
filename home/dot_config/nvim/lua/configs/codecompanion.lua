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
                    model = { default = "claude-haiku-4.5" },
                    max_tokens = { default = 8192 },
                },
            })
        end,
        ollama_cloud = function()
            return ca.extend("ollama", {
                opts = {
                    vision = true,
                },
                env = {
                    url = "https://ollama.com",
                    api_key = "OLLAMA_API_KEY",
                },
                headers = {
                    ["Content-Type"] = "application/json",
                    ["Authorization"] = "Bearer ${api_key}",
                },
                parameters = {
                    sync = true,
                },
                schema = {
                    model = {
                        default = "qwen3-coder:480b-cloud",
                        choices = {
                            "gpt-oss:120b-cloud",
                            "qwen3-coder:480b-cloud",
                        },
                    },
                    num_ctx = {
                        default = 49152,
                    },
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
                schema = {
                    model = {
                        default = "glm-4.7-flash:q4_K_M",
                        choices = {
                            "deepseek-r1:8b",
                            "glm-4.7-flash:q4_K_M",
                            "qwen3.5:9b",
                            "llama3.2:latest",
                            "ministral-3:8b",
                        },
                    },
                    num_ctx = {
                        default = 49152,
                    },
                    think = {
                        default = function(adapter)
                            local model_name = adapter.model.name:lower()
                            return vim.iter({ "glm-4.7-flash:q4_K_M", "qwen3.5:9b" }):any(function(kw)
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
            show_preset_actions = true, -- Show the default actions in the action palette?
            show_preset_prompts = true, -- Show the default prompt library in the action palette?
        },
        diff = {
            enabled = true,
            provider = "inline",
            provider_opts = {
                inline = {
                    layout = "float", -- float|buffer - Where to display the diff
                    opts = {
                        context_lines = 3, -- Number of context lines in hunks
                        dim = 25, -- Background dim level for floating diff (0-100, [100 full transparent], only applies when layout = "float")
                        full_width_removed = true, -- Make removed lines span full width
                        show_keymap_hints = true, -- Show hints above diff
                        show_removed = true, -- Show removed lines as virtual text
                    },
                },
                split = {
                    close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
                    layout = "vertical", -- vertical|horizontal split
                },
            },
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
            sticky = true, -- Chat window follows when switching tabs
            -- Autosize
            width = 0,
            height = 0,
        },
    },
    diff = {
        enabled = true,
        word_highlights = {
            additions = true,
            deletions = true,
        },
    },
}

local interactions = {
    chat = {
        adapter = "ollama",
        model = "glm-4.7-flash:q4_K_M",
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
            ---Decorate the user message before it's sent to the LLM
            ---@param message string
            ---@param adapter CodeCompanion.Adapter
            ---@param context table
            ---@return string
            prompt_decorator = function(message, adapter, context)
                return string.format([[<prompt>%s</prompt>]], message)
            end,
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
        editor_context = {
            ["buffer"] = {
                opts = {
                    default_params = "diff",
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
            ["create_file"] = {
                opts = {
                    require_approval_before = false,
                },
            },
            ["insert_edit_into_file"] = {
                opts = {
                    require_approval_before = { buffer = true },
                    patching_algorithm = "strategies.chat.tools.catalog.helpers.patch",
                },
            },
        },
    },
    inline = {
        adapter = "ollama",
        keymaps = {
            stop = {
                modes = { n = "q" },
                callback = "keymaps.stop",
                description = "Stop request",
            },
        },
    },
    agent = {
        adapter = "copilot",
    },
    background = {
        adapter = {
            name = "ollama",
            model = "glm-4.7-flash:q4_K_M",
        },
    },
    shared = {
        keymaps = {
            always_accept = {
                callback = "keymaps.always_accept",
                modes = { n = "<leader>cA" },
            },
            accept_change = {
                modes = { n = "<leader>ca" },
                description = "Accept the suggested change",
            },
            reject_change = {
                modes = { n = "<leader>cr" },
                opts = { nowait = true },
                description = "Reject the suggested change",
            },
        },
    },
}

local prompt_library = {
    ["Documentation"] = require("prompts.documentation"),
    ["Advanced Commit Message"] = require("prompts.commit_advanced"),
    ["Review"] = require("prompts.review"),
    ["Mindmap"] = require("prompts.mindmap"),
    -- ["Documentation Comments"] = require("prompts.doc_comments"),
    markdown = {
        dirs = {
            vim.fn.getcwd() .. "/.prompts",
            "~/.config/nvim/lua/prompts",
        },
    },
}

local extensions = {
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
                model = "claude-haiku-4.5",
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
}

-- Logs stored in ~/.local/state/nvim/codecompanion.log
local opts = {
    log_level = "INFO", -- TRACE|DEBUG|ERROR|INFO
    default_servers = { "sequential-thinking" },
    per_project_config = {
      files = {
        ".codecompanion.lua",
      },
    },
}

local rules = {
    default = {
        description = "Default rules",
        files = {
            ".clinerules",
            ".goosehints",
            ".rules",
            ".github/copilot-instructions.md",
            "AGENT.md",
            "AGENTS.md",
            { path = "CLAUDE.md", parser = "claude" },
            { path = "CLAUDE.local.md", parser = "claude" },
            { path = "~/.claude/CLAUDE.md", parser = "claude" },
        },
        is_preset = true,
    },
    claude = {
        description = "Rules for claude",
        parser = "claude",
        files = {
            "CLAUDE.md",
            "CLAUDE.local.md",
            "~/.claude/CLAUDE.md",
        },
    },
    copilot = {
        description = "Rules for copilot",
        files = {
            ".github/copilot-instructions.md",
            ["security"] = {
                description = "Security",
                files = {
                    ".github/instructions/*security*.md",
                },
            },
            ["cicd"] = {
                description = "CICD",
                files = {
                    ".github/instructions/*ci-cd*.md",
                },
            },
        },
    },
    opts = {
        chat = {
            enabled = true,
            condition = function(chat)
                return chat.adapter.type ~= "acp"
            end,
            default_rules = "default", -- The rule groups to load
        },
    },
}

local mcp = {
    ["tavily-mcp"] = {
        cmd = { "npx", "-y", "tavily-mcp@latest" },
        env = {
            "TAVILY_API_KEY",
        },
    },
    filesystem = {
        cmd = { "npx", "-y", "@modelcontextprotocol/server-filesystem" },
        -- TODO: Update this.
        -- roots = function()
        --     -- Return a list of names and directories as per:
        --     -- https://modelcontextprotocol.io/specification/2025-11-25/client/roots#listing-roots
        -- end,
    },
    ["sequential-thinking"] = {
        cmd = { "npx", "-y", "@modelcontextprotocol/server-sequential-thinking" },
    },
    memory = {
        cmd = { "npx", "-y", "@modelcontextprotocol/server-memory" },
    },
    time = {
        cmd = { "uvx", "mcp-server-time", "--local-timezone", "America/Los_Angeles" },
        tool_overrides = {
            get_current_time = {
                opts = {
                    require_approval_before = false,
                },
            },
            convert_time = {
                opts = {
                    require_approval_before = false,
                },
            },
        },
    },
}

local config = {
    extensions = extensions,
    adapters = adapters,
    display = display,
    interactions = interactions,
    prompt_library = prompt_library,
    rules = rules,
    opts = opts,
    mcp = mcp,
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

-- Expand 'CC' into 'CodeCompanion' in the command line
vim.cmd([[cab CC CodeCompanion]])

-- https://codecompanion.olimorris.dev/configuration/chat-buffer#checkpoints
vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionChatCreated",
    callback = function(args)
        local chat = cc.buf_get_chat(args.data.bufnr)
        chat:add_callback("on_checkpoint", function(c, data)
            local context_window = data.adapter.meta and data.adapter.meta.context_window
            if not context_window then
                return
            end

            local usage = data.estimated_tokens / context_window
            if usage > 0.8 then
                vim.notify(string.format("Context window %.0f%% full", usage * 100), vim.log.levels.WARN)
                -- Compact data.messages in-place here
            end
        end)
    end,
})
