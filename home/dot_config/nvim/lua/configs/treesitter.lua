local ts = require("nvim-treesitter")

local config = {
    -- ensure_installed = "all",
    auto_install = true,
    autopairs = {
        enable = not vim.g.use_blink,
    },
    indent = { enable = true, disable = { "python", "css" } },
    autotag = {
        enable = true,
    },
    highlight = {
        enable = true,
        disable = function(lang, buf)
            if vim.bo[buf].filetype == "codecompanion" then
                return false
            end
            local max_filesize = 5 * 1024 * 1024 -- 5MB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        use_languagetree = true,
    },
}

dofile(vim.g.base46_cache .. "semantic_tokens")
dofile(vim.g.base46_cache .. "treesitter")

ts.setup(config)

local ensure_installed = {
    "bash",
    "c_sharp",
    "c",
    "cmake",
    "comment",
    "css",
    "csv",
    "diff",
    "dockerfile",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "gpg",
    "haskell",
    "html",
    "http",
    "javascript",
    "jq",
    "json",
    "json5",
    "latex",
    "lua",
    "luadoc",
    "luap",
    "markdown_inline",
    "markdown",
    "mermaid",
    "powershell",
    "python",
    "query",
    "r",
    "regex",
    "rnoweb",
    "sql",
    "terraform",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "zathurarc",
}

ts.install(ensure_installed)

vim.treesitter.language.register("xml", { "csproj", "svg", "xslt" })
vim.treesitter.language.register("markdown", { "codecompanion", "quarto" })

-- https://github.com/R-nvim/R.nvim/wiki/Configuration#support-for-webr-and-pyodide
vim.treesitter.language.register("r", "webr")
vim.treesitter.language.register("python", "pyodide")
