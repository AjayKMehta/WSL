local utils = require("utils.codecompanion")

return {
    description = "Add documentation to the selected code",
    strategy = "chat",
    opts = {
        -- Getting marksman error so disabled for now.
        -- pre_hook = function()
        --     local bufnr = vim.api.nvim_create_buf(true, false)
        --     vim.api.nvim_set_current_buf(bufnr)
        --     vim.api.nvim_set_option_value("filetype", "markdown", { buf = bufnr })
        --     return bufnr
        -- end,
        auto_submit = true,
        is_slash_cmd = true,
        modes = { "n", "v" },
        short_name = "doc",
        stop_context_insertion = true,
        user_prompt = false,
    },
    prompts = {
        {
            role = "system",
            content = [[
                When asked to add documentation, follow these steps:
                1. **Identify Key Points**: Carefully read the provided code to understand its functionality.
                2. **Plan the Documentation**: Describe the key points to be documented in pseudocode, detailing each step.
                3. **Implement the Documentation**: Write the accompanying documentation in the same file or a separate file.
                4. **Review the Documentation**: Ensure that the documentation is comprehensive and clear. Ensure the documentation:
                  - Includes necessary explanations.
                  - Helps in understanding the code's functionality.
                  - Add parameters, return values, and exceptions documentation.
                  - Follows best practices for readability and maintainability.
                  - Is formatted correctly.

                Use Markdown formatting and specify the programming language for each code block.]],
            opts = {
                visible = false,
            },
        },
        {
            role = "user",
            content = function(context)
                local text = utils.get_text(context)
                local lang = context.filetype or ""
                return "Please document the selected code:\n\n```" .. lang .. "\n" .. text .. "\n```\n\n"
            end,
            opts = {
                contains_code = true,
            },
        },
    },
}
