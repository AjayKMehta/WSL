local config = require("codecompanion.config")

return {
  strategy = "inline",
  description = "Generate documentation comments.",
  opts = {
    modes = { "v" },
    short_name = "doccomment",
    auto_submit = true,
    user_prompt = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = config.constants.USER_ROLE,
      content = function(context)
        local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

        return "Please provide documentation in comments for the following code explaining what it does briefly and highlight any important points.\n\n```"
          .. context.filetype
          .. "\n"
          .. code
          .. "\n```\n\n"
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
