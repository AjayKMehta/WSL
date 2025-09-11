local ss = require("schemastore")

return require("schema-companion").setup_client(
    require("schema-companion").adapters.jsonls.setup({
        sources = {
            require("schema-companion").sources.lsp.setup(),
            require("schema-companion").sources.none.setup(),
        },
    }),
    {
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        init_options = {
            provideFormatter = true,
        },
        settings = {
            -- See setting options
            -- https://github.com/microsoft/vscode/tree/main/extensions/json-language-features/server#settings
            json = {
                -- Use JSON Schema Store (SchemaStore.nvim)
                schemas = ss.json.schemas(),
                validate = { enable = true },
            },
        },
    }
)
