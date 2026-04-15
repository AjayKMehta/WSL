local lsp = require("utils.lsp")
local on_attach = lsp.on_attach

local capabilities = lsp.get_capabilities()

dofile(vim.g.base46_cache .. "lsp")

vim.lsp.config("*", {
    on_attach = on_attach,
    capabilities = capabilities,
    root_markers = { ".git" },
})

-- The lsp name must match the name of the file that contains the lsp configuration.
vim.lsp.enable({
    "air",
    -- "ast_grep",
    "basedpyright",
    "bashls",
    "dockerls",
    "docker_compose",
    "jsonls",
    "lemminx",
    "ltex",
    "lua_ls",
    "marksman",
    "panache",
    "powershell",
    "r_language_server",
    "roslyn",
    "ruff",
    "taplo",
    "texlab",
    "yaml",
})
