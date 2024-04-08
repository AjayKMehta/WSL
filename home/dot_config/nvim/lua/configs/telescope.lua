-- For NvChad-specified settings, see https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/configs/telescope.lua
local M = {}

M.config = function()
    local actions = require("telescope.actions")
    local actions_layout = require("telescope.actions.layout")

    -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#dont-preview-binaries
    local previewers = require("telescope.previewers")
    local Job = require("plenary.job")
    local new_maker = function(filepath, bufnr, opts)
        filepath = vim.fn.expand(filepath)
        Job:new({
            command = "file",
            args = { "--mime-type", "-b", filepath },
            on_exit = function(j)
                local mime_type = vim.split(j:result()[1], "/")[1]
                if mime_type == "text" then
                    previewers.buffer_previewer_maker(filepath, bufnr, opts)
                else
                    -- maybe we want to write something to the buffer here
                    vim.schedule(function()
                        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
                    end)
                end
            end,
        }):sync()
    end

    local settings = {
        defaults = {
            mappings = {
                i = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<esc>"] = actions.close,
                    -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#mapping-c-d-to-delete-buffer
                    ["<M-d>"] = actions.delete_buffer + actions.move_to_top,
                    ["<M-p>"] = actions_layout.toggle_preview,
                    -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#mapping-c-sc-a-to-cycle-previewer-for-git-commits-to-show-full-message
                    ["<C-s>"] = actions.cycle_previewers_next,
                    ["<C-a>"] = actions.cycle_previewers_prev,
                },
                n = {
                    -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#add-mapping-to-toggle-the-preview
                    ["<M-p>"] = actions_layout.toggle_preview,
                },
            },
            -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#use-terminal-image-viewer-to-preview-images
            preview = {
                mime_hook = function(filepath, bufnr, opts)
                    if require("utils").is_image(filepath) then
                        local term = vim.api.nvim_open_term(bufnr, {})
                        local function send_output(_, data, _)
                            for _, d in ipairs(data) do
                                vim.api.nvim_chan_send(term, d .. "\r\n")
                            end
                        end
                        vim.fn.jobstart({
                            "catimg",
                            filepath, -- Terminal image viewer command
                        }, { on_stdout = send_output, stdout_buffered = true, pty = true })
                    else
                        require("telescope.previewers.utils").set_preview_message(
                            bufnr,
                            opts.winid,
                            "Binary cannot be previewed"
                        )
                    end
                end,
            },
            file_ignore_patterns = {
                "node_modules",
                ".docker",
                "yarn.lock",
                "go.sum",
                "go.mod",
                "tags",
                "mocks",
                "refactoring",
            },
            layout_config = {
                horizontal = {
                    prompt_position = "bottom",
                },
            },
        },
        extensions_list = {
            -- "aerial",
            "dap",
            "emoji",
            "file_browser",
            "frecency",
            "fzf",
            "helpgrep",
            "hoogle",
            -- TODO: <C-o> 	Open selected plugin repository in browser not working
            "lazy",
            "noice",
            "notify",
            "terms",
            "themes",
            "undo",
            "vim_bookmarks",
            -- https://github.com/benfowler/telescope-luasnip.nvim/issues/22
            "luasnip",
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
            lazy = {
                show_icon = true,
                mappings = {
                    open_in_browser = "<C-o>",
                    open_in_file_browser = "<M-b>",
                    open_in_find_files = "<C-f>",
                    open_in_live_grep = "<C-g>",
                    -- open_plugins_picker = "<C-b>",
                    open_lazy_root_find_files = "<C-r>f",
                    open_lazy_root_live_grep = "<C-r>g",
                },
            },
            media_files = {
                -- filetypes whitelist
                -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
                filetypes = { "png", "webp", "jpg", "jpeg" },
                -- find command (defaults to `fd`)
                find_cmd = "rg",
            },
            file_browser = {
                hidden = { file_browser = true, folder_browser = true },
                hijack_netrw = true,
            },
            aerial = {
                -- Display symbols as <root>.<parent>.<symbol>
                show_nesting = {
                    ["_"] = false, -- This key will be the default
                    json = true, -- You can set the option for specific filetypes
                    yaml = true,
                    xml = true,
                },
            },
        },
        -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#ripgrep-remove-indentation
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim", -- add this value
        },
        buffer_previewer_maker = new_maker,
    }
    local conf = require("nvchad.configs.telescope")
    return vim.tbl_deep_extend("force", conf, settings)
end

return M
