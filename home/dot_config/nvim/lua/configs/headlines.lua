vim.cmd([[highlight Headline1 guifg=#FD585F gui=italic]])
vim.cmd([[highlight Headline2 guifg=#58DB01 gui=italic]])
vim.cmd([[highlight Headline3 guifg=#27CFFF gui=italic]])
vim.cmd([[highlight Headline4 guifg=#39B877 gui=italic]])

vim.cmd([[highlight Quote guifg=#0099EC]])

local md_query = [[
                (atx_heading [
                    (atx_h1_marker)
                    (atx_h2_marker)
                    (atx_h3_marker)
                    (atx_h4_marker)
                    (atx_h5_marker)
                    (atx_h6_marker)
                ] @headline)

                (thematic_break) @dash

                (fenced_code_block) @codeblock

                (block_quote_marker) @quote
                (block_quote (paragraph (inline (block_continuation) @quote)))
                (block_quote (paragraph (block_continuation) @quote))
                (block_quote (block_continuation) @quote)
            ]]

require("headlines").setup({
    markdown = {
        query = vim.treesitter.query.parse("markdown", md_query),
        headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4" },
        bullets = false,
        codeblock_highlight = "CodeBlock",
        dash_highlight = "Dash",
        dash_string = "-",
        quote_highlight = "Quote",
        quote_string = "┃",
        fat_headlines = false,
    },
    rmd = {
        query = vim.treesitter.query.parse("markdown", md_query),
        treesitter_language = "markdown",
        headline_highlights = { "Headline1", "Headline2", "Headline3" },
        codeblock_highlight = "CodeBlock",
        dash_highlight = "Dash",
        dash_string = "-",
        quote_highlight = "Quote",
        quote_string = "┃",
        fat_headlines = false,
    },
    yaml = {
        query = vim.treesitter.query.parse(
            "yaml",
            [[
                (
                    (comment) @dash
                    (#match? @dash "^# ---+$")
                )
            ]]
        ),
        dash_highlight = "Dash",
    },
})
