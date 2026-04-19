local load_config = require("utils.helpers").load_config

local map_desc = require("utils.mappings").map_desc

return {
    {
        "mfussenegger/nvim-dap",
        config = load_config("dap"),
        dependencies = {
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
                keys = {
                    {
                        "<leader>dvd",
                        "<cmd>DapViewVirtualTextDisable<cr>",
                        desc = "DAP Disable Virtual Text",
                    },
                    {
                        "<leader>dve",
                        "<cmd>DapViewVirtualTextEnable<cr>",
                        desc = "DAP Enable Virtual Text",
                    },
                    {
                        "<leader>dvt",
                        "<cmd>DapViewVirtualTextToggle<cr>",
                        desc = "DAP Toggle Virtual Text",
                    },
                },
                config = load_config("nvim_dap_view"),
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
                config = load_config("osv"),
            },
        },
    },
    {
        "Carcuis/dap-breakpoints.nvim",
        cmd = { "DapBpToggle", "DapBpNext", "DapBpPrev", "DapBpReveal", "DapBpEditException" },
        event = { "BufReadPost", "BufNewFile" },
        config = load_config("dap_breakpoints"),
        dependencies = {
            {
                "Weissle/persistent-breakpoints.nvim",
                config = function()
                    require("persistent-breakpoints").setup({
                        load_breakpoints_event = { "BufReadPost" },
                        always_reload = true,
                    })
                end,
            },
            "mfussenegger/nvim-dap",
        },
    },
    {
        -- It's important that you set up the plugins in the following order:

        -- 1. mason.nvim
        -- 2. mason-nvim-dap.nvim

        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
        config = function()
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
