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
            { "theHamsta/nvim-dap-virtual-text" },
            {
                "mfussenegger/nvim-dap-python",
                ft = "python",
                dependencies = { "HiPhish/debugpy.nvim" },
                config = function(_, opts)
                    local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
                    require("dap-python").setup(path)
                end,
            },
            {
                "Willem-J-an/nvim-dap-powershell",
                enabled = true,
                dependencies = {
                    "nvim-lua/plenary.nvim",
                    {
                        "m00qek/baleia.nvim",
                        lazy = true,
                    },
                },
                config = function()
                    require("dap-powershell").setup()
                end,
            }
        }
    },
    {
        -- It's important that you set up the plugins in the following order:

        -- 1. mason.nvim
        -- 2. mason-nvim-dap.nvim

        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason").setup()
            require("mason-nvim-dap").setup({
                ensure_installed = { "python", "bash", "coreclr", "haskell", "jq", "stylua" },
            })
        end,
    },
}
