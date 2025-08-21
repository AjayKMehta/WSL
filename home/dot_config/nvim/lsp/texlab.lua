return {

    cmd = { "texlab" },
    filetypes = { "tex", "plaintex", "bib" },
    root_markers = { ".git", ".latexmkrc", ".texlabroot", "texlabroot", "Tectonic.toml" },
    -- https://github.com/latex-lsp/texlab/wiki/configurations
    settings = {
        texlab = {
            bibtexFormatter = "texlab",
            build = {
                auxDirectory = ".",
                executable = "tectonic",
                -- Use V1 CLI. See https://tectonic-typesetting.github.io/book/latest/ref/v2cli.html.
                args = { "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
                forwardSearchAfter = false,
                onSave = false,
            },
            chktex = {
                onEdit = false,
                onOpenAndSave = true,
            },
            diagnosticsDelay = 300,
            diagnostics = {
                ignoredPatterns = {
                    "Overfull",
                    "Underfull",
                    "Package hyperref Warning",
                    "Float too large for page",
                    "contains only floats",
                },
            },
            formatterLineLength = 80,
            forwardSearch = {
                executable = "zathura",
                args = { "--synctex-forward", "%l:1:%f", "%p" },
            },
            latexFormatter = "latexindent",
            latexindent = {
                ["local"] = nil, -- local is a reserved keyword
                modifyLineBreaks = false,
            },
        },
    },
}
