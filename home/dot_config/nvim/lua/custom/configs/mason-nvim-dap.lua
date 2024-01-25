require("mason").setup()
require("mason-nvim-dap").setup({
    ensure_installed = { "python", "bash", "cppdbg", "coreclr", "haskell", "jq", "stylua" }
})
