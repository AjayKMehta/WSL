local excluded_ftypes = require("utils.helpers").excluded_ftypes

-- spellcheck method: "cursor", "iter", or boolean
local ft_config = {
    alpha = false,
    cabal = false,
    markdown = true,
    cs = "iter",
    python = "iter",
}

for i, ftype in ipairs(excluded_ftypes) do
    ft_config[ftype] = false
end

local config = {
    ft_default = false, -- default option for unspecified filetypes
    ft_config = ft_config,
    max_file_size = nil, -- maximum file size to check in lines (nil for no limit)
    severity = { -- severity for each spelling error type (false to disable diagnostics for that type)
        spellbad = "WARN",
        spellcap = "HINT",
        spelllocal = "HINT",
        spellrare = "INFO",
    },
    prefix = "possible misspelling(s): ", -- prefix for each diagnostic message
}

require("spellwarn").setup(config)
