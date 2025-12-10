return {
    default = function(_)
        local success, node = pcall(vim.treesitter.get_node)
        if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
            return { "lsp", "buffer", "path" }
        end

        -- By default, the buffer source will only show when the LSP
        -- source is disabled or returns no items.
        return { "lsp", "snippets", "codecompanion", "unitex" }
    end,
    per_filetype = {
        lua = { inherit_defaults = true, "lazydev" },
        gitcommit = { "git", "buffer" },
        octo = { "git", "buffer" },
        gitrebase = { "git", "buffer", "path" },
        plaintex = { "lsp", "snippets", "buffer", "path" },
        tex = { "lsp", "snippets", "buffer", "path" },
        rmd = { inherit_defaults = true, "nerdfont" },
        quarto = { inherit_defaults = true, "nerdfont" },
        markdown = { inherit_defaults = true, "nerdfont" },
        codecompanion = { inherit_defaults = true, "nerdfont" },
        cs = { inherit_defaults = true, "easy-dotnet" },
        csproj = { inherit_defaults = true, "easy-dotnet" },
        sln = { inherit_defaults = true, "easy-dotnet" },
        slnx = { inherit_defaults = true, "easy-dotnet" },
    },
    providers = {
        path = {
            score_offset = -5,
            opts = {
                -- https://cmp.saghen.dev/recipes#path-completion-from-cwd-instead-of-current-buffer-s-directory
                get_cwd = function(_)
                    return vim.fn.getcwd()
                end,
            },
        },
        snippets = {
            score_offset = 7,
            -- https://www.reddit.com/r/neovim/comments/1jb29tw/comment/mhuoecs/
            should_show_items = function(ctx)
                return ctx.trigger.initial_kind ~= "trigger_character"
                --    and not require("blink.cmp").snippet_active()
            end,
        },
        buffer = { score_offset = -10, min_keyword_length = 4 },
        lazydev = {
            name = "Lazydev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority
            score_offset = 100,
            fallbacks = { "lsp" },
        },
        -- https://github.com/GustavEikaas/easy-dotnet.nvim#using-blinkcmp
        ["easy-dotnet"] = {
            name = "easy-dotnet",
            enabled = true,
            module = "easy-dotnet.completion.blink",
            score_offset = 10000,
            async = true,
        },
        cmdline = {
            -- when typing a command, only show when the keyword is 3 characters or longer
            min_keyword_length = function(ctx)
                if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                    return 3
                end
                return 0
            end,
            -- https://cmp.saghen.dev/recipes.html#disable-completion-in-only-shell-command-mode
            -- ignores cmdline completions when executing shell commands
            enabled = function()
                return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
            end,
        },
        lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            -- Exclude keywords/constants from autocomplete
            transform_items = function(_, items)
                return vim.tbl_filter(function(item)
                    return item.kind ~= require("blink.cmp.types").CompletionItemKind.Keyword
                end, items)
            end,
            min_keyword_length = function(ctx)
                if vim.bo.filetype == "cs" then
                    return 1
                end
                return 2
            end,
        },
        codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
        },
        nerdfont = {
            name = "nerdfont",
            module = "blink.compat.source",
        },
        unitex = {
            name = "unitex",
            module = "blink.compat.source",
            min_keyword_length = 2,
        },
        git = {
            module = "blink-cmp-git",
            name = "Git",
            enabled = function()
                return vim.tbl_contains({ "octo", "gitcommit", "gitrebase" }, vim.bo.filetype)
            end,
            opts = {},
        },
    },
}
