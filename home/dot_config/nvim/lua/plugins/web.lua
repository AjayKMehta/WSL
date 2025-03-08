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
        ft = {"html", "markdown", "quarto", "rmd"},
        opts = {
            default_title = "URLs",
            default_action = "clipboard",
            sorted = false,
            jump = {
                ["prev"] = "[u",
                ["next"] = "]u",
            },
        },
    },
}
