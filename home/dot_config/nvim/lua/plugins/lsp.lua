local load_config = require("utils").load_config

return {
    {
        -- Performant LSP progress status.
        "linrongbin16/lsp-progress.nvim",
        config = load_config("lsp_progress"),
    },
    {
        -- Garbage collector that stops inactive LSP clients to free RAM.
        "zeioth/garbage-day.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        event = "VeryLazy",
    },
    {
        -- lsp_lines is a simple neovim plugin that renders diagnostics using virtual lines on top of the real line of code.
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            local lsp_lines = require("lsp_lines")
            lsp_lines.setup()
            lsp_lines.toggle()
        end,
        keys = {
            {
                "<leader>ltd",
                function()
                    require("lsp_lines").toggle()
                end,
                desc = "Lsp Toggle inline diagnostics",
            },
        },
    },
    {
        "adoyle-h/lsp-toggle.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        cmd = { "LspToggle" },
        opts = {
            create_cmds = true, -- Whether to create user commands
            telescope = true,   -- Whether to load telescope extensions
        },
    },
    {
        -- Display LSP inlay hints at the end of the line, rather than within the line.
        "chrisgrieser/nvim-lsp-endhints",
        event = "LspAttach",
        opts = {}, -- required, even if empty
        keys = {
            {
                "<leader>lte",
                function()
                    require("lsp-endhints").toggle()
                end,
                desc = "Lsp Toggle hints at end of line.",
            },
        },
    },
    -- TODO: Investigate further. Tried renaming Lua file in nvim-tree and didn't work.
    {
        "antosha417/nvim-lsp-file-operations",
        enabled = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-tree.lua",
        },
        config = function()
            require("lsp-file-operations").setup()
        end,
    },
}
