return {
    {
        -- Advanced comment plugin with Treesitter support.
        "numToStr/Comment.nvim",
        lazy = true,
        enabled = function()
            return not vim.g.nvim_comment
        end,
        config = function(_, opts)
            local comment = require("Comment")
            -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#commentnvim
            local pre_hook = {
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            }
            comment.setup(vim.tbl_deep_extend("force", opts, pre_hook))
        end,
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                lazy = false,
                init = function()
                    vim.g.skip_ts_context_commentstring_module = true
                end,
                config = function()
                    local tsc = require("ts_context_commentstring")
                    if vim.g.nvim_comment then
                        tsc.setup({
                            enable_autocmd = false,
                        })
                        local get_option = vim.filetype.get_option
                        vim.filetype.get_option = function(filetype, option)
                            return option == "commentstring"
                                    and require("ts_context_commentstring.internal").calculate_commentstring()
                                or get_option(filetype, option)
                        end
                    else
                        tsc.setup({
                            enable_autocmd = false,
                            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
                        })
                    end
                end,
            },
        },
    },
    {
        -- Generate comments based on treesitter.
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = {
            enabled = true,
            snippet_engine = "luasnip",
            languages = {
                lua = {
                    template = {
                        annotation_convention = "emmylua",
                    },
                    -- Even though specified here, still have to specify again when calling command or it will use default (doxygen)!
                    cs = { template = { annotation_convention = "xmldoc" } },
                },
            },
        },
        -- Uncomment next line if you want to follow only stable versions
        version = "*",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    },
}
