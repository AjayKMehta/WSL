return {
    {
        "rest-nvim/rest.nvim",
        ft = "http",
        cmd = "Rest",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function(_, opts)
            require("telescope").load_extension("rest")
        end,
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
}
