$env:DELTA_PAGER = 'less -rFX'
# https://ohmyposh.dev/docs/segments/git
$env:POSH_GIT_ENABLED = $true

$env:XDG_CONFIG_HOME="$HOME/.config"
# https://superuser.com/questions/1262977/open-browser-in-host-system-from-windows-subsystem-for-linux
$env:BROWSER='/mnt/c/Program Files/Firefox/firefox.exe'

# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.4#formatenumerationlimit
$FormatEnumerationLimit = 10

# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.4#psnativecommanduseerroractionpreference
# Native commands with non-zero exit codes issue errors according to $ErrorActionPreference.
$PSNativeCommandUseErrorActionPreference = $true

# Make sure mise and shims are in path
$env:PATH += ':~/.local/bin'
if ($env:TERM_PROGRAM -eq 'vscode') {
    (&mise activate pwsh --shims) | Out-String | Invoke-Expression
}
else {
    (&mise activate pwsh) | Out-String | Invoke-Expression
}

$env:PATH = "~/.yarn/bin:~/.config/yarn/global/node_modules/.bin:$env:PATH"

Import-Module PSudo

#region posh-git

Import-Module 'posh-git' -Force
# https://github.com/JanDeDobbeleer/oh-my-posh/issues/3297#issuecomment-1369845222
$GitPromptSettings.EnableStashStatus = $true

#endregion

#region Map Windows drives

if (!(Get-PSDrive C -ErrorAction Ignore))
{
    New-PSDrive -Name C -PSProvider FileSystem -Root '/mnt/c/' | Out-Null
}

if (!(Get-PSDrive D -ErrorAction Ignore)) {
    New-PSDrive -Name D -PSProvider FileSystem -Root '/mnt/d/' | Out-Null
}

#endregion

$env:COMPLETION_SHELL_PREFERENCE = 'bash'
Import-Module Microsoft.PowerShell.UnixTabCompletion

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# Parameter completion for CLI apps
Get-ChildItem "$PSScriptRoot/scripts/ArgumentCompleters/*.ps1" | ForEach-Object { . $_ }

#region PSReadLine

# Either regular console or one created by PowerShell Extension
# if ($host.Name -in 'ConsoleHost', 'Visual Studio Code Host') {
if (!(Get-Module -Name PSReadLine)) {
    Import-Module PSReadline
}

. "$PSScriptRoot/scripts/PSReadLine/PSReadLineProfile.ps1"
Import-Module -Name CompletionPredictor, DirectoryPredictor
Set-PSReadLineOption -PredictionSource HistoryAndPlugin

function Set-EnvVar {
    $env:POSH = if (-not (Get-Module -Name PSReadLine)) {
        $False
    } else {
            (Get-PSReadLineOption).HistorySaveStyle -ne 'SaveNothing'
    }
}

function Set-PoshPrompt {
    param (
        [ArgumentCompleter({
                param (
                    $CommandName,
                    $ParameterName,
                    $WordToComplete,
                    $CommandAst,
                    $FakeBoundParameters
                )
                Get-ChildItem '/root/.cache/oh-my-posh/themes' -Filter "$WordToComplete*.omp.json" |
                    ForEach-Object {
                        $file = "'$($_.FullName)'"
                        # 9 = ".omp.json".Length
                        $name = $_.Name.Substring(0, $_.Name.Length - 9)
                        [System.Management.Automation.CompletionResult]::new($file, $name, 'ParameterValue', $name)
                    } |
                    Sort-Object -Property ListItemText
            })]
        [Parameter(Position = 0, Mandatory = $true)]
        [String] $Theme
    )

        (@(oh-my-posh init pwsh --config="$Theme" --print) -join "`n") | Invoke-Expression

    New-Alias -Name 'Set-PoshContext' -Value 'Set-EnvVar' -Scope Global -Force
}

if (Test-Path env:\TERM_PROGRAM) {
    Set-PSReadLineOption -HistorySaveStyle SaveNothing
}

Set-PoshPrompt -Theme '/root/.cache/oh-my-posh/themes/night-owl.omp.json'

#endregion


#region fzf

$env:FZF_DEFAULT_COMMAND = 'rg --files . 2> nul'

# Dracula theme
# See https://github.com/junegunn/fzf.vim/issues/358#issuecomment-841665170
$env:FZF_DEFAULT_OPTS = @'
--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
--bind alt-up:preview-page-up,alt-down:preview-page-down,alt-e:preview-top,alt-f:preview-bottom,ctrl-e:half-page-up,ctrl-f:half-page-down --highlight-line
'@

# junegunn/seoul256.vim (light)

#'--color=bg+:#D9D9D9,bg:#E1E1E1,border:#C8C8C8,spinner:#719899,hl:#719872,fg:#616161,header:#719872,info:#727100,pointer:#E12672,marker:#E17899,fg+:#616161,preview-bg:#D9D9D9,prompt:#0099BD,hl+:#719899'

# morhetz/gruvbox

#'--color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'

# tomasr/molokai

#'--color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672'


function ifind() {
    fd * | fzf --prompt 'All> ' --header 'CTRL-D: Directories / CTRL-F: Files' --bind 'ctrl-d:change-prompt(Directories> )+reload(fd --glob  * --type d)' --bind 'ctrl-f:change-prompt(Files> )+reload(fd --glob * --type f)'
}

Import-Module -Name PSFzf
# Ctrl + t to select based on current PSProvider.
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+Shift+r' -PSReadlineChordProvider 'Ctrl+t'
# Press Alt+C to set location based on selected directory.
# fe = fuzzy edit, fh = fuzzy history, fkill = fuzzy kill, fgs = fuzzy git status
# <C-g> is leader for git key bindings.
# <C-g>, <C-f> selects files.
# <C-g>, <C-b> selects branches.
# <C-g>, <C-t> selects tags.
# <C-g>, <C-h> selects hashes (commits).
# <C-g>, <C-s> selects stashes.
$setPsFzfOptionSplat = @{
    EnableAliasFuzzyEdit        = $true
    EnableAliasFuzzyHistory     = $true
    EnableAliasFuzzyKillProcess = $true
    EnableAliasFuzzyGitStatus   = $true
    EnableFd                    = $true
    GitKeyBindings              = $true
}
Set-PsFzfOption @setPsFzfOptionSplat

Set-Alias -Name 'ipfr' -Value Invoke-PsFzfRipgrep

if (!(Get-Alias -Name 'fgb' -ErrorAction Ignore)) {
    Set-Alias -Name 'fgb' -Value Invoke-PsFzfGitBranches
}

if (!(Get-Alias -Name 'fgh' -ErrorAction Ignore)) {
    Set-Alias -Name 'fgh' -Value Invoke-PsFzfGitHashes
}

#endregion

if ($host.Name -eq 'ConsoleHost') {
    # This clobbers Tab shortcut mapping.
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
}

Import-Module 'cd-extras'
Set-CdExtrasOption ColorCompletion
# Paths within $cde.CD_PATH are included in the completion results.
Set-CdExtrasOption CD_PATH -Value '/mnt/d/git'

Import-Module Terminal-Icons, command-not-found

# Docker
$env:DOCKER_BUILDKIT=1
$env:BUILDX_EXPERIMENTAL=1
Import-Module -Name DockerCompletion, DockerComposeCompletion, DockerMachineCompletion

# Nice formatting
Import-Module Posh

# if ($env:TERM_PROGRAM -eq 'vscode') { . "$(code --locate-shell-integration-path pwsh)" }

Import-Module Microsoft.PowerShell.SecretStore, Microsoft.PowerShell.SecretManagement

# Zoxide
. "$PSScriptRoot/scripts/zoxide.ps1"

Invoke-Expression "$(direnv hook pwsh)"
