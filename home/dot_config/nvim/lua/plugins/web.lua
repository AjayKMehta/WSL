return {
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
