-- https://github.com/rcarriga/nvim-notify/wiki/Usage-Recipes#dap-status-updates

-- DAP integration
-- Make sure to also have the snippet with the common helper functions in your config!

local dap = require("dap")

local client_notifs = {}

-- https://nvchad.com/docs/config/mappings#manually_load_mappings
require("core.utils").load_mappings("dap")
require("core.utils").load_mappings("dap_python")

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

dap.adapters.coreclr = {
	type = "executable",
	command = "~/.local/share/nvim/mason/bin/netcoredbg",
	args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		program = function()
			return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
		end,
	},
}

-- Bash

dap.adapters.bashdb = {
	type = "executable",
	command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
	name = "bashdb",
}

dap.configurations.sh = {
	{
		type = "bashdb",
		request = "launch",
		name = "Launch file",
		showDebugOutput = true,
		pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
		pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
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

-- stack install haskell-dap ghci-dap haskell-debug-adapter

-- Haskell
dap.adapters.haskell = {
	type = "executable",
	command = "haskell-debug-adapter",
	-- args = { '--hackage-version=0.0.33.0' },
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
		-- Adjust the prompt to the prompt you see when you invoke the stack ghci command below
		ghciInitialPrompt = "λ: ",
		ghciCmd = "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show",
	},
}
