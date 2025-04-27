-- https://github.com/rcarriga/nvim-notify/wiki/Usage-Recipes#dap-status-updates

-- DAP integration
-- Make sure to also have the snippet with the common helper functions in your config!

local dap = require("dap")
local dapui = require("dapui")

local mason_path = vim.fn.stdpath("data") .. "/mason"

-- https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt
require("dap.ext.vscode").json_decode = require("json5").parse

dofile(vim.g.base46_cache .. "dap")

local dapui_config = {
    controls = {
        element = "repl",
        enabled = true,
        icons = {
            disconnect = "",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = "",
        },
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
        border = "single",
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    force_buffers = true,
    icons = {
        collapsed = "",
        current_frame = "",
        expanded = "",
    },
    layouts = {
        {
            elements = {
                {
                    id = "scopes",
                    size = 0.25,
                },
                {
                    id = "breakpoints",
                    size = 0.25,
                },
                {
                    id = "stacks",
                    size = 0.25,
                },
                {
                    id = "watches",
                    size = 0.25,
                },
            },
            position = "left",
            size = 40,
        },
        {
            elements = {
                {
                    id = "repl",
                    size = 0.5,
                },
                {
                    id = "console",
                    size = 0.5,
                },
            },
            position = "bottom",
            size = 10,
        },
    },
    mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
    },
    render = {
        indent = 1,
        max_value_lines = 100,
    },
}

dapui.setup(dapui_config)

dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

-- Setup icons
-- vim.fn.sign_define('DapBreakpoint', {text='', texthl='', linehl='', numhl=''})
vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#990000" })
vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#3d59a1" })
vim.api.nvim_set_hl(0, "DapStopped", { fg = "#9ece6a" })

vim.fn.sign_define("DapBreakpoint", { text = "⬤", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "󰣕", texthl = "DapLogPoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "", linehl = "", numhl = "" })

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
            icon = spinner_frames[new_spinner],
            replace = notif_data.notification,
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

-- https://github.com/rcarriga/nvim-notify/wiki/Usage-Recipes#dap-status-updates
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

local dotnet = require("easy-dotnet")
local debug_dll = nil
local function ensure_dll()
    if debug_dll ~= nil then
        return debug_dll
    end
    local dll = dotnet.get_debug_dll()
    debug_dll = dll
    return dll
end

dap.configurations.cs = {
    {
        name = "launch - netcoredbg",
        type = "coreclr",
        request = "launch",
        justMyCode = false,
        stopAtEntry = false,
        env = function()
            local dll = ensure_dll()
            local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
            return vars or nil
        end,
        program = function()
            local dll = ensure_dll()
            local co = coroutine.running()
            rebuild_project(co, dll.project_path)
            return dll.relative_dll_path
        end,
        cwd = function()
            local dll = ensure_dll()
            return dll.relative_project_path
        end,
    },
    {
        name = "debug unittests - netcoredbg",
        type = "coreclr",
        request = "attach",
        processId = require("dap.utils").pick_process,
        justMyCode = true, -- set to `true` in debug configuration and `false` in release configuration
    },
}
dap.listeners.before["event_terminated"]["easy-dotnet"] = function()
    debug_dll = nil
end

dap.adapters.coreclr = {
    type = "executable",
    command = mason_path .. "/bin/netcoredbg",
    args = { "--interpreter=vscode" },
}

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

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#local-lua-debugger-vscode
dap.adapters["local-lua"] = {
    type = "executable",
    command = "node",
    args = { mason_path .. "/packages/local-lua-debugger-vscode/extension/extension/debugAdapter.js" },
}

-- https://zignar.net/2023/06/10/debugging-lua-in-neovim/#debugging-lua
-- https://github.com/mfussenegger/nlua
dap.configurations.lua = {
    {
        name = "Current file (local-lua-dbg, nlua)",
        type = "local-lua",
        request = "launch",
        cwd = "${workspaceFolder}",
        program = {
            lua = "nlua.lua",
            file = "${file}",
        },
        verbose = true,
        args = {},
    },
}

-- PowerShell

-- Disable DAP virtual text when a PowerShell file is opened
vim.api.nvim_create_autocmd({ "BufRead" }, {
    pattern = { "*.ps1", "*.psm1" },
    callback = function()
        vim.cmd("DapVirtualTextDisable")
    end,
})
