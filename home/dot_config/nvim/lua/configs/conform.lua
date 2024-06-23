local conform = require("conform")

conform.setup({
    formatters = {
        -- stack install cabal-fmt
        -- Not listed in Mason registry.
        cabal_fmt = {
            meta = {
                url = "https://hackage.haskell.org/package/cabal-fmt",
                description = "Format cabal files with cabal-fmt",
            },
            command = "cabal-fmt",
        },
        cbfmt = {
            prepend_args = {
                "--config",
                vim.env.HOME .. "/.cbfmt.toml",
            },
        },
        markdownlint = {
            prepend_args = {
                "--config",
                vim.env.HOME .. "/.markdownlint.json",
            },
        },
        injected = {
            options = {
                -- Map of treesitter language to file extension
                -- A temporary file name with this extension will be generated during formatting
                -- because some formatters care about the filename.
                lang_to_ext = {
                    bash = "sh",
                    c_sharp = "cs",
                    julia = "jl",
                    latex = "tex",
                    markdown = "md",
                    python = "py",
                    ruby = "rb",
                    rust = "rs",
                    typescript = "ts",
                    r = "r",
                },
                lang_to_formatters = {
                    json = { "jq" },
                    python = "ruff",
                },
            },
        },
    },
    format_on_save = function(bufnr)
        -- Disable autoformat on certain filetypes
        local ignore_filetypes = { "sql", "python" }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
            return
        end
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        -- Disable autoformat for files in a certain path
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
            return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    -- If you specify more than one formatter, they will be executed in the order you list them.
    formatters_by_ft = {
        bash = { "shellcheck" },
        -- dotnet format doesn't work on files or ranges 🙁
        cs = { "csharpier" },
        cabal = { "cabal_fmt" },
        haskell = { "fourmolu" },
        json = { "fixjson" },
        json5 = { "fixjson" },
        jsonc = { "fixjson" },
        lua = { "stylua" },
        markdown = { "markdownlint", "cbfmt", "injected" },
        python = { "ruff" },
        query = { "format-queries" },
        sql = { "sql-formatter" },
        tex = { "latexindent" },
        toml = { "taplo" },
        xml = { "xmllint" },
        yaml = { "yamlfix" },
        -- Use the "*" filetype to run formatters on all filetypes.
        -- ["*"] = {},
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = { "trim_whitespace" },
    },
})

-- Keymap

-- In normal mode it will apply to the whole file, in visual mode it will apply to the current selection.
vim.keymap.set({ "n", "v" }, "<leader>lf", function()
    conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 5000,
    })
end, { desc = "Format file or range (in visual mode)" })

--#region Commands

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable auto-formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat on save",
    bang = true,
})

-- Enable auto-format on save
vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Enable autoformat on save",
})

--endregion
