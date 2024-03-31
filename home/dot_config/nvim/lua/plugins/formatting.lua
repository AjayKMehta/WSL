local load_config = require("utils").load_config

return {
    {
        -- Lightweight formatter plugin
        "stevearc/conform.nvim",
        enabled = true,
        cmd = { "ConformInfo" },
        event = { "BufReadPre", "BufNewFile" },
        config = load_config("conform"),
    },
}
