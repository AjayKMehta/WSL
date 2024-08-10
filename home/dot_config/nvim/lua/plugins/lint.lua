return {
    {
        -- An asynchronous linter plugin
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            -- Event to trigger linters
            events = { "BufWritePost", "BufReadPost", "InsertLeave" },
            linters_by_ft = {
                bash = { "shellcheck" },
                dockerfile = { "hadolint" },
                editorconfig = { "editorconfig-checker" },
                haskell = { "hlint" },
                html = { "tidy" },
                json = { "jsonlint" },
                jsonc = { "jsonlint" },
                lua = { "selene" },
                markdown = { "markdownlint" },
                python = { "mypy", "ruff" },
                sh = { "shellcheck" },
                tex = { "chktex", "lacheck" },
                yaml = { "yamllint" },
            },
        },
        config = function(_, opts)
            local lint = require("lint")

            -- See https://github.com/petobens/dotfiles/blob/08ef71fe8772cd107ac0a141cdefabf9cf2acb93/nvim/lua/plugin-config/nvimlint_config.lua
            -- Linter config/args
            local linters = lint.linters
            ---- Markdown
            linters.markdownlint.args = { "--config=" .. vim.env.HOME .. "/.markdownlint.json" }
            ---- Python
            local ruff_severities = {
                ["E"] = vim.diagnostic.severity.ERROR,
                ["F8"] = vim.diagnostic.severity.ERROR,
                ["F"] = vim.diagnostic.severity.WARN,
                ["C4"] = vim.diagnostic.severity.WARN,
                ["EM"] = vim.diagnostic.severity.WARN,
                ["W"] = vim.diagnostic.severity.WARN,
                ["D"] = vim.diagnostic.severity.INFO,
                ["B"] = vim.diagnostic.severity.INFO,
            }
            local ruff_parser = linters.ruff.parser
            local function starts_with(str, start)
                return str:sub(1, #start) == start
            end

            linters.ruff.parser = function(output, bufnr)
                local diagnostics = ruff_parser(output, bufnr)
                for _, v in pairs(diagnostics) do
                    if starts_with(v.code, "RET") then
                        return vim.diagnostic.severity.WARN
                    end

                    local code = string.sub(v.code, 1, 2)

                    if code ~= "F8" or code ~= "C4" or code ~= "EM" then
                        code = string.sub(code, 1, 1)
                    end
                    local new_severity = ruff_severities[code]
                    if new_severity ~= nil then
                        v.severity = new_severity
                    else
                        -- Default to INFO if not mapped.
                        v.severity = vim.diagnostic.severity.WARN
                    end
                end
                return diagnostics
            end
            ---- TeX
            linters.chktex.args = vim.list_extend(vim.deepcopy(linters.chktex.args), {
                "-wall",
                "-n22",
                "-n30",
                "-e16",
                "-q",
                "-n46",
            })
            linters.chktex.ignore_exitcode = true

            -- Keymap

            vim.keymap.set("n", "<leader>ll", function()
                lint.try_lint()
            end, { desc = "Trigger linting for current file" })
        end,
    },
}
