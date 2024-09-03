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
            "Theo-Steiner/togglescope",
            "benfowler/telescope-luasnip.nvim",
            "tom-anders/telescope-vim-bookmarks.nvim",
            "debugloop/telescope-undo.nvim",
            "nvim-telescope/telescope-frecency.nvim",
            "catgoose/telescope-helpgrep.nvim",
            "nvim-telescope/telescope-dap.nvim",
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
