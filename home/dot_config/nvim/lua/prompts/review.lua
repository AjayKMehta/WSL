local config = require("codecompanion.config")
local utils = require("prompts.helper")

return {
    interaction = "chat",
    description = "Review code",
    opts = {
        mapping = "<leader>cr",
        is_slash_cmd = true,
        alias = "review", -- Run as `:CodeCompanion /review`
        stop_context_insertion = true, -- avoid duplication because visually selecting text
        auto_submit = true, -- get the user's input before we action the response
        user_prompt = false,
    },
    prompts = {
        {
            role = config.constants.SYSTEM_ROLE,
            content = function(context)
                return "I want you to act as a principal"
                    .. ((context.filetype and " " .. context.filetype) or "")
                    .. " developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples."
            end,
        },
        {
            role = config.constants.USER_ROLE,
            content = function(context)
                local text = utils.get_text(context)

                return "@rag\n/buffer\n"
                    .. "Review, optimize and simplify the following code:\n\n```"
                    .. context.filetype
                    .. "\n"
                    .. text
                    .. "\n```\n\n"
                    .. "If possible, improve it for maintainability, readability and provide a step-by-step explanation of the changes made. If it's not possible, don't provide any suggestions to improve the code."
            end,
            opts = {
                contains_code = true,
            },
        },
    },
}
