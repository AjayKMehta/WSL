return {
    {
        "MattesGroeger/vim-bookmarks",
        cmd = {
            "BookmarkToggle",
            "BookmarkClear",
            "BookmarkClearAll",
            "BookmarkNext",
            "BookmarkPrev",
            "BookmarkShowALl",
            "BookmarkAnnotate",
            "BookmarkSave",
            "BookmarkLoad",
        },
    }, -- https://github.com/tinyCatzilla/dots/blob/193cc61951579db692e9cc7f8f278ed33c8b52d4/.config/nvim/lua/custom/plugins.lua
    {
        -- Configurable, notification manager
        "rcarriga/nvim-notify",
        lazy = false,
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss notifications.",
            },
        },
        opts = {
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
        config = function(_, opts)
            -- https://github.com/rcarriga/nvim-notify/wiki/Usage-Recipes#output-of-command
            local notify = require("notify")
            notify.setup(opts)
            vim.notify = notify
        end,
    },
}
