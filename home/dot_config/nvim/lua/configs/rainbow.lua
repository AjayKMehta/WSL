local rainbow = require("rainbow-delimiters")

dofile(vim.g.base46_cache .."rainbowdelimiters")

require("rainbow-delimiters.setup").setup({
    query = {
        [""] = "rainbow-delimiters",
        html = "rainbow-tags",
        javascript = "rainbow-delimiters-react",
        latex = "rainbow-blocks",
        lua = "rainbow-blocks",
        -- Determine the query dynamically
        query = function(bufnr)
            -- Use blocks for read-only buffers like in `:InspectTree`
            local is_nofile = vim.bo[bufnr].buftype == "nofile"
            return is_nofile and "rainbow-blocks" or "rainbow-delimiters"
        end,
    },
    strategy = {
        [""] = "rainbow-delimiters.strategy.global",
        c_sharp = "rainbow-delimiters.strategy.local",
        latex = "rainbow-delimiters.strategy.local",
        lua = "rainbow-delimiters.strategy.local",
        vim = "rainbow-delimiters.strategy.local",
    },
})
