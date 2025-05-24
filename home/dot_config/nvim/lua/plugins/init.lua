local load_config = require("utils").load_config

local HEIGHT_RATIO = 0.7
local WIDTH_RATIO = 0.4

return {
    {
        "b0o/SchemaStore.nvim",
        version = false, -- last release is way too old
    },
    -- NVChad loads this by default.
    { "neovim/nvim-lspconfig", enabled = false },
    {
        -- NvChad loads base46 integration for mason
        "mason-org/mason.nvim",
        opts = {
            -- https://github.com/williamboman/nvim-lsp-installer/discussions/509#discussioncomment-4009039
            PATH = "prepend", -- "skip" seems to cause the spawning error
            -- https://github.com/seblj/roslyn.nvim/issues/11#issuecomment-2294820871
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            },
            ui = {
              icons = {
                package_pending = " ",
                package_installed = " ",
                package_uninstalled = " ",
              },
            },
            max_concurrent_installers = 10,
        },
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "mason")
            require("mason").setup(opts)
        end
    },
        {
            "nvchad/base46",
            event = { "BufReadPre", "BufNewFile" },
            branch = "v3.0",
            build = function()
                require("base46").load_all_highlights()
            end,
          },
        -- Use config from NvChad
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                "~/.config/nvim",
                "lazy.nvim",
                -- It can also be a table with trigger words / mods
                -- Only load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
        dependencies = { "Bilal2453/luvit-meta", lazy = true },
    },
    {
        "nvim-tree/nvim-tree.lua",
        opts = {
            filters = {
                -- https://github.com/nvim-tree/nvim-tree.lua/pull/2706
                enable = true,
                dotfiles = false,
                custom = { "node_modules" },
            },
            -- git support in nvimtree
            git = {
                enable = true,
                timeout = 10000,
            },
            diagnostics = {
                enable = true,
                show_on_dirs = true,
                show_on_open_dirs = true,
                debounce_delay = 50,
                severity = {
                    min = vim.diagnostic.severity.HINT,
                    max = vim.diagnostic.severity.ERROR,
                },
            },

            modified = {
                enable = true,
            },
            renderer = {
                root_folder_label = ":~:s?$?/..?",
                add_trailing = true,
                highlight_opened_files = "name",
                highlight_git = "icon",
                highlight_diagnostics = "icon",
                highlight_modified = "name",
                highlight_bookmarks = "icon",
                special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
                symlink_destination = true,
                indent_markers = {
                    enable = true,
                },
                icons = {
                    git_placement = "after",
                    modified_placement = "after",
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                        modified = true,
                        diagnostics = true,
                        bookmarks = true,
                    },
                    web_devicons = {
                        file = {
                            enable = true,
                            color = true,
                        },
                        folder = {
                            enable = false,
                            color = true,
                        },
                    },
                },
            },
            on_attach = function(bufnr)
                -- See :help nvim-tree.api
                local api = require("nvim-tree.api")
                local preview = require("nvim-tree-preview")
                local luv = vim.loop

                local bufmap = function(lhs, rhs, desc)
                    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
                end

                local treeutils = require("utils.tree")
                api.config.mappings.default_on_attach(bufnr)

                local function add_dotnet()
                    local node = api.tree.get_node_under_cursor()
                    local path = node.type == "directory" and node.absolute_path or vim.fs.dirname(node.absolute_path)
                    require("easy-dotnet").create_new_item(path)
                end

                local function add_ref_to_chat(chat, path, pinned)
                    chat.references:add({
                        id = "<file>" .. path .. "</file>",
                        path = path,
                        source = "codecompanion.strategies.chat.slash_commands.file",
                        opts = {
                            pinned = pinned,
                        },
                    })
                end
                -- Function to recursively add files in a directory to chat references
                local function traverse_directory(path, chat, pinned)
                    local handle, err = luv.fs_scandir(path)
                    if not handle then
                        return print("Error scanning directory: " .. err)
                    end

                    while true do
                        local name, type = luv.fs_scandir_next(handle)
                        if not name then
                            break
                        end

                        local item_path = path .. "/" .. name
                        if type == "file" then
                            add_ref_to_chat(chat, item_path, pinned)
                        elseif type == "directory" then
                            -- recursive call for a subdirectory
                            traverse_directory(item_path, chat)
                        end
                    end
                end

                local function add_refs_to_chat(pinned)
                    return function()
                        local node = api.tree.get_node_under_cursor()
                        local path = node.absolute_path
                        local codecompanion = require("codecompanion")
                        local chat = codecompanion.last_chat()
                        -- create chat if none exists
                        if chat == nil then
                            chat = codecompanion.chat()
                        end

                        local attr = luv.fs_stat(path)
                        if attr and attr.type == "directory" then
                            -- Recursively traverse the directory
                            traverse_directory(path, chat, pinned)
                        else
                            -- if already added, ignore
                            for _, ref in ipairs(chat.refs) do
                                if ref.path == path then
                                    return print("Already added")
                                end
                            end
                            add_ref_to_chat(chat, path, pinned)
                        end
                    end
                end

                bufmap("A", add_dotnet, "Create file from dotnet template")

                -- https://github.com/olimorris/codecompanion.nvim/discussions/641#discussioncomment-11836380
                bufmap("<leader>ca", add_refs_to_chat(false), "Add file(s) to Chat")
                bufmap("<leader>cp", add_refs_to_chat(true), "Pin file(s) to Chat")

                bufmap("<c-f>", treeutils.launch_find_files, "Launch Find Files")
                bufmap("<c-g>", treeutils.launch_live_grep, "Launch Live Grep")
                bufmap("<m-r>", function()
                    local path = vim.fn.input("Enter root path:")
                    api.tree.change_root(path)
                end, "Change root to input path")

                bufmap("<S-Tab>", preview.watch, "Preview (Watch)")
                bufmap("<Esc>", preview.unwatch, "Close Preview/Unwatch")

                local function print_node_path()
                    local node = api.tree.get_node_under_cursor()
                    print(node.absolute_path)
                end
                bufmap("<C-P>", print_node_path, "Print path")

                -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#h-j-k-l-style-navigation-and-editing
                bufmap("l", treeutils.edit_or_open, "Expand folder or go to file")
                bufmap("L", treeutils.vsplit_preview, "VSplit Preview")
                bufmap("h", api.node.navigate.parent_close, "Close parent folder")
                bufmap("gl", api.node.open.toggle_group_empty, "Toggle group empty")

                bufmap("<C-c>", treeutils.change_root_to_global_cwd, "Change Root To Global CWD")

                -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#git-stage-unstage-files-and-directories-from-the-tree
                local git_add = function()
                    local node = api.tree.get_node_under_cursor()
                    local gs = node.git_status.file

                    -- If the current node is a directory get children status
                    if gs == nil then
                        gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
                            or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
                    end

                    -- If the file is untracked, unstaged or partially staged, we stage it
                    if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
                        vim.cmd("silent !git add " .. node.absolute_path)

                        -- If the file is staged, we unstage
                    elseif gs == "M " or gs == "A " then
                        vim.cmd("silent !git restore --staged " .. node.absolute_path)
                    end

                    api.tree.reload()
                end

                bufmap("ga", git_add, "Stage/unstage file")

                -- https://github.com/b0o/nvim-tree-preview.lua
                -- Smart tab behavior: Only preview files, expand/collapse directories (recommended)
                bufmap("<Tab>", function()
                    local ok, node = pcall(api.tree.get_node_under_cursor)
                    if ok and node then
                        if node.type == "directory" then
                            api.node.open.edit()
                        else
                            preview.node(node, { toggle_focus = true })
                        end
                    end
                end, "Preview")

                -- https://github.com/nvim-tree/nvim-tree.lua/pull/3040#discussion_r1912634104
                bufmap("BW", function()
                    api.node.buffer.wipe(api.tree.get_node_under_cursor(), { force = false })
                end, "Wipe")

                bufmap("BD", function()
                    api.node.buffer.wipe(api.tree.get_node_under_cursor(), { force = true })
                end, "Delete")
            end,
            -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#center-a-floating-nvim-tree-window
            view = {
                float = {
                    enable = false,
                    open_win_config = function()
                        local screen_w = vim.opt.columns:get()
                        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                        local window_w = screen_w * WIDTH_RATIO
                        local window_h = screen_h * HEIGHT_RATIO
                        local window_w_int = math.floor(window_w)
                        local window_h_int = math.floor(window_h)
                        local center_x = (screen_w - window_w) / 2
                        local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                        return {
                            border = "rounded",
                            relative = "editor",
                            row = center_y,
                            col = center_x,
                            width = window_w_int,
                            height = window_h_int,
                        }
                    end,
                },
                -- TODO: Switch to adaptive width?
                -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#toggle-adaptive-width

                width = function()
                    return require("utils").get_width(WIDTH_RATIO, nil, nil)
                end,
            },
        },
        dependencies = { "nvim-tree/nvim-web-devicons", "b0o/nvim-tree-preview.lua" },
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "nvimtree")
            require("configs.nvimtree")
            require("nvim-tree").setup(opts)
            vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
        end,
    },
    {
        -- Plugin to easily manage multiple terminal windows.
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm", "ToggleTermAll", "TermExec", "TermNew" },
        config = load_config("toggleterm"),
    },

    { "nvchad/volt", lazy = true },
    {
        "nvchad/menu",
        lazy = true,
        config = function()
            -- mouse users + nvimtree users!
            vim.keymap.set("n", "<RightMouse>", function()
                vim.cmd.exec('"normal! \\<RightMouse>"')

                local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
                require("menu").open(options, { mouse = true })
            end, {})
        end,
    },
}
