
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName 'atuin' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'atuin'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-') -or
                $element.Value -eq $wordToComplete) {
                break
        }
        $element.Value
    }) -join ';'

    $completions = @(switch ($command) {
        'atuin' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('-V', '-V ', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('--version', '--version', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('history', 'history', [CompletionResultType]::ParameterValue, 'Manipulate shell history')
            [CompletionResult]::new('import', 'import', [CompletionResultType]::ParameterValue, 'Import shell history from file')
            [CompletionResult]::new('stats', 'stats', [CompletionResultType]::ParameterValue, 'Calculate statistics for your history')
            [CompletionResult]::new('search', 'search', [CompletionResultType]::ParameterValue, 'Interactive history search')
            [CompletionResult]::new('sync', 'sync', [CompletionResultType]::ParameterValue, 'Sync with the configured server')
            [CompletionResult]::new('login', 'login', [CompletionResultType]::ParameterValue, 'Login to the configured server')
            [CompletionResult]::new('logout', 'logout', [CompletionResultType]::ParameterValue, 'Log out')
            [CompletionResult]::new('register', 'register', [CompletionResultType]::ParameterValue, 'Register with the configured server')
            [CompletionResult]::new('key', 'key', [CompletionResultType]::ParameterValue, 'Print the encryption key for transfer to another machine')
            [CompletionResult]::new('status', 'status', [CompletionResultType]::ParameterValue, 'Display the sync status')
            [CompletionResult]::new('account', 'account', [CompletionResultType]::ParameterValue, 'Manage your sync account')
            [CompletionResult]::new('kv', 'kv', [CompletionResultType]::ParameterValue, 'Get or set small key-value pairs')
            [CompletionResult]::new('store', 'store', [CompletionResultType]::ParameterValue, 'Manage the atuin data store')
            [CompletionResult]::new('dotfiles', 'dotfiles', [CompletionResultType]::ParameterValue, 'Manage your dotfiles with Atuin')
            [CompletionResult]::new('scripts', 'scripts', [CompletionResultType]::ParameterValue, 'Manage your scripts with Atuin')
            [CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterValue, 'Print Atuin''s shell init script')
            [CompletionResult]::new('info', 'info', [CompletionResultType]::ParameterValue, 'Information about dotfiles locations and ENV vars')
            [CompletionResult]::new('doctor', 'doctor', [CompletionResultType]::ParameterValue, 'Run the doctor to check for common issues')
            [CompletionResult]::new('wrapped', 'wrapped', [CompletionResultType]::ParameterValue, 'wrapped')
            [CompletionResult]::new('daemon', 'daemon', [CompletionResultType]::ParameterValue, '*Experimental* Start the background daemon')
            [CompletionResult]::new('default-config', 'default-config', [CompletionResultType]::ParameterValue, 'Print the default atuin configuration (config.toml)')
            [CompletionResult]::new('server', 'server', [CompletionResultType]::ParameterValue, 'Start an atuin server')
            [CompletionResult]::new('uuid', 'uuid', [CompletionResultType]::ParameterValue, 'Generate a UUID')
            [CompletionResult]::new('contributors', 'contributors', [CompletionResultType]::ParameterValue, 'contributors')
            [CompletionResult]::new('gen-completions', 'gen-completions', [CompletionResultType]::ParameterValue, 'Generate shell completions')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;history' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('start', 'start', [CompletionResultType]::ParameterValue, 'Begins a new command in the history')
            [CompletionResult]::new('end', 'end', [CompletionResultType]::ParameterValue, 'Finishes a new command in the history (adds time, exit code)')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all items in history')
            [CompletionResult]::new('last', 'last', [CompletionResultType]::ParameterValue, 'Get the last command ran')
            [CompletionResult]::new('init-store', 'init-store', [CompletionResultType]::ParameterValue, 'init-store')
            [CompletionResult]::new('prune', 'prune', [CompletionResultType]::ParameterValue, 'Delete history entries matching the configured exclusion filters')
            [CompletionResult]::new('dedup', 'dedup', [CompletionResultType]::ParameterValue, 'Delete duplicate history entries (that have the same command, cwd and hostname)')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;history;start' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;history;end' {
            [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'e')
            [CompletionResult]::new('--exit', '--exit', [CompletionResultType]::ParameterName, 'exit')
            [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'd')
            [CompletionResult]::new('--duration', '--duration', [CompletionResultType]::ParameterName, 'duration')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;history;list' {
            [CompletionResult]::new('-r', '-r', [CompletionResultType]::ParameterName, 'r')
            [CompletionResult]::new('--reverse', '--reverse', [CompletionResultType]::ParameterName, 'reverse')
            [CompletionResult]::new('--timezone', '--timezone', [CompletionResultType]::ParameterName, 'Display the command time in another timezone other than the configured default')
            [CompletionResult]::new('--tz', '--tz', [CompletionResultType]::ParameterName, 'Display the command time in another timezone other than the configured default')
            [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Available variables: {command}, {directory}, {duration}, {user}, {host}, {exit} and {time}. Example: --format "{time} - [{duration}] - {directory}$\t{command}"')
            [CompletionResult]::new('--format', '--format', [CompletionResultType]::ParameterName, 'Available variables: {command}, {directory}, {duration}, {user}, {host}, {exit} and {time}. Example: --format "{time} - [{duration}] - {directory}$\t{command}"')
            [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'c')
            [CompletionResult]::new('--cwd', '--cwd', [CompletionResultType]::ParameterName, 'cwd')
            [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 's')
            [CompletionResult]::new('--session', '--session', [CompletionResultType]::ParameterName, 'session')
            [CompletionResult]::new('--human', '--human', [CompletionResultType]::ParameterName, 'human')
            [CompletionResult]::new('--cmd-only', '--cmd-only', [CompletionResultType]::ParameterName, 'Show only the text of the command')
            [CompletionResult]::new('--print0', '--print0', [CompletionResultType]::ParameterName, 'Terminate the output with a null, for better multiline support')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            break
        }
        'atuin;history;last' {
            [CompletionResult]::new('--timezone', '--timezone', [CompletionResultType]::ParameterName, 'Display the command time in another timezone other than the configured default')
            [CompletionResult]::new('--tz', '--tz', [CompletionResultType]::ParameterName, 'Display the command time in another timezone other than the configured default')
            [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Available variables: {command}, {directory}, {duration}, {user}, {host} and {time}. Example: --format "{time} - [{duration}] - {directory}$\t{command}"')
            [CompletionResult]::new('--format', '--format', [CompletionResultType]::ParameterName, 'Available variables: {command}, {directory}, {duration}, {user}, {host} and {time}. Example: --format "{time} - [{duration}] - {directory}$\t{command}"')
            [CompletionResult]::new('--human', '--human', [CompletionResultType]::ParameterName, 'human')
            [CompletionResult]::new('--cmd-only', '--cmd-only', [CompletionResultType]::ParameterName, 'Show only the text of the command')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            break
        }
        'atuin;history;init-store' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;history;prune' {
            [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'List matching history lines without performing the actual deletion')
            [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'List matching history lines without performing the actual deletion')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;history;dedup' {
            [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Only delete results added before this date')
            [CompletionResult]::new('--before', '--before', [CompletionResultType]::ParameterName, 'Only delete results added before this date')
            [CompletionResult]::new('--dupkeep', '--dupkeep', [CompletionResultType]::ParameterName, 'How many recent duplicates to keep')
            [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'List matching history lines without performing the actual deletion')
            [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'List matching history lines without performing the actual deletion')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;history;help' {
            [CompletionResult]::new('start', 'start', [CompletionResultType]::ParameterValue, 'Begins a new command in the history')
            [CompletionResult]::new('end', 'end', [CompletionResultType]::ParameterValue, 'Finishes a new command in the history (adds time, exit code)')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all items in history')
            [CompletionResult]::new('last', 'last', [CompletionResultType]::ParameterValue, 'Get the last command ran')
            [CompletionResult]::new('init-store', 'init-store', [CompletionResultType]::ParameterValue, 'init-store')
            [CompletionResult]::new('prune', 'prune', [CompletionResultType]::ParameterValue, 'Delete history entries matching the configured exclusion filters')
            [CompletionResult]::new('dedup', 'dedup', [CompletionResultType]::ParameterValue, 'Delete duplicate history entries (that have the same command, cwd and hostname)')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;history;help;start' {
            break
        }
        'atuin;history;help;end' {
            break
        }
        'atuin;history;help;list' {
            break
        }
        'atuin;history;help;last' {
            break
        }
        'atuin;history;help;init-store' {
            break
        }
        'atuin;history;help;prune' {
            break
        }
        'atuin;history;help;dedup' {
            break
        }
        'atuin;history;help;help' {
            break
        }
        'atuin;import' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('auto', 'auto', [CompletionResultType]::ParameterValue, 'Import history for the current shell')
            [CompletionResult]::new('zsh', 'zsh', [CompletionResultType]::ParameterValue, 'Import history from the zsh history file')
            [CompletionResult]::new('zsh-hist-db', 'zsh-hist-db', [CompletionResultType]::ParameterValue, 'Import history from the zsh history file')
            [CompletionResult]::new('bash', 'bash', [CompletionResultType]::ParameterValue, 'Import history from the bash history file')
            [CompletionResult]::new('replxx', 'replxx', [CompletionResultType]::ParameterValue, 'Import history from the replxx history file')
            [CompletionResult]::new('resh', 'resh', [CompletionResultType]::ParameterValue, 'Import history from the resh history file')
            [CompletionResult]::new('fish', 'fish', [CompletionResultType]::ParameterValue, 'Import history from the fish history file')
            [CompletionResult]::new('nu', 'nu', [CompletionResultType]::ParameterValue, 'Import history from the nu history file')
            [CompletionResult]::new('nu-hist-db', 'nu-hist-db', [CompletionResultType]::ParameterValue, 'Import history from the nu history file')
            [CompletionResult]::new('xonsh', 'xonsh', [CompletionResultType]::ParameterValue, 'Import history from xonsh json files')
            [CompletionResult]::new('xonsh-sqlite', 'xonsh-sqlite', [CompletionResultType]::ParameterValue, 'Import history from xonsh sqlite db')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;import;auto' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;import;zsh' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;import;zsh-hist-db' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;import;bash' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;import;replxx' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;import;resh' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;import;fish' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;import;nu' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;import;nu-hist-db' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;import;xonsh' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;import;xonsh-sqlite' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;import;help' {
            [CompletionResult]::new('auto', 'auto', [CompletionResultType]::ParameterValue, 'Import history for the current shell')
            [CompletionResult]::new('zsh', 'zsh', [CompletionResultType]::ParameterValue, 'Import history from the zsh history file')
            [CompletionResult]::new('zsh-hist-db', 'zsh-hist-db', [CompletionResultType]::ParameterValue, 'Import history from the zsh history file')
            [CompletionResult]::new('bash', 'bash', [CompletionResultType]::ParameterValue, 'Import history from the bash history file')
            [CompletionResult]::new('replxx', 'replxx', [CompletionResultType]::ParameterValue, 'Import history from the replxx history file')
            [CompletionResult]::new('resh', 'resh', [CompletionResultType]::ParameterValue, 'Import history from the resh history file')
            [CompletionResult]::new('fish', 'fish', [CompletionResultType]::ParameterValue, 'Import history from the fish history file')
            [CompletionResult]::new('nu', 'nu', [CompletionResultType]::ParameterValue, 'Import history from the nu history file')
            [CompletionResult]::new('nu-hist-db', 'nu-hist-db', [CompletionResultType]::ParameterValue, 'Import history from the nu history file')
            [CompletionResult]::new('xonsh', 'xonsh', [CompletionResultType]::ParameterValue, 'Import history from xonsh json files')
            [CompletionResult]::new('xonsh-sqlite', 'xonsh-sqlite', [CompletionResultType]::ParameterValue, 'Import history from xonsh sqlite db')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;import;help;auto' {
            break
        }
        'atuin;import;help;zsh' {
            break
        }
        'atuin;import;help;zsh-hist-db' {
            break
        }
        'atuin;import;help;bash' {
            break
        }
        'atuin;import;help;replxx' {
            break
        }
        'atuin;import;help;resh' {
            break
        }
        'atuin;import;help;fish' {
            break
        }
        'atuin;import;help;nu' {
            break
        }
        'atuin;import;help;nu-hist-db' {
            break
        }
        'atuin;import;help;xonsh' {
            break
        }
        'atuin;import;help;xonsh-sqlite' {
            break
        }
        'atuin;import;help;help' {
            break
        }
        'atuin;stats' {
            [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'How many top commands to list')
            [CompletionResult]::new('--count', '--count', [CompletionResultType]::ParameterName, 'How many top commands to list')
            [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'The number of consecutive commands to consider')
            [CompletionResult]::new('--ngram-size', '--ngram-size', [CompletionResultType]::ParameterName, 'The number of consecutive commands to consider')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;search' {
            [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'Filter search result by directory')
            [CompletionResult]::new('--cwd', '--cwd', [CompletionResultType]::ParameterName, 'Filter search result by directory')
            [CompletionResult]::new('--exclude-cwd', '--exclude-cwd', [CompletionResultType]::ParameterName, 'Exclude directory from results')
            [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'Filter search result by exit code')
            [CompletionResult]::new('--exit', '--exit', [CompletionResultType]::ParameterName, 'Filter search result by exit code')
            [CompletionResult]::new('--exclude-exit', '--exclude-exit', [CompletionResultType]::ParameterName, 'Exclude results with this exit code')
            [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Only include results added before this date')
            [CompletionResult]::new('--before', '--before', [CompletionResultType]::ParameterName, 'Only include results added before this date')
            [CompletionResult]::new('--after', '--after', [CompletionResultType]::ParameterName, 'Only include results after this date')
            [CompletionResult]::new('--limit', '--limit', [CompletionResultType]::ParameterName, 'How many entries to return at most')
            [CompletionResult]::new('--offset', '--offset', [CompletionResultType]::ParameterName, 'Offset from the start of the results')
            [CompletionResult]::new('--filter-mode', '--filter-mode', [CompletionResultType]::ParameterName, 'Allow overriding filter mode over config')
            [CompletionResult]::new('--search-mode', '--search-mode', [CompletionResultType]::ParameterName, 'Allow overriding search mode over config')
            [CompletionResult]::new('--keymap-mode', '--keymap-mode', [CompletionResultType]::ParameterName, 'Notify the keymap at the shell''s side')
            [CompletionResult]::new('--timezone', '--timezone', [CompletionResultType]::ParameterName, 'Display the command time in another timezone other than the configured default')
            [CompletionResult]::new('--tz', '--tz', [CompletionResultType]::ParameterName, 'Display the command time in another timezone other than the configured default')
            [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Available variables: {command}, {directory}, {duration}, {user}, {host}, {time}, {exit} and {relativetime}. Example: --format "{time} - [{duration}] - {directory}$\t{command}"')
            [CompletionResult]::new('--format', '--format', [CompletionResultType]::ParameterName, 'Available variables: {command}, {directory}, {duration}, {user}, {host}, {time}, {exit} and {relativetime}. Example: --format "{time} - [{duration}] - {directory}$\t{command}"')
            [CompletionResult]::new('--inline-height', '--inline-height', [CompletionResultType]::ParameterName, 'Set the maximum number of lines Atuin''s interface should take up')
            [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Open interactive search UI')
            [CompletionResult]::new('--interactive', '--interactive', [CompletionResultType]::ParameterName, 'Open interactive search UI')
            [CompletionResult]::new('--shell-up-key-binding', '--shell-up-key-binding', [CompletionResultType]::ParameterName, 'Marker argument used to inform atuin that it was invoked from a shell up-key binding (hidden from help to avoid confusion)')
            [CompletionResult]::new('--human', '--human', [CompletionResultType]::ParameterName, 'Use human-readable formatting for time')
            [CompletionResult]::new('--cmd-only', '--cmd-only', [CompletionResultType]::ParameterName, 'Show only the text of the command')
            [CompletionResult]::new('--print0', '--print0', [CompletionResultType]::ParameterName, 'Terminate the output with a null, for better multiline handling')
            [CompletionResult]::new('--delete', '--delete', [CompletionResultType]::ParameterName, 'Delete anything matching this query. Will not print out the match')
            [CompletionResult]::new('--delete-it-all', '--delete-it-all', [CompletionResultType]::ParameterName, 'Delete EVERYTHING!')
            [CompletionResult]::new('-r', '-r', [CompletionResultType]::ParameterName, 'Reverse the order of results, oldest first')
            [CompletionResult]::new('--reverse', '--reverse', [CompletionResultType]::ParameterName, 'Reverse the order of results, oldest first')
            [CompletionResult]::new('--include-duplicates', '--include-duplicates', [CompletionResultType]::ParameterName, 'Include duplicate commands in the output (non-interactive only)')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            break
        }
        'atuin;sync' {
            [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Force re-download everything')
            [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Force re-download everything')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;login' {
            [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'u')
            [CompletionResult]::new('--username', '--username', [CompletionResultType]::ParameterName, 'username')
            [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'p')
            [CompletionResult]::new('--password', '--password', [CompletionResultType]::ParameterName, 'password')
            [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'The encryption key for your account')
            [CompletionResult]::new('--key', '--key', [CompletionResultType]::ParameterName, 'The encryption key for your account')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;logout' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;register' {
            [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'u')
            [CompletionResult]::new('--username', '--username', [CompletionResultType]::ParameterName, 'username')
            [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'p')
            [CompletionResult]::new('--password', '--password', [CompletionResultType]::ParameterName, 'password')
            [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'e')
            [CompletionResult]::new('--email', '--email', [CompletionResultType]::ParameterName, 'email')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;key' {
            [CompletionResult]::new('--base64', '--base64', [CompletionResultType]::ParameterName, 'Switch to base64 output of the key')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;status' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;account' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('login', 'login', [CompletionResultType]::ParameterValue, 'Login to the configured server')
            [CompletionResult]::new('register', 'register', [CompletionResultType]::ParameterValue, 'Register a new account')
            [CompletionResult]::new('logout', 'logout', [CompletionResultType]::ParameterValue, 'Log out')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'Delete your account, and all synced data')
            [CompletionResult]::new('change-password', 'change-password', [CompletionResultType]::ParameterValue, 'Change your password')
            [CompletionResult]::new('verify', 'verify', [CompletionResultType]::ParameterValue, 'Verify your account')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;account;login' {
            [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'u')
            [CompletionResult]::new('--username', '--username', [CompletionResultType]::ParameterName, 'username')
            [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'p')
            [CompletionResult]::new('--password', '--password', [CompletionResultType]::ParameterName, 'password')
            [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'The encryption key for your account')
            [CompletionResult]::new('--key', '--key', [CompletionResultType]::ParameterName, 'The encryption key for your account')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;account;register' {
            [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'u')
            [CompletionResult]::new('--username', '--username', [CompletionResultType]::ParameterName, 'username')
            [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'p')
            [CompletionResult]::new('--password', '--password', [CompletionResultType]::ParameterName, 'password')
            [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'e')
            [CompletionResult]::new('--email', '--email', [CompletionResultType]::ParameterName, 'email')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;account;logout' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;account;delete' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;account;change-password' {
            [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'c')
            [CompletionResult]::new('--current-password', '--current-password', [CompletionResultType]::ParameterName, 'current-password')
            [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'n')
            [CompletionResult]::new('--new-password', '--new-password', [CompletionResultType]::ParameterName, 'new-password')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;account;verify' {
            [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 't')
            [CompletionResult]::new('--token', '--token', [CompletionResultType]::ParameterName, 'token')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;account;help' {
            [CompletionResult]::new('login', 'login', [CompletionResultType]::ParameterValue, 'Login to the configured server')
            [CompletionResult]::new('register', 'register', [CompletionResultType]::ParameterValue, 'Register a new account')
            [CompletionResult]::new('logout', 'logout', [CompletionResultType]::ParameterValue, 'Log out')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'Delete your account, and all synced data')
            [CompletionResult]::new('change-password', 'change-password', [CompletionResultType]::ParameterValue, 'Change your password')
            [CompletionResult]::new('verify', 'verify', [CompletionResultType]::ParameterValue, 'Verify your account')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;account;help;login' {
            break
        }
        'atuin;account;help;register' {
            break
        }
        'atuin;account;help;logout' {
            break
        }
        'atuin;account;help;delete' {
            break
        }
        'atuin;account;help;change-password' {
            break
        }
        'atuin;account;help;verify' {
            break
        }
        'atuin;account;help;help' {
            break
        }
        'atuin;kv' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set a key-value pair')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'Delete one or more key-value pairs')
            [CompletionResult]::new('get', 'get', [CompletionResultType]::ParameterValue, 'Retrieve a saved value')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all keys in a namespace, or in all namespaces')
            [CompletionResult]::new('rebuild', 'rebuild', [CompletionResultType]::ParameterValue, 'Rebuild the KV store')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;kv;set' {
            [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'Key to set')
            [CompletionResult]::new('--key', '--key', [CompletionResultType]::ParameterName, 'Key to set')
            [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Namespace for the key-value pair')
            [CompletionResult]::new('--namespace', '--namespace', [CompletionResultType]::ParameterName, 'Namespace for the key-value pair')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;kv;delete' {
            [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Namespace for the key-value pair')
            [CompletionResult]::new('--namespace', '--namespace', [CompletionResultType]::ParameterName, 'Namespace for the key-value pair')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;kv;get' {
            [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Namespace for the key-value pair')
            [CompletionResult]::new('--namespace', '--namespace', [CompletionResultType]::ParameterName, 'Namespace for the key-value pair')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;kv;list' {
            [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Namespace to list keys from')
            [CompletionResult]::new('--namespace', '--namespace', [CompletionResultType]::ParameterName, 'Namespace to list keys from')
            [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'List all keys in all namespaces')
            [CompletionResult]::new('--all-namespaces', '--all-namespaces', [CompletionResultType]::ParameterName, 'List all keys in all namespaces')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;kv;rebuild' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;kv;help' {
            [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set a key-value pair')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'Delete one or more key-value pairs')
            [CompletionResult]::new('get', 'get', [CompletionResultType]::ParameterValue, 'Retrieve a saved value')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all keys in a namespace, or in all namespaces')
            [CompletionResult]::new('rebuild', 'rebuild', [CompletionResultType]::ParameterValue, 'Rebuild the KV store')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;kv;help;set' {
            break
        }
        'atuin;kv;help;delete' {
            break
        }
        'atuin;kv;help;get' {
            break
        }
        'atuin;kv;help;list' {
            break
        }
        'atuin;kv;help;rebuild' {
            break
        }
        'atuin;kv;help;help' {
            break
        }
        'atuin;store' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('status', 'status', [CompletionResultType]::ParameterValue, 'Print the current status of the record store')
            [CompletionResult]::new('rebuild', 'rebuild', [CompletionResultType]::ParameterValue, 'Rebuild a store (eg atuin store rebuild history)')
            [CompletionResult]::new('rekey', 'rekey', [CompletionResultType]::ParameterValue, 'Re-encrypt the store with a new key (potential for data loss!)')
            [CompletionResult]::new('purge', 'purge', [CompletionResultType]::ParameterValue, 'Delete all records in the store that cannot be decrypted with the current key')
            [CompletionResult]::new('verify', 'verify', [CompletionResultType]::ParameterValue, 'Verify that all records in the store can be decrypted with the current key')
            [CompletionResult]::new('push', 'push', [CompletionResultType]::ParameterValue, 'Push all records to the remote sync server (one way sync)')
            [CompletionResult]::new('pull', 'pull', [CompletionResultType]::ParameterValue, 'Pull records from the remote sync server (one way sync)')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;store;status' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;store;rebuild' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;store;rekey' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;store;purge' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;store;verify' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;store;push' {
            [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'The tag to push (eg, ''history''). Defaults to all tags')
            [CompletionResult]::new('--tag', '--tag', [CompletionResultType]::ParameterName, 'The tag to push (eg, ''history''). Defaults to all tags')
            [CompletionResult]::new('--host', '--host', [CompletionResultType]::ParameterName, 'The host to push, in the form of a UUID host ID. Defaults to the current host')
            [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Force push records This will override both host and tag, to be all hosts and all tags. First clear the remote store, then upload all of the local store')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;store;pull' {
            [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'The tag to push (eg, ''history''). Defaults to all tags')
            [CompletionResult]::new('--tag', '--tag', [CompletionResultType]::ParameterName, 'The tag to push (eg, ''history''). Defaults to all tags')
            [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Force push records This will first wipe the local store, and then download all records from the remote')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;store;help' {
            [CompletionResult]::new('status', 'status', [CompletionResultType]::ParameterValue, 'Print the current status of the record store')
            [CompletionResult]::new('rebuild', 'rebuild', [CompletionResultType]::ParameterValue, 'Rebuild a store (eg atuin store rebuild history)')
            [CompletionResult]::new('rekey', 'rekey', [CompletionResultType]::ParameterValue, 'Re-encrypt the store with a new key (potential for data loss!)')
            [CompletionResult]::new('purge', 'purge', [CompletionResultType]::ParameterValue, 'Delete all records in the store that cannot be decrypted with the current key')
            [CompletionResult]::new('verify', 'verify', [CompletionResultType]::ParameterValue, 'Verify that all records in the store can be decrypted with the current key')
            [CompletionResult]::new('push', 'push', [CompletionResultType]::ParameterValue, 'Push all records to the remote sync server (one way sync)')
            [CompletionResult]::new('pull', 'pull', [CompletionResultType]::ParameterValue, 'Pull records from the remote sync server (one way sync)')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;store;help;status' {
            break
        }
        'atuin;store;help;rebuild' {
            break
        }
        'atuin;store;help;rekey' {
            break
        }
        'atuin;store;help;purge' {
            break
        }
        'atuin;store;help;verify' {
            break
        }
        'atuin;store;help;push' {
            break
        }
        'atuin;store;help;pull' {
            break
        }
        'atuin;store;help;help' {
            break
        }
        'atuin;dotfiles' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('alias', 'alias', [CompletionResultType]::ParameterValue, 'Manage shell aliases with Atuin')
            [CompletionResult]::new('var', 'var', [CompletionResultType]::ParameterValue, 'Manage shell and environment variables with Atuin')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;dotfiles;alias' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set an alias')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'Delete an alias')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all aliases')
            [CompletionResult]::new('clear', 'clear', [CompletionResultType]::ParameterValue, 'Delete all aliases')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;dotfiles;alias;set' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;dotfiles;alias;delete' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;dotfiles;alias;list' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;dotfiles;alias;clear' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;dotfiles;alias;help' {
            [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set an alias')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'Delete an alias')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all aliases')
            [CompletionResult]::new('clear', 'clear', [CompletionResultType]::ParameterValue, 'Delete all aliases')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;dotfiles;alias;help;set' {
            break
        }
        'atuin;dotfiles;alias;help;delete' {
            break
        }
        'atuin;dotfiles;alias;help;list' {
            break
        }
        'atuin;dotfiles;alias;help;clear' {
            break
        }
        'atuin;dotfiles;alias;help;help' {
            break
        }
        'atuin;dotfiles;var' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set a variable')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'Delete a variable')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all variables')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;dotfiles;var;set' {
            [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'n')
            [CompletionResult]::new('--no-export', '--no-export', [CompletionResultType]::ParameterName, 'no-export')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;dotfiles;var;delete' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;dotfiles;var;list' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;dotfiles;var;help' {
            [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set a variable')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'Delete a variable')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all variables')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;dotfiles;var;help;set' {
            break
        }
        'atuin;dotfiles;var;help;delete' {
            break
        }
        'atuin;dotfiles;var;help;list' {
            break
        }
        'atuin;dotfiles;var;help;help' {
            break
        }
        'atuin;dotfiles;help' {
            [CompletionResult]::new('alias', 'alias', [CompletionResultType]::ParameterValue, 'Manage shell aliases with Atuin')
            [CompletionResult]::new('var', 'var', [CompletionResultType]::ParameterValue, 'Manage shell and environment variables with Atuin')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;dotfiles;help;alias' {
            [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set an alias')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'Delete an alias')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all aliases')
            [CompletionResult]::new('clear', 'clear', [CompletionResultType]::ParameterValue, 'Delete all aliases')
            break
        }
        'atuin;dotfiles;help;alias;set' {
            break
        }
        'atuin;dotfiles;help;alias;delete' {
            break
        }
        'atuin;dotfiles;help;alias;list' {
            break
        }
        'atuin;dotfiles;help;alias;clear' {
            break
        }
        'atuin;dotfiles;help;var' {
            [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set a variable')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'Delete a variable')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all variables')
            break
        }
        'atuin;dotfiles;help;var;set' {
            break
        }
        'atuin;dotfiles;help;var;delete' {
            break
        }
        'atuin;dotfiles;help;var;list' {
            break
        }
        'atuin;dotfiles;help;help' {
            break
        }
        'atuin;scripts' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('new', 'new', [CompletionResultType]::ParameterValue, 'new')
            [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterValue, 'run')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'list')
            [CompletionResult]::new('get', 'get', [CompletionResultType]::ParameterValue, 'get')
            [CompletionResult]::new('edit', 'edit', [CompletionResultType]::ParameterValue, 'edit')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'delete')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;scripts;new' {
            [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'd')
            [CompletionResult]::new('--description', '--description', [CompletionResultType]::ParameterName, 'description')
            [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 't')
            [CompletionResult]::new('--tags', '--tags', [CompletionResultType]::ParameterName, 'tags')
            [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 's')
            [CompletionResult]::new('--shebang', '--shebang', [CompletionResultType]::ParameterName, 'shebang')
            [CompletionResult]::new('--script', '--script', [CompletionResultType]::ParameterName, 'script')
            [CompletionResult]::new('--last', '--last', [CompletionResultType]::ParameterName, 'Use the last command as the script content Optionally specify a number to use the last N commands')
            [CompletionResult]::new('--no-edit', '--no-edit', [CompletionResultType]::ParameterName, 'Skip opening editor when using --last')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;scripts;run' {
            [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Specify template variables in the format KEY=VALUE Example: -v name=John -v greeting="Hello there"')
            [CompletionResult]::new('--var', '--var', [CompletionResultType]::ParameterName, 'Specify template variables in the format KEY=VALUE Example: -v name=John -v greeting="Hello there"')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;scripts;list' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;scripts;get' {
            [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Display only the executable script with shebang')
            [CompletionResult]::new('--script', '--script', [CompletionResultType]::ParameterName, 'Display only the executable script with shebang')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;scripts;edit' {
            [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'd')
            [CompletionResult]::new('--description', '--description', [CompletionResultType]::ParameterName, 'description')
            [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Replace all existing tags with these new tags')
            [CompletionResult]::new('--tags', '--tags', [CompletionResultType]::ParameterName, 'Replace all existing tags with these new tags')
            [CompletionResult]::new('--rename', '--rename', [CompletionResultType]::ParameterName, 'Rename the script')
            [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 's')
            [CompletionResult]::new('--shebang', '--shebang', [CompletionResultType]::ParameterName, 'shebang')
            [CompletionResult]::new('--script', '--script', [CompletionResultType]::ParameterName, 'script')
            [CompletionResult]::new('--no-tags', '--no-tags', [CompletionResultType]::ParameterName, 'Remove all tags from the script')
            [CompletionResult]::new('--no-edit', '--no-edit', [CompletionResultType]::ParameterName, 'Skip opening editor')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;scripts;delete' {
            [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'f')
            [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'force')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;scripts;help' {
            [CompletionResult]::new('new', 'new', [CompletionResultType]::ParameterValue, 'new')
            [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterValue, 'run')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'list')
            [CompletionResult]::new('get', 'get', [CompletionResultType]::ParameterValue, 'get')
            [CompletionResult]::new('edit', 'edit', [CompletionResultType]::ParameterValue, 'edit')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'delete')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;scripts;help;new' {
            break
        }
        'atuin;scripts;help;run' {
            break
        }
        'atuin;scripts;help;list' {
            break
        }
        'atuin;scripts;help;get' {
            break
        }
        'atuin;scripts;help;edit' {
            break
        }
        'atuin;scripts;help;delete' {
            break
        }
        'atuin;scripts;help;help' {
            break
        }
        'atuin;init' {
            [CompletionResult]::new('--disable-ctrl-r', '--disable-ctrl-r', [CompletionResultType]::ParameterName, 'Disable the binding of CTRL-R to atuin')
            [CompletionResult]::new('--disable-up-arrow', '--disable-up-arrow', [CompletionResultType]::ParameterName, 'Disable the binding of the Up Arrow key to atuin')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            break
        }
        'atuin;info' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;doctor' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;wrapped' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;daemon' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;default-config' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;server' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('start', 'start', [CompletionResultType]::ParameterValue, 'Start the server')
            [CompletionResult]::new('default-config', 'default-config', [CompletionResultType]::ParameterValue, 'Print server example configuration')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;server;start' {
            [CompletionResult]::new('--host', '--host', [CompletionResultType]::ParameterName, 'The host address to bind')
            [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'The port to bind')
            [CompletionResult]::new('--port', '--port', [CompletionResultType]::ParameterName, 'The port to bind')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;server;default-config' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;server;help' {
            [CompletionResult]::new('start', 'start', [CompletionResultType]::ParameterValue, 'Start the server')
            [CompletionResult]::new('default-config', 'default-config', [CompletionResultType]::ParameterValue, 'Print server example configuration')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;server;help;start' {
            break
        }
        'atuin;server;help;default-config' {
            break
        }
        'atuin;server;help;help' {
            break
        }
        'atuin;uuid' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;contributors' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;gen-completions' {
            [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Set the shell for generating completions')
            [CompletionResult]::new('--shell', '--shell', [CompletionResultType]::ParameterName, 'Set the shell for generating completions')
            [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Set the output directory')
            [CompletionResult]::new('--out-dir', '--out-dir', [CompletionResultType]::ParameterName, 'Set the output directory')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'atuin;help' {
            [CompletionResult]::new('history', 'history', [CompletionResultType]::ParameterValue, 'Manipulate shell history')
            [CompletionResult]::new('import', 'import', [CompletionResultType]::ParameterValue, 'Import shell history from file')
            [CompletionResult]::new('stats', 'stats', [CompletionResultType]::ParameterValue, 'Calculate statistics for your history')
            [CompletionResult]::new('search', 'search', [CompletionResultType]::ParameterValue, 'Interactive history search')
            [CompletionResult]::new('sync', 'sync', [CompletionResultType]::ParameterValue, 'Sync with the configured server')
            [CompletionResult]::new('login', 'login', [CompletionResultType]::ParameterValue, 'Login to the configured server')
            [CompletionResult]::new('logout', 'logout', [CompletionResultType]::ParameterValue, 'Log out')
            [CompletionResult]::new('register', 'register', [CompletionResultType]::ParameterValue, 'Register with the configured server')
            [CompletionResult]::new('key', 'key', [CompletionResultType]::ParameterValue, 'Print the encryption key for transfer to another machine')
            [CompletionResult]::new('status', 'status', [CompletionResultType]::ParameterValue, 'Display the sync status')
            [CompletionResult]::new('account', 'account', [CompletionResultType]::ParameterValue, 'Manage your sync account')
            [CompletionResult]::new('kv', 'kv', [CompletionResultType]::ParameterValue, 'Get or set small key-value pairs')
            [CompletionResult]::new('store', 'store', [CompletionResultType]::ParameterValue, 'Manage the atuin data store')
            [CompletionResult]::new('dotfiles', 'dotfiles', [CompletionResultType]::ParameterValue, 'Manage your dotfiles with Atuin')
            [CompletionResult]::new('scripts', 'scripts', [CompletionResultType]::ParameterValue, 'Manage your scripts with Atuin')
            [CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterValue, 'Print Atuin''s shell init script')
            [CompletionResult]::new('info', 'info', [CompletionResultType]::ParameterValue, 'Information about dotfiles locations and ENV vars')
            [CompletionResult]::new('doctor', 'doctor', [CompletionResultType]::ParameterValue, 'Run the doctor to check for common issues')
            [CompletionResult]::new('wrapped', 'wrapped', [CompletionResultType]::ParameterValue, 'wrapped')
            [CompletionResult]::new('daemon', 'daemon', [CompletionResultType]::ParameterValue, '*Experimental* Start the background daemon')
            [CompletionResult]::new('default-config', 'default-config', [CompletionResultType]::ParameterValue, 'Print the default atuin configuration (config.toml)')
            [CompletionResult]::new('server', 'server', [CompletionResultType]::ParameterValue, 'Start an atuin server')
            [CompletionResult]::new('uuid', 'uuid', [CompletionResultType]::ParameterValue, 'Generate a UUID')
            [CompletionResult]::new('contributors', 'contributors', [CompletionResultType]::ParameterValue, 'contributors')
            [CompletionResult]::new('gen-completions', 'gen-completions', [CompletionResultType]::ParameterValue, 'Generate shell completions')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'atuin;help;history' {
            [CompletionResult]::new('start', 'start', [CompletionResultType]::ParameterValue, 'Begins a new command in the history')
            [CompletionResult]::new('end', 'end', [CompletionResultType]::ParameterValue, 'Finishes a new command in the history (adds time, exit code)')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all items in history')
            [CompletionResult]::new('last', 'last', [CompletionResultType]::ParameterValue, 'Get the last command ran')
            [CompletionResult]::new('init-store', 'init-store', [CompletionResultType]::ParameterValue, 'init-store')
            [CompletionResult]::new('prune', 'prune', [CompletionResultType]::ParameterValue, 'Delete history entries matching the configured exclusion filters')
            [CompletionResult]::new('dedup', 'dedup', [CompletionResultType]::ParameterValue, 'Delete duplicate history entries (that have the same command, cwd and hostname)')
            break
        }
        'atuin;help;history;start' {
            break
        }
        'atuin;help;history;end' {
            break
        }
        'atuin;help;history;list' {
            break
        }
        'atuin;help;history;last' {
            break
        }
        'atuin;help;history;init-store' {
            break
        }
        'atuin;help;history;prune' {
            break
        }
        'atuin;help;history;dedup' {
            break
        }
        'atuin;help;import' {
            [CompletionResult]::new('auto', 'auto', [CompletionResultType]::ParameterValue, 'Import history for the current shell')
            [CompletionResult]::new('zsh', 'zsh', [CompletionResultType]::ParameterValue, 'Import history from the zsh history file')
            [CompletionResult]::new('zsh-hist-db', 'zsh-hist-db', [CompletionResultType]::ParameterValue, 'Import history from the zsh history file')
            [CompletionResult]::new('bash', 'bash', [CompletionResultType]::ParameterValue, 'Import history from the bash history file')
            [CompletionResult]::new('replxx', 'replxx', [CompletionResultType]::ParameterValue, 'Import history from the replxx history file')
            [CompletionResult]::new('resh', 'resh', [CompletionResultType]::ParameterValue, 'Import history from the resh history file')
            [CompletionResult]::new('fish', 'fish', [CompletionResultType]::ParameterValue, 'Import history from the fish history file')
            [CompletionResult]::new('nu', 'nu', [CompletionResultType]::ParameterValue, 'Import history from the nu history file')
            [CompletionResult]::new('nu-hist-db', 'nu-hist-db', [CompletionResultType]::ParameterValue, 'Import history from the nu history file')
            [CompletionResult]::new('xonsh', 'xonsh', [CompletionResultType]::ParameterValue, 'Import history from xonsh json files')
            [CompletionResult]::new('xonsh-sqlite', 'xonsh-sqlite', [CompletionResultType]::ParameterValue, 'Import history from xonsh sqlite db')
            break
        }
        'atuin;help;import;auto' {
            break
        }
        'atuin;help;import;zsh' {
            break
        }
        'atuin;help;import;zsh-hist-db' {
            break
        }
        'atuin;help;import;bash' {
            break
        }
        'atuin;help;import;replxx' {
            break
        }
        'atuin;help;import;resh' {
            break
        }
        'atuin;help;import;fish' {
            break
        }
        'atuin;help;import;nu' {
            break
        }
        'atuin;help;import;nu-hist-db' {
            break
        }
        'atuin;help;import;xonsh' {
            break
        }
        'atuin;help;import;xonsh-sqlite' {
            break
        }
        'atuin;help;stats' {
            break
        }
        'atuin;help;search' {
            break
        }
        'atuin;help;sync' {
            break
        }
        'atuin;help;login' {
            break
        }
        'atuin;help;logout' {
            break
        }
        'atuin;help;register' {
            break
        }
        'atuin;help;key' {
            break
        }
        'atuin;help;status' {
            break
        }
        'atuin;help;account' {
            [CompletionResult]::new('login', 'login', [CompletionResultType]::ParameterValue, 'Login to the configured server')
            [CompletionResult]::new('register', 'register', [CompletionResultType]::ParameterValue, 'Register a new account')
            [CompletionResult]::new('logout', 'logout', [CompletionResultType]::ParameterValue, 'Log out')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'Delete your account, and all synced data')
            [CompletionResult]::new('change-password', 'change-password', [CompletionResultType]::ParameterValue, 'Change your password')
            [CompletionResult]::new('verify', 'verify', [CompletionResultType]::ParameterValue, 'Verify your account')
            break
        }
        'atuin;help;account;login' {
            break
        }
        'atuin;help;account;register' {
            break
        }
        'atuin;help;account;logout' {
            break
        }
        'atuin;help;account;delete' {
            break
        }
        'atuin;help;account;change-password' {
            break
        }
        'atuin;help;account;verify' {
            break
        }
        'atuin;help;kv' {
            [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set a key-value pair')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'Delete one or more key-value pairs')
            [CompletionResult]::new('get', 'get', [CompletionResultType]::ParameterValue, 'Retrieve a saved value')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all keys in a namespace, or in all namespaces')
            [CompletionResult]::new('rebuild', 'rebuild', [CompletionResultType]::ParameterValue, 'Rebuild the KV store')
            break
        }
        'atuin;help;kv;set' {
            break
        }
        'atuin;help;kv;delete' {
            break
        }
        'atuin;help;kv;get' {
            break
        }
        'atuin;help;kv;list' {
            break
        }
        'atuin;help;kv;rebuild' {
            break
        }
        'atuin;help;store' {
            [CompletionResult]::new('status', 'status', [CompletionResultType]::ParameterValue, 'Print the current status of the record store')
            [CompletionResult]::new('rebuild', 'rebuild', [CompletionResultType]::ParameterValue, 'Rebuild a store (eg atuin store rebuild history)')
            [CompletionResult]::new('rekey', 'rekey', [CompletionResultType]::ParameterValue, 'Re-encrypt the store with a new key (potential for data loss!)')
            [CompletionResult]::new('purge', 'purge', [CompletionResultType]::ParameterValue, 'Delete all records in the store that cannot be decrypted with the current key')
            [CompletionResult]::new('verify', 'verify', [CompletionResultType]::ParameterValue, 'Verify that all records in the store can be decrypted with the current key')
            [CompletionResult]::new('push', 'push', [CompletionResultType]::ParameterValue, 'Push all records to the remote sync server (one way sync)')
            [CompletionResult]::new('pull', 'pull', [CompletionResultType]::ParameterValue, 'Pull records from the remote sync server (one way sync)')
            break
        }
        'atuin;help;store;status' {
            break
        }
        'atuin;help;store;rebuild' {
            break
        }
        'atuin;help;store;rekey' {
            break
        }
        'atuin;help;store;purge' {
            break
        }
        'atuin;help;store;verify' {
            break
        }
        'atuin;help;store;push' {
            break
        }
        'atuin;help;store;pull' {
            break
        }
        'atuin;help;dotfiles' {
            [CompletionResult]::new('alias', 'alias', [CompletionResultType]::ParameterValue, 'Manage shell aliases with Atuin')
            [CompletionResult]::new('var', 'var', [CompletionResultType]::ParameterValue, 'Manage shell and environment variables with Atuin')
            break
        }
        'atuin;help;dotfiles;alias' {
            [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set an alias')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'Delete an alias')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all aliases')
            [CompletionResult]::new('clear', 'clear', [CompletionResultType]::ParameterValue, 'Delete all aliases')
            break
        }
        'atuin;help;dotfiles;alias;set' {
            break
        }
        'atuin;help;dotfiles;alias;delete' {
            break
        }
        'atuin;help;dotfiles;alias;list' {
            break
        }
        'atuin;help;dotfiles;alias;clear' {
            break
        }
        'atuin;help;dotfiles;var' {
            [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterValue, 'Set a variable')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'Delete a variable')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all variables')
            break
        }
        'atuin;help;dotfiles;var;set' {
            break
        }
        'atuin;help;dotfiles;var;delete' {
            break
        }
        'atuin;help;dotfiles;var;list' {
            break
        }
        'atuin;help;scripts' {
            [CompletionResult]::new('new', 'new', [CompletionResultType]::ParameterValue, 'new')
            [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterValue, 'run')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'list')
            [CompletionResult]::new('get', 'get', [CompletionResultType]::ParameterValue, 'get')
            [CompletionResult]::new('edit', 'edit', [CompletionResultType]::ParameterValue, 'edit')
            [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterValue, 'delete')
            break
        }
        'atuin;help;scripts;new' {
            break
        }
        'atuin;help;scripts;run' {
            break
        }
        'atuin;help;scripts;list' {
            break
        }
        'atuin;help;scripts;get' {
            break
        }
        'atuin;help;scripts;edit' {
            break
        }
        'atuin;help;scripts;delete' {
            break
        }
        'atuin;help;init' {
            break
        }
        'atuin;help;info' {
            break
        }
        'atuin;help;doctor' {
            break
        }
        'atuin;help;wrapped' {
            break
        }
        'atuin;help;daemon' {
            break
        }
        'atuin;help;default-config' {
            break
        }
        'atuin;help;server' {
            [CompletionResult]::new('start', 'start', [CompletionResultType]::ParameterValue, 'Start the server')
            [CompletionResult]::new('default-config', 'default-config', [CompletionResultType]::ParameterValue, 'Print server example configuration')
            break
        }
        'atuin;help;server;start' {
            break
        }
        'atuin;help;server;default-config' {
            break
        }
        'atuin;help;uuid' {
            break
        }
        'atuin;help;contributors' {
            break
        }
        'atuin;help;gen-completions' {
            break
        }
        'atuin;help;help' {
            break
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
