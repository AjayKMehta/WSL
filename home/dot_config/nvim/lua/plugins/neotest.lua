return {
    {
        -- An extensible framework for interacting with tests.
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
            "Issafalcon/neotest-dotnet",
            "mrcjkb/neotest-haskell",
        },
        config = function()
            local neotest = require("neotest")

            neotest.setup({
                adapters = {
                    require("neotest-python")({
                        -- Extra arguments for nvim-dap configuration
                        -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
                        dap = {
                            justMyCode = false,
                            console = "integratedTerminal",
                        },
                        args = { "--log-level", "DEBUG", "--quiet" },
                        runner = "pytest",
                    }),
                    -- https://github.com/Issafalcon/neotest-dotnet
                    require("neotest-dotnet")({
                        -- Extra arguments for nvim-dap configuration
                        -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
                        dap = { justMyCode = true },
                    }),
                    require("neotest-haskell"),
                },
            })
        end,
    },
}
