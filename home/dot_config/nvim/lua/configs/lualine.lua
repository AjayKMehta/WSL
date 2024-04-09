local lualine = require("lualine")
local utils = require("utils")

local colors = {
    bg = "#202328",
    fg = "#bbc2cf",
    yellow = "#ECBE7B",
    cyan = "#008080",
    darkblue = "#081633",
    green = "#98be65",
    orange = "#FF8800",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    blue = "#51afef",
    lightblue = "#7fd6ee",
    red = "#ec5f67",
}

local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
        }
    end
end

local function has_module(module)
    local result, _ = utils.is_loaded(module)
    return result
end

local function LspStatus()
    return require("lsp-progress").progress({
        format = function(messages)
            local buf_number = vim.api.nvim_get_current_buf()
            local active_clients = vim.lsp.get_active_clients({ bufnr = buf_number })
            local client_count = #active_clients
            if #messages > 0 then
                return " LSP:" .. client_count .. " " .. table.concat(messages, " ")
            end
            if #active_clients <= 0 then
                return " LSP:" .. client_count
            else
                local client_names = {}
                for i, client in ipairs(active_clients) do
                    if client and client.name ~= "" and client.name ~= "null-ls" then
                        table.insert(client_names, "[" .. client.name .. "]")
                        -- print("client[" .. i .. "]:" .. vim.inspect(client.name))
                    end
                end
                return " LSP:" .. client_count .. " " .. table.concat(client_names, " ")
            end
        end,
    })
end

local config = {
    options = {
        ignore_focus = { "NvimTree", "lspInfo" },
        theme = "dracula",
        icons_enabled = true,
        component_separators = "|",
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = { "NvimTree", "dashboard" },
        },
    },
    -- This clobbers bufferline!
    -- tabline = {
    --     lualine_y = { "searchcount", "selectioncount" },
    -- },
    sections = {
        lualine_a = {
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },

                -- Displays diagnostics for the defined severity types
                sections = { "error", "warn", "info", "hint" },

                symbols = { error = "", warn = "", info = "", hint = "󰌶" },
                update_in_insert = true, -- Update diagnostics in insert mode.
                always_visible = false, -- Show diagnostics even if there are none.s
                diagnostics_color = {
                    color_error = { fg = colors.red },
                    color_warn = { fg = colors.yellow },
                    color_info = { fg = colors.darkblue },
                    color_hint = { fg = colors.yellow },
                },
            },
            {
                "buffers",
                mode = 1,
                cond = function()
                    return false
                end,
            },
        },
        lualine_b = {
            {
                "branch",
                icon = "",
                color = {
                    fg = colors.lightblue,
                    -- gui = "bold",
                },
            },
            {
                "diff",
                padding = { left = 2, right = 1 },
                colored = true,
                diff_color = {
                    -- Same color values as the general color option can be used here.
                    added = { fg = colors.green },
                    modified = { fg = colors.yellow },
                    removed = { fg = colors.red },
                },
                symbols = { added = "+", modified = "~", removed = "-" },
                source = diff_source,
            },
        },
        lualine_c = {
            { LspStatus, cond = utils.has_filename },
        },
        lualine_x = {
            -- https://github.com/folke/lazy.nvim#-usage
            {
                require("lazy.status").updates,
                cond = function()
                    local ok, ls = utils.is_loaded("lazy.status")
                    if not ok then
                        return false
                    end
                    return ls.has_updates
                end,
                color = { fg = "#ff9e64" },
            },
            -- https://github.com/folke/noice.nvim/wiki/A-Guide-to-Messages#showmode
            {
                require("noice").api.statusline.mode.get,
                cond = function()
                    local ok, n = utils.is_loaded("noice")
                    if not ok then
                        return false
                    end
                    return n.api.statusline.mode.has
                end,
                color = { fg = "#ff9e64" },
            },
            -- https://github.com/PheloiVim/PheloiVim/blob/1d831d8dfd7e0fa52fda19ee6b8dcfc20254a3d8/lua/plugins/lualine.lua
            {
                ---@diagnostic disable-next-line: undefined-field
                function()
                    return require("noice").api.status.command.get()
                end,
                ---@diagnostic disable-next-line: undefined-field
                cond = function()
                    return package.loaded["noice"] and require("noice").api.status.command.has()
                end,
                color = { fg = "pink" },
            },
            {
                "encoding",
                cond = function()
                    return vim.fn.winwidth(0) > 80
                end,
            },
            {
                "fileformat",
                symbols = {
                    unix = "", -- e712
                    dos = "", -- e70f
                    mac = "", -- e711
                },
            },
            "filetype",
            --  TODO: Uncomment if using aerial.
            -- { "aerial" },
            -- https://github.com/cuducos/yaml.nvim#showing-the-yaml-path-and-value
            {
                function(msg)
                    msg = require("yaml_nvim").get_yaml_key_and_value()
                    if msg == nil then
                        return ""
                    else
                        return msg
                    end
                end,
            },
        },
    },
    extensions = { "nvim-tree", "lazy", "mason", "nvim-dap-ui", "trouble", "toggleterm", "quickfix" },
}

lualine.setup(config)

-- Listen for lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lualine_augroup",
    pattern = "LspProgressStatusUpdated",
    callback = lualine.refresh,
})
