return {
    cmd = { "taplo", "lsp", "stdio" },
    filetypes = { "toml" },
    root_markers = { ".git", ".toml" },
    settings = {
        -- See all the setting options
        -- https://github.com/tamasfe/taplo/blob/master/editors/vscode/package.json
        evenBetterToml = {
            taplo = {
                bundled = true,
                configFile = {
                    enabled = true,
                },
            },
            semanticTokens = true,
            schema = {
                enabled = true,
                links = true,
                catalogs = {
                    "https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/api/json/catalog.json",
                    "https://taplo.tamasfe.dev/schema_index.json",
                },
                cache = {
                    memoryExpiration = 60,
                    diskExpiration = 600,
                },
            },
            completion = {
                maxKeys = 10, -- default: 5
            },
        },
    },
}
