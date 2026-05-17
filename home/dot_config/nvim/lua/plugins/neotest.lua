return {
    {
        -- An extensible framework for interacting with tests.
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
            -- https://github.com/mrcjkb/neotest-haskell/issues/179
            { "mrcjkb/neotest-haskell", tag = "2.0.0" },
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
                        args = { "--log-level", "INFO", "--quiet" },
                        runner = "pytest",
                        pytest_discover_instances = true,
                    }),
                    -- https://github.com/GustavEikaas/easy-dotnet.nvim/blob/main/news.md#neotest-support-389
                    require("easy-dotnet").neotest(),
                    require("neotest-haskell"),
                },
            })
        end,
    },
}
