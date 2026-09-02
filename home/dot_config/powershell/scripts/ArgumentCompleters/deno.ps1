Register-ArgumentCompleter -Native -CommandName 'deno' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    $commandElements = $commandAst.CommandElements
    $command = @(
        'deno'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-') -or
                $element.Value -eq $wordToComplete) {
                break
            }
            $element.Value
        }
    ) -join ';'

    $completions = @(switch ($command) {
        'deno' {
            [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterValue, 'Run a JavaScript or TypeScript program, or a task')
            [CompletionResult]::new('watch', 'watch', [CompletionResultType]::ParameterValue, 'Run a JavaScript or TypeScript program, watching for file changes and hot-replacing modules')
            [CompletionResult]::new('serve', 'serve', [CompletionResultType]::ParameterValue, 'Run a server')
            [CompletionResult]::new('eval', 'eval', [CompletionResultType]::ParameterValue, 'Evaluate a script from the command line')
            [CompletionResult]::new('fmt', 'fmt', [CompletionResultType]::ParameterValue, 'Format source files')
            [CompletionResult]::new('lint', 'lint', [CompletionResultType]::ParameterValue, 'Lint source files')
            [CompletionResult]::new('test', 'test', [CompletionResultType]::ParameterValue, 'Run tests')
            [CompletionResult]::new('upgrade', 'upgrade', [CompletionResultType]::ParameterValue, 'Upgrade deno executable to given version')
            [CompletionResult]::new('cache', 'cache', [CompletionResultType]::ParameterValue, 'Cache the dependencies')
            [CompletionResult]::new('check', 'check', [CompletionResultType]::ParameterValue, 'Type-check the dependencies')
            [CompletionResult]::new('info', 'info', [CompletionResultType]::ParameterValue, 'Show info about cache or info related to source file')
            [CompletionResult]::new('doc', 'doc', [CompletionResultType]::ParameterValue, 'Generate and show documentation for a module or built-ins')
            [CompletionResult]::new('task', 'task', [CompletionResultType]::ParameterValue, 'Run a task defined in the configuration file')
            [CompletionResult]::new('bench', 'bench', [CompletionResultType]::ParameterValue, 'Run benchmarks')
            [CompletionResult]::new('compile', 'compile', [CompletionResultType]::ParameterValue, 'Compile the script into a self contained executable')
            [CompletionResult]::new('coverage', 'coverage', [CompletionResultType]::ParameterValue, 'Print coverage reports')
            [CompletionResult]::new('repl', 'repl', [CompletionResultType]::ParameterValue, 'Start an interactive Read-Eval-Print Loop (REPL) for Deno')
            [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterValue, 'Installs dependencies either in the local project or globally to a bin directory')
            [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstalls a dependency or an executable script in the installation root''s bin directory')
            [CompletionResult]::new('types', 'types', [CompletionResultType]::ParameterValue, 'Print runtime TypeScript declarations')
            [CompletionResult]::new('completions', 'completions', [CompletionResultType]::ParameterValue, 'Generate shell completions')
            [CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterValue, 'Initialize a new project')
            [CompletionResult]::new('create', 'create', [CompletionResultType]::ParameterValue, 'Create a project from a template')
            [CompletionResult]::new('jupyter', 'jupyter', [CompletionResultType]::ParameterValue, 'Deno kernel for Jupyter notebooks')
            [CompletionResult]::new('publish', 'publish', [CompletionResultType]::ParameterValue, 'Publish the current working directory''s package or workspace')
            [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterValue, 'Add dependencies')
            [CompletionResult]::new('remove', 'remove', [CompletionResultType]::ParameterValue, 'Remove dependencies')
            [CompletionResult]::new('outdated', 'outdated', [CompletionResultType]::ParameterValue, 'Find outdated dependencies')
            [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Update outdated dependencies')
            [CompletionResult]::new('deploy', 'deploy', [CompletionResultType]::ParameterValue, 'Deploy to Deno Deploy')
            [CompletionResult]::new('sandbox', 'sandbox', [CompletionResultType]::ParameterValue, 'Run in sandbox mode')
            [CompletionResult]::new('clean', 'clean', [CompletionResultType]::ParameterValue, 'Remove the cache directory')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List the dependencies declared in deno.json / package.json')
            [CompletionResult]::new('link', 'link', [CompletionResultType]::ParameterValue, 'Link a local JSR package into the current project for development')
            [CompletionResult]::new('unlink', 'unlink', [CompletionResultType]::ParameterValue, 'Remove a linked local package from the current project')
            [CompletionResult]::new('approve-scripts', 'approve-scripts', [CompletionResultType]::ParameterValue, 'Approve npm lifecycle scripts')
            [CompletionResult]::new('lsp', 'lsp', [CompletionResultType]::ParameterValue, 'Start the language server')
            [CompletionResult]::new('vendor', 'vendor', [CompletionResultType]::ParameterValue, '`deno vendor` was removed in Deno 2.

See the Deno 1.x to 2.x Migration Guide for migration instructions: https://docs.deno.com/runtime/manual/advanced/migrate_deprecations')
            [CompletionResult]::new('bundle', 'bundle', [CompletionResultType]::ParameterValue, 'Output a single JavaScript file with all dependencies')
            [CompletionResult]::new('audit', 'audit', [CompletionResultType]::ParameterValue, 'Audit currently installed dependencies')
            [CompletionResult]::new('why', 'why', [CompletionResultType]::ParameterValue, 'Show why a package is installed')
            [CompletionResult]::new('transpile', 'transpile', [CompletionResultType]::ParameterValue, 'Transpile TypeScript/JSX/TSX files to JavaScript')
            [CompletionResult]::new('bump-version', 'bump-version', [CompletionResultType]::ParameterValue, 'Update version in the configuration file')
            [CompletionResult]::new('ci', 'ci', [CompletionResultType]::ParameterValue, 'Install dependencies from a lockfile in a frozen state')
            [CompletionResult]::new('desktop', 'desktop', [CompletionResultType]::ParameterValue, 'Compile a script into a desktop application')
            [CompletionResult]::new('pack', 'pack', [CompletionResultType]::ParameterValue, 'Create a tarball of the package')
            [CompletionResult]::new('x', 'x', [CompletionResultType]::ParameterValue, 'Execute a binary from npm or jsr, like npx')
            [CompletionResult]::new('json_reference', 'json_reference', [CompletionResultType]::ParameterValue, '')
        }
        'deno;run' {
            [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Enable type-checking. This subcommand does not type-check by default; pass --check=all to also type-check remote modules. Alternatively, use the ''deno check'' subcommand.')
            [CompletionResult]::new('--watch', '--watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart process automatically.
  Local files from entry point module graph are watched by default.
  Additional paths might be watched by passing them as arguments to this flag.')
            [CompletionResult]::new('--hmr', '--hmr', [CompletionResultType]::ParameterName, 'Watch for file changes and hot-replace modules. The process restarts if hot replacement fails.
  Local files from entry point module graph are watched by default.
  Additional paths might be watched by passing them as arguments to this flag.')
            [CompletionResult]::new('--watch-exclude', '--watch-exclude', [CompletionResultType]::ParameterName, 'Exclude provided files/patterns from watch mode')
            [CompletionResult]::new('--no-clear-screen', '--no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
            [CompletionResult]::new('--ext', '--ext', [CompletionResultType]::ParameterName, 'Set content type of the supplied file')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--no-code-cache', '--no-code-cache', [CompletionResultType]::ParameterName, 'Disable V8 code cache feature')
            [CompletionResult]::new('--coverage', '--coverage', [CompletionResultType]::ParameterName, 'Collect coverage profile data into DIR. If DIR is not specified, it uses ''coverage/''.
  This option can also be set via the DENO_COVERAGE_DIR environment variable.')
            [CompletionResult]::new('--use-env-proxy', '--use-env-proxy', [CompletionResultType]::ParameterName, 'Use HTTP_PROXY, HTTPS_PROXY, and NO_PROXY for node:http/node:https')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--inspect', '--inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port [default: 127.0.0.1:9229]. Host and port are optional. Using port 0 will assign a random free port.')
            [CompletionResult]::new('--inspect-brk', '--inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script')
            [CompletionResult]::new('--inspect-wait', '--inspect-wait', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and wait for debugger to connect before running user code')
            [CompletionResult]::new('--inspect-publish-uid', '--inspect-publish-uid', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--cached-only', '--cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
            [CompletionResult]::new('--location', '--location', [CompletionResultType]::ParameterName, 'Value of globalThis.location used by some web APIs')
            [CompletionResult]::new('--v8-flags', '--v8-flags', [CompletionResultType]::ParameterName, 'To see a list of all available flags use --v8-flags=--help
  Flags can also be set via the DENO_V8_FLAGS environment variable.
  Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable')
            [CompletionResult]::new('--seed', '--seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
            [CompletionResult]::new('--preload', '--preload', [CompletionResultType]::ParameterName, 'A list of files that will be executed before the main module')
            [CompletionResult]::new('--require', '--require', [CompletionResultType]::ParameterName, 'A list of CommonJS modules that will be executed before the main module')
            [CompletionResult]::new('--conditions', '--conditions', [CompletionResultType]::ParameterName, 'Use this argument to specify custom conditions for npm package exports. You can also use DENO_CONDITIONS env var.

Docs: https://docs.deno.com/go/conditional-exports')
            [CompletionResult]::new('--allow-scripts', '--allow-scripts', [CompletionResultType]::ParameterName, 'Allow running npm lifecycle scripts for the given packages
  Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)')
        }
        'deno;watch' {
            [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Enable type-checking. This subcommand does not type-check by default; pass --check=all to also type-check remote modules. Alternatively, use the ''deno check'' subcommand.')
            [CompletionResult]::new('--watch', '--watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart process automatically.
  Local files from entry point module graph are watched by default.
  Additional paths might be watched by passing them as arguments to this flag.')
            [CompletionResult]::new('--hmr', '--hmr', [CompletionResultType]::ParameterName, 'Watch for file changes and hot-replace modules. The process restarts if hot replacement fails.
  Local files from entry point module graph are watched by default.
  Additional paths might be watched by passing them as arguments to this flag.')
            [CompletionResult]::new('--watch-exclude', '--watch-exclude', [CompletionResultType]::ParameterName, 'Exclude provided files/patterns from watch mode')
            [CompletionResult]::new('--no-clear-screen', '--no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
            [CompletionResult]::new('--ext', '--ext', [CompletionResultType]::ParameterName, 'Set content type of the supplied file')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--no-code-cache', '--no-code-cache', [CompletionResultType]::ParameterName, 'Disable V8 code cache feature')
            [CompletionResult]::new('--coverage', '--coverage', [CompletionResultType]::ParameterName, 'Collect coverage profile data into DIR. If DIR is not specified, it uses ''coverage/''.
  This option can also be set via the DENO_COVERAGE_DIR environment variable.')
            [CompletionResult]::new('--use-env-proxy', '--use-env-proxy', [CompletionResultType]::ParameterName, 'Use HTTP_PROXY, HTTPS_PROXY, and NO_PROXY for node:http/node:https')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--inspect', '--inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port [default: 127.0.0.1:9229]. Host and port are optional. Using port 0 will assign a random free port.')
            [CompletionResult]::new('--inspect-brk', '--inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script')
            [CompletionResult]::new('--inspect-wait', '--inspect-wait', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and wait for debugger to connect before running user code')
            [CompletionResult]::new('--inspect-publish-uid', '--inspect-publish-uid', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--cached-only', '--cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
            [CompletionResult]::new('--location', '--location', [CompletionResultType]::ParameterName, 'Value of globalThis.location used by some web APIs')
            [CompletionResult]::new('--v8-flags', '--v8-flags', [CompletionResultType]::ParameterName, 'To see a list of all available flags use --v8-flags=--help
  Flags can also be set via the DENO_V8_FLAGS environment variable.
  Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable')
            [CompletionResult]::new('--seed', '--seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
            [CompletionResult]::new('--preload', '--preload', [CompletionResultType]::ParameterName, 'A list of files that will be executed before the main module')
            [CompletionResult]::new('--require', '--require', [CompletionResultType]::ParameterName, 'A list of CommonJS modules that will be executed before the main module')
            [CompletionResult]::new('--conditions', '--conditions', [CompletionResultType]::ParameterName, 'Use this argument to specify custom conditions for npm package exports. You can also use DENO_CONDITIONS env var.

Docs: https://docs.deno.com/go/conditional-exports')
            [CompletionResult]::new('--allow-scripts', '--allow-scripts', [CompletionResultType]::ParameterName, 'Allow running npm lifecycle scripts for the given packages
  Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)')
        }
        'deno;serve' {
            [CompletionResult]::new('--port', '--port', [CompletionResultType]::ParameterName, 'The TCP port to serve on. Pass 0 to pick a random free port [default: 8000]')
            [CompletionResult]::new('--host', '--host', [CompletionResultType]::ParameterName, 'The TCP address to serve on, defaulting to 0.0.0.0 (all interfaces)')
            [CompletionResult]::new('--open', '--open', [CompletionResultType]::ParameterName, 'Open the browser on the address that the server is running on.')
            [CompletionResult]::new('--parallel', '--parallel', [CompletionResultType]::ParameterName, 'Run multiple server workers in parallel. Parallelism defaults to the number of available CPUs or the value of the DENO_JOBS environment variable')
            [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Enable type-checking. This subcommand does not type-check by default; pass --check=all to also type-check remote modules. Alternatively, use the ''deno check'' subcommand.')
            [CompletionResult]::new('--watch', '--watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart process automatically.
  Local files from entry point module graph are watched by default.
  Additional paths might be watched by passing them as arguments to this flag.')
            [CompletionResult]::new('--watch-hmr', '--watch-hmr', [CompletionResultType]::ParameterName, 'Watch for file changes and hot-replace modules. The process restarts if hot replacement fails.
  Local files from entry point module graph are watched by default.
  Additional paths might be watched by passing them as arguments to this flag.')
            [CompletionResult]::new('--watch-exclude', '--watch-exclude', [CompletionResultType]::ParameterName, 'Exclude provided files/patterns from watch mode')
            [CompletionResult]::new('--no-clear-screen', '--no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
            [CompletionResult]::new('--ext', '--ext', [CompletionResultType]::ParameterName, 'Set content type of the supplied file')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--no-code-cache', '--no-code-cache', [CompletionResultType]::ParameterName, 'Disable V8 code cache feature')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--inspect', '--inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port [default: 127.0.0.1:9229]. Host and port are optional. Using port 0 will assign a random free port.')
            [CompletionResult]::new('--inspect-brk', '--inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script')
            [CompletionResult]::new('--inspect-wait', '--inspect-wait', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and wait for debugger to connect before running user code')
            [CompletionResult]::new('--inspect-publish-uid', '--inspect-publish-uid', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--cached-only', '--cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
            [CompletionResult]::new('--location', '--location', [CompletionResultType]::ParameterName, 'Value of globalThis.location used by some web APIs')
            [CompletionResult]::new('--v8-flags', '--v8-flags', [CompletionResultType]::ParameterName, 'To see a list of all available flags use --v8-flags=--help
  Flags can also be set via the DENO_V8_FLAGS environment variable.
  Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable')
            [CompletionResult]::new('--seed', '--seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
            [CompletionResult]::new('--preload', '--preload', [CompletionResultType]::ParameterName, 'A list of files that will be executed before the main module')
            [CompletionResult]::new('--require', '--require', [CompletionResultType]::ParameterName, 'A list of CommonJS modules that will be executed before the main module')
            [CompletionResult]::new('--conditions', '--conditions', [CompletionResultType]::ParameterName, 'Use this argument to specify custom conditions for npm package exports. You can also use DENO_CONDITIONS env var.

Docs: https://docs.deno.com/go/conditional-exports')
            [CompletionResult]::new('--allow-scripts', '--allow-scripts', [CompletionResultType]::ParameterName, 'Allow running npm lifecycle scripts for the given packages
  Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)')
        }
        'deno;eval' {
            [CompletionResult]::new('--print', '--print', [CompletionResultType]::ParameterName, 'print result to stdout')
            [CompletionResult]::new('--ext', '--ext', [CompletionResultType]::ParameterName, 'Set content type of the supplied file')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Enable type-checking. This subcommand does not type-check by default; pass --check=all to also type-check remote modules. Alternatively, use the ''deno check'' subcommand.')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--inspect', '--inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port [default: 127.0.0.1:9229]. Host and port are optional. Using port 0 will assign a random free port.')
            [CompletionResult]::new('--inspect-brk', '--inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script')
            [CompletionResult]::new('--inspect-wait', '--inspect-wait', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and wait for debugger to connect before running user code')
            [CompletionResult]::new('--inspect-publish-uid', '--inspect-publish-uid', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--cached-only', '--cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
            [CompletionResult]::new('--location', '--location', [CompletionResultType]::ParameterName, 'Value of globalThis.location used by some web APIs')
            [CompletionResult]::new('--v8-flags', '--v8-flags', [CompletionResultType]::ParameterName, 'To see a list of all available flags use --v8-flags=--help
  Flags can also be set via the DENO_V8_FLAGS environment variable.
  Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable')
            [CompletionResult]::new('--seed', '--seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
            [CompletionResult]::new('--preload', '--preload', [CompletionResultType]::ParameterName, 'A list of files that will be executed before the main module')
            [CompletionResult]::new('--require', '--require', [CompletionResultType]::ParameterName, 'A list of CommonJS modules that will be executed before the main module')
            [CompletionResult]::new('--conditions', '--conditions', [CompletionResultType]::ParameterName, 'Use this argument to specify custom conditions for npm package exports. You can also use DENO_CONDITIONS env var.

Docs: https://docs.deno.com/go/conditional-exports')
        }
        'deno;fmt' {
            [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Check if the source files are formatted')
            [CompletionResult]::new('--fail-fast', '--fail-fast', [CompletionResultType]::ParameterName, 'Stop checking files on first format error')
            [CompletionResult]::new('--permit-no-files', '--permit-no-files', [CompletionResultType]::ParameterName, 'Don''t return an error code if no files were found')
            [CompletionResult]::new('--watch', '--watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart process automatically.
  Local files from entry point module graph are watched by default.
  Additional paths might be watched by passing them as arguments to this flag.')
            [CompletionResult]::new('--watch-exclude', '--watch-exclude', [CompletionResultType]::ParameterName, 'Exclude provided files/patterns from watch mode')
            [CompletionResult]::new('--no-clear-screen', '--no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
            [CompletionResult]::new('--ext', '--ext', [CompletionResultType]::ParameterName, 'Set content type of the supplied file')
            [CompletionResult]::new('--ignore', '--ignore', [CompletionResultType]::ParameterName, 'Ignore formatting particular source files')
            [CompletionResult]::new('--use-tabs', '--use-tabs', [CompletionResultType]::ParameterName, 'Use tabs instead of spaces for indentation [default: false]')
            [CompletionResult]::new('--line-width', '--line-width', [CompletionResultType]::ParameterName, 'Define maximum line width [default: 80]')
            [CompletionResult]::new('--indent-width', '--indent-width', [CompletionResultType]::ParameterName, 'Define indentation width [default: 2]')
            [CompletionResult]::new('--single-quote', '--single-quote', [CompletionResultType]::ParameterName, 'Use single quotes [default: false]')
            [CompletionResult]::new('--prose-wrap', '--prose-wrap', [CompletionResultType]::ParameterName, 'Define how prose should be wrapped [default: always]')
            [CompletionResult]::new('--no-semicolons', '--no-semicolons', [CompletionResultType]::ParameterName, 'Don''t use semicolons except where necessary [default: false]')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--no-editorconfig', '--no-editorconfig', [CompletionResultType]::ParameterName, 'Don''t read .editorconfig files to infer formatting options [default: false]')
            [CompletionResult]::new('--unstable-component', '--unstable-component', [CompletionResultType]::ParameterName, 'Enable formatting Svelte, Vue, Astro and Angular files')
            [CompletionResult]::new('--unstable-sql', '--unstable-sql', [CompletionResultType]::ParameterName, 'Enable formatting SQL files.')
        }
        'deno;lint' {
            [CompletionResult]::new('--rules', '--rules', [CompletionResultType]::ParameterName, 'List available rules')
            [CompletionResult]::new('--fix', '--fix', [CompletionResultType]::ParameterName, 'Fix any linting errors for rules that support it')
            [CompletionResult]::new('--rules-tags', '--rules-tags', [CompletionResultType]::ParameterName, 'Use set of rules with a tag')
            [CompletionResult]::new('--rules-include', '--rules-include', [CompletionResultType]::ParameterName, 'Include lint rules')
            [CompletionResult]::new('--rules-exclude', '--rules-exclude', [CompletionResultType]::ParameterName, 'Exclude lint rules')
            [CompletionResult]::new('--json', '--json', [CompletionResultType]::ParameterName, 'Output lint result in JSON format')
            [CompletionResult]::new('--compact', '--compact', [CompletionResultType]::ParameterName, 'Output lint result in compact format')
            [CompletionResult]::new('--ignore', '--ignore', [CompletionResultType]::ParameterName, 'Ignore linting particular source files')
            [CompletionResult]::new('--watch', '--watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart process automatically.
  Local files from entry point module graph are watched by default.
  Additional paths might be watched by passing them as arguments to this flag.')
            [CompletionResult]::new('--watch-exclude', '--watch-exclude', [CompletionResultType]::ParameterName, 'Exclude provided files/patterns from watch mode')
            [CompletionResult]::new('--no-clear-screen', '--no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
            [CompletionResult]::new('--permit-no-files', '--permit-no-files', [CompletionResultType]::ParameterName, 'Don''t return an error code if no files were found')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--ext', '--ext', [CompletionResultType]::ParameterName, 'Specify the file extension to lint when reading from stdin.For example, use `jsx` to lint JSX files or `tsx` for TSX files.This argument is necessary because stdin input does not automatically infer the file type.Example usage: `cat file.jsx | deno lint - --ext=jsx`.')
            [CompletionResult]::new('--allow-import', '--allow-import', [CompletionResultType]::ParameterName, 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,raw.esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,gist.githubusercontent.com:443')
            [CompletionResult]::new('--deny-import', '--deny-import', [CompletionResultType]::ParameterName, 'Deny importing from remote hosts. Optionally specify denied IP addresses and host names, with ports as necessary.')
        }
        'deno;test' {
            [CompletionResult]::new('--doc', '--doc', [CompletionResultType]::ParameterName, 'Evaluate code blocks in JSDoc and Markdown')
            [CompletionResult]::new('--no-run', '--no-run', [CompletionResultType]::ParameterName, 'Cache test modules, but don''t run tests')
            [CompletionResult]::new('--coverage', '--coverage', [CompletionResultType]::ParameterName, 'Collect coverage profile data into DIR. If DIR is not specified, it uses ''coverage/''.
  This option can also be set via the DENO_COVERAGE_DIR environment variable.')
            [CompletionResult]::new('--clean', '--clean', [CompletionResultType]::ParameterName, 'Empty the temporary coverage profile data directory before running tests.
  Note: running multiple `deno test --clean` calls in series or parallel for the same coverage directory may cause race conditions.')
            [CompletionResult]::new('--fail-fast', '--fail-fast', [CompletionResultType]::ParameterName, 'Stop after N errors. Defaults to stopping after first failure')
            [CompletionResult]::new('--filter', '--filter', [CompletionResultType]::ParameterName, 'Run tests with this string or regexp pattern in the test name')
            [CompletionResult]::new('--shuffle', '--shuffle', [CompletionResultType]::ParameterName, 'Shuffle the order in which the tests are run')
            [CompletionResult]::new('--parallel', '--parallel', [CompletionResultType]::ParameterName, 'Run test modules in parallel. Parallelism defaults to the number of available CPUs or the value of the DENO_JOBS environment variable')
            [CompletionResult]::new('--sanitize-ops', '--sanitize-ops', [CompletionResultType]::ParameterName, 'Enable the ops sanitizer, which ensures that all async ops started in a test are completed before the test ends')
            [CompletionResult]::new('--sanitize-resources', '--sanitize-resources', [CompletionResultType]::ParameterName, 'Enable the resources sanitizer, which ensures that all resources opened in a test are closed before the test ends')
            [CompletionResult]::new('--coverage-threshold', '--coverage-threshold', [CompletionResultType]::ParameterName, 'Fail if coverage is below this percentage (0-100). Requires --coverage')
            [CompletionResult]::new('--update-snapshots', '--update-snapshots', [CompletionResultType]::ParameterName, 'Update snapshots created with `t.assertSnapshot()` instead of failing when they do not match')
            [CompletionResult]::new('--watch', '--watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart process automatically.
  Local files from entry point module graph are watched by default.
  Additional paths might be watched by passing them as arguments to this flag.')
            [CompletionResult]::new('--watch-exclude', '--watch-exclude', [CompletionResultType]::ParameterName, 'Exclude provided files/patterns from watch mode')
            [CompletionResult]::new('--no-clear-screen', '--no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
            [CompletionResult]::new('--reporter', '--reporter', [CompletionResultType]::ParameterName, 'Select reporter to use. Default to ''pretty''')
            [CompletionResult]::new('--junit-path', '--junit-path', [CompletionResultType]::ParameterName, 'Write a JUnit XML test report to PATH. Use ''-'' to write to stdout which is the default when PATH is not provided')
            [CompletionResult]::new('--hide-stacktraces', '--hide-stacktraces', [CompletionResultType]::ParameterName, 'Hide stack traces for errors in failure test results.')
            [CompletionResult]::new('--retry', '--retry', [CompletionResultType]::ParameterName, 'Re-run failing tests up to NUMBER times. A test passes if any attempt passes. Tests that set their own `retry` option take precedence')
            [CompletionResult]::new('--repeats', '--repeats', [CompletionResultType]::ParameterName, 'Run each test NUMBER additional times. Every repetition must pass. Tests that set their own `repeats` option take precedence')
            [CompletionResult]::new('--shard', '--shard', [CompletionResultType]::ParameterName, 'Run only the test files for shard INDEX of COUNT, e.g. --shard=2/3.
  The discovered test files are sorted and split into COUNT consecutive groups; INDEX is 1-based. Useful for splitting a run across machines.')
            [CompletionResult]::new('--changed', '--changed', [CompletionResultType]::ParameterName, 'Run only test modules affected by files changed in git.
  With no value, uses uncommitted changes (staged, unstaged and untracked).
  Pass a git ref to compare against, e.g. --changed=main or --changed=HEAD~1.')
            [CompletionResult]::new('--related', '--related', [CompletionResultType]::ParameterName, 'Run only test modules that depend on the given source files')
            [CompletionResult]::new('--coverage-raw-data-only', '--coverage-raw-data-only', [CompletionResultType]::ParameterName, 'Only collect raw coverage data, without generating a report')
            [CompletionResult]::new('--ignore', '--ignore', [CompletionResultType]::ParameterName, 'Ignore files')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--permit-no-files', '--permit-no-files', [CompletionResultType]::ParameterName, 'Don''t return an error code if no files were found')
            [CompletionResult]::new('--ext', '--ext', [CompletionResultType]::ParameterName, 'Set content type of the supplied file')
            [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Set type-checking behavior. This subcommand type-checks local modules by default, so passing --check is redundant; pass --check=all to also type-check remote modules. Alternatively, use the ''deno check'' subcommand.')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--inspect', '--inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port [default: 127.0.0.1:9229]. Host and port are optional. Using port 0 will assign a random free port.')
            [CompletionResult]::new('--inspect-brk', '--inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script')
            [CompletionResult]::new('--inspect-wait', '--inspect-wait', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and wait for debugger to connect before running user code')
            [CompletionResult]::new('--inspect-publish-uid', '--inspect-publish-uid', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--cached-only', '--cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
            [CompletionResult]::new('--location', '--location', [CompletionResultType]::ParameterName, 'Value of globalThis.location used by some web APIs')
            [CompletionResult]::new('--v8-flags', '--v8-flags', [CompletionResultType]::ParameterName, 'To see a list of all available flags use --v8-flags=--help
  Flags can also be set via the DENO_V8_FLAGS environment variable.
  Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable')
            [CompletionResult]::new('--seed', '--seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
            [CompletionResult]::new('--preload', '--preload', [CompletionResultType]::ParameterName, 'A list of files that will be executed before the main module')
            [CompletionResult]::new('--require', '--require', [CompletionResultType]::ParameterName, 'A list of CommonJS modules that will be executed before the main module')
            [CompletionResult]::new('--conditions', '--conditions', [CompletionResultType]::ParameterName, 'Use this argument to specify custom conditions for npm package exports. You can also use DENO_CONDITIONS env var.

Docs: https://docs.deno.com/go/conditional-exports')
            [CompletionResult]::new('--allow-scripts', '--allow-scripts', [CompletionResultType]::ParameterName, 'Allow running npm lifecycle scripts for the given packages
  Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)')
        }
        'deno;upgrade' {
            [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Perform all checks without replacing old exe')
            [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Replace current exe even if not out-of-date')
            [CompletionResult]::new('--canary', '--canary', [CompletionResultType]::ParameterName, 'Upgrade to canary builds')
            [CompletionResult]::new('--release-candidate', '--release-candidate', [CompletionResultType]::ParameterName, 'Upgrade to a release candidate')
            [CompletionResult]::new('--version', '--version', [CompletionResultType]::ParameterName, 'The version to upgrade to')
            [CompletionResult]::new('--output', '--output', [CompletionResultType]::ParameterName, 'The path to output the updated version to')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--pr', '--pr', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--checksum', '--checksum', [CompletionResultType]::ParameterName, 'Verify the downloaded archive against the provided SHA256 checksum')
            [CompletionResult]::new('--branch', '--branch', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--no-delta', '--no-delta', [CompletionResultType]::ParameterName, 'Disable delta updates and always download the full archive')
        }
        'deno;cache' {
            [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Enable type-checking. This subcommand does not type-check by default; pass --check=all to also type-check remote modules. Alternatively, use the ''deno check'' subcommand.')
            [CompletionResult]::new('--ext', '--ext', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--inspect', '--inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port [default: 127.0.0.1:9229]. Host and port are optional. Using port 0 will assign a random free port.')
            [CompletionResult]::new('--inspect-brk', '--inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script')
            [CompletionResult]::new('--inspect-wait', '--inspect-wait', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and wait for debugger to connect before running user code')
            [CompletionResult]::new('--inspect-publish-uid', '--inspect-publish-uid', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--allow-import', '--allow-import', [CompletionResultType]::ParameterName, 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,raw.esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,gist.githubusercontent.com:443')
            [CompletionResult]::new('--deny-import', '--deny-import', [CompletionResultType]::ParameterName, 'Deny importing from remote hosts. Optionally specify denied IP addresses and host names, with ports as necessary.')
            [CompletionResult]::new('--allow-scripts', '--allow-scripts', [CompletionResultType]::ParameterName, 'Allow running npm lifecycle scripts for the given packages
  Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)')
        }
        'deno;check' {
            [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'Type-check all code, including remote modules and npm packages')
            [CompletionResult]::new('--doc', '--doc', [CompletionResultType]::ParameterName, 'Type-check code blocks in JSDoc as well as actual code')
            [CompletionResult]::new('--doc-only', '--doc-only', [CompletionResultType]::ParameterName, 'Type-check code blocks in JSDoc and Markdown only')
            [CompletionResult]::new('--desktop', '--desktop', [CompletionResultType]::ParameterName, 'Type-check using the type definitions for `deno desktop`')
            [CompletionResult]::new('--no-code-cache', '--no-code-cache', [CompletionResultType]::ParameterName, 'Disable V8 code cache feature')
            [CompletionResult]::new('--watch', '--watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart process automatically.
  Only local files from entry point module graph are watched.')
            [CompletionResult]::new('--watch-exclude', '--watch-exclude', [CompletionResultType]::ParameterName, 'Exclude provided files/patterns from watch mode')
            [CompletionResult]::new('--no-clear-screen', '--no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--cached-only', '--cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
            [CompletionResult]::new('--location', '--location', [CompletionResultType]::ParameterName, 'Value of globalThis.location used by some web APIs')
            [CompletionResult]::new('--v8-flags', '--v8-flags', [CompletionResultType]::ParameterName, 'To see a list of all available flags use --v8-flags=--help
  Flags can also be set via the DENO_V8_FLAGS environment variable.
  Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable')
            [CompletionResult]::new('--seed', '--seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
            [CompletionResult]::new('--preload', '--preload', [CompletionResultType]::ParameterName, 'A list of files that will be executed before the main module')
            [CompletionResult]::new('--require', '--require', [CompletionResultType]::ParameterName, 'A list of CommonJS modules that will be executed before the main module')
            [CompletionResult]::new('--conditions', '--conditions', [CompletionResultType]::ParameterName, 'Use this argument to specify custom conditions for npm package exports. You can also use DENO_CONDITIONS env var.

Docs: https://docs.deno.com/go/conditional-exports')
            [CompletionResult]::new('--allow-import', '--allow-import', [CompletionResultType]::ParameterName, 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,raw.esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,gist.githubusercontent.com:443')
            [CompletionResult]::new('--deny-import', '--deny-import', [CompletionResultType]::ParameterName, 'Deny importing from remote hosts. Optionally specify denied IP addresses and host names, with ports as necessary.')
        }
        'deno;info' {
            [CompletionResult]::new('--json', '--json', [CompletionResultType]::ParameterName, 'UNSTABLE: Outputs the information in JSON format')
            [CompletionResult]::new('--location', '--location', [CompletionResultType]::ParameterName, 'Show files used for origin bound APIs like the Web Storage API when running a script with --location=<HREF>')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--allow-import', '--allow-import', [CompletionResultType]::ParameterName, 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,raw.esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,gist.githubusercontent.com:443')
            [CompletionResult]::new('--deny-import', '--deny-import', [CompletionResultType]::ParameterName, 'Deny importing from remote hosts. Optionally specify denied IP addresses and host names, with ports as necessary.')
        }
        'deno;doc' {
            [CompletionResult]::new('--json', '--json', [CompletionResultType]::ParameterName, 'Output documentation in JSON format')
            [CompletionResult]::new('--private', '--private', [CompletionResultType]::ParameterName, 'Output private documentation')
            [CompletionResult]::new('--lint', '--lint', [CompletionResultType]::ParameterName, 'Output documentation diagnostics.')
            [CompletionResult]::new('--html', '--html', [CompletionResultType]::ParameterName, 'Output documentation in HTML format')
            [CompletionResult]::new('--name', '--name', [CompletionResultType]::ParameterName, 'The name that will be used in the docs (ie for breadcrumbs)')
            [CompletionResult]::new('--output', '--output', [CompletionResultType]::ParameterName, 'Directory for HTML documentation output')
            [CompletionResult]::new('--category-docs', '--category-docs', [CompletionResultType]::ParameterName, 'Path to a JSON file keyed by category and an optional value of a markdown doc')
            [CompletionResult]::new('--symbol-redirect-map', '--symbol-redirect-map', [CompletionResultType]::ParameterName, 'Path to a JSON file keyed by file, with an inner map of symbol to an external link')
            [CompletionResult]::new('--default-symbol-map', '--default-symbol-map', [CompletionResultType]::ParameterName, 'Uses the provided mapping of default name to wanted name for usage blocks')
            [CompletionResult]::new('--strip-trailing-html', '--strip-trailing-html', [CompletionResultType]::ParameterName, 'Remove trailing .html from various links. Will still generate files with a .html extension')
            [CompletionResult]::new('--filter', '--filter', [CompletionResultType]::ParameterName, 'Dot separated path to symbol')
            [CompletionResult]::new('--builtin', '--builtin', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--allow-import', '--allow-import', [CompletionResultType]::ParameterName, 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,raw.esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,gist.githubusercontent.com:443')
            [CompletionResult]::new('--deny-import', '--deny-import', [CompletionResultType]::ParameterName, 'Deny importing from remote hosts. Optionally specify denied IP addresses and host names, with ports as necessary.')
        }
        'deno;task' {
            [CompletionResult]::new('--cwd', '--cwd', [CompletionResultType]::ParameterName, 'Specify the directory to run the task in')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--recursive', '--recursive', [CompletionResultType]::ParameterName, 'Run the task in all projects in the workspace')
            [CompletionResult]::new('--members', '--members', [CompletionResultType]::ParameterName, 'Run the task in all workspace members, but not in the workspace root')
            [CompletionResult]::new('--filter', '--filter', [CompletionResultType]::ParameterName, 'Filter members of the workspace by name, implies --recursive flag')
            [CompletionResult]::new('--eval', '--eval', [CompletionResultType]::ParameterName, 'Evaluate the passed value as if it was a task in a configuration file')
            [CompletionResult]::new('--if-present', '--if-present', [CompletionResultType]::ParameterName, 'Exit with code 0 instead of an error when the task is not found')
            [CompletionResult]::new('--no-prefix', '--no-prefix', [CompletionResultType]::ParameterName, 'Disable prefixing the output of concurrently-executing tasks with the task name')
            [CompletionResult]::new('--jobs', '--jobs', [CompletionResultType]::ParameterName, 'Maximum number of tasks to run concurrently.
Overrides the DENO_JOBS environment variable; defaults to the number of
available CPUs. Use 1 to force sequential execution. Only affects runs
where multiple tasks can run concurrently (workspace runs, or a task with
parallelizable dependencies)')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
        }
        'deno;bench' {
            [CompletionResult]::new('--filter', '--filter', [CompletionResultType]::ParameterName, 'Run benchmarks with this string or regexp pattern in the bench name')
            [CompletionResult]::new('--json', '--json', [CompletionResultType]::ParameterName, 'UNSTABLE: Output benchmark result in JSON format')
            [CompletionResult]::new('--no-run', '--no-run', [CompletionResultType]::ParameterName, 'Cache bench modules, but don''t run benchmarks')
            [CompletionResult]::new('--permit-no-files', '--permit-no-files', [CompletionResultType]::ParameterName, 'Don''t return an error code if no files were found')
            [CompletionResult]::new('--watch', '--watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart process automatically.
  Local files from entry point module graph are watched by default.
  Additional paths might be watched by passing them as arguments to this flag.')
            [CompletionResult]::new('--watch-exclude', '--watch-exclude', [CompletionResultType]::ParameterName, 'Exclude provided files/patterns from watch mode')
            [CompletionResult]::new('--no-clear-screen', '--no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
            [CompletionResult]::new('--ignore', '--ignore', [CompletionResultType]::ParameterName, 'Ignore files')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Set type-checking behavior. This subcommand type-checks local modules by default, so passing --check is redundant; pass --check=all to also type-check remote modules. Alternatively, use the ''deno check'' subcommand.')
            [CompletionResult]::new('--ext', '--ext', [CompletionResultType]::ParameterName, 'Set content type of the supplied file')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--inspect', '--inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port [default: 127.0.0.1:9229]. Host and port are optional. Using port 0 will assign a random free port.')
            [CompletionResult]::new('--inspect-brk', '--inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script')
            [CompletionResult]::new('--inspect-wait', '--inspect-wait', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and wait for debugger to connect before running user code')
            [CompletionResult]::new('--inspect-publish-uid', '--inspect-publish-uid', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--cached-only', '--cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
            [CompletionResult]::new('--location', '--location', [CompletionResultType]::ParameterName, 'Value of globalThis.location used by some web APIs')
            [CompletionResult]::new('--v8-flags', '--v8-flags', [CompletionResultType]::ParameterName, 'To see a list of all available flags use --v8-flags=--help
  Flags can also be set via the DENO_V8_FLAGS environment variable.
  Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable')
            [CompletionResult]::new('--seed', '--seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
            [CompletionResult]::new('--preload', '--preload', [CompletionResultType]::ParameterName, 'A list of files that will be executed before the main module')
            [CompletionResult]::new('--require', '--require', [CompletionResultType]::ParameterName, 'A list of CommonJS modules that will be executed before the main module')
            [CompletionResult]::new('--conditions', '--conditions', [CompletionResultType]::ParameterName, 'Use this argument to specify custom conditions for npm package exports. You can also use DENO_CONDITIONS env var.

Docs: https://docs.deno.com/go/conditional-exports')
        }
        'deno;compile' {
            [CompletionResult]::new('--output', '--output', [CompletionResultType]::ParameterName, 'Output file (defaults to $PWD/<inferred-name>)')
            [CompletionResult]::new('--target', '--target', [CompletionResultType]::ParameterName, 'Target OS architecture')
            [CompletionResult]::new('--engine', '--engine', [CompletionResultType]::ParameterName, 'JS engine the compiled binary runs on (quickjs is smaller and experimental, and does not receive the same security updates as v8)')
            [CompletionResult]::new('--no-terminal', '--no-terminal', [CompletionResultType]::ParameterName, 'Hide terminal on Windows')
            [CompletionResult]::new('--icon', '--icon', [CompletionResultType]::ParameterName, 'Set the icon of the executable on Windows (.ico)')
            [CompletionResult]::new('--include', '--include', [CompletionResultType]::ParameterName, 'Includes an additional module or file/directory in the compiled executable.
  Use this flag if a dynamically imported module or a web worker main module
  fails to load in the executable or to embed a file or directory in the executable.
  This flag can be passed multiple times, to include multiple additional modules.')
            [CompletionResult]::new('--exclude', '--exclude', [CompletionResultType]::ParameterName, 'Excludes a file/directory in the compiled executable.
  Use this flag to exclude a specific file or directory within the included files.
  For example, to exclude a certain folder in the bundled node_modules directory.')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--no-code-cache', '--no-code-cache', [CompletionResultType]::ParameterName, 'Disable V8 code cache feature')
            [CompletionResult]::new('--ext', '--ext', [CompletionResultType]::ParameterName, 'Set content type of the supplied file')
            [CompletionResult]::new('--self-extracting', '--self-extracting', [CompletionResultType]::ParameterName, 'Create a self-extracting binary that extracts the embedded file system to disk on first run and then runs from there')
            [CompletionResult]::new('--bundle', '--bundle', [CompletionResultType]::ParameterName, 'Experimental. Bundle the entrypoint with esbuild before embedding, instead of shipping the whole node_modules tree.
  Produces a smaller binary with faster startup, at the cost of dropping dynamic require/import patterns that can''t be statically traced.')
            [CompletionResult]::new('--minify', '--minify', [CompletionResultType]::ParameterName, 'Experimental. Minify the bundled output. Only meaningful with --bundle.
  Reduces both the embedded bundle size and runtime memory use, at the cost of less readable stack traces.')
            [CompletionResult]::new('--app-name', '--app-name', [CompletionResultType]::ParameterName, 'Stable identity for the compiled app.
  Determines where origin-bound storage such as the default `Deno.openKv()`,
  `localStorage` and `caches` is persisted (under the platform''s app data directory).
  Defaults to the output file name. Set this to keep storage stable across renames.')
            [CompletionResult]::new('--exclude-unused-npm', '--exclude-unused-npm', [CompletionResultType]::ParameterName, 'Embed only the npm packages reachable from the module graph (managed npm; no node_modules directory).
  Without this flag the full managed npm snapshot from the lockfile / package.json is embedded.
  Reduces binary size when the lockfile contains packages the entrypoint does not import.
  Skips packages that are only reached through non-statically-analyzable dynamic imports;
  pass those with --include npm:<pkg> if needed.')
            [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Set type-checking behavior. This subcommand type-checks local modules by default, so passing --check is redundant; pass --check=all to also type-check remote modules. Alternatively, use the ''deno check'' subcommand.')
            [CompletionResult]::new('--watch', '--watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart process automatically.
  Only local files from entry point module graph are watched.')
            [CompletionResult]::new('--watch-exclude', '--watch-exclude', [CompletionResultType]::ParameterName, 'Exclude provided files/patterns from watch mode')
            [CompletionResult]::new('--no-clear-screen', '--no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--inspect', '--inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port [default: 127.0.0.1:9229]. Host and port are optional. Using port 0 will assign a random free port.')
            [CompletionResult]::new('--inspect-brk', '--inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script')
            [CompletionResult]::new('--inspect-wait', '--inspect-wait', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and wait for debugger to connect before running user code')
            [CompletionResult]::new('--inspect-publish-uid', '--inspect-publish-uid', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--cached-only', '--cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
            [CompletionResult]::new('--location', '--location', [CompletionResultType]::ParameterName, 'Value of globalThis.location used by some web APIs')
            [CompletionResult]::new('--v8-flags', '--v8-flags', [CompletionResultType]::ParameterName, 'To see a list of all available flags use --v8-flags=--help
  Flags can also be set via the DENO_V8_FLAGS environment variable.
  Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable')
            [CompletionResult]::new('--seed', '--seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
            [CompletionResult]::new('--preload', '--preload', [CompletionResultType]::ParameterName, 'A list of files that will be executed before the main module')
            [CompletionResult]::new('--require', '--require', [CompletionResultType]::ParameterName, 'A list of CommonJS modules that will be executed before the main module')
            [CompletionResult]::new('--conditions', '--conditions', [CompletionResultType]::ParameterName, 'Use this argument to specify custom conditions for npm package exports. You can also use DENO_CONDITIONS env var.

Docs: https://docs.deno.com/go/conditional-exports')
        }
        'deno;coverage' {
            [CompletionResult]::new('--ignore', '--ignore', [CompletionResultType]::ParameterName, 'Ignore coverage files')
            [CompletionResult]::new('--include', '--include', [CompletionResultType]::ParameterName, 'Include source files in the report')
            [CompletionResult]::new('--exclude', '--exclude', [CompletionResultType]::ParameterName, 'Exclude source files from the report')
            [CompletionResult]::new('--lcov', '--lcov', [CompletionResultType]::ParameterName, 'Output coverage report in lcov format')
            [CompletionResult]::new('--html', '--html', [CompletionResultType]::ParameterName, 'Output coverage report in HTML format in the given directory')
            [CompletionResult]::new('--detailed', '--detailed', [CompletionResultType]::ParameterName, 'Output coverage report in detailed format in the terminal')
            [CompletionResult]::new('--threshold', '--threshold', [CompletionResultType]::ParameterName, 'Fail if coverage is below this percentage (0-100), applied to line, branch, and function coverage.
  Per-metric thresholds can be set in deno.json under "coverage": { "thresholds": { ... } }. The flag takes precedence.')
            [CompletionResult]::new('--output', '--output', [CompletionResultType]::ParameterName, 'Exports the coverage report in lcov format to the given file.
  If no --output arg is specified then the report is written to stdout.')
        }
        'deno;repl' {
            [CompletionResult]::new('--eval', '--eval', [CompletionResultType]::ParameterName, 'Evaluates the provided code when the REPL starts')
            [CompletionResult]::new('--eval-file', '--eval-file', [CompletionResultType]::ParameterName, 'Evaluates the provided file(s) as scripts when the REPL starts. Accepts file paths and URLs')
            [CompletionResult]::new('--json', '--json', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--inspect', '--inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port [default: 127.0.0.1:9229]. Host and port are optional. Using port 0 will assign a random free port.')
            [CompletionResult]::new('--inspect-brk', '--inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script')
            [CompletionResult]::new('--inspect-wait', '--inspect-wait', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and wait for debugger to connect before running user code')
            [CompletionResult]::new('--inspect-publish-uid', '--inspect-publish-uid', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--cached-only', '--cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
            [CompletionResult]::new('--location', '--location', [CompletionResultType]::ParameterName, 'Value of globalThis.location used by some web APIs')
            [CompletionResult]::new('--v8-flags', '--v8-flags', [CompletionResultType]::ParameterName, 'To see a list of all available flags use --v8-flags=--help
  Flags can also be set via the DENO_V8_FLAGS environment variable.
  Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable')
            [CompletionResult]::new('--seed', '--seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
            [CompletionResult]::new('--preload', '--preload', [CompletionResultType]::ParameterName, 'A list of files that will be executed before the main module')
            [CompletionResult]::new('--require', '--require', [CompletionResultType]::ParameterName, 'A list of CommonJS modules that will be executed before the main module')
            [CompletionResult]::new('--conditions', '--conditions', [CompletionResultType]::ParameterName, 'Use this argument to specify custom conditions for npm package exports. You can also use DENO_CONDITIONS env var.

Docs: https://docs.deno.com/go/conditional-exports')
        }
        'deno;install' {
            [CompletionResult]::new('--global', '--global', [CompletionResultType]::ParameterName, 'Install a package or script as a globally available executable')
            [CompletionResult]::new('--name', '--name', [CompletionResultType]::ParameterName, 'Executable file name')
            [CompletionResult]::new('--root', '--root', [CompletionResultType]::ParameterName, 'Installation root')
            [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Forcefully overwrite existing installation')
            [CompletionResult]::new('--dev', '--dev', [CompletionResultType]::ParameterName, 'Add the package as a dev dependency (under `devDependencies`). Note: this only applies when adding to a `package.json` file.')
            [CompletionResult]::new('--save-optional', '--save-optional', [CompletionResultType]::ParameterName, 'Add the package as an optional dependency (under `optionalDependencies`). Note: this only applies when adding to a `package.json` file.')
            [CompletionResult]::new('--no-save', '--no-save', [CompletionResultType]::ParameterName, 'Install the package(s) without adding them to the configuration file.')
            [CompletionResult]::new('--prod', '--prod', [CompletionResultType]::ParameterName, 'Only install production dependencies (excludes devDependencies)')
            [CompletionResult]::new('--skip-types', '--skip-types', [CompletionResultType]::ParameterName, 'Exclude @types/* packages from installation.
Be careful, as it uses a name-based heuristic and may skip packages that ship runtime code.')
            [CompletionResult]::new('--entrypoint', '--entrypoint', [CompletionResultType]::ParameterName, 'Install dependents of the specified entrypoint(s)')
            [CompletionResult]::new('--compile', '--compile', [CompletionResultType]::ParameterName, 'Install the script as a compiled executable')
            [CompletionResult]::new('--lockfile-only', '--lockfile-only', [CompletionResultType]::ParameterName, 'Install only updating the lockfile')
            [CompletionResult]::new('--npm', '--npm', [CompletionResultType]::ParameterName, 'assume unprefixed package names are npm packages (default)')
            [CompletionResult]::new('--jsr', '--jsr', [CompletionResultType]::ParameterName, 'assume unprefixed package names are jsr packages')
            [CompletionResult]::new('--save-exact', '--save-exact', [CompletionResultType]::ParameterName, 'Save exact version without the caret (^)')
            [CompletionResult]::new('--unscoped', '--unscoped', [CompletionResultType]::ParameterName, 'Use the package name without its scope as the alias (ex. `jsr:@david/jsonc-morph` is added as `jsonc-morph`). Packages given an explicit alias are unaffected.')
            [CompletionResult]::new('--package-json', '--package-json', [CompletionResultType]::ParameterName, 'Force using package.json for dependency management instead of deno.json')
            [CompletionResult]::new('--os', '--os', [CompletionResultType]::ParameterName, 'Target OS for npm package installation (e.g., linux, darwin, win32)')
            [CompletionResult]::new('--arch', '--arch', [CompletionResultType]::ParameterName, 'Target architecture for npm package installation (e.g., x64, arm64)')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Set type-checking behavior. This subcommand type-checks local modules by default, so passing --check is redundant; pass --check=all to also type-check remote modules. Alternatively, use the ''deno check'' subcommand.')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--inspect', '--inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port [default: 127.0.0.1:9229]. Host and port are optional. Using port 0 will assign a random free port.')
            [CompletionResult]::new('--inspect-brk', '--inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script')
            [CompletionResult]::new('--inspect-wait', '--inspect-wait', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and wait for debugger to connect before running user code')
            [CompletionResult]::new('--inspect-publish-uid', '--inspect-publish-uid', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--cached-only', '--cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
            [CompletionResult]::new('--location', '--location', [CompletionResultType]::ParameterName, 'Value of globalThis.location used by some web APIs')
            [CompletionResult]::new('--v8-flags', '--v8-flags', [CompletionResultType]::ParameterName, 'To see a list of all available flags use --v8-flags=--help
  Flags can also be set via the DENO_V8_FLAGS environment variable.
  Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable')
            [CompletionResult]::new('--seed', '--seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
            [CompletionResult]::new('--preload', '--preload', [CompletionResultType]::ParameterName, 'A list of files that will be executed before the main module')
            [CompletionResult]::new('--require', '--require', [CompletionResultType]::ParameterName, 'A list of CommonJS modules that will be executed before the main module')
            [CompletionResult]::new('--conditions', '--conditions', [CompletionResultType]::ParameterName, 'Use this argument to specify custom conditions for npm package exports. You can also use DENO_CONDITIONS env var.

Docs: https://docs.deno.com/go/conditional-exports')
            [CompletionResult]::new('--allow-scripts', '--allow-scripts', [CompletionResultType]::ParameterName, 'Allow running npm lifecycle scripts for the given packages
  Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)')
        }
        'deno;uninstall' {
            [CompletionResult]::new('--global', '--global', [CompletionResultType]::ParameterName, 'Remove globally installed packages or modules')
            [CompletionResult]::new('--root', '--root', [CompletionResultType]::ParameterName, 'Installation root')
            [CompletionResult]::new('--lockfile-only', '--lockfile-only', [CompletionResultType]::ParameterName, 'Install only updating the lockfile')
            [CompletionResult]::new('--package-json', '--package-json', [CompletionResultType]::ParameterName, 'Force using package.json for dependency management instead of deno.json')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
        }
        'deno;types' {
        }
        'deno;completions' {
            [CompletionResult]::new('--dynamic', '--dynamic', [CompletionResultType]::ParameterName, 'Generate dynamic completions for the given shell (unstable), currently this only provides available tasks for `deno task`.')
        }
        'deno;init' {
            [CompletionResult]::new('--lib', '--lib', [CompletionResultType]::ParameterName, 'Generate an example library project')
            [CompletionResult]::new('--serve', '--serve', [CompletionResultType]::ParameterName, 'Generate an example project for `deno serve`')
            [CompletionResult]::new('--npm', '--npm', [CompletionResultType]::ParameterName, 'Generate a npm create-* project')
            [CompletionResult]::new('--jsr', '--jsr', [CompletionResultType]::ParameterName, 'Generate a project from a JSR package')
            [CompletionResult]::new('--empty', '--empty', [CompletionResultType]::ParameterName, 'Generate a minimal project with just main.ts and deno.json')
            [CompletionResult]::new('--yes', '--yes', [CompletionResultType]::ParameterName, 'Bypass the prompt and run with full permissions')
        }
        'deno;create' {
            [CompletionResult]::new('--npm', '--npm', [CompletionResultType]::ParameterName, 'Treat unprefixed package names as npm packages')
            [CompletionResult]::new('--jsr', '--jsr', [CompletionResultType]::ParameterName, 'Treat unprefixed package names as JSR packages')
            [CompletionResult]::new('--yes', '--yes', [CompletionResultType]::ParameterName, 'Bypass the prompt and run with full permissions')
        }
        'deno;jupyter' {
            [CompletionResult]::new('--install', '--install', [CompletionResultType]::ParameterName, 'Install a kernelspec')
            [CompletionResult]::new('--name', '--name', [CompletionResultType]::ParameterName, 'Set a name for the kernel (defaults to ''deno''). Useful when maintaing multiple Deno kernels.')
            [CompletionResult]::new('--display', '--display', [CompletionResultType]::ParameterName, 'Set a display name for the kernel (defaults to ''Deno''). Useful when maintaing multiple Deno kernels.')
            [CompletionResult]::new('--kernel', '--kernel', [CompletionResultType]::ParameterName, 'Start the kernel')
            [CompletionResult]::new('--conn', '--conn', [CompletionResultType]::ParameterName, 'Path to JSON file describing connection parameters, provided by Jupyter')
            [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Force installation of a kernel, overwriting previously existing kernelspec')
        }
        'deno;publish' {
            [CompletionResult]::new('--token', '--token', [CompletionResultType]::ParameterName, 'The API token to use when publishing. If unset, interactive authentication is be used')
            [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Prepare the package for publishing performing all checks and validations without uploading')
            [CompletionResult]::new('--allow-slow-types', '--allow-slow-types', [CompletionResultType]::ParameterName, 'Allow publishing with slow types')
            [CompletionResult]::new('--allow-dirty', '--allow-dirty', [CompletionResultType]::ParameterName, 'Allow publishing if the repository has uncommitted changed')
            [CompletionResult]::new('--no-provenance', '--no-provenance', [CompletionResultType]::ParameterName, 'Disable provenance attestation.
  Enabled by default on Github actions, publicly links the package to where it was built and published from.')
            [CompletionResult]::new('--set-version', '--set-version', [CompletionResultType]::ParameterName, 'Set version for a package to be published.
  This flag can be used while publishing individual packages and cannot be used in a workspace.')
            [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Set type-checking behavior. This subcommand type-checks local modules by default, so passing --check is redundant; pass --check=all to also type-check remote modules. Alternatively, use the ''deno check'' subcommand.')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
        }
        'deno;add' {
            [CompletionResult]::new('--dev', '--dev', [CompletionResultType]::ParameterName, 'Add the package as a dev dependency (under `devDependencies`). Note: this only applies when adding to a `package.json` file.')
            [CompletionResult]::new('--save-optional', '--save-optional', [CompletionResultType]::ParameterName, 'Add the package as an optional dependency (under `optionalDependencies`). Note: this only applies when adding to a `package.json` file.')
            [CompletionResult]::new('--no-save', '--no-save', [CompletionResultType]::ParameterName, 'Install the package(s) without adding them to the configuration file.')
            [CompletionResult]::new('--save-exact', '--save-exact', [CompletionResultType]::ParameterName, 'Save exact version without the caret (^)')
            [CompletionResult]::new('--unscoped', '--unscoped', [CompletionResultType]::ParameterName, 'Use the package name without its scope as the alias (ex. `jsr:@david/jsonc-morph` is added as `jsonc-morph`). Packages given an explicit alias are unaffected.')
            [CompletionResult]::new('--npm', '--npm', [CompletionResultType]::ParameterName, 'assume unprefixed package names are npm packages (default)')
            [CompletionResult]::new('--jsr', '--jsr', [CompletionResultType]::ParameterName, 'assume unprefixed package names are jsr packages')
            [CompletionResult]::new('--lockfile-only', '--lockfile-only', [CompletionResultType]::ParameterName, 'Install only updating the lockfile')
            [CompletionResult]::new('--allow-import', '--allow-import', [CompletionResultType]::ParameterName, 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,raw.esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,gist.githubusercontent.com:443')
            [CompletionResult]::new('--deny-import', '--deny-import', [CompletionResultType]::ParameterName, 'Deny importing from remote hosts. Optionally specify denied IP addresses and host names, with ports as necessary.')
            [CompletionResult]::new('--package-json', '--package-json', [CompletionResultType]::ParameterName, 'Force using package.json for dependency management instead of deno.json')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--allow-scripts', '--allow-scripts', [CompletionResultType]::ParameterName, 'Allow running npm lifecycle scripts for the given packages
  Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
        }
        'deno;remove' {
            [CompletionResult]::new('--global', '--global', [CompletionResultType]::ParameterName, 'Remove globally installed package or module')
            [CompletionResult]::new('--root', '--root', [CompletionResultType]::ParameterName, 'Installation root')
            [CompletionResult]::new('--lockfile-only', '--lockfile-only', [CompletionResultType]::ParameterName, 'Install only updating the lockfile')
            [CompletionResult]::new('--package-json', '--package-json', [CompletionResultType]::ParameterName, 'Force using package.json for dependency management instead of deno.json')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
        }
        'deno;outdated' {
            [CompletionResult]::new('--recursive', '--recursive', [CompletionResultType]::ParameterName, 'Include all workspace members')
            [CompletionResult]::new('--compatible', '--compatible', [CompletionResultType]::ParameterName, 'Only consider versions that satisfy semver requirements')
            [CompletionResult]::new('--update', '--update', [CompletionResultType]::ParameterName, 'Update dependency versions')
            [CompletionResult]::new('--latest', '--latest', [CompletionResultType]::ParameterName, 'Consider the latest version, regardless of semver constraints')
            [CompletionResult]::new('--interactive', '--interactive', [CompletionResultType]::ParameterName, 'Interactively select which dependencies to update')
            [CompletionResult]::new('--lockfile-only', '--lockfile-only', [CompletionResultType]::ParameterName, 'Install only updating the lockfile')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
        }
        'deno;update' {
            [CompletionResult]::new('--recursive', '--recursive', [CompletionResultType]::ParameterName, 'Include all workspace members')
            [CompletionResult]::new('--latest', '--latest', [CompletionResultType]::ParameterName, 'Consider the latest version, regardless of semver constraints')
            [CompletionResult]::new('--compatible', '--compatible', [CompletionResultType]::ParameterName, 'Only consider versions that satisfy semver requirements')
            [CompletionResult]::new('--lockfile-only', '--lockfile-only', [CompletionResultType]::ParameterName, 'Install only updating the lockfile')
            [CompletionResult]::new('--interactive', '--interactive', [CompletionResultType]::ParameterName, 'Interactively select which dependencies to update')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
        }
        'deno;deploy' {
        }
        'deno;sandbox' {
        }
        'deno;clean' {
            [CompletionResult]::new('--except', '--except', [CompletionResultType]::ParameterName, 'Retain cache data needed by the given files')
            [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Show what would be removed without performing any actions')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
        }
        'deno;list' {
            [CompletionResult]::new('--depth', '--depth', [CompletionResultType]::ParameterName, 'Maximum depth of the dependency tree to display (0 = direct dependencies only)')
            [CompletionResult]::new('--prod', '--prod', [CompletionResultType]::ParameterName, 'Only list production dependencies')
            [CompletionResult]::new('--dev', '--dev', [CompletionResultType]::ParameterName, 'Only list development dependencies')
            [CompletionResult]::new('--recursive', '--recursive', [CompletionResultType]::ParameterName, 'Include all workspace members')
        }
        'deno;link' {
            [CompletionResult]::new('--lockfile-only', '--lockfile-only', [CompletionResultType]::ParameterName, 'Install only updating the lockfile')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
        }
        'deno;unlink' {
            [CompletionResult]::new('--lockfile-only', '--lockfile-only', [CompletionResultType]::ParameterName, 'Install only updating the lockfile')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
        }
        'deno;approve-scripts' {
            [CompletionResult]::new('--lockfile-only', '--lockfile-only', [CompletionResultType]::ParameterName, 'Install only updating the lockfile')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
        }
        'deno;lsp' {
        }
        'deno;vendor' {
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, '[possible values: unstable, full]')
            [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
            [CompletionResult]::new('--unstable', '--unstable', [CompletionResultType]::ParameterName, 'The `--unstable` flag has been deprecated. Use granular `--unstable-*` flags instead
  To view the list of individual unstable feature flags, run this command again with --help=unstable')
        }
        'deno;bundle' {
            [CompletionResult]::new('--output', '--output', [CompletionResultType]::ParameterName, 'Output path`')
            [CompletionResult]::new('--outdir', '--outdir', [CompletionResultType]::ParameterName, 'Output directory for bundled files')
            [CompletionResult]::new('--format', '--format', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--packages', '--packages', [CompletionResultType]::ParameterName, 'How to handle packages. Accepted values are ''bundle'' or ''external''')
            [CompletionResult]::new('--platform', '--platform', [CompletionResultType]::ParameterName, 'Platform to bundle for. Accepted values are ''browser'' or ''deno''')
            [CompletionResult]::new('--sourcemap', '--sourcemap', [CompletionResultType]::ParameterName, 'Generate source map. Accepted values are ''linked'', ''inline'', or ''external''')
            [CompletionResult]::new('--external', '--external', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--watch', '--watch', [CompletionResultType]::ParameterName, 'Watch and rebuild on changes')
            [CompletionResult]::new('--minify', '--minify', [CompletionResultType]::ParameterName, 'Minify the output')
            [CompletionResult]::new('--keep-names', '--keep-names', [CompletionResultType]::ParameterName, 'Keep function and class names')
            [CompletionResult]::new('--code-splitting', '--code-splitting', [CompletionResultType]::ParameterName, 'Enable code splitting')
            [CompletionResult]::new('--inline-imports', '--inline-imports', [CompletionResultType]::ParameterName, 'Whether to inline imported modules into the importing file [default: true]')
            [CompletionResult]::new('--declaration', '--declaration', [CompletionResultType]::ParameterName, 'Generate .d.ts declaration files alongside the bundle')
            [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Enable type-checking. This subcommand does not type-check by default; pass --check=all to also type-check remote modules. Alternatively, use the ''deno check'' subcommand.')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--allow-import', '--allow-import', [CompletionResultType]::ParameterName, 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,raw.esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,gist.githubusercontent.com:443')
            [CompletionResult]::new('--deny-import', '--deny-import', [CompletionResultType]::ParameterName, 'Deny importing from remote hosts. Optionally specify denied IP addresses and host names, with ports as necessary.')
            [CompletionResult]::new('--allow-scripts', '--allow-scripts', [CompletionResultType]::ParameterName, 'Allow running npm lifecycle scripts for the given packages
  Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)')
        }
        'deno;audit' {
            [CompletionResult]::new('--level', '--level', [CompletionResultType]::ParameterName, 'Only show advisories with severity greater or equal to the one specified')
            [CompletionResult]::new('--ignore-unfixable', '--ignore-unfixable', [CompletionResultType]::ParameterName, 'Ignore advisories that don''t have any actions to resolve them')
            [CompletionResult]::new('--ignore-registry-errors', '--ignore-registry-errors', [CompletionResultType]::ParameterName, 'Return exit code 0 if remote service(s) responds with an error.')
            [CompletionResult]::new('--socket', '--socket', [CompletionResultType]::ParameterName, 'Check against socket.dev vulnerability database')
            [CompletionResult]::new('--fix', '--fix', [CompletionResultType]::ParameterName, 'Automatically fix vulnerabilities by upgrading packages')
            [CompletionResult]::new('--ignore', '--ignore', [CompletionResultType]::ParameterName, 'Ignore advisories matching the given CVE IDs')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
        }
        'deno;why' {
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
        }
        'deno;transpile' {
            [CompletionResult]::new('--output', '--output', [CompletionResultType]::ParameterName, 'Output file path (for single file transpilation)')
            [CompletionResult]::new('--outdir', '--outdir', [CompletionResultType]::ParameterName, 'Output directory for transpiled files')
            [CompletionResult]::new('--source-map', '--source-map', [CompletionResultType]::ParameterName, 'Source map mode: none, inline, or separate')
            [CompletionResult]::new('--declaration', '--declaration', [CompletionResultType]::ParameterName, 'Generate .d.ts declaration files (requires type-checking via tsc)')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
        }
        'deno;bump-version' {
            [CompletionResult]::new('--workspace', '--workspace', [CompletionResultType]::ParameterName, 'Bump every package in the workspace (auto-detected at the workspace root)')
            [CompletionResult]::new('--no-workspace', '--no-workspace', [CompletionResultType]::ParameterName, 'Disable workspace mode and only bump the deno.json/package.json in the current directory')
            [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Print the planned changes without writing any files')
            [CompletionResult]::new('--start', '--start', [CompletionResultType]::ParameterName, '[conventional-commits mode] Git ref to start from. Default: latest tag (git describe --tags --abbrev=0)')
            [CompletionResult]::new('--base', '--base', [CompletionResultType]::ParameterName, '[conventional-commits mode] Git ref to compare against. Default: current branch')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Path to the import map to rewrite jsr: version constraints in. Defaults to the root deno.json (or its importMap target)')
            [CompletionResult]::new('--release-notes', '--release-notes', [CompletionResultType]::ParameterName, '[conventional-commits mode] Path to the release notes file to prepend. Default: Releases.md')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Explicit path to the manifest file to bump.
  May point to a `deno.json`/`deno.jsonc` or a `package.json`. When
  set, single-file mode is forced (workspace auto-detection is bypassed).
  Useful when both `deno.json` and `package.json` exist in the same
  directory.')
        }
        'deno;ci' {
            [CompletionResult]::new('--prod', '--prod', [CompletionResultType]::ParameterName, 'Only install production dependencies (excludes devDependencies)')
            [CompletionResult]::new('--skip-types', '--skip-types', [CompletionResultType]::ParameterName, 'Exclude @types/* packages from installation.
Be careful, as it uses a name-based heuristic and may skip packages that ship runtime code.')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
        }
        'deno;desktop' {
            [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Set type-checking behavior. This subcommand type-checks local modules by default, so passing --check is redundant; pass --check=all to also type-check remote modules. Alternatively, use the ''deno check'' subcommand.')
            [CompletionResult]::new('--inspect-renderer', '--inspect-renderer', [CompletionResultType]::ParameterName, 'Override the CEF renderer debugger listen address; defaults to an auto-allocated port')
            [CompletionResult]::new('--include', '--include', [CompletionResultType]::ParameterName, 'Includes an additional module or file/directory in the compiled executable.
  Use this flag if a dynamically imported module or a web worker main module
  fails to load in the executable or to embed a file or directory in the executable.
  This flag can be passed multiple times, to include multiple additional modules.')
            [CompletionResult]::new('--exclude', '--exclude', [CompletionResultType]::ParameterName, 'Excludes a file/directory in the compiled executable.
  Use this flag to exclude a specific file or directory within the included files.')
            [CompletionResult]::new('--exclude-unused-npm', '--exclude-unused-npm', [CompletionResultType]::ParameterName, 'Embed only the npm packages reachable from the module graph (managed npm; no node_modules directory).
  Without this flag the full managed npm snapshot from the lockfile / package.json is embedded.
  Reduces binary size when the lockfile contains packages the entrypoint does not import.
  Skips packages that are only reached through non-statically-analyzable dynamic imports;
  pass those with --include npm:<pkg> if needed.')
            [CompletionResult]::new('--output', '--output', [CompletionResultType]::ParameterName, 'Output path (e.g. MyApp.app, MyApp.dmg, MyApp.AppImage, MyApp.deb, MyApp.rpm, MyApp.msi)')
            [CompletionResult]::new('--target', '--target', [CompletionResultType]::ParameterName, 'Target OS architecture')
            [CompletionResult]::new('--no-code-cache', '--no-code-cache', [CompletionResultType]::ParameterName, 'Disable V8 code cache feature')
            [CompletionResult]::new('--icon', '--icon', [CompletionResultType]::ParameterName, 'Set the application icon (.ico on Windows, .icns or .png on macOS)')
            [CompletionResult]::new('--hmr', '--hmr', [CompletionResultType]::ParameterName, 'Run the desktop app with Hot Module Replacement enabled')
            [CompletionResult]::new('--backend', '--backend', [CompletionResultType]::ParameterName, 'Backend to use for the desktop app')
            [CompletionResult]::new('--engine', '--engine', [CompletionResultType]::ParameterName, 'JS engine the desktop binary runs on (quickjs is smaller and experimental, and does not receive the same security updates as v8)')
            [CompletionResult]::new('--all-targets', '--all-targets', [CompletionResultType]::ParameterName, 'Build for all supported target platforms')
            [CompletionResult]::new('--compress', '--compress', [CompletionResultType]::ParameterName, 'Make the packaged app self-extracting: the payload is compressed inside the app and unpacked on first launch. Off by default. Defaults to xz (decompressed by the system `tar` everywhere); zstd is smaller/faster but needs the `zstd` tool at runtime.')
            [CompletionResult]::new('--ext', '--ext', [CompletionResultType]::ParameterName, 'Set content type of the supplied file')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--inspect', '--inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port [default: 127.0.0.1:9229]. Host and port are optional. Using port 0 will assign a random free port.')
            [CompletionResult]::new('--inspect-brk', '--inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script')
            [CompletionResult]::new('--inspect-wait', '--inspect-wait', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and wait for debugger to connect before running user code')
            [CompletionResult]::new('--inspect-publish-uid', '--inspect-publish-uid', [CompletionResultType]::ParameterName, '')
            [CompletionResult]::new('--cached-only', '--cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
            [CompletionResult]::new('--location', '--location', [CompletionResultType]::ParameterName, 'Value of globalThis.location used by some web APIs')
            [CompletionResult]::new('--v8-flags', '--v8-flags', [CompletionResultType]::ParameterName, 'To see a list of all available flags use --v8-flags=--help
  Flags can also be set via the DENO_V8_FLAGS environment variable.
  Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable')
            [CompletionResult]::new('--seed', '--seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
            [CompletionResult]::new('--preload', '--preload', [CompletionResultType]::ParameterName, 'A list of files that will be executed before the main module')
            [CompletionResult]::new('--require', '--require', [CompletionResultType]::ParameterName, 'A list of CommonJS modules that will be executed before the main module')
            [CompletionResult]::new('--conditions', '--conditions', [CompletionResultType]::ParameterName, 'Use this argument to specify custom conditions for npm package exports. You can also use DENO_CONDITIONS env var.

Docs: https://docs.deno.com/go/conditional-exports')
            [CompletionResult]::new('--allow-scripts', '--allow-scripts', [CompletionResultType]::ParameterName, 'Allow running npm lifecycle scripts for the given packages
  Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)')
        }
        'deno;pack' {
            [CompletionResult]::new('--output', '--output', [CompletionResultType]::ParameterName, 'Output file path (defaults to <name>-<version>.tgz)')
            [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Show what would be packed without creating the tarball')
            [CompletionResult]::new('--allow-slow-types', '--allow-slow-types', [CompletionResultType]::ParameterName, 'Skip fast-check type extraction; .d.ts files are omitted from the output')
            [CompletionResult]::new('--allow-dirty', '--allow-dirty', [CompletionResultType]::ParameterName, 'Allow packing if the repository has uncommitted changes')
            [CompletionResult]::new('--set-version', '--set-version', [CompletionResultType]::ParameterName, 'Override the version in the tarball')
            [CompletionResult]::new('--no-source-maps', '--no-source-maps', [CompletionResultType]::ParameterName, 'Don''t include source maps in the output')
            [CompletionResult]::new('--ignore', '--ignore', [CompletionResultType]::ParameterName, 'Ignore files matching these patterns')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
        }
        'deno;x' {
            [CompletionResult]::new('--yes', '--yes', [CompletionResultType]::ParameterName, 'Assume confirmation for all prompts')
            [CompletionResult]::new('--package', '--package', [CompletionResultType]::ParameterName, 'Package to install (use when the binary name differs from the package name)')
            [CompletionResult]::new('--ignore-scripts', '--ignore-scripts', [CompletionResultType]::ParameterName, 'Do not run npm lifecycle scripts for the given packages')
            [CompletionResult]::new('--install-alias', '--install-alias', [CompletionResultType]::ParameterName, 'Creates a dx alias so you can run dx <command> instead of deno x <command>')
            [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Enable type-checking. This subcommand does not type-check by default; pass --check=all to also type-check remote modules. Alternatively, use the ''deno check'' subcommand.')
            [CompletionResult]::new('--env-file', '--env-file', [CompletionResultType]::ParameterName, 'Load environment variables from local file
  Only the first environment variable with a given key is used.
  Existing process environment variables are not overwritten, so if variables with the same names already exist in the environment, their values will be preserved.
  Where multiple declarations for the same environment variable exist in your .env file, the first one encountered is applied. This is determined by the order of the files you pass as arguments.')
            [CompletionResult]::new('--allow-scripts', '--allow-scripts', [CompletionResultType]::ParameterName, 'Allow running npm lifecycle scripts for the given packages
  Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)')
            [CompletionResult]::new('--no-check', '--no-check', [CompletionResultType]::ParameterName, 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored')
            [CompletionResult]::new('--import-map', '--import-map', [CompletionResultType]::ParameterName, 'Load import map file from local file or remote URL
  Docs: https://docs.deno.com/runtime/manual/basics/import_maps')
            [CompletionResult]::new('--no-remote', '--no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
            [CompletionResult]::new('--no-npm', '--no-npm', [CompletionResultType]::ParameterName, 'Do not resolve npm modules')
            [CompletionResult]::new('--node-modules-dir', '--node-modules-dir', [CompletionResultType]::ParameterName, 'Selects the node_modules directory mode for npm packages (not a path). One of: auto (create a local node_modules directory and install npm packages into it), manual (use the existing local node_modules directory, do not modify it), none (do not use a local node_modules directory; resolve npm packages from the global cache). Defaults to auto when the flag is passed without a value.')
            [CompletionResult]::new('--vendor', '--vendor', [CompletionResultType]::ParameterName, 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages')
            [CompletionResult]::new('--node-modules-linker', '--node-modules-linker', [CompletionResultType]::ParameterName, 'Sets the linker mode for npm packages (isolated or hoisted)')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Configure different aspects of deno including TypeScript, linting, and code formatting.
  Typically the configuration file will be called `deno.json` or `deno.jsonc` and
  automatically detected; in that case this flag is not necessary.
  Docs: https://docs.deno.com/go/config')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file')
            [CompletionResult]::new('--reload', '--reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript). With no value, reloads everything. Pass a comma-separated list of specifiers to reload only those modules; npm: reloads all npm modules; npm:chalk reloads a single npm module; jsr:@std/http/file-server,jsr:@std/assert/assert-equals reloads specific modules.')
            [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")')
            [CompletionResult]::new('--no-lock', '--no-lock', [CompletionResultType]::ParameterName, 'Disable auto discovery of the lock file')
            [CompletionResult]::new('--frozen-lockfile', '--frozen-lockfile', [CompletionResultType]::ParameterName, 'Error out if lockfile is out of date')
            [CompletionResult]::new('--cert', '--cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
            [CompletionResult]::new('--unsafely-ignore-certificate-errors', '--unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
            [CompletionResult]::new('--min-dep-age', '--min-dep-age', [CompletionResultType]::ParameterName, '(Unstable) The age in minutes, ISO-8601 duration or RFC3339 absolute timestamp (e.g. ''120'' for two hours, ''P2D'' for two days, ''2025-09-16'' for cutoff date, ''2025-09-16T12:00:00+00:00'' for cutoff time, ''0'' to disable)')
            [CompletionResult]::new('--cached-only', '--cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
            [CompletionResult]::new('--location', '--location', [CompletionResultType]::ParameterName, 'Value of globalThis.location used by some web APIs')
            [CompletionResult]::new('--v8-flags', '--v8-flags', [CompletionResultType]::ParameterName, 'To see a list of all available flags use --v8-flags=--help
  Flags can also be set via the DENO_V8_FLAGS environment variable.
  Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable')
            [CompletionResult]::new('--seed', '--seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
            [CompletionResult]::new('--preload', '--preload', [CompletionResultType]::ParameterName, 'A list of files that will be executed before the main module')
            [CompletionResult]::new('--require', '--require', [CompletionResultType]::ParameterName, 'A list of CommonJS modules that will be executed before the main module')
            [CompletionResult]::new('--conditions', '--conditions', [CompletionResultType]::ParameterName, 'Use this argument to specify custom conditions for npm package exports. You can also use DENO_CONDITIONS env var.

Docs: https://docs.deno.com/go/conditional-exports')
            [CompletionResult]::new('--inspect', '--inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port [default: 127.0.0.1:9229]. Host and port are optional. Using port 0 will assign a random free port.')
            [CompletionResult]::new('--inspect-brk', '--inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script')
            [CompletionResult]::new('--inspect-wait', '--inspect-wait', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and wait for debugger to connect before running user code')
            [CompletionResult]::new('--inspect-publish-uid', '--inspect-publish-uid', [CompletionResultType]::ParameterName, '')
        }
        'deno;json_reference' {
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
