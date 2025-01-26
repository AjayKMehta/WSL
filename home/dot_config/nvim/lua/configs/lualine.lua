local lualine = require("lualine")
local utils = require("utils")
local custom_fname = require("lualine.components.filename"):extend()
local highlight = require("lualine.highlight")
local default_status_colors = { saved = "#228B22", modified = "#C70039" }

local neominimap = require("neominimap.statusline")
local minimap_extension = {
    sections = {
        lualine_c = {
            neominimap.fullname,
        },
        lualine_z = {
            neominimap.position,
            "progress",
        },
    },
    filetypes = { "neominimap" },
}

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

local function LspStatus()
    return require("lsp-progress").progress({
        format = function(messages)
            local buf_number = vim.api.nvim_get_current_buf()
            local active_clients = vim.lsp.get_clients({ bufnr = buf_number })
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

-- https://codecompanion.olimorris.dev/usage/events#example-lualine-nvim-integration
local function create_codecompanion_component()
    local M = require("lualine.component"):extend()
    M.processing = false
    M.spinner_index = 1
    local spinner_symbols = {
        "⠋",
        "⠙",
        "⠹",
        "⠸",
        "⠼",
        "⠴",
        "⠦",
        "⠧",
        "⠇",
        "⠏",
    }
    local spinner_symbols_len = 10

    function M:init(options)
        M.super.init(self, options)
        local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
        vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "CodeCompanionRequest*",
            group = group,
            callback = function(request)
                if request.match == "CodeCompanionRequestStarted" then
                    self.processing = true
                elseif request.match == "CodeCompanionRequestFinished" then
                    self.processing = false
                end
            end,
        })
    end

    function M:update_status()
        if self.processing then
            self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
            return spinner_symbols[self.spinner_index]
        else
            return nil
        end
    end

    return M
end

-- https://github.com/smoka7/multicursors.nvim#status-line-module
local function is_active()
    local ok, hydra = pcall(require, "hydra.statusline")
    return ok and hydra.is_active()
end

local function get_name()
    local ok, hydra = pcall(require, "hydra.statusline")
    if ok then
        return hydra.get_name()
    end
    return ""
end

-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#changing-filename-color-based-on--modified-status
function custom_fname:init(options)
    custom_fname.super.init(self, options)
    self.status_colors = {
        saved = highlight.create_component_highlight_group(
            { bg = default_status_colors.saved },
            "filename_status_saved",
            self.options
        ),
        modified = highlight.create_component_highlight_group(
            { bg = default_status_colors.modified },
            "filename_status_modified",
            self.options
        ),
    }
    if self.options.color == nil then
        self.options.color = ""
    end
end

function custom_fname:update_status()
    local data = custom_fname.super.update_status(self)
    data = highlight.component_format_highlight(
        vim.bo.modified and self.status_colors.modified or self.status_colors.saved
    ) .. data
    return data
end

local rstatus = function()
    if not vim.g.rplugin then
        -- No R file type (R, Quarto, Rmd, Rhelp) opened yet
        return ""
    end
    if vim.g.rplugin.jobs.R ~= 0 then
        -- R was launched and nvimrserver started its TCP server
        return "R"
    end
    if vim.g.rplugin.jobs.Server ~= 0 then
        -- nvimrserver was started
        return "S"
    else
        -- nvimrserver was not started yet
        return "-"
    end
end

local rsttcolor = function()
    if not vim.g.rplugin then
        return { fg = "#000000" }
    end
    if vim.g.rplugin.jobs.R ~= 0 then
        if vim.g.rplugin.R_pid == 0 then
            -- R was launched
            return { fg = "#ff8833" }
        else
            -- R started and informed its PID.
            -- This means nvimcom is running.
            return { fg = "#3388ff" }
        end
    end
    if vim.g.rplugin.jobs.Server ~= 0 and #vim.g.rplugin.libs_in_nrs > 0 then
        -- nvimrserver finished reading omni completion files
        return { fg = "#33ff33" }
    end
    return { fg = "#aaaaaa" }
end

local config = {
    options = {
        ignore_focus = { "NvimTree", "lspInfo" },
        theme = "dracula",
        icons_enabled = true,
        component_separators = "|",
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = { "NvimTree", "dashboard", "crunner" },
        },
    },
    -- This clobbers bufferline!
    -- tabline = {
    --     lualine_y = { "searchcount", "selectioncount" },
    -- },
    sections = {
        lualine_a = {
            { "mason" },
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
                -- Use gitsigns
                "b:gitsigns_head",
                icon = "",
                color = {
                    fg = colors.lightblue,
                    -- gui = "bold",
                },
                fmt = utils.trunc(120, 20, 60, false),
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
            { get_name, cond = is_active },
        },
        lualine_c = {
            { custom_fname },
            { LspStatus, cond = utils.has_filename, color = { fg = "#00FDAF" } },
            {
                function()
                    local formatters = require("conform").list_formatters()
                    local available_formatters = {}
                    for _, fmt in ipairs(formatters) do
                        if fmt.available then
                            table.insert(available_formatters, fmt.name)
                        end
                    end

                    local pretty_list_formatters = #available_formatters ~= 0
                        and table.concat(available_formatters, ", ")
                    return "[" .. pretty_list_formatters .. "]"
                end,
                color = { fg = "pink" },
                padding = 0,
                cond = function()
                    return vim.g.show_formatters
                end,
            },
            {
                -- https://github.com/mfussenegger/nvim-lint#get-the-current-running-linters-for-your-buffer
                function()
                    local linters = require("lint").get_running()
                    if #linters == 0 then
                        return "󰦕 "
                    end
                    return "󱉶 " .. table.concat(linters, ", ")
                end,
                cond = function()
                    return vim.g.show_linters
                end,
                color = { fg = "#FA32EA" },
            },
        },
        lualine_x = {
            create_codecompanion_component(),
            {
                "rest",
                icon = "",
                fg = "#428890",
            },
            -- https://github.com/folke/lazy.nvim#-usage
            {
                require("lazy.status").updates,
                cond = function()
                    return package.loaded["lazy"] and require("lazy.status").has_updates
                end,
                color = { fg = "#ff9e64" },
            },
            -- https://github.com/folke/noice.nvim?tab=readme-ov-file#-statusline-components
            {
                require("noice").api.status.message.get_hl,
                -- Way too noisy. Would be nice to be able to show only for 2 seconds.
                cond = function()
                    return false
                end,
                -- cond = require("noice").api.status.message.has,
                color = { fg = "pink" },
            },
            {
                require("noice").api.status.mode.get,
                cond = require("noice").api.status.mode.has,
                color = { fg = "#ff9e64" },
            },
            {
                require("noice").api.status.search.get,
                cond = require("noice").api.status.search.has,
                color = { fg = "#ff9e64" },
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
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            -- https://github.com/cuducos/yaml.nvim#showing-the-yaml-path-and-value
            {
                function(msg)
                    msg = require("yaml_nvim").get_yaml_key_and_value()
                    return msg or ""
                end,
            },
        },
        lualine_y = { { rstatus, color = rsttcolor } },
    },
    extensions = { "nvim-tree", "lazy", "mason", "nvim-dap-ui", "trouble", "toggleterm", "quickfix", minimap_extension },
}

lualine.setup(config)

-- Listen for lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lualine_augroup",
    pattern = "LspProgressStatusUpdated",
    callback = lualine.refresh,
})
