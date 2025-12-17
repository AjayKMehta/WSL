local M = {}

M.get_text = function(context)
    if context.is_visual then
        return require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
    else
        local buf_utils = require("codecompanion.utils.buffers")
        return buf_utils.get_content(context.bufnr)
    end
end

return M
