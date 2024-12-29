local load_config = require("utils").load_config

return {
    {
        -- Code outline sidebar powered by LSP.
        -- More reliable than aerial.
        "hedyhli/outline.nvim",
        cmd = { "Outline", "OutlineOpen" },
        dependencies = { "epheien/outline-treesitter-provider.nvim" },
        opts = {
            providers = {
                priority = { "lsp", "markdown", "norg", "treesitter" },
            },
            outline_window = {
                auto_jump = false,
                wrap = true,
                show_cursorline = true,
                hide_cursor = true,
            },
            -- Auto-open preview was annoying. `live = true` allows editing in preview window!
            preview_window = { auto_preview = false, live = true },
            symbol_folding = {
                auto_unfold = {
                    only = 2,
                },
            },
            outline_items = {
                show_symbol_lineno = false,
            },
            view = {
                -- Support help (vimdoc) when run `:help`, replace `gO`.
                filter = function(buf)
                    local ft = vim.bo[buf].filetype
                    if ft == "qf" then
                        return false
                    end
                    return vim.bo[buf].buflisted or ft == "help"
                end,
            },
            symbols = {
                filter = {
                    default = { "String", exclude = true },
                    python = { "Function", "Class" },
                },
                icon_source = "lspkind",
            },
        },
        config = function(_, opts)
            require("outline").setup(opts)
        end,
    },
}
