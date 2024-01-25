-- https://github.com/PowerShell/PowerShellEditorServices/blob/89ce0867c6b119bef8af83ab21c249e10d0e77a2/docs/guide/getting_started.md
local on_attach = function(client, bufnr)
    require("plugins.configs.lspconfig").on_attach(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

    -- Conflicts
    vim.keymap.set('n', '<Leader>td', vim.lsp.buf.type_definition, bufopts)
end

local home_directory = os.getenv('HOME')
if home_directory == nil then
    home_directory = os.getenv('USERPROFILE')
end

-- The bundle_path is where PowerShell Editor Services was installed
local bundle_path = home_directory .. '/PowerShellEditorServices'

require('lspconfig')['powershell_es'].setup {
    bundle_path = bundle_path,
    on_attach = on_attach,
    capabilities = require("plugins.configs.lspconfig").capabilities,
    settings = {
        powershell = {
            codeFormatting = {
                Preset = 'OTBS',
                AddWhitespaceAroundPipe = true,
                IgnoreOneLineBlock = true,
                PipelineIndentationStyle = "IncreaseIndentationForFirstPipeline",
                TrimWhitespaceAroundPipe = true,
                UseConstantStrings = true,
                UseCorrectCasing = true,
                WhitespaceBetweenParameters = true
            }
        }
    }
}
