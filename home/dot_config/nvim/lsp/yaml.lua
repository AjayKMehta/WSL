local ss = require("schemastore")

return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  root_markers = { ".git" },
  settings = {
    -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
    redhat = { telemetry = { enabled = false } },
    yaml = {
      validate = true,
      format = { enable = true },
      hover = true,
      completion = true,
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin (SchemaStore.nvim) and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      schemaDownload = { enable = true },
      schemas = ss.yaml.schemas(),
      trace = { server = "debug" },
    },
  },
}
