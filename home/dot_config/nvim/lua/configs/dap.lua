local utils = require("utils.mappings")
local map_desc = utils.map_desc

local dap = require("dap")

local mason_path = vim.fn.stdpath("data") .. "/mason"

-- https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt
require("dap.ext.vscode").json_decode = require("json5").parse

dofile(vim.g.base46_cache .. "dap")

-- Mappings
-- Keep same as VS + VS Code
map_desc({ "n", "v" }, "<F9>", "<cmd>DapToggleBreakpoint<CR>", "DAP Toggle breakpoint")
-- <C-S-F9> doesn't work!
map_desc("n", "<F8>", "<cmd>DapClearBreakpoints<CR>", "DAP Clear breakpoints")
map_desc("n", "<F5>", "<cmd>DapContinue<CR>", "DAP Launch debugger")
map_desc("n", "<F10>", "<cmd>DapStepOver<CR>", "DAP Step over")
map_desc("n", "<Leader>dc", dap.run_to_cursor, "DAP Run To Cursor")
map_desc("n", "<F11>", "<cmd>DapStepInto<CR>", "DAP Step into")
map_desc("n", "<S-F11>", "<cmd>DapStepOut<CR>", "DAP Step out")
map_desc("n", "<Leader>dr", "<cmd>DapToggleRepl<CR>", "DAP Toggle REPL")
map_desc({ "n", "v" }, "<Leader>dh", function()
    require("dap.ui.widgets").hover()
end, "DAP Hover")
map_desc({ "n", "v" }, "<Leader>dp", function()
    require("dap.ui.widgets").preview()
end, "DAP Preview")

map_desc("n", "<leader>dj", dap.down, "DAP Go down stack frame")
map_desc("n", "<leader>dk", dap.up, "DAP Go up stack frame")

map_desc({ "n", "v" }, "<leader>dtc", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "DAP Set conditional breakpoint")

map_desc("n", "<leader>dlm", function()
    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, "DAP Set Log Point")

-- DAP View
local dv = require("dap-view")
dap.listeners.before.attach["dap-view-config"] = function()
    dv.open()
end
dap.listeners.before.launch["dap-view-config"] = function()
    dv.open()
end
dap.listeners.before.event_terminated["dap-view-config"] = function()
    dv.close()
    vim.cmd("DapVirtualTextForceRefresh") -- Clear virtual text after session is terminated
end
dap.listeners.before.event_exited["dap-view-config"] = function()
    dv.close()
end

-- Setup icons
vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#990000" })
vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#3d59a1" })
vim.api.nvim_set_hl(0, "DapStopped", { fg = "#9ece6a" })

vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "DapBreakpoint" })
vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = "🟠", texthl = "DapBreakpoint", linehl = "", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
    "DapLogPoint",
    { text = "✳️", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define("DapStopped", { text = "⭕", texthl = "", linehl = "DapStopped", numhl = "" })
vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = "🚫", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)

-- DAP integration with vim-notify
-- https://github.com/rcarriga/nvim-notify/wiki/Usage-Recipes#dap-status-updates

local client_notifs = {}

local function get_notif_data(client_id, token)
    if not client_notifs[client_id] then
        client_notifs[client_id] = {}
    end

    if not client_notifs[client_id][token] then
        client_notifs[client_id][token] = {}
    end

    return client_notifs[client_id][token]
end

local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

local function update_spinner(client_id, token)
    local notif_data = get_notif_data(client_id, token)

    if notif_data.spinner then
        local new_spinner = (notif_data.spinner + 1) % #spinner_frames
        notif_data.spinner = new_spinner

        notif_data.notification = vim.notify(nil, nil, {
            hide_from_history = true,
            replace = notif_data.notification,
            icon = spinner_frames[new_spinner],
        })

        vim.defer_fn(function()
            update_spinner(client_id, token)
        end, 100)
    end
end

local function format_title(title, client_name)
    return client_name .. (#title > 0 and ": " .. title or "")
end

local function format_message(message, percentage)
    return (percentage and percentage .. "%\t" or "") .. (message or "")
end

dap.listeners.before["event_progressStart"]["progress-notifications"] = function(session, body)
    local notif_data = get_notif_data("dap", body.progressId)

    local message = format_message(body.message, body.percentage)
    notif_data.notification = vim.notify(message, "info", {
        title = format_title(body.title, session.config.type),
        icon = spinner_frames[1],
        timeout = false,
        hide_from_history = false,
    })

    ---@diagnostic disable-next-line: redundant-value
    notif_data.notification.spinner = 1, update_spinner("dap", body.progressId)
end

dap.listeners.before["event_progressUpdate"]["progress-notifications"] = function(session, body)
    local notif_data = get_notif_data("dap", body.progressId)
    notif_data.notification = vim.notify(format_message(body.message, body.percentage), "info", {
        replace = notif_data.notification,
        hide_from_history = false,
    })
end

dap.listeners.before["event_progressEnd"]["progress-notifications"] = function(session, body)
    local notif_data = client_notifs["dap"][body.progressId]
    notif_data.notification = vim.notify(body.message and format_message(body.message) or "Complete", "info", {
        icon = "",
        replace = notif_data.notification,
        timeout = 3000,
    })
    notif_data.spinner = nil
end

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation

-- .NET

--- Rebuilds the project before starting the debug session
---@param co thread
local function rebuild_project(co, path)
    local spinner = require("easy-dotnet.ui-modules.spinner").new()
    spinner:start_spinner("Building")
    vim.fn.jobstart(string.format("dotnet build %s", path), {
        on_exit = function(_, return_code)
            if return_code == 0 then
                spinner:stop_spinner("Built successfully")
            else
                spinner:stop_spinner("Build failed with exit code " .. return_code, vim.log.levels.ERROR)
                error("Build failed")
            end
            coroutine.resume(co)
        end,
    })
    coroutine.yield()
end

require("easy-dotnet.netcoredbg").register_dap_variables_viewer() -- special variables viewer specific for .NET

-- Bash

local bash_dbg_path = mason_path .. "/packages/bash-debug-adapter"

dap.adapters.bashdb = {
    type = "executable",
    command = bash_dbg_path .. "/bash-debug-adapter",
    name = "bashdb",
}

dap.configurations.sh = {
    {
        type = "bashdb",
        request = "launch",
        name = "Launch file",
        showDebugOutput = true,
        pathBashdb = bash_dbg_path .. "/extension/bashdb_dir/bashdb",
        pathBashdbLib = bash_dbg_path .. "/extension/bashdb_dir",
        trace = true,
        file = "${file}",
        program = "${file}",
        cwd = "${workspaceFolder}",
        pathCat = "cat",
        pathBash = "/bin/bash",
        pathMkfifo = "mkfifo",
        pathPkill = "pkill",
        args = {},
        env = {},
        terminalKind = "integrated",
    },
}

-- Haskell

-- stack install haskell-dap ghci-dap haskell-debug-adapter

dap.adapters.haskell = {
    type = "executable",
    command = "haskell-debug-adapter",
    args = { "--hackage-version=0.0.39.0" },
}

dap.configurations.haskell = {
    {
        type = "haskell",
        request = "launch",
        name = "Debug",
        workspace = "${workspaceFolder}",
        startup = "${file}",
        stopOnEntry = true,
        logFile = vim.fn.stdpath("data") .. "/haskell-dap.log",
        logLevel = "WARNING",
        ghciEnv = vim.empty_dict(),
        ghciPrompt = "λ: ",
        ghciInitialPrompt = "λ: ",
        ghciCmd = "stack ghci --test --no-load --no-build --ghci-options -fprint-evld-with-show",
    },
}

-- Lua

-- PowerShell

-- Disable DAP virtual text when a PowerShell file is opened
vim.api.nvim_create_autocmd({ "BufRead" }, {
    pattern = { "*.ps1", "*.psm1" },
    callback = function()
        vim.cmd("DapVirtualTextDisable")
    end,
})
