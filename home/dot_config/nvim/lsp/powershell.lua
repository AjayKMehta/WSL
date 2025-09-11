local data_path = os.getenv("HOME")
local bundle_path = data_path .. "/PowerShellEditorServices"

return {
    cmd = function(dispatchers)
        local temp_path = vim.fn.stdpath("cache")

        local command_fmt =
            [[& '%s/PowerShellEditorServices/Start-EditorServices.ps1' -BundledModulesPath '%s' -LogPath '%s/powershell_es.log' -SessionDetailsPath '%s/powershell_es.session.json' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Normal]]
        local command = command_fmt:format(bundle_path, bundle_path, temp_path, temp_path)
        local cmd = { "pwsh", "-NoLogo", "-NoProfile", "-Command", command }

        return vim.lsp.rpc.start(cmd, dispatchers)
    end,
    filetypes = { "ps1", "psm1", "psd1" },
    settings = { powershell = { codeFormatting = { Preset = "OTBS" } } },
    root_markers = { "PSScriptAnalyzerSettings.psd1", ".git" },
}
