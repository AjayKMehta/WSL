local load_config = require("utils").load_config

local map_desc = require("utils.mappings").map_desc

return {
    {
        "mfussenegger/nvim-dap",
        config = load_config("dap"),
        dependencies = {
            {
                {
                    -- https://igorlfs.github.io/nvim-dap-view/faq#why-add-nvim-dap-view-as-a-dependency-for-nvim-dap
                    "igorlfs/nvim-dap-view",
                    cmd = { "DapViewOpen", "DapViewClose", "DapViewToggle", "DapViewWatch" },
                    opts = {
                        winbar = {
                            sections = {
                                "console",
                                "watches",
                                "scopes",
                                "exceptions",
                                "breakpoints",
                                "threads",
                                "repl",
                            },
                            controls = {
                                enabled = true,
                            },
                        },
                        windows = {
                            terminal = {
                                position = "left",
                                -- List of debug adapters for which the terminal should be ALWAYS hidden
                                hide = {},
                                -- Hide the terminal when starting a new session
                                start_hidden = true,
                            },
                        },
                    },
                },
                {
                    "Joakker/lua-json5",
                    build = "./install.sh",
                },
                {
                    "theHamsta/nvim-dap-virtual-text",
                    opts = {
                        enabled = true, -- enable this plugin (the default)
                        enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
                        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
                        highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
                        show_stop_reason = true, -- show stop reason when stopped for exceptions
                        commented = true, -- prefix virtual text with comment string (otherwise a bit confusing IMO)
                        only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
                        all_references = false, -- show virtual text on all all references of the variable (not only definitions)
                        clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
                        --- A callback that determines how a variable is displayed or whether it should be omitted
                        display_callback = function(variable, buf, stackframe, node, options)
                            if options.virt_text_pos == "inline" then
                                return " = " .. variable.value
                            else
                                return variable.name .. " = " .. variable.value
                            end
                        end,
                        -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
                        virt_text_pos = "inline",

                        -- experimental features:
                        all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
                        virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
                        virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
                    },
                    config = function(_, opts)
                        require("nvim-dap-virtual-text").setup(opts)
                        vim.api.nvim_create_user_command("DapVirtualTextClear", function()
                            require("nvim-dap-virtual-text.virtual_text").clear_virtual_text()
                        end, {
                            desc = "Clear all the virtual text displayed by nvim-dap-virtual-text",
                            force = true,
                        })
                    end,
                },
                {
                    "mfussenegger/nvim-dap-python",
                    ft = "python",
                    config = function(_, opts)
                        local dp = require("dap-python")
                        dp.test_runner = "pytest"
                        dp.setup("uv")
                        map_desc("n", "<leader>dt", function()
                            dp.test_method()
                        end, "DAP Debug closest method to cursor")
                    end,
                },
                {
                    "jbyuki/one-small-step-for-vimkind",
                    config = function()
                        local dap = require("dap")
                        -- https://www.lazyvim.org/extras/dap/nlua
                        dap.adapters.nlua = function(callback, conf)
                            local adapter = {
                                type = "server",
                                -- host = config.host or "172.17.0.1", -- "192.168.0.141",
                                host = conf.host or "127.0.0.1",
                                port = conf.port or 3000,
                            }
                            if conf.start_neovim then
                                local dap_run = dap.run
                                dap.run = function(c)
                                    adapter.port = c.port
                                    adapter.host = c.host
                                end
                                require("osv").run_this()
                                dap.run = dap_run
                            end
                            callback(adapter)
                        end

                        dap.configurations.lua = {
                            {
                                name = "Current file",
                                type = "nlua",
                                request = "attach",
                                verbose = true,
                                start_neovim = {},
                            },
                            {
                                type = "nlua",
                                request = "attach",
                                name = "Attach to running Neovim instance",
                                port = 3000,
                            },
                        }
                    end,
                },
            },
        },
    },
    {
        "Carcuis/dap-breakpoints.nvim",
        cmd = { "DapBpToggle", "DapBpNext", "DapBpPrev", "DapBpReveal" },
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("persistent-breakpoints").setup({
                load_breakpoints_event = { "BufReadPost" },
                always_reload = true,
            })
            require("dap-breakpoints").setup()

            local dapbp_api = require("dap-breakpoints.api")
            map_desc("n", "<leader>dth", dapbp_api.set_hit_condition_breakpoint, "Set Hit Condition Breakpoint")
            map_desc("n", "<leader>dtL", function()
                dapbp_api.load_breakpoints({ notify = "on_some" })
            end, "Load Breakpoints")
            map_desc("n", "<leader>dtS", function()
                dapbp_api.save_breakpoints({ notify = "on_some" })
            end, "Save Breakpoints")
            map_desc("n", "<leader>dte", dapbp_api.edit_property, "Edit Breakpoint Property")
            map_desc("n", "<leader>dtv", dapbp_api.toggle_virtual_text, "Toggle Breakpoint Virtual Text")
            map_desc("n", "[,", dapbp_api.go_to_previous, "Go to Previous Breakpoint")
            map_desc("n", "],", dapbp_api.go_to_next, "Go to Next Breakpoint")
        end,
        dependencies = { "Weissle/persistent-breakpoints.nvim", "mfussenegger/nvim-dap" },
    },
    {
        -- It's important that you set up the plugins in the following order:

        -- 1. mason.nvim
        -- 2. mason-nvim-dap.nvim

        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
        config = function()
            require("mason").setup()
            require("mason-nvim-dap").setup({
                ensure_installed = { "python", "bash", "coreclr", "haskell", "jq", "stylua" },
                handlers = {
                    coreclr = function() end, -- Don't setup netcoredbg adapter, use easy-dotnet.nvim instead
                },
            })
            -- https://www.reddit.com/r/neovim/comments/1d11ahc/comment/l5rz54s
            local vscode = require("dap.ext.vscode")
            local _filetypes = require("mason-nvim-dap.mappings.filetypes")
            local filetypes = vim.tbl_deep_extend("force", _filetypes, {
                ["node"] = { "javascriptreact", "typescriptreact", "typescript", "javascript" },
            })
            local json = require("plenary.json")
            vscode.json_decode = function(str)
                return vim.json.decode(json.json_strip_comments(str))
            end
            vscode.load_launchjs(nil, filetypes)
        end,
    },
}
