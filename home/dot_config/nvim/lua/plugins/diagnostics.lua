return {
    {
        -- Preview code with LSP code actions applied.
        "aznhe21/actions-preview.nvim",
        event = "VeryLazy",
        opts = {
            diff = {
                algorithm = "patience",
            },
            telescope = {
                sorting_strategy = "ascending",
                layout_strategy = "vertical",
                layout_config = {
                    width = 0.8,
                    height = 0.9,
                    prompt_position = "top",
                    preview_cutoff = 20,
                    preview_height = function(_, _, max_lines)
                        return max_lines - 15
                    end,
                },
            },
        },
    },
    {
        -- AI/search-engine powered diagnostic debugging
        "piersolenski/wtf.nvim",
        opts = {
            popup_type = "vertical",
        },
        cmd = { "WtfSearch", "Wtf" },
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },
    {
        -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
        "folke/trouble.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = { "Trouble", "TroubleToggle", "TodoTrouble" },
        config = function()
            require("trouble").setup({})
        end,
        lazy = false,
    },
}
