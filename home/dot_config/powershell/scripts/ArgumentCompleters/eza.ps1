using namespace System.Management.Automation

# Define the script block for argument completion
$ezaCompletionScriptBlock = {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'eza'
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

    if ($command -ne 'eza')
    { return }
    # Array of option names, their short forms, long forms, and descriptions
    $options = @(
        # Meta options
        ('help', '', '--help', 'Show list of command-line options'),
        ('version', '-v', '--version', 'Show version of eza'),

        # Display Options
        ('oneline', '-1', '--oneline', 'Display one entry per line'),
        ('long', '-l', '--long', 'Display extended file metadata as a table'),
        ('grid', '-G', '--grid', 'Display entries as a grid (default)'),
        ('across', '-x', '--across', 'Sort the grid across, rather than downwards'),
        ('recurse', '-R', '--recurse', 'Recurse into directories'),
        ('tree', '-T', '--tree', 'Recurse into directories as a tree'),
        ('dereference', '-X', '--dereference', 'Dereference symbolic links when displaying information'),
        ('classify', '-F', '--classify', 'Display type indicator by file names (always, auto, never)'),
        ('color', '', '--color', 'When to use terminal colors (always, auto, never)'),
        ('color-scale', '', '--color-scale', "Highlight levels of 'field' distinctly (all, age, size)"),
        ('color-scale-mode', '', '--color-scale-mode', '(fixed, gradient)'),
        ('icons', '', '--icons', 'When to display icons (always, auto, never)'),
        ('no-quotes', '', '--no-quotes', "Don't quote file names with spaces"),
        ('hyperlink', '', '--hyperlink', 'Display entries as hyperlinks'),
        ('absolute', '', '--absolute', 'Display entries with their absolute path (on, follow, off)'),
        ('width', '-w', '--width', 'Set screen width in columns')

        # Filtering and sort options
        ('all', '-a', '--all', "Show hidden and 'dot' files. Use this twice to also show the '.' and '..' directories"),
        ('almost-all', '-A', '--almost-all', 'Equivalent to --all; included for compatibility with `ls -A`'),
        ('list-dirs', '-d', '--list-dirs', "List directories as files; don't list their contents"),
        ('level=DEPTH', '-L', '--level', 'Limit the depth of recursion'),
        ('reverse', '-r', '--reverse', 'Reverse the sort order'),
        ('sort SORT_FIELD', '-s', '--sort', 'Which field to sort by'),
        ('group-directories-first', '', '--group-directories-first', 'List directories before other files'),
        ('only-dirs', '-D', '--only-dirs', 'List only directories'),
        ('only-files', '-f', '--only-files', 'List only files'),
        ('ignore-glob GLOBS', '-I', '--ignore-glob', 'Glob patterns (pipe-separated) of files to ignore'),
        ('git-ignore', '', '--git-ignore', "Ignore files mentioned in '.gitignore'")

        # Long View options
        ('binary', '-b', '--binary', 'List file sizes with binary prefixes'),
        ('bytes', '-B', '--bytes', 'List file sizes in bytes, without any prefixes'),
        ('group', '-g', '--group', "List each file's group"),
        ('smart-group', '', '--smart-group', 'Only show group if it has a different name from owner'),
        ('header', '-h', '--header', 'Add a header row to each column'),
        ('links', '-H', '--links', "List each file's number of hard links"),
        ('inode', '-i', '--inode', "List each file's inode number"),
        ('modified', '-m', '--modified', 'Use the modified timestamp field'),
        ('mounts', '-M', '--mounts', 'Show mount details (Linux and Mac only)'),
        ('numeric', '-n', '--numeric', 'List numeric user and group IDs'),
        ('flags', '-O', '--flags', "List file flags (Mac,'BSD,'and Windows only)"),
        ('blocksize', '-S', '--blocksize', 'Show size of allocated file system blocks'),
        ('time', '-t', '--time', "Which timestamp field to list (modified,'accessed, 'created)"),
        ('accessed', '-u', '--accessed', 'Use the accessed timestamp field'),
        ('created', '-U', '--created', 'Use the created timestamp field'),
        ('changed', '', '--changed', 'Use the changed timestamp field')
        ('time-style', '', '--time-style', 'format for timestamps'),
        ('total-size', '', '--total-size', 'show the size of a directory (unix only)'),
        ('no-permissions', '', '--no-permissions', 'suppress the permissions field'),
        ('octal-permissions', '-o', '--octal-permissions', 'list each file''s permission in octal format'),
        ('no-filesize', '', '--no-filesize', 'suppress the filesize field'),
        ('no-user', '', '--no-user', 'suppress the user field'),
        ('no-time', '', '--no-time', 'suppress the time field'),
        ('stdin', '', '--stdin', 'read file names from stdin, one per line'),
        ('git', '', '--git', 'list each file''s Git status, if tracked or ignored'),
        ('no-git', '', '--no-git', 'suppress Git status (always overrides --git, --git-repos, --git-repos-no-status)'),
        ('git-repos', '', '--git-repos', 'list root of git-tree status')
    )

    # Iterate through the options to find matches
    $completions = foreach ($option in $options) {
        $name, $shortForm, $longForm, $description = $option
        if ($longForm -like "$wordToComplete*") {
            # Generate completions for the matching long form
            [CompletionResult]::new($longForm, $name, [CompletionResultType]::ParameterName, $description)

        } elseif ($shortForm -like "$wordToComplete*") {
            # Generate completions for the matching short form
            [CompletionResult]::new($shortForm, $name, [CompletionResultType]::ParameterName, $description)
        }
    }
    $completions | Sort-Object -Property ListItemText
}

# Register the argument completer for the eza command
Register-ArgumentCompleter -Native -CommandName eza -ScriptBlock $ezaCompletionScriptBlock
