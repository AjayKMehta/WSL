local load_config = require("utils").load_config

return {
    {
        "mfussenegger/nvim-dap",
        config = load_config("dap"),
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                dependencies = {  "nvim-neotest/nvim-nio" },
            },
            {"theHamsta/nvim-dap-virtual-text"},
            {
                "mfussenegger/nvim-dap-python",
                ft = "python",
                dependencies = { "HiPhish/debugpy.nvim" },
                config = function(_, opts)
                    local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
                    require("dap-python").setup(path)
                end,
            },
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
    {
    "Willem-J-an/nvim-dap-powershell",
    -- TODO: Get this to work.
    enabled = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
        {
            "m00qek/baleia.nvim",
            lazy = true,
            tag = "v1.4.0",
        },
    },
    config = function()
        require("dap-powershell").setup()
    end,
}
}
