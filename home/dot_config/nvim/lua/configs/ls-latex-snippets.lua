require("luasnip-latex-snippets").setup({
    -- use treesitter to determine if cursor is in math mode; if false, vimtex is used
    use_treesitter = true,
    allow_on_markdown = true,
})
-- Need this for snippets to work
require("luasnip").config.setup({ enable_autosnippets = true })
