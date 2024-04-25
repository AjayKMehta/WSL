local load_config = require("utils").load_config

return {
    {
        "lervag/vimtex",
        ft = { "tex", "rmd" },
        -- Setting to true will break the inverse-search mechanism
        lazy = false,
        init = load_config("vimtex"),
    },
    {
        "iurimateus/luasnip-latex-snippets.nvim",
        dependencies = { "L3MON4D3/LuaSnip" },
        ft = { "tex", "markdown" },
        config = function()
            require("luasnip-latex-snippets").setup({
                -- use treesitter to determine if cursor is in math mode; if false, vimtex is used
                use_treesitter = true,
                allow_on_markdown = true,
            })
            -- Need this for snippets to work
            require("luasnip").config.setup({ enable_autosnippets = true })
        end,
    },
}
