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
