return {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    cmd_env = { RUFF_TRACE = "messages" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
    -- single_file_support = true,
    settings = {
        lint = {
            preview = true,
        },
        showSyntaxErrors = false,
    },
}
