local load_config = require("utils").load_config

return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        {
            "mfussenegger/nvim-dap",
            config = load_config("dap"),
            dependencies = {
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
                    dependencies = { "HiPhish/debugpy.nvim" },
                    config = function(_, opts)
                        require("dap-python").test_runner = "pytest"
                        require("dap-python").setup("uv")
                    end,
                },
            },
        },
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
