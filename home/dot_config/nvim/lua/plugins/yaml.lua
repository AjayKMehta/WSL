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
        config = function(_, opts)
            local sc = require("schema-companion")
            sc.setup(opts)

            require("lspconfig")["yamlls"].setup(sc.setup_client({
                servers = {
                    yamlls = {
                        capabilities = {
                            -- https://github.com/redhat-developer/yaml-language-server/issues/912#issuecomment-1797097638
                            textDocument = {
                                foldingRange = {
                                    dynamicRegistration = false,
                                    lineFoldingOnly = true,
                                },
                            },
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
                                    -- url = "https://www.schemastore.org/api/json/catalog.json",
                                },
                                schemaDownload = { enable = true },
                                schemas = require("schemastore").yaml.schemas(),
                                trace = { server = "debug" },
                            },
                        },
                    },
                },
            }))
        end,
    },
    {
        "cuducos/yaml.nvim",
        ft = { "yaml", "helm" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
}
