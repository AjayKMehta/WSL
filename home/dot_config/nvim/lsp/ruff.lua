return {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    cmd_env = { RUFF_TRACE = "messages" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
    init_options = {
        settings = {
            configurationPreference = "filesystemFirst",
            format = {
                preview = true,
            },
            lint = {
                preview = true,
            },
            showSyntaxErrors = false,
        },
    },
}
