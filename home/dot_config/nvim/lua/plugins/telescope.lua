return {
    {
        "nvim-telescope/telescope.nvim",
        -- If you load some function or module within opts, wrap it within a function
        opts = require("configs.telescope").config,
        -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
        dependencies = {
            {
                -- Use fzf syntax in Telescope.
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
            },
            "benfowler/telescope-luasnip.nvim",
            "tom-anders/telescope-vim-bookmarks.nvim",
            "debugloop/telescope-undo.nvim",
            "nvim-telescope/telescope-frecency.nvim",
            "catgoose/telescope-helpgrep.nvim",
            "tsakirist/telescope-lazy.nvim",
            "nvim-telescope/telescope-dap.nvim",
            {
                "LukasPietzschmann/telescope-tabs",
                config = function()
                    -- https://github.com/LukasPietzschmann/telescope-tabs/wiki/Configs#configs
                    require("telescope-tabs").setup({
                        entry_formatter = function(tab_id, buffer_ids, file_names, file_paths, is_current)
                            local entry_string = table.concat(
                                vim.tbl_map(function(v)
                                    return vim.fn.fnamemodify(v, ":.")
                                end, file_paths),
                                ", "
                            )
                            return string.format("%d: %s%s", tab_id, entry_string, is_current and " <" or "")
                        end,
                    })
                end,
            },
            "stevearc/aerial.nvim",
        },
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },
    {
        "axieax/urlview.nvim",
        cmd = { "UrlView" },
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "stevearc/dressing.nvim",
        },
        opts = {
            default_title = "URLs",
            default_picker = "telescope",
            default_action = "clipboard",
            sorted = false,
            jump = {
                ["prev"] = "[u",
                ["next"] = "]u",
            },
        },
    },
    {
        "trevarj/telescope-tmux.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        keys = {
            { "<leader>fxs", "<cmd>Telescope tmux sessions<CR>", mode = { "n" }, desc = "Tmux sessions" },
            { "<leader>fxw", "<cmd>Telescope tmux windows<CR>", mode = { "n" }, desc = "Tmux windows" },
            { "<leader>fxc", "<cmd>Telescope tmux pane_contents<CR>", mode = { "n" }, desc = "Tmux pane contents" },
            { "<leader>fxf", "<cmd>Telescope tmux pane_file_paths<CR>", mode = { "n" }, desc = "Tmux file paths" },
        },
        lazy = true,
    },
}
