require("nvchad.autocmds")

local autocmd, augroup = vim.api.nvim_create_autocmd, vim.api.nvim_create_augroup

-- Disable persistent undo for files in /private directory

local noundo_augroup = augroup("DisablePersistentUndoPrivate", { clear = true })

autocmd("BufReadPre", {
    group = noundo_augroup,
    pattern = "/private/*",
    command = "set noundofile",
})

-- Highlight yanked text

-- local yank_highlight_id = augroup("highlightyank", { clear = true })

-- https://github.com/jakesjews/Dot-Files-And-Scripts/blob/088138f25c16f89f206af6be9756175b3bb682da/init.lua
-- autocmd("TextYankPost", {
--     group = yank_highlight_id,
--     callback = function()
--         vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200, on_visual = true })
--     end,
-- })

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

-- Create command for LSP attach to close hover window

-- https://vi.stackexchange.com/a/43436
local hover_close = function(base_win_id)
    local windows = vim.api.nvim_tabpage_list_wins(0)
    for _, win_id in ipairs(windows) do
        if win_id ~= base_win_id then
            local win_cfg = vim.api.nvim_win_get_config(win_id)
            if win_cfg.relative == "win" and win_cfg.win == base_win_id then
                vim.api.nvim_win_close(win_id, {})
                break
            end
        end
    end
end

-- Later, or in another file, when you create keymaps for LSP
local lspattach_augroup = augroup("LspHoverClose", { clear = true })

autocmd("LspAttach", {
    group = lspattach_augroup,
    callback = function(ev)
        vim.keymap.set("n", "<Leader>;", function()
            hover_close(vim.api.nvim_get_current_win())
        end, { remap = false, silent = true, buffer = ev.buf, desc = "Close hover window" })
    end,
})

-- Set conceallevel for markdown files

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
