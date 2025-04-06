local map_buf = require("utils.mappings").map_buf

-- Necessary because `]m`, etc. used by treesitter to move to method start/end
map_buf(0, { "n", "x", "o" }, "[e", "<plug>(vimtex-[m)", "Go to previous start of environment")
map_buf(0, { "n", "x", "o" }, "]e", "<plug>(vimtex-]m)", "Go to next start of environment")
map_buf(0, { "n", "x", "o" }, "[E", "<plug>(vimtex-[M)", "Go to previous end of environment")
map_buf(0, { "n", "x", "o" }, "]E", "<plug>(vimtex-]M)", "Go to previous start of environment")

map_buf(0, { "x", "o" }, "ic", "<plug>(vimtex-targets-i)c", "Inner command")
map_buf(0, { "x", "o" }, "ac", "<plug>(vimtex-targets-a)c", "Around command")

-- Commands below based on nvim-lspconfig TexLab configuration.
-- Including commands as part of texlab LSP config didn't work 😕

local function client_with_fn(fn)
    return function()
        local clients = vim.lsp.get_clients({ bufnr = 0, name = "texlab" })
        if not clients then
            return vim.notify("texlab client not found in buffer.", vim.log.levels.ERROR)
        end
        fn(clients[1])
    end
end

local function buf_build(client)
    local win = vim.api.nvim_get_current_win()
    local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
    client:request("textDocument/build", params, function(err, result)
        if err then
            error(tostring(err))
        end
        local texlab_build_status = {
            [0] = "Success",
            [1] = "Error",
            [2] = "Failure",
            [3] = "Cancelled",
        }
        vim.notify("Build " .. texlab_build_status[result.status], vim.log.levels.INFO)
    end, 0)
end

local function buf_search(client)
    local win = vim.api.nvim_get_current_win()
    local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
    client:request("textDocument/forwardSearch", params, function(err, result)
        if err then
            error(tostring(err))
        end
        local texlab_forward_status = {
            [0] = "Success",
            [1] = "Error",
            [2] = "Failure",
            [3] = "Unconfigured",
        }
        vim.notify("Search " .. texlab_forward_status[result.status], vim.log.levels.INFO)
    end, 0)
end

local function buf_cancel_build(client)
    return client:exec_cmd({
        title = "cancel",
        command = "texlab.cancelBuild",
    }, { bufnr = bufnr })
end

local function dependency_graph(client)
    client:request("workspace/executeCommand", { command = "texlab.showDependencyGraph" }, function(err, result)
        if err then
            return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
        end
        vim.notify("The dependency graph has been generated:\n" .. result, vim.log.levels.INFO)
    end, 0)
end

local function command_factory(cmd)
    local cmd_tbl = {
        Auxiliary = "texlab.cleanAuxiliary",
        Artifacts = "texlab.cleanArtifacts",
        CancelBuild = "texlab.cancelBuild",
    }
    return function(client)
        return client:exec_cmd({
            title = ("clean_%s"):format(cmd),
            command = cmd_tbl[cmd],
            arguments = { { uri = vim.uri_from_bufnr(0) } },
        }, { bufnr = 0 }, function(err, _)
            if err then
                vim.notify(("Failed to clean %s files: %s"):format(cmd, err.message), vim.log.levels.ERROR)
            else
                vim.notify(("command %s executed successfully"):format(cmd), vim.log.levels.INFO)
            end
        end)
    end
end

local function buf_find_envs(client)
    local win = vim.api.nvim_get_current_win()
    client:request("workspace/executeCommand", {
        command = "texlab.findEnvironments",
        arguments = { vim.lsp.util.make_position_params(win, client.offset_encoding) },
    }, function(err, result)
        if err then
            return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
        end
        local env_names = {}
        local max_length = 1
        for _, env in ipairs(result) do
            table.insert(env_names, env.name.text)
            max_length = math.max(max_length, string.len(env.name.text))
        end
        for i, name in ipairs(env_names) do
            env_names[i] = string.rep(" ", i - 1) .. name
        end
        vim.lsp.util.open_floating_preview(env_names, "", {
            height = #env_names,
            width = math.max((max_length + #env_names - 1), (string.len("Environments"))),
            focusable = false,
            focus = false,
            border = "single",
            title = "Environments",
        })
    end, 0)
end

local function buf_change_env(client)
    local new = vim.fn.input("Enter the new environment name: ")
    if not new or new == "" then
        return vim.notify("No environment name provided", vim.log.levels.WARN)
    end
    local pos = vim.api.nvim_win_get_cursor(0)
    return client:exec_cmd({
        title = "change_environment",
        command = "texlab.changeEnvironment",
        arguments = {
            {
                textDocument = { uri = vim.uri_from_bufnr(0) },
                position = { line = pos[1] - 1, character = pos[2] },
                newName = tostring(new),
            },
        },
    }, { bufnr = 0 })
end

vim.api.nvim_buf_create_user_command(0, "TexlabBuild", client_with_fn(buf_build), { desc = "" })

vim.api.nvim_buf_create_user_command(
    0,
    "TexlabForward",
    client_with_fn(buf_search),
    { desc = "Forward search from current position" }
)

vim.api.nvim_buf_create_user_command(
    0,
    "TexlabCancelBuild",
    client_with_fn(buf_cancel_build),
    { desc = "Cancel the current build" }
)

vim.api.nvim_buf_create_user_command(
    0,
    "TexlabDependencyGraph",
    client_with_fn(dependency_graph),
    { desc = "Show the dependency graph" }
)

vim.api.nvim_buf_create_user_command(
    0,
    "TexlabCleanArtifacts",
    client_with_fn(command_factory("Artifacts")),
    { desc = "Clean the artifacts" }
)

vim.api.nvim_buf_create_user_command(
    0,
    "TexlabCleanAuxiliary",
    client_with_fn(command_factory("Auxiliary")),
    { desc = "Clean the auxiliary files" }
)

vim.api.nvim_buf_create_user_command(
    0,
    "TexlabFindEnvironments",
    client_with_fn(buf_find_envs),
    { desc = "Find the environments at current position" }
)

vim.api.nvim_buf_create_user_command(
    0,
    "TexlabChangeEnvironment",
    client_with_fn(buf_change_env),
    { desc = "Change the environment at current position" }
)
