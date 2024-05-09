
local haskell_ft = { "haskell", "lhaskell", "cabal", "cabalproject" }

--[[
Plugins divided into the following categories:
2. Treesitter + LSP
7. Haskell
]]

---@diagnostic disable-next-line: undefined-doc-name

local plugins = {
    --#region Treesitter + LSP



    -- Haskell
    {
        "hasufell/ghcup.vim",
        lazy = false,
        dependencies = {
            { "rbgrouleff/bclose.vim" },
        },
    },
    -- TODO: Comment out later when switch extensions.
    {
        "neovimhaskell/haskell-vim",
        ft = haskell_ft,
        -- https://github.com/neovimhaskell/haskell-vim#configuration
        config = function()
            -- to enable highlighting of `forall`
            vim.g.haskell_enable_quantification = 1
            -- to enable highlighting of `mdo` and `rec`
            vim.g.haskell_enable_recursivedo = 1
            -- to enable highlighting of `proc`
            vim.g.haskell_enable_arrowsyntax = 1
            -- to enable highlighting of `pattern`
            vim.g.haskell_enable_pattern_synonyms = 1
            -- to enable highlighting of type roles
            vim.g.haskell_enable_typeroles = 1
            -- to enable highlighting of `static`
            vim.g.haskell_enable_static_pointers = 1
            -- to enable highlighting of backpack keywords
            vim.g.haskell_backpack = 1
        end,
    },
    {
        "mrcjkb/haskell-snippets.nvim",
        ft = haskell_ft,
        dependencies = { "L3MON4D3/LuaSnip" },
        config = function()
            local haskell_snippets = require("haskell-snippets").all

            require("luasnip").add_snippets("haskell", haskell_snippets, { key = "haskell" })
        end,
    },
    {
        "luc-tielen/telescope_hoogle",
        ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
        dependencies = {
            { "nvim-telescope/telescope.nvim" },
        },
    },

    -- Appearance
}

return plugins
