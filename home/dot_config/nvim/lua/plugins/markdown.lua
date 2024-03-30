return {
    {
        "tadmccorkle/markdown.nvim",
        event = "VeryLazy",
        opts = {
            -- configuration here or empty for defaults
        },
    },
    {
        "AckslD/nvim-FeMaco.lua",
        config = function()
            require("femaco").setup()
        end,
    },
}
