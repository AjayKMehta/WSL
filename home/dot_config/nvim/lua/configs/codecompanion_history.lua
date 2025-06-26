require("mcphub").setup({
    auto_approve = function(params)
        -- Respect CodeCompanion's auto tool mode when enabled
        if vim.g.codecompanion_auto_tool_mode == true then
            return true
        end

        -- Auto-approve GitHub issue reading
        if params.server_name == "github" and params.tool_name == "get_issue" then
            return true
        end

        -- Block access to private repos
        if params.arguments.repo == "private" then
            return "You can't access private repos." -- Error message
        end

        -- Auto-approve safe file operations in current project
        if params.tool_name == "read_file" then
            local path = params.arguments.path or ""
            if path:match("^" .. vim.fn.getcwd()) then
                return true
            end
        end

        -- Check if tool is configured for auto-approval in servers.json
        if params.is_auto_approved_in_server then
            return true
        end

        return false -- Show confirmation prompt
    end,
})
