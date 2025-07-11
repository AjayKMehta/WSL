return {
    {
        "nvim-telescope/telescope.nvim",
        opts = require("configs.telescope").config,
        -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
        dependencies = {
            {
                -- Use fzf syntax in Telescope.
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
            },
            "nvim-telescope/telescope-dap.nvim",
        },
    },
}
