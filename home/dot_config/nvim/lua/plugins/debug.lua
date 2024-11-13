local load_config = require("utils").load_config

return {
    {
        "mfussenegger/nvim-dap",
        config = load_config("dap"),
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
            },
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {
                    enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
                    highlight_changed_variables = true,
                    show_stop_reason = true, -- show stop reason when stopped for exceptions
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
                    local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
                    require("dap-python").setup(path)
                end,
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
