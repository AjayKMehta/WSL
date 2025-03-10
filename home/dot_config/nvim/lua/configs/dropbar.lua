local dropbar = require("dropbar")
local dropbar_api = require("dropbar.api")
local sources = require("dropbar.sources")
local utils = require("dropbar.utils")
local map_desc = require("utils.mappings").map_desc

vim.api.nvim_set_hl(0, "DropBarFileName", { fg = "#FFFFFF", italic = true })

local custom_path = {
    get_symbols = function(buff, win, cursor)
        local symbols = sources.path.get_symbols(buff, win, cursor)
        symbols[#symbols].name_hl = "DropBarFileName"
        if vim.bo[buff].modified then
            symbols[#symbols].name = symbols[#symbols].name .. " [+]"
            symbols[#symbols].name_hl = "DiffAdded"
        end
        return symbols
    end,
}

local opts = {
    bar = {
        sources = function(buf, _)
            if vim.bo[buf].ft == "markdown" then
                return {
                    custom_path,
                    sources.markdown,
                }
            end
            if vim.bo[buf].buftype == "terminal" then
                return {
                    sources.terminal,
                }
            end
            return {
                custom_path,
                utils.source.fallback({
                    sources.lsp,
                    sources.treesitter,
                }),
            }
        end,
    },
    sources = {
        lsp = {
            valid_symbols = {
                "File",
                "Module",
                "Namespace",
                "Package",
                "Class",
                "Method",
                "Property",
                "Field",
                "Constructor",
                "Enum",
                "Interface",
                "Function",
                "Variable",
                -- "Constant",
                -- "String",
                -- "Number",
                -- "Boolean",
                "Array",
                "Object",
                "Keyword",
                -- "Null",
                "EnumMember",
                "Struct",
                "Event",
                "Operator",
                "TypeParameter",
            },
        },
    },
}
dropbar.setup(opts)
map_desc("n", "<Leader>;", dropbar_api.pick, "Pick symbols in winbar")
map_desc("n", "[;", dropbar_api.goto_context_start, "Go to start of current context" )
map_desc("n", "];", dropbar_api.select_next_context, "Select next context" )
