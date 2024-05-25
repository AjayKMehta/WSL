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
            render = "wrapped-compact",
            stages = "slide",
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
            -- vim.notify = notify
        end,
    },
    {
        "folke/noice.nvim",
        enabled = true,
        event = "VeryLazy",
        opts = {
            cmdline = {
                format = {
                    cmdline = {
                        title = "",
                        icon = "",
                    },
                    lua = {
                        title = "",
                        icon = " 󰢱 ",
                    },
                    help = {
                        title = "",
                        icon = " 󰋖 ",
                    },
                    input = {
                        title = "",
                        icon = "❓",
                    },
                    filter = {
                        title = "",
                        icon = "  ",
                    },
                    search_up = {
                        icon = "    ",
                        view = "cmdline",
                    },
                    search_down = {
                        icon = "    ",
                        view = "cmdline",
                    },
                },
                opts = {
                    win_options = {
                        winhighlight = {
                            -- Normal = "NormalFloat",
                            FloatBorder = "FloatBorder",
                        },
                    },
                },
            },
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
                hover = {
                    enabled = true,
                    -- Do not show a message if hover is not available
                    silent = true,
                },
                signature = {
                    enabled = false, -- use lsp_signature.nvim
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                lsp_doc_border = true, -- add a border to hover docs and signature help
            },
            popupmenu = {
                -- Doesn't work with cmp.
                enabled = true,
                ---@type 'nui'|'cmp'
                backend = "nui", -- backend for regular cmdline completions
            },
            routes = {
                {
                    filter = { event = "notify", find = "No information available" },
                    opts = { skip = true },
                },
                {
                    filter = { find = "method textDocument/codeLens is not supported"},
                    opts = { skip = true },
                },
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            --   `nvim-notify` is only needed, if you want to use the notification view.
            "rcarriga/nvim-notify",
        },
    },
    {
        -- Better quickfix window
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        cmds = { "BqfEnable", "BqfDisable", "BqfToggle" },
        opts = {
            auto_enable = true,
            auto_resize_height = true,
            func_map = {
                open = "<cr>",
                openc = "o",
                drop = "O",
                vsplit = "v",
                split = "s",
                tab = "t",
                tabc = "T",
                stoggledown = "<Tab>",
                stoggleup = "<S-Tab>",
                stogglevm = "<Tab>",
                sclear = "z<Tab>",
                pscrollup = "<C-u>",
                pscrolldown = "<C-d>",
                fzffilter = "zf",
                ptogglemode = "zp",
                filter = "zn",
                filterr = "zr",
            },
        },
        dependencies = {
            "junegunn/fzf",
            build = function()
                vim.fn["fzf#install"]()
            end,
        },
    },
    {
        "CRAG666/code_runner.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            filetype = {
                bash = "$dir/$fileName",
                cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
                haskell = "stack runhaskell",
                java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
                javascript = "node",
                lua = "lua",
                python = "python3 -u",
                r = "Rscript",
                ps1 = "pwsh -f $file",
                shell = "$dir/$fileName",
                typescript = "deno run",
                zsh = "$dir/$fileName",
                excluded_buftypes = { "message" },
                -- Using tectonic compiler
                tex = function(...)
                    local latexCompileOptions = {
                        "Single",
                        "Project",
                    }
                    local preview = require("code_runner.hooks.preview_pdf")
                    local cr_au = require("code_runner.hooks.autocmd")
                    vim.ui.select(latexCompileOptions, {
                        prompt = "Select compile mode:",
                    }, function(opt, _)
                        if opt then
                            if opt == "Single" then
                                -- Single preview for latex files
                                preview.run({
                                    command = "tectonic",
                                    args = { "$fileName", "--keep-logs", "-o", "/tmp" },
                                    preview_cmd = "zathura --fork",
                                    overwrite_output = "/tmp",
                                })
                            elseif opt == "Project" then
                                -- Create command for stop job
                                cr_au.stop_job() -- CodeRunnerJobPosWrite
                                -- Compile
                                os.execute("tectonic -X build --keep-logs --open &> /dev/null &")
                                -- Command for hot reload
                                local fn = function()
                                    os.execute("tectonic -X build --keep-logs &> /dev/null &")
                                end
                                -- Create Job for hot reload latex compiler
                                -- Execute after write
                                cr_au.create_au_write(fn)
                            end
                        end
                    end)
                end,
                markdown = function(...)
                    local markdownCompileOptions = {
                        Normal = "pdf",
                        Presentation = "beamer",
                    }
                    vim.ui.select(vim.tbl_keys(markdownCompileOptions), {
                        prompt = "Select preview mode:",
                    }, function(opt, _)
                        if opt then
                            require("code_runner.hooks.preview_pdf").run({
                                command = "pandoc",
                                args = { "$fileName", "-o", "$tmpFile", "-t", markdownCompileOptions[opt] },
                                preview_cmd = "/bin/zathura --fork",
                            })
                        else
                            print("Not Preview")
                        end
                    end)
                end,
            },
            mode = "float",
            startinsert = true,
            float = {
                close_key = "q",
                border = "rounded",
                height = 0.8,
                width = 0.8,
                x = 0.5,
                y = 0.5,
                -- Highlight group for floating window/border (see ':h winhl')
                border_hl = "FloatBorder",
                float_hl = "Normal",
                -- Transparency (see ':h winblend')
                blend = 0,
            },
        },
        event = "BufEnter",
    },
    {
        -- Show all todo comments in solution
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup({})
        end,
        event = "VeryLazy",
    },
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
    {
        "brenoprata10/nvim-highlight-colors",
        event = "BufEnter",
        opts = { ---Render style
            ---@usage 'background'|'foreground'|'virtual'
            render = "background",

            ---Set virtual symbol (requires render to be set to 'virtual')
            virtual_symbol = "■",

            ---Highlight named colors, e.g. 'green'
            enable_named_colors = true,

            ---Highlight tailwind colors, e.g. 'bg-blue-500'
            enable_tailwind = true,

            ---Set custom colors
            ---Label must be properly escaped with '%' to adhere to `string.gmatch`
            --- :help string.gmatch
            custom_colors = {
                { label = "%-%-theme%-primary%-color", color = "#0f1219" },
                { label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
            },
        },
        config = function(_, opts)
            require("nvim-highlight-colors").setup(opts)
        end,
    },
    {
            -- Highlight cursor and visual selections in current buffer when entering command mode
        "moyiz/command-and-cursor.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
            -- NeoVim plugin for jumping to the other end of the current Tree-sitter node using `%`
        "yorickpeterse/nvim-tree-pairs",
        config = function()
            require("tree-pairs").setup()
        end,
    },
    {
        -- Displays the keys you are typing in a floating window, just like screenkey does
        "NStefan002/screenkey.nvim",
        cmd = "Screenkey",
        version = "*",
        config = true,
    },
}
