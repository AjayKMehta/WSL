return {
    {
        -- An asynchronous linter plugin
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                bash = { "shellcheck" },
                dockerfile = { "hadolint" },
                editorconfig = { "editorconfig-checker" },
                ghaction = { "actionlint", "zizmor" },
                haskell = { "hlint" },
                html = { "tidy" },
                json = { "jsonlint" },
                jsonc = { "jsonlint" },
                lua = { "selene" },
                markdown = { "markdownlint-cli2" },
                python = { "ruff" },
                quarto = { "panache" },
                rmd = { "panache" },
                sh = { "shellcheck" },
                tex = { "chktex", },
                yaml = { "yamllint", "yq" },
            }

            -- Linter config/args
            local linters = lint.linters
            ---- Markdown
            linters["markdownlint-cli2"].args = { "--config=" .. vim.env.HOME .. "/.markdownlint.json" }

            -- Quarto
            local function get_file_name()
                return vim.api.nvim_buf_get_name(0)
            end

            local severity_map = {
                ["error"] = vim.diagnostic.severity.ERROR,
                ["warning"] = vim.diagnostic.severity.WARN,
                ["information"] = vim.diagnostic.severity.INFO,
            }

            -- warning[undefined-reference-label]: Reference label '[2]' not found at <stdin>:1:5
            local pattern = "(%w+)%[([^%]]+)%]:%s?(.+)%s+([^:]+):(%d+):(%d+)"
            -- This also works: (%w+)%[(%S+)%]:%s?([^:]+)%s(%S+):(%d+):(%d+)
            local groups = { "severity", "code", "message", "file", "lnum", "col" }
            local defaults = {["source"] = "panache"}

            linters.panache = {
                cmd = "panache",
                args = { "lint", "--message-format", "short", "--stdin-filename", get_file_name },
                parser = require('lint.parser').from_pattern(pattern, groups, severity_map, defaults)
            }

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

            -- Lint code automatically

            local function debounce(ms, fn)
                local timer = vim.uv.new_timer()
                return function(...)
                    local argv = { ... }
                    timer:start(ms, 0, function()
                        timer:stop()
                        ---@diagnostic disable-next-line: deprecated
                        vim.schedule_wrap(fn)(unpack(argv))
                    end)
                end
            end

            local lint_augroup = vim.api.nvim_create_augroup("Autolint", { clear = true })

            vim.api.nvim_create_autocmd({
                "BufEnter",
                "BufWritePost",
                "InsertLeave",
                "TextChanged",
            }, {
                desc = "nvim-lint",
                group = lint_augroup,
                callback = debounce(100, function()
                    require("lint").try_lint()
                end),
            })

            -- Keymap

            vim.keymap.set("n", "<leader>ll", lint.try_lint, { desc = "Trigger linting for current file" })
        end,
    },
}
