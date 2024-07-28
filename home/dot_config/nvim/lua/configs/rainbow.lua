local rainbow = require("rainbow-delimiters")

local function init_strategy(bufnr)
    -- Disabled for very large files, global strategy for large files,
    -- local strategy otherwise
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    if line_count > 10000 then
        return nil
    elseif line_count > 1000 then
        return rainbow.strategy["global"]
    end
    return rainbow.strategy["local"]
end

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
        [""] = rainbow.strategy["global"],
        c_sharp = rainbow.strategy["local"],
        latex = init_strategy,
        lua = init_strategy,
        vim = rainbow.strategy["local"],
    },
})
