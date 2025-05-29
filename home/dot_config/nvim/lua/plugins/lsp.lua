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
        ft = { "r", "rmd", "quarto" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {},
        setup = function(_, opts)
            require("otter").setup(opts)

            -- https://github.com/olimorris/codecompanion.nvim/discussions/1284#discussioncomment-12949708
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "r", "rmd", "quarto", "codecompanion" },
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
}
