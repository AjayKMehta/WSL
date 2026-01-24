local M = {}

M.setup = function(theme)
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

    local rstt = {
        { "-", "#aaaaaa" }, -- 1: ftplugin/* sourced, but nclientserver not started yet.
        { "S", "#757755" }, -- 2: nclientserver started, but not ready yet.
        { "S", "#117711" }, -- 3: nclientserver is ready.
        { "S", "#ff8833" }, -- 4: nclientserver started the TCP server
        { "S", "#3388ff" }, -- 5: TCP server is ready
        { "R", "#ff8833" }, -- 6: R started, but nvimcom was not loaded yet.
        { "R", "#3388ff" }, -- 7: nvimcom is loaded.
    }

    local rstatus = function()
        if not vim.g.R_Nvim_status or vim.g.R_Nvim_status == 0 then
            -- No R file type (R, Quarto, Rmd, Rhelp) opened yet
            return ""
        end
        return rstt[vim.g.R_Nvim_status][1]
    end

    -- https://github.com/R-nvim/R.nvim/wiki/Status-line
    local rsttcolor = function()
        if not vim.g.rplugin or not vim.g.rplugin.jobs then
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

    -- https://github.com/GustavEikaas/easy-dotnet.nvim#lualine-config
    local job_indicator = { require("easy-dotnet.ui-modules.jobs").lualine }

    local config = {
        options = {
            ignore_focus = {
                "checkhealth",
                "codecompanion",
                "help",
                "lspInfo",
                "no-profile",
                "noice",
                "notify",
                "nvcheatsheet",
                "NvimTree",
                "oil",
                "Outline",
                "snacks_picker_input",
                "tutor",
                "VoltWindow",
            },
            theme = theme,
            icons_enabled = true,
            component_separators = "|",
            section_separators = { left = "", right = "" },
            disabled_filetypes = {
                statusline = {
                    "checkhealth",
                    "codecompanion",
                    "crunner",
                    "dashboard",
                    "netrw",
                    "nvcheatsheet",
                    "NvimTree",
                    "oil",
                    "Outline",
                    "snacks_picker_input",
                    "tutor",
                    "VoltWindow",
                },
            },
            refresh = {
                statusline = 300, -- Note these are in mili second and default is 1000
                tabline = 300,
                winbar = 300,
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
                    sources = { "nvim_lsp" },

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
                    -- button: l(left) | r(right) | m(middle)
                    -- modifiers: s(shift) | c(ctrl) | a(alt) | m(meta)...)
                    on_click = function(num_clicks, button, modifiers)
                        if button == "l" then
                            local config = {
                                layout = "ivy",
                                on_show = function()
                                    vim.cmd.stopinsert()
                                end,
                            }
                            local snacks = require("snacks")
                            if modifiers == "c" then
                                snacks.picker.diagnostics(config)
                            else
                                snacks.picker.diagnostics_buffer(config)
                            end
                        elseif button == "r" then
                            vim.diagnostic.setloclist()
                        end
                    end,
                },
                { "mode", job_indicator },
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
                    on_click = function(num_clicks, button, modifiers)
                        local snacks = require("snacks")
                        if button == "l" then
                            snacks.picker.git_branches()
                        else
                            snacks.picker.git_log()
                        end
                    end,
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
                    on_click = function()
                        vim.cmd("DiffviewOpen")
                    end,
                },
            },
            lualine_c = {
                {
                    custom_fname,
                    on_click = function()
                        vim.cmd("NvimTreeToggle")
                    end,
                },
                {
                    function()
                        return ("%s %s")
                            :format(nvim.ui.icons.ui.Table, require("schema-companion").get_current_schemas() or "none")
                            :sub(0, 128)
                    end,
                    cond = function()
                        return package.loaded["schema-companion"]
                    end,
                },
                {
                    -- other components ...
                    function()
                        return require("screenkey").get_keys()
                    end,
                    cond = function()
                        return vim.g.screenkey_statusline_component
                    end,
                },
                {
                    "lsp_status",
                    icon = "", -- f013
                    symbols = {
                        -- Standard unicode symbols to cycle through for LSP progress:
                        spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                        -- Standard unicode symbol for when LSP is done:
                        done = "✓",
                        separator = " ",
                    },
                    ignore_lsp = { "GitHub Copilot" },
                    on_click = function(num_clicks, button, modifiers)
                        if button == "l" then
                            vim.cmd("LspInfo")
                        else
                            require("trouble").toggle("lsp_document_symbols")
                        end
                    end,
                },
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
                "codecompanion",
                -- https://github.com/folke/lazy.nvim#-usage
                {
                    require("lazy.status").updates,
                    cond = function()
                        return package.loaded["lazy"] and require("lazy.status").has_updates
                    end,
                    color = { fg = "#ff9e64" },
                    on_click = function()
                        vim.cmd("Lazy")
                    end,
                },
                -- https://github.com/folke/noice.nvim?tab=readme-ov-file#-statusline-components
                {
                    function()
                        return require("noice").api.status.mode.get
                    end,
                    cond = function()
                        return utils.is_loaded("noice") and require("noice").api.status.mode.has
                    end,
                    color = { fg = "#ff9e64" },
                },
                {
                    function()
                        return require("noice").api.status.search.get
                    end,
                    cond = function()
                        return utils.is_loaded("noice") and require("noice").api.status.search.has
                    end,
                    color = { fg = "#ff9e64" },
                },
                {
                    function()
                        -- Check if MCPHub is loaded
                        if not vim.g.loaded_mcphub then
                            return "󰐻 -"
                        end

                        local count = vim.g.mcphub_servers_count or 0
                        local status = vim.g.mcphub_status or "stopped"
                        local executing = vim.g.mcphub_executing

                        -- Show "-" when stopped
                        if status == "stopped" then
                            return "󰐻 -"
                        end

                        -- Show spinner when executing, starting, or restarting
                        if executing or status == "starting" or status == "restarting" then
                            local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                            local frame = math.floor(vim.loop.now() / 100) % #frames + 1
                            return "󰐻 " .. frames[frame]
                        end

                        return "󰐻 " .. count
                    end,
                    color = function()
                        if not vim.g.loaded_mcphub then
                            return { fg = "#6c7086" } -- Gray for not loaded
                        end

                        local status = vim.g.mcphub_status or "stopped"
                        if status == "ready" or status == "restarted" then
                            return { fg = "#50fa7b" } -- Green for connected
                        elseif status == "starting" or status == "restarting" then
                            return { fg = "#ffb86c" } -- Orange for connecting
                        else
                            return { fg = "#ff5555" } -- Red for error/stopped
                        end
                    end,
                },
                {
                    "encoding",
                    show_bomb = true,
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
            lualine_z = { "location" },
        },
        extensions = {
            "fzf",
            "nvim-tree",
            "lazy",
            "mason",
            "nvim-tree",
            "trouble",
            "toggleterm",
            "quickfix",
            minimap_extension,
        },
    }

    lualine.setup(config)

    vim.api.nvim_create_user_command("LuaLineRefresh", lualine.refresh, { desc = "Lualine Refresh " })

    vim.api.nvim_create_user_command("LuaLineDisable", lualine.hide, { desc = "Lualine Disable " })

    vim.api.nvim_create_user_command("LuaLineEnable", function()
        lualine.hide({ unhide = true })
    end, { desc = "Lualine Enable " })
end

return M
