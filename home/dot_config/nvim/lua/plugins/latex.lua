local load_config = require("utils").load_config

return {
    {
        "lervag/vimtex",
        ft = { "tex", "rmd" },
        config = load_config("vimtex"),
    },
    {
        "iurimateus/luasnip-latex-snippets.nvim",
        dependencies = { "L3MON4D3/LuaSnip" },
        ft = { "tex", "markdown" },
        config = load_config("ls-latex-snippets"),
    },
}
