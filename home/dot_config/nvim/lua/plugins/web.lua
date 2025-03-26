return {
    {
        "rest-nvim/rest.nvim",
        ft = "http",
        cmd = "Rest",
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
