local config = require("codecompanion.config")

return {
  strategy = "inline",
  description = "Generate a commit message (advanced)",
  opts = {
    mapping = "<leader>cm",
    modes = { "n", "v" },
    is_slash_cmd = true,
    short_name = "commit",
    stop_context_insertion = true,
    auto_submit = true,
  },
  prompts = {
    {
      role = config.constants.USER_ROLE,
      content = function()
        local diffs = vim.fn.system("git diff --staged")
        if diffs == "" then
          vim.notify(
            "Error while generating commit message: No staged changes found"
              .. "\n\n"
              .. "Please stage your changes before running this command.",
            vim.log.levels.ERROR
          )
        end
        return string.format(
          [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

` ` `diff
%s
` ` `

When unsure about the commit message format, you can refer to the last 20 commit messages in this repository:

` ` `
%s
` ` `

Output only the commit message without any explanations and follow-up suggestions. It should ideally be less than 72 characters long.
]],
          diffs,
          vim.fn.system('git log --pretty=format:"%s" -n 20')
        )
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
