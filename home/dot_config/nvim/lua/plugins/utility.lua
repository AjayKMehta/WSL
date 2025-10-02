return {
    {
        "folke/noice.nvim",
        cond = true,
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
                        icon = "󰥻 ",
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
                -- override markdown rendering so that plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
                hover = {
                    enabled = true,
                    -- Do not show a message if hover is not available
                    silent = true,
                },
                signature = {
                    enabled = false,
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
                    filter = { find = "method textDocument/codeLens is not supported" },
                    opts = { skip = true },
                },
                {
                    filter = { find = "Error running vale: ENOENT: no such file or directory" },
                    opts = { skip = true },
                },
                -- always route any messages with more than 20 lines to the split view
                {
                    view = "split",
                    filter = { event = "msg_show", min_height = 20 },
                },
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },
    {
        -- Better quickfix window
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        cmd = { "BqfEnable", "BqfDisable", "BqfToggle" },
        dependencies = { { "junegunn/fzf", build = "./install --bin" }, "nvim-treesitter/nvim-treesitter" },
        opts = {
            auto_enable = true,
            auto_resize_height = true,
            preview = {
                border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
                should_preview_cb = function(bufnr, qwinid)
                    local ret = true
                    local bufname = vim.api.nvim_buf_get_name(bufnr)
                    local fsize = vim.fn.getfsize(bufname)
                    if fsize > 100 * 1024 then
                        -- skip file size greater than 100k
                        ret = false
                    elseif bufname:match("^fugitive://") then
                        -- skip fugitive buffer
                        ret = false
                    end
                    return ret
                end,
            },
            -- These only work in the quickfix window.
            func_map = {
                open = "<cr>",
                openc = "o",
                drop = "O", -- open the item, and close quickfix window
                vsplit = "v",
                split = "s",
                tab = "t", -- open the item in a new tab
                tabc = "T", -- open the item in a new tab, and close quickfix window
                ptoggleitem = "p", -- toggle preview for a quickfix list item
                ptoggleauto = "P", -- toggle auto-preview when cursor moves
                prevfile = "<C-p>",
                nextfile = "<C-n>",
                stoggledown = "<Tab>", -- toggle sign and move cursor down
                stoggleup = "<S-Tab>", -- toggle sign and move cursor up
                stogglevm = "<Tab>", -- toggle multiple signs in visual mode
                sclear = "z<Tab>",
                pscrollup = "<C-u>",
                pscrolldown = "<C-d>",
                fzffilter = "zf", -- enter fzf mode
                ptogglemode = "zp",
                filter = "zn", -- create new list for signed items
                filterr = "zr", -- create new list for non-signed items
            },
            filter = {
                fzf = {
                    action_for = {
                        ["ctrl-t"] = "tabedit",
                        ["ctrl-q"] = "signtoggle",
                        ["ctrl-c"] = "closeall",
                    },
                    extra_opts = {
                        "--bind",
                        "ctrl-o:toggle-all",
                        "--delimiter",
                        "│",
                        "--bind",
                        "ctrl-/:toggle-wrap",
                    },
                },
            },
        },
        init = function()
            vim.cmd([[
                hi BqfPreviewBorder guifg=#3e8e2d ctermfg=71
                hi BqfPreviewTitle guifg=#3e8e2d ctermfg=71
                hi BqfPreviewThumb guibg=#3e8e2d ctermbg=71
                hi link BqfPreviewRange Search
            ]])

            -- https://github.com/kevinhwang91/nvim-bqf#format-new-quickfix
            local fn = vim.fn

            function _G.qftf(info)
                local items
                local ret = {}
                -- The name of item in list is based on the directory of quickfix window.
                -- Change the directory for quickfix window make the name of item shorter.
                -- It's a good opportunity to change current directory in quickfixtextfunc :)
                --
                -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
                -- local root = getRootByAlterBufnr(alterBufnr)
                -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
                --
                if info.quickfix == 1 then
                    items = fn.getqflist({ id = info.id, items = 0 }).items
                else
                    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
                end
                local limit = 31
                local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
                local validFmt = "%s │%5d:%-3d│%s %s"
                for i = info.start_idx, info.end_idx do
                    local e = items[i]
                    local fname = ""
                    local str
                    if e.valid == 1 then
                        if e.bufnr > 0 then
                            fname = fn.bufname(e.bufnr)
                            if fname == "" then
                                fname = "[No Name]"
                            else
                                fname = fname:gsub("^" .. vim.env.HOME, "~")
                            end
                            -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
                            if #fname <= limit then
                                fname = fnameFmt1:format(fname)
                            else
                                fname = fnameFmt2:format(fname:sub(1 - limit))
                            end
                        end
                        local lnum = e.lnum > 99999 and -1 or e.lnum
                        local col = e.col > 999 and -1 or e.col
                        local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
                        str = validFmt:format(fname, lnum, col, qtype, e.text)
                    else
                        str = e.text
                    end
                    table.insert(ret, str)
                end
                return ret
            end

            vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
        end,
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
                -- Using tectonic compiler
                tex = function(...)
                    require("code_runner.hooks.ui").select({
                        Single = function()
                            local preview = require("code_runner.hooks.preview_pdf")
                            preview.run({
                                command = "tectonic",
                                args = { "$fileName", "--keep-logs", "-o", "/tmp" },
                                preview_cmd = "zathura --fork",
                                overwrite_output = "/tmp",
                            })
                        end,
                        Project = function()
                            -- this is my personal config for compiling a project with tectonic
                            -- for example --keep-logs is used to keep the logs of the compilation, see tectonic -X build --help for more info
                            require("code_runner.hooks.tectonic").build("zathura --fork", { "--keep-logs" }) -- Build the project, default command is tectonic -X build
                        end,
                    })
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
        },
        config = function(_, opts)
            require("nvim-highlight-colors").setup(opts)
        end,
    },
    {
        -- Displays the keys you are typing in a floating window, just like screenkey does
        "NStefan002/screenkey.nvim",
        cmd = "Screenkey",
        version = "*",
        config = true,
    },
    {
        "mikavilpas/yazi.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>yy",
                function()
                    require("yazi").yazi()
                end,
                desc = "Open yazi",
            },
            {
                -- Open in the current working directory
                "<leader>yw",
                function()
                    require("yazi").yazi(nil, vim.fn.getcwd())
                end,
                desc = "Open yazi in working directory",
            },
        },
        opts = {
            open_for_directories = false,
        },
    },
    {
        -- Toggle options
        [1] = "gregorias/toggle.nvim",
        version = "2.0",
        lazy = false,
        config = true,
    },
    {
        -- Decorations for vimdoc/help files in Neovim.
        -- The plugin comes with the Helpview command.
        "OXY2DEV/helpview.nvim",
        lazy = false, -- Recommended
        ft = "help",
        cmd = "Helpview",
        opts = {
            preview = {
                icon_provider = "devicons", -- "mini" or "devicons"
            },
        },
        -- ft = "help",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { size = 1.5 * 1024 * 1024 },
            notifier = {
                enabled = true,
                timeout = 3000,
            },
            quickfile = { enabled = false },
            words = {
                enabled = true,
                debounce = 200,
                notify_jump = true,
                notify_end = true,
            },
            picker = {
                enabled = true,
                ui_select = true,
                -- https://github.com/folke/flash.nvim#-examples
                win = {
                    input = {
                        keys = {
                            ["<a-s>"] = { "flash", mode = { "n", "i" } },
                            ["s"] = { "flash" },
                        },
                    },
                },
                matcher = {
                    frecency = true,
                },
                previewers = {
                    git = {
                        native = true, -- Use my local git previewer (delta).
                    },
                },
                sources = {
                    files = { hidden = true },
                    explorer = {
                        hidden = true,
                        -- https://github.com/GustavEikaas/easy-dotnet.nvim?tab=readme-ov-file#integrating-with-snacks-explorer
                        win = {
                            list = {
                                keys = {
                                    ["A"] = "explorer_add_dotnet",
                                },
                            },
                        },
                        actions = {
                            explorer_add_dotnet = function(picker)
                                local dir = picker:dir()
                                local tree = require("snacks.explorer.tree")
                                local actions = require("snacks.explorer.actions")
                                local easydotnet = require("easy-dotnet")

                                easydotnet.create_new_item(dir, function(item_path)
                                    tree:open(dir)
                                    tree:refresh(dir)
                                    actions.update(picker, { target = item_path })
                                end)
                            end,
                        },
                    },
                    keymaps = { layout = { preset = "vertical", fullscreen = true } },
                },
                actions = {
                    flash = function(picker)
                        require("flash").jump({
                            pattern = "^",
                            label = { after = { 0, 0 } },
                            search = {
                                mode = "search",
                                exclude = {
                                    function(win)
                                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                                    end,
                                },
                            },
                            action = function(match)
                                local idx = picker.list:row2idx(match.pos[1])
                                picker.list:_move(idx, true, true)
                            end,
                        })
                    end,
                },
            },
        },
        keys = {
            --region LSP
            {
                "]r",
                function()
                    Snacks.words.jump(vim.v.count1)
                end,
                desc = "Next Reference",
            },
            {
                "[r",
                function()
                    Snacks.words.jump(-vim.v.count1)
                end,
                desc = "Prev Reference",
            },
            {
                "<leader>lSD",
                function()
                    Snacks.picker.diagnostics({
                        layout = "ivy",
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                desc = "Snacks LSP Diagnostics",
            },
            {
                "<leader>lSd",
                function()
                    Snacks.picker.diagnostics_buffer({
                        layout = "ivy",
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                desc = "Snacks LSP Diagnostics (Buffer)",
            },
            {
                "<leader>ltd",
                function()
                    Snacks.picker.lsp_type_definitions({
                        layout = "ivy",
                    })
                end,
                desc = "Lsp type definitions",
            },
            {
                "<leader>ls",
                function()
                    Snacks.picker.lsp_symbols({
                        layout = "sidebar",
                    })
                end,
                desc = "Lsp document symbols",
            },
            {
                "<leader>lws",
                function()
                    Snacks.picker.lsp_workspace_symbols({
                        layout = "sidebar",
                    })
                end,
                desc = "Lsp workspace symbols",
            },
            --endregion

            --region Grep
            {
                "<leader>sgg",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Snacks Grep",
            },
            {
                "<leader>sgh",
                function()
                    Snacks.picker.grep({ dirs = { hidden = true } })
                end,
                desc = "Snacks Grep (hidden)",
            },
            {
                "<leader>sgc",
                function()
                    Snacks.picker.grep({ dirs = { vim.fn.expand("%:h") }, hidden = true })
                end,
                desc = "Snacks Grep cwd",
            },
            {
                "<leader>sw",
                function()
                    Snacks.picker.grep_word({
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                desc = "Snacks Visual selection or word",
                mode = { "n", "x" },
            },
            {
                "<leader>sgB",
                function()
                    Snacks.picker.grep_buffers({
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                desc = "Snacks Grep Open Buffers",
            },
            --endregion

            -- region General
            {
                "<leader>sb",
                function()
                    Snacks.picker()
                end,
                desc = "Snacks picker builtins",
            },
            {
                "<leader>s:",
                function()
                    Snacks.picker.command_history({
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                desc = "Snacks Command History",
            },
            {
                "<leader>sn",
                function()
                    Snacks.picker.notifications()
                end,
                desc = "Snacks Notification History",
            },
            {
                "<leader>sp",
                function()
                    Snacks.picker.projects({ layout = "ivy" })
                end,
                desc = "Snacks Find projects",
            },
            {
                "<leader>sP",
                function()
                    Snacks.picker.lazy()
                end,
                desc = "Snacks Find plugins",
            },
            {
                "<leader>sq",
                function()
                    Snacks.picker.qflist()
                end,
                desc = "Snacks Quickfix List",
            },
            {
                "<leader>sR",
                function()
                    Snacks.picker.resume()
                end,
                desc = "Resume",
            },
            {
                "<leader>st",
                function()
                    Snacks.picker.treesitter()
                end,
                desc = "Snacks Treesitter",
            },
            {
                "<leader>su",
                function()
                    Snacks.picker.undo()
                end,
                desc = "Undo History",
            },
            {
                "<leader>sz",
                function()
                    Snacks.picker.zoxide()
                end,
                desc = "Snacks Zoxide",
            },
            {
                '<leader>s"',
                function()
                    Snacks.picker.registers()
                end,
                desc = "Snacks Registers",
            },
            {
                "<leader>s/",
                function()
                    Snacks.picker.search_history()
                end,
                desc = "Snacks Search History",
            },
            {
                "<leader>sa",
                function()
                    Snacks.picker.autocmds()
                end,
                desc = "Snacks Autocmds",
            },
            {
                "<leader>sc",
                function()
                    Snacks.picker.colorschemes()
                end,
                desc = "Snacks Colorschemes",
            },
            {
                "<leader>sC",
                function()
                    Snacks.picker.commands()
                end,
                desc = "Snacks Commands",
            },
            {
                "<leader>s?",
                function()
                    Snacks.picker.help()
                end,
                desc = "Snacks Help Pages",
            },
            {
                "<leader>sH",
                function()
                    Snacks.picker.highlights()
                end,
                desc = "Snacks Highlights",
            },
            {
                "<leader>sj",
                function()
                    Snacks.picker.jumps()
                end,
                desc = "Snacks Jumps",
            },
            {
                "<leader>sk",
                function()
                    Snacks.picker.keymaps()
                end,
                desc = "Snacks Keymaps",
            },
            {
                "<leader>sm",
                function()
                    Snacks.picker.marks()
                end,
                desc = "Marks",
            },
            {
                "<leader>sM",
                function()
                    Snacks.picker.man()
                end,
                desc = "Man Pages",
            },
            --endregion

            --region Files
            {
                "<leader>sff",
                function()
                    Snacks.picker.smart()
                end,
                desc = "Snacks Find Old Files",
            },
            {
                "<leader>se",
                function()
                    Snacks.explorer()
                end,
                desc = "Snacks File Explorer",
            },
            {
                "<leader>sfc",
                function()
                    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
                end,
                desc = "Snacks Find Config File",
            },
            {
                "<leader>sr",
                function()
                    Snacks.picker.recent()
                end,
                desc = "Snacks Recent",
            },
            --endregion

            --region Buffers
            {
                "<leader>bd",
                function()
                    Snacks.bufdelete()
                end,
                desc = "Delete current buffer",
            },
            {
                "<leader>bD",
                function()
                    Snacks.bufdelete.other()
                end,
                desc = "Delete all buffers except current",
            },
            {
                "<leader>sB",
                function()
                    Snacks.picker.buffers({
                        finder = "buffers",
                        format = "buffer",
                        hidden = false,
                        unloaded = true,
                        current = true,
                        layout = "vscode",
                        sort_lastused = true,
                        win = {
                            input = {
                                keys = {
                                    ["d"] = "bufdelete",
                                },
                            },
                            list = { keys = { ["d"] = "bufdelete" } },
                        },
                    })
                end,
                desc = "Snacks Find Buffers",
            },
            --endregion
        },
    },
    {
        -- Interactive, searchable reference for all Vim commands with detailed
        -- explanations, beginner tips, and context-aware guidance.
        "shahshlok/vim-coach.nvim",
        cond = false,
        dependencies = {
            "folke/snacks.nvim",
        },
        config = function()
            require("vim-coach").setup()
        end,
        keys = {
            { "<leader>?", "<cmd>VimCoach<cr>", desc = "Vim Coach" },
        },
    },
    {
        "fei6409/log-highlight.nvim",
        opts = {
            keyword = {
                error = "ERROR_MSG",
                warning = { "WARN_X", "WARN_Y" },
                info = { "INFORMATION" },
                debug = {},
                pass = {},
            },
        },
    },
    {
        "stevearc/quicker.nvim",
        ft = "qf",
        opts = {
            keys = {
                {
                    ">",
                    function()
                        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                    end,
                    desc = "Expand quickfix context",
                },
                {
                    "<",
                    function()
                        require("quicker").collapse()
                    end,
                    desc = "Collapse quickfix context",
                },
            },
        },
    },
    {
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {},
    },
}
