local load_config = require("utils").load_config

return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        lazy = false,
        branch = "main",
        cmd = {
            "TSInstall",
            "TSInstallSync",
            "TSInstallInfo",
            "TSUpdate",
            "TSUpdateSync",
            "TSUninstall",
        },
        build = ":TSUpdate",
        config = load_config("treesitter"),
        -- https://mise.jdx.dev/mise-cookbook/neovim.html#code-highlight-for-run-commands
        init = function()
            require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
                local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
                local filename = vim.fn.fnamemodify(filepath, ":t")
                return string.match(filename, ".*mise.*%.toml$") ~= nil
            end, { force = true, all = false })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = false,
        branch = "main",
        init = function()
            -- You can disable entire built-in ftplugin mappings to avoid conflicts.
            -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
            vim.g.no_plugin_maps = false

            -- Or, disable per filetype (add as you like)
            -- vim.g.no_python_maps = true
            -- vim.g.no_ruby_maps = true
            -- vim.g.no_rust_maps = true
            -- vim.g.no_go_maps = true
        end,
        config = load_config("treesitter_textobjects"),
    },
    {
        -- Show code context.
        "nvim-treesitter/nvim-treesitter-context",
        lazy = false,
        event = "BufReadPost",
        cmd = { "TSContext" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            enable = true,
            multiwindow = true,
            multiline_threshold = 10,
            min_window_height = 0,
            patterns = {
                default = {
                    "class",
                    "function",
                    "method",
                },
            },
        },
        init = function()
            vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true })
            vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true })
        end,
    },
    {
        -- Syntax aware text-objects, select, move, swap, and peek support.
        "nvim-treesitter/nvim-treesitter-textobjects",
        cmd = {
            "TSTextobjectSelect",
            "TSTextobjectSwapNext",
            "TSTextobjectSwapPrevious",
            "TSTextobjectGotoNextStart",
            "TSTextobjectGotoPreviousStart",
        },
    },
    {
        -- Rainbow delimiters with Treesitter
        "HiPhish/rainbow-delimiters.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = { "BufReadPost", "BufNewFile" },
        config = load_config("rainbow"),
    },
    {
        "aaronik/treewalker.nvim",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "Treewalker" },
        opts = {
            highlight = true, -- Whether to briefly highlight the node after jumping to it
            highlight_duration = 250, -- How long should above highlight last (in ms)
            -- Whether to create a visual selection after a movement to a node.
            -- If true, highlight is disabled and a visual selection is made in
            -- its place.
            select = false,
        },
        config = load_config("treewalker"),
    },
    {
        -- NeoVim plugin for jumping to the other end of the current Tree-sitter node using `%`
        "yorickpeterse/nvim-tree-pairs",
        config = function()
            require("tree-pairs").setup()
        end,
    },
}
