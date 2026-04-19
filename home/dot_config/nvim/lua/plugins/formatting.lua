local load_config = require("utils.helpers").load_config

return {
    {
        -- Lightweight formatter plugin
        "stevearc/conform.nvim",
        cmd = { "ConformInfo" },
        event = { "BufReadPre", "BufNewFile" },
        config = load_config("conform"),
    },
}
