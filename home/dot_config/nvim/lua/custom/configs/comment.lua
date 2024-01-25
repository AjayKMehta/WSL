local comment = require("Comment")
comment.setup(
-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#commentnvim
    {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
    }
)
