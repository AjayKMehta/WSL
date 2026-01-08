return {
    {
        "cenk1cenk2/schema-companion.nvim",
        ft = { "yaml", "helm" },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
        config = function()
            require("schema-companion").setup({
                log_level = vim.log.levels.INFO,
            })
        end,
    },
    {
        "https://tangled.org/cuducos.me/yaml.nvim",
        ft = { "yaml", "helm" },
        dependencies = { "folke/snacks.nvim" },
    },
}
