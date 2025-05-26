local ts = require("nvim-treesitter")

local config = {
    -- ensure_installed = "all",
    auto_install = true,
    autopairs = {
        enable = vim.g.use_autopairs,
    },
    indent = { enable = true, disable = { "python", "css" } },
    autotag = {
        enable = true,
    },
    highlight = {
        enable = true,
        disable = function(lang, buf)
            local max_filesize = 200 * 1024 -- 200 KB
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
    "diff",
    "dockerfile",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "haskell",
    "html",
    "javascript",
    "jq",
    "json",
    "json5",
    "jsonc",
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

local already_installed = require("nvim-treesitter.config").installed_parsers()
local to_install = vim.iter(ensure_installed)
    :filter(function(parser)
        return not vim.tbl_contains(already_installed, parser)
    end)
    :totable()
ts.install(to_install)
