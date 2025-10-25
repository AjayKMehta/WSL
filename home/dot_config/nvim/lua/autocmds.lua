require("nvchad.autocmds")
local autocmd, augroup = vim.api.nvim_create_autocmd, vim.api.nvim_create_augroup

-- Disable persistent undo for files in /private directory

local noundo_augroup = augroup("DisablePersistentUndoPrivate", { clear = true })

autocmd("BufReadPre", {
    group = noundo_augroup,
    pattern = "/private/*",
    command = "set noundofile",
})

-- https://github.com/catgoose/nvim/blob/main/lua/config/autocmd.lua#L2
local conceallevel_augroup = augroup("SetConcealLevel", { clear = true })

autocmd({ "FileType" }, {
    group = conceallevel_augroup,
    pattern = { "*.*md" },
    callback = function()
        -- TODO: Look into changing this?
        vim.opt_local.conceallevel = 2
    end,
})

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

local lint_augroup = augroup("Autolint", { clear = true })

autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = debounce(100, function()
        require("lint").try_lint()
    end),
})

-- https://nvchad.com/docs/recipes/#restore_cursor_position

local restore_augroup = augroup("RestoreCursorPos", { clear = true })

autocmd("BufReadPost", {
    group = restore_augroup,
    pattern = "*",
    callback = function()
        local line = vim.fn.line("'\"")
        if
            line > 1
            and line <= vim.fn.line("$")
            and vim.bo.filetype ~= "commit"
            and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
        then
            vim.cmd('normal! g`"')
        end
    end,
})

-- always open quickfix window automatically.
-- this uses cwindows which will open it only if there are entries.
-- vim.api.nvim_create_autocmd("QuickFixCmdPost", {
--     group = vim.api.nvim_create_augroup("AutoOpenQuickfix", { clear = true }),
--     pattern = { "[^l]*" },
--     command = "cwindow",
-- })

if vim.g.nvim_comment then
    -- https://github.com/neovim/neovim/pull/28176#issuecomment-2051944146
    local comment_augroup = augroup("CommentIncSpaces", { clear = true })
    autocmd({ "FileType" }, {
        group = comment_augroup,
        desc = "Force commentstring to include spaces",
        -- group = ...,
        callback = function(event)
            local cs = vim.bo[event.buf].commentstring
            vim.bo[event.buf].commentstring = cs:gsub("(%S)%%s", "%1 %%s"):gsub("%%s(%S)", "%%s %1")
        end,
    })
end

-- https://www.reddit.com/r/neovim/comments/1cwd181/comment/l4wqmza/
-- autocmd("BufEnter", {
--     callback = function(ctx)
--         local bufPath = ctx.file
--         local specialBuffer = vim.api.nvim_get_option_value("buftype", { buf = ctx.buf }) ~= ""
--         local exists = vim.uv.fs_stat(bufPath) ~= nil
--         if specialBuffer or not exists then
--             return
--         end
--         local root = vim.fs.root(0, { ".git", "Makefile" })
--         if root then
--             vim.uv.chdir(root)
--         end
--     end,
-- })

local nospell_augroup = augroup("DisableSpell", { clear = true })
autocmd({ "BufRead", "BufNewFile" }, {
    group = nospell_augroup,
    pattern = {
        "*.log",
        "*.log.gz",
    },
    command = ":setlocal nospell",
})

-- https://github.com/folke/snacks.nvim/blob/main/docs/rename.md#nvim-tree
local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
autocmd("User", {
    pattern = "NvimTreeSetup",
    callback = function()
        local events = require("nvim-tree.api").events
        events.subscribe(events.Event.NodeRenamed, function(data)
            if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
                data = data
                Snacks.rename.on_rename_file(data.old_name, data.new_name)
            end
        end)
    end,
})

-- https://github.com/seblj/roslyn.nvim/wiki#diagnostic-refresh
autocmd({ "InsertLeave" }, {
    pattern = "*",
    callback = function()
        local clients = vim.lsp.get_clients({ name = "roslyn" })
        if not clients or #clients == 0 then
            return
        end

        local buffers = vim.lsp.get_buffers_by_client_id(clients[1].id)
        for _, buf in ipairs(buffers) do
            vim.lsp.util._refresh("textDocument/diagnostic", { bufnr = buf })
        end
    end,
})

-- https://github.com/seblyng/roslyn.nvim/wiki#textdocument_vs_onautoinsert
autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        if client and (client.name == "roslyn" or client.name == "roslyn_ls") then
            vim.api.nvim_create_autocmd("InsertCharPre", {
                desc = "Roslyn: Trigger an auto insert on '/'.",
                buffer = bufnr,
                callback = function()
                    local char = vim.v.char

                    if char ~= "/" then
                        return
                    end

                    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                    row, col = row - 1, col + 1
                    local uri = vim.uri_from_bufnr(bufnr)

                    local params = {
                        _vs_textDocument = { uri = uri },
                        _vs_position = { line = row, character = col },
                        _vs_ch = char,
                        _vs_options = {
                            tabSize = vim.bo[bufnr].tabstop,
                            insertSpaces = vim.bo[bufnr].expandtab,
                        },
                    }

                    -- NOTE: We should send textDocument/_vs_onAutoInsert request only after
                    -- buffer has changed.
                    vim.defer_fn(function()
                        client:request(
                            ---@diagnostic disable-next-line: param-type-mismatch
                            "textDocument/_vs_onAutoInsert",
                            params,
                            function(err, result, _)
                                if err or not result then
                                    return
                                end

                                vim.snippet.expand(result._vs_textEdit.newText)
                            end,
                            bufnr
                        )
                    end, 1)
                end,
            })
        end
    end,
})

if require("utils").is_loaded("snacks") then
    autocmd("BufEnter", {
        callback = function(args)
            local buf = args.buf
            if Snacks.git.get_root(buf) == nil then
                return
            end
            local map_buf = require("utils.mappings").map_buf

            map_buf(buf, "n", "<leader>gf", function()
                Snacks.picker.git_files({ untracked = true })
            end, "Git Find Files")

            map_buf(buf, "n", "<leader>gb", Snacks.picker.git_branches, "Git Branches")

            map_buf(buf, { "n", "v" }, "<leader>gB", function()
                Snacks.gitbrowse()
            end, "Git Browse")

            map_buf(buf, "n", "<leader>gL", Snacks.picker.git_log, "Git Log")

            map_buf(buf, "n", "<leader>gll", Snacks.picker.git_log_line, "Git Log Line")

            map_buf(buf, "n", "<leader>gS", Snacks.picker.git_status, "Git Status")

            map_buf(buf, "n", "<leader>gdh", Snacks.picker.git_diff, "Git Diff (Hunks)")

            map_buf(buf, "n", "<leader>glf", Snacks.picker.git_log_file, "Git Log File")
        end,
    })
end

-- https://neovim.io/doc/user/lsp.html#vim.lsp.foldexpr()
-- Prefer LSP folding if client supports it
autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client:supports_method("textDocument/foldingRange") then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end
    end,
})

-- TODO: Look into solution based on installed parsers, i.e. no hardcoding.
-- Based on https://www.reddit.com/r/neovim/comments/1kuj9xm/comment/mubg2cm
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "bash",
        "c",
        "cmake",
        "codecompanion",
        "css",
        "diff",
        "dockerfile",
        "gitconfig",
        "gitrebase",
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
        "jsonc",
        "lua",
        "make",
        "markdown",
        "mermaid",
        "ps1", -- PowerShell
        "python",
        "quarto",
        "r",
        "sql",
        "toml",
        "typescript",
        "vim",
        "help", -- for vimdoc
        "xml",
        "yaml",
    },
    callback = function()
        vim.treesitter.start()
    end,
})

-- https://igorlfs.github.io/nvim-dap-view/filetypes-autocmds#example-autocommand
autocmd({ "FileType" }, {
    pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
    callback = function(evt)
        vim.keymap.set("n", "q", "<C-w>q", { buffer = evt.buf })
    end,
})
