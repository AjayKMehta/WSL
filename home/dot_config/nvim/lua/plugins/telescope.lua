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
            {
                "nvim-telescope/telescope-frecency.nvim",
                opts = {
                    enable_prompt_mappings = true,
                    hide_current_buffer = true,
                },
            },
            "nvim-telescope/telescope-dap.nvim",
        },
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },
}
