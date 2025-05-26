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
autocmd('InsertCharPre', {
    pattern = '*.cs',
    callback = function()
    local char = vim.v.char

    if char ~= "/" then
        return
    end

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row, col = row - 1, col + 1
    local bufnr = vim.api.nvim_get_current_buf()
    local uri = vim.uri_from_bufnr(bufnr)

    local params = {
        _vs_textDocument = { uri = uri },
        _vs_position = { line = row, character = col },
        _vs_ch = char,
        _vs_options = { tabSize = 4, insertSpaces = true },
    }

    -- NOTE: we should send textDocument/_vs_onAutoInsert request only after buffer has changed.
    vim.defer_fn(function()
        vim.lsp.buf_request(bufnr, "textDocument/_vs_onAutoInsert", params)
    end, 1)
    end,
  })

-- https://github.com/olimorris/codecompanion.nvim/discussions/640#discussioncomment-12057645
-- https://github.com/olimorris/codecompanion.nvim/discussions/640#discussioncomment-12057645
local M = {}

local ns_id = vim.api.nvim_create_namespace("spinner")

M.config = {
    spinner = {
        text = "",
        -- text = "",
        hl_positions = {
            { 0, 3 }, -- First circle
            { 3, 6 }, -- Second circle
            { 6, 9 }, -- Third circle
        },
        interval = 100,
        hl_group = "Title",
        hl_dim_group = "NonText",
    },
}

local spinner_state = {
    timer = nil,
    win = nil,
    buf = nil,
    frame = 1,
}

local function create_spinner_window()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

    local win = vim.api.nvim_open_win(buf, false, {
        relative = "cursor",
        row = -1,
        col = 0,
        width = 3,
        height = 1,
        style = "minimal",
        focusable = false,
    })

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { M.config.spinner.text })

    -- Set the dim highlight for the entire text
    vim.api.nvim_buf_set_extmark(buf, ns_id, 0, 0, {
        end_col = 9,
        hl_group = M.config.spinner.hl_dim_group,
        priority = vim.highlight.priorities.user - 1,
    })

    return buf, win, ns_id
end

function M.start_spinner()
    if spinner_state.timer then
        return
    end

    local buf, win = create_spinner_window()
    spinner_state.buf = buf
    spinner_state.win = win

    spinner_state.timer = vim.loop.new_timer()
    spinner_state.timer:start(
        0,
        M.config.spinner.interval,
        vim.schedule_wrap(function()
            if
                spinner_state.win == nil
                or spinner_state.buf == nil
                or not (vim.api.nvim_win_is_valid(spinner_state.win) and vim.api.nvim_buf_is_valid(spinner_state.buf))
            then
                M.stop_spinner()
                return
            end

            -- Update window position relative to cursor
            local ok = pcall(vim.api.nvim_win_set_config, spinner_state.win, {
                relative = "cursor",
                row = -1,
                col = 0,
            })

            -- If window update failed, stop the spinner
            if not ok then
                M.stop_spinner()
                return
            end
            vim.api.nvim_buf_clear_namespace(spinner_state.buf, ns_id, 0, -1)

            vim.api.nvim_buf_set_extmark(spinner_state.buf, ns_id, 0, 0, {
                end_col = 9,
                hl_group = M.config.spinner.hl_dim_group,
                priority = vim.highlight.priorities.user - 1,
            })

            -- Set animation highlight
            local hl_pos = M.config.spinner.hl_positions[spinner_state.frame]
            vim.api.nvim_buf_set_extmark(spinner_state.buf, ns_id, 0, hl_pos[1], {
                end_col = hl_pos[2],
                hl_group = M.config.spinner.hl_group,
                priority = vim.highlight.priorities.user + 1,
            })

            spinner_state.frame = (spinner_state.frame % #M.config.spinner.hl_positions) + 1
        end)
    )
end

function M.stop_spinner()
    if spinner_state.timer then
        spinner_state.timer:stop()
        spinner_state.timer:close()
        spinner_state.timer = nil
    end

    -- safely close the window if it exists and is valid
    if spinner_state.win then
        pcall(vim.api.nvim_win_close, spinner_state.win, true)
        spinner_state.win = nil
    end

    if spinner_state.buf then
        pcall(vim.api.nvim_buf_delete, spinner_state.buf, { force = true })
        spinner_state.buf = nil
    end
    spinner_state.frame = 1
end

autocmd("User", {
    pattern = {
        "CodeCompanionRequestStarted",
        "CodeCompanionRequestFinished",
    },
    callback = function(args)
        if args.match == "CodeCompanionRequestStarted" then
            M.start_spinner()
        elseif args.match == "CodeCompanionRequestFinished" then
            M.stop_spinner()
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
