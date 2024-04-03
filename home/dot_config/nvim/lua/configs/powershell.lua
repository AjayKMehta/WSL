-- https://github.com/PowerShell/PowerShellEditorServices/blob/89ce0867c6b119bef8af83ab21c249e10d0e77a2/docs/guide/getting_started.md

local home_directory = os.getenv("HOME")
if home_directory == nil then
    home_directory = os.getenv("USERPROFILE")
end

-- The bundle_path is where PowerShell Editor Services was installed
local bundle_path = home_directory .. "/PowerShellEditorServices"

require("lspconfig")["powershell_es"].setup({
    bundle_path = bundle_path,
    on_attach = require("utils.lsp").on_attach,
    capabilities = require("nvchad.configs.lspconfig").capabilities,
    settings = {
        powershell = {
            codeFormatting = {
                Preset = "OTBS",
                AddWhitespaceAroundPipe = true,
                IgnoreOneLineBlock = true,
                PipelineIndentationStyle = "IncreaseIndentationForFirstPipeline",
                TrimWhitespaceAroundPipe = true,
                UseConstantStrings = true,
                UseCorrectCasing = true,
                WhitespaceBetweenParameters = true,
            },
        },
    },
})
