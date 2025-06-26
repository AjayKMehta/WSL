-- https://www.youtube.com/watch?v=NecszftvMFI
vim.filetype.add({
    extension = {
        csproj = "xml",
        jq = "jq",
        qmd = "markdown",
        gitconfig = "gitconfig",
        http = "http",
        query = "query",
    },
    filename = {
        ["Directory.Build.targets"] = "xml",
        [".eslintrc.json"] = "jsonc",
    },
    pattern = {
        ["Directory.*.props"] = "xml",
        [".*%.scm"] = "query",
        [".*/%.vscode/.*%.json"] = "jsonc",
    },
})
