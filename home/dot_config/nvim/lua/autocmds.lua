require("nvchad.autocmds")

local autocmd, augroup = vim.api.nvim_create_autocmd, vim.api.nvim_create_augroup

-- Disable persistent undo for files in /private directory

autocmd("BufReadPre", { pattern = "/private/*", command = "set noundofile" })

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
autocmd("LspAttach", {
    callback = function(ev)
        vim.keymap.set("n", "<Leader>;", function()
            hover_close(vim.api.nvim_get_current_win())
        end, { remap = false, silent = true, buffer = ev.buf, desc = "Close hover window" })
    end,
})

-- Set conceallevel for markdown files

-- https://github.com/catgoose/nvim/blob/main/lua/config/autocmd.lua#L2
local set_filetype = augroup("SetFileTypeOptLocalOptions", { clear = true })

autocmd({ "FileType" }, {
    group = set_filetype,
    pattern = { "*.*md" },
    callback = function()
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

local lint_augroup = augroup("lint", { clear = true })

autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = debounce(100, function()
        require("lint").try_lint()
    end),
})

-- https://nvchad.com/docs/recipes/#restore_cursor_position

autocmd("BufReadPost", {
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
