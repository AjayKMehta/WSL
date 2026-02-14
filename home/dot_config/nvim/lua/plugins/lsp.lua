local load_config = require("utils").load_config

return {
    {
        -- Garbage collector that stops inactive LSP clients to free RAM.
        "zeioth/garbage-day.nvim",
        event = "VeryLazy",
    },
    -- Otter.nvim provides lsp features and a code completion source for code embedded in other documents!
    {
        "jmbuhr/otter.nvim",
        ft = { "r", "rmd", "markdown" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            lsp = {
                hover = { border = "rounded" },
            },
            buffers = {
                set_filetype = true,
                write_to_disk = true,
            },
            handle_leading_whitespace = true,
        },
        config = function(_, opts)
            require("otter").setup(opts)

            -- https://github.com/olimorris/codecompanion.nvim/discussions/1284#discussioncomment-12949708
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "markdown", "quarto", "rmd", "codecompanion", "toml" }, -- toml for mise
                callback = function(args)
                    require("otter").activate()
                    local bufnr = args.buf
                    vim.api.nvim_create_autocmd("BufWritePost", {
                        buffer = bufnr,
                        callback = function()
                            require("otter").activate()
                        end,
                    })
                end,
            })

            vim.api.nvim_create_autocmd("user", {
                pattern = "CodeCompanionRequestFinished",
                callback = function(request)
                    local currentBuf = vim.api.nvim_get_current_buf()

                    vim.cmd("buffer " .. request.data.bufnr)
                    require("otter").activate()
                    vim.cmd("buffer " .. currentBuf)
                end,
            })
        end,
    },
    {
        "quarto-dev/quarto-nvim",
        dependencies = {
            "jmbuhr/otter.nvim",
            "nvim-treesitter/nvim-treesitter",
            "Vigemus/iron.nvim",
        },
        cmd = {
            "QuartoPreview",
            "QuartoClosePreview",
            "QuartoSend",
            "QuartoSendAbove",
            "QuartoSendBelow",
            "QuartoSendAll",
            "QuartoSendLine",
        },
        opts = {
            closepreviewonexit = true,
            lspFeatures = {
                enabled = true,
                chunks = "curly",
                languages = { "r", "python", "bash", "html" },
                diagnostics = { enabled = true, triggers = { "BufWritePost" } },
                completion = {
                    enabled = true,
                },
            },
            codeRunner = {
                enabled = true,
                default_method = "iron",
                never_run = { "yaml" }, -- filetypes which are never sent to a code runner
            },
        },
        config = function(_, opts)
            require("quarto").setup(opts)
            local runner = require("quarto.runner")
            vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "Run cell", silent = true })
            vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "Run cell and above", silent = true })
            vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "Run all cells", silent = true })
            vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "Run line", silent = true })
            vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "Run visual range", silent = true })
            vim.keymap.set("n", "<localleader>RA", function()
                runner.run_all(true)
            end, { desc = "Run all cells of all languages", silent = true })
        end,
    },
    {
        -- displays code lens for references, diagnostics, and git authorship
        "oribarilan/lensline.nvim",
        tag = "1.0.0", -- or: branch = 'release/1.x' for latest non-breaking updates
        event = "LspAttach",
        cmd = { "LenslineEnable", "LenslineDisable", "LenslineToggleEngine" },
        config = function()
            require("lensline").setup({
                providers = {
                    {
                        name = "diagnostics",
                        enabled = true,
                        min_level = "WARN", -- only show WARN and ERROR by default (HINT, INFO, WARN, ERROR)
                    },
                },
            })
        end,
    },
}
