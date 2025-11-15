return {
    {
        -- Generate comments based on treesitter.
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = {
            enabled = true,
            snippet_engine = "luasnip",
            languages = {
                lua = {
                    template = {
                        annotation_convention = "emmylua",
                    },
                    -- Even though specified here, still have to specify again when calling command or it will use default (doxygen)!
                    cs = { template = { annotation_convention = "xmldoc" } },
                },
            },
        },
        -- Uncomment next line if you want to follow only stable versions
        version = "*",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    },
}
