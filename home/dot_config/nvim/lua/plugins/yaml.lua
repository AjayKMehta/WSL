return {
    {
        "someone-stole-my-name/yaml-companion.nvim",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
        },
        -- Inspired by https://www.arthurkoziel.com/json-schemas-in-neovim/
        opts = {
            builtin_matchers = {
                -- Detects Kubernetes files based on content
                kubernetes = { enabled = true },
                cloud_init = { enabled = true },
            },

            -- Additional schemas available in Telescope picker
            schemas = {
                -- schemas below are automatically loaded, but added
                -- them here so that they show up in the statusline
                {
                    name = "GitHub Workflow",
                    uri = "https://json.schemastore.org/github-workflow.json",
                },
            },

            -- Pass any additional options that will be merged in the final LSP config
            lspconfig = {
                flags = {
                    debounce_text_changes = 150,
                },
                settings = {
                    redhat = { telemetry = { enabled = false } },
                    yaml = {
                        validate = true,
                        format = { enable = true },
                        hover = true,
                        completion = true,
                        schemaStore = {
                            enable = false,
                            url = "",
                        },
                        schemaDownload = { enable = true },
                        -- Transitive dependency due to lspconfig
                        schemas = require("schemastore").yaml.schemas(),
                        trace = { server = "debug" },
                    },
                },
            },
        },
        config = function(_, opts)
            -- require("yaml-companion").setup(opts)
            require("lspconfig")["yamlls"].setup(opts)
            require("telescope").load_extension("yaml_schema")
        end,
    },
    {
        "cuducos/yaml.nvim",
        ft = { "yaml" }, -- optional
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim", -- optional
        },
    },
}
