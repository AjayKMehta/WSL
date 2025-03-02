return {
    {
        "someone-stole-my-name/yaml-companion.nvim",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
        },
        keys = {
            {
                "<leader>ys",
                function()
                    require("yaml-companion").open_ui_select()
                end,
                desc = "YAML Schema",
            },
        },
        -- Inspired by https://www.arthurkoziel.com/json-schemas-in-neovim/
        opts = function()
            local ss_schemas = require("schemastore").yaml.schemas()
            return {
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
                            schemas = ss_schemas,
                            trace = { server = "debug" },
                        },
                    },
                },
            }
        end,
        config = function(_, opts)
            local cfg = require("yaml-companion").setup(opts)
            local lsp = require("utils.lsp")
            cfg = vim.tbl_deep_extend("force", cfg, { on_attach = lsp.on_attach, capabilities = lsp.capabilities })
            require("lspconfig")["yamlls"].setup(cfg)
        end,
    },
    {
        "cuducos/yaml.nvim",
        ft = { "yaml" }, -- optional
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
}
