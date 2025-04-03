return {
    {
        "cenk1cenk2/schema-companion.nvim",
        ft = { "yaml", "helm" },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
        opts = {
            enable_telescope = true,
        },
    },
    {
        "cuducos/yaml.nvim",
        ft = { "yaml", "helm" },
        dependencies = { "folke/snacks.nvim" },
    },
}
