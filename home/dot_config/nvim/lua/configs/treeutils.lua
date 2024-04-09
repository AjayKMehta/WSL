-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes
local api = require("nvim-tree.api")
local openfile = require("nvim-tree.actions.node.open-file")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local utils = require("utils")

local M = {}

local view_selection = function(prompt_bufnr, map)
    actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local filename = selection.filename
        if filename == nil then
            filename = selection[1]
        end
        openfile.fn("preview", filename)
    end)
    return true
end

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#change-root-to-global-current-working-directory
function M.change_root_to_global_cwd()
    local global_cwd = vim.fn.getcwd(-1, -1)
    api.tree.change_root(global_cwd)
end

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#h-j-k-l-style-navigation-and-editing

-- open as vsplit on current node
function M.vsplit_preview()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
        -- expand or collapse folder
        api.node.open.edit()
    else
        -- open file as vsplit
        api.node.open.vertical()
    end

    -- Finally refocus on tree if it was lost
    api.tree.focus()
end

function M.edit_or_open()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
        -- expand or collapse folder
        api.node.open.edit()
    else
        -- open file
        api.node.open.edit()
        -- Close the tree if file was opened
        api.tree.close()
    end
end

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#find-file-from-node-in-telescope

function M.launch_live_grep(opts)
    return M.launch_telescope("live_grep", opts)
end

function M.launch_find_files(opts)
    return M.launch_telescope("find_files", opts)
end

function M.launch_telescope(func_name, opts)
    local telescope_status_ok, _ = utils.is_loaded("telescope")
    if not telescope_status_ok then
        return
    end
    local node = api.tree.get_node_under_cursor()
    local is_folder = node.fs_stat and node.fs_stat.type == "directory" or false
    local basedir = is_folder and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
    if node.name == ".." and TreeExplorer ~= nil then
        basedir = TreeExplorer.cwd
    end
    opts = opts or {}
    opts.cwd = basedir
    opts.search_dirs = { basedir }
    opts.attach_mappings = view_selection
    return require("telescope.builtin")[func_name](opts)
end

return M
