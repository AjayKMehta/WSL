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
                    cmd = {
                        "DapViewOpen",
                        "DapViewClose",
                        "DapViewToggle",
                        "DapViewWatch",
                        "DapViewJump",
                        "DapViewShow",
                        "DapViewVirtualTextEnable",
                        "DapViewVirtualTextDisable",
                        "DapViewVirtualTextToggle",
                    },
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
                            default_section = "watches",
                            controls = {
                                enabled = true,
                            },
                        },
                        windows = {
                            terminal = {
                                position = "left",
                                -- List of debug adapters for which the terminal should be ALWAYS hidden
                                hide = {},
                            },
                        },
                        auto_toggle = true,
                        virtual_text = {
                            -- Control with `DapViewVirtualTextToggle`
                            enabled = true,
                            format = function(variable, _, _)
                                -- Strip out excessive whitespace
                                return " " .. variable.value:gsub("%s+", " ")
                            end,
                        },
                    },
                },
                {
                    "Joakker/lua-json5",
                    build = "./install.sh",
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
        cmd = { "DapBpToggle", "DapBpNext", "DapBpPrev", "DapBpReveal", "DapBpEditException" },
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
            map_desc("n", "<leader>def", dapbp_api.edit_exception_filters, "Edit Exception Breakpoint Filters")
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
