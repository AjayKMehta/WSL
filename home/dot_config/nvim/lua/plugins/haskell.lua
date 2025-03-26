local load_config = require("utils").load_config

return {
    -- Haskell
    {
        "mrcjkb/haskell-tools.nvim",
        version = "^4", -- Recommended
        ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
        config = load_config("haskell"),
    },
    {
        "mrcjkb/haskell-snippets.nvim",
        ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
        dependencies = { "L3MON4D3/LuaSnip" },
        config = function()
            local haskell_snippets = require("haskell-snippets").all

            require("luasnip").add_snippets("haskell", haskell_snippets, { key = "haskell" })
        end,
    },
}
