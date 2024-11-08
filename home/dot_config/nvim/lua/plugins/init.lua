local load_config = require("utils").load_config

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.6

return {
    -- It's important that you set up the plugins in the following order:

    -- mason.nvim
    -- mason-lspconfig.nvim
    -- Setup servers via lspconfig
    {
        "williamboman/mason.nvim",
        opts = {
            -- https://github.com/williamboman/nvim-lsp-installer/discussions/509#discussioncomment-4009039
            PATH = "prepend", -- "skip" seems to cause the spawning error
            -- https://github.com/seblj/roslyn.nvim/issues/11#issuecomment-2294820871
            registries = {
                "github:mason-org/mason-registry",
                "github:syndim/mason-registry",
            },
        },
        -- Use config from NvChad
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- You can also add plugins you always want to have loaded.
                -- Useful if the plugin has globals or types you want to use
                -- Library paths can be absolute
                -- Or relative, which means they will be resolved from the plugin dir.
                "lazy.nvim",
                -- It can also be a table with trigger words / mods
                -- Only load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                -- always load the LazyVim library
                "LazyVim",
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            -- https://mason-registry.dev/registry/list
            ensure_installed = {
                -- lua stuff
                "lua_ls",

                -- web dev
                "cssls",
                "html",
                "ts_ls",
                "denols",
                "jsonls",
                -- "jqls",

                -- docker
                "docker_compose_language_service",
                "dockerls",

                -- Python
                "basedpyright",
                "ruff",
                "pylyzer",

                --Haskell
                "hls",

                -- .NET
                "csharp_ls",
                "omnisharp",
                "powershell_es",

                -- DevOps + Shell
                "bashls",
                "yamlls",
                -- required for bash LSP
                "codeqlls",

                -- R
                "r_language_server",

                -- SQL
                "sqls",

                -- Misc
                "ast_grep",
                "vimls",

                -- Markdown
                "marksman",

                -- LaTeX
                "texlab",

                -- XML
                "lemminx",
            },
            automatic_installation = true,
        },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)
        end,
    },
    {
        -- Quickstart configs for Neovim LSP.
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason-lspconfig.nvim" },
            {
                "b0o/SchemaStore.nvim",
                version = false, -- last release is way too old
            },
        },
        config = function()
            require("configs.lspconfig")
        end,
    },
    {
        "mrjones2014/legendary.nvim",
        -- since legendary.nvim handles all your keymaps/commands,
        -- its recommended to load legendary.nvim before other plugins
        priority = 10000,
        lazy = false,
        config = function()
            require("legendary").setup({
                extensions = {
                    nvim_tree = true,
                    -- automatically load keymaps from lazy.nvim's `keys` option
                    lazy_nvim = true,
                    diffview = true,
                    which_key = {
                        -- Automatically add which-key tables to legendary
                        -- see ./doc/WHICH_KEY.md for more details
                        auto_register = true,
                    },
                },
            })
        end,
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
            -- https://vonheikemen.github.io/devlog/tools/neovim-plugins-to-get-started/
            on_attach = function(bufnr)
                -- See :help nvim-tree.api
                local api = require("nvim-tree.api")

                local bufmap = function(lhs, rhs, desc)
                    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
                end

                local treeutils = require("utils.tree")
                api.config.mappings.default_on_attach(bufnr)

                bufmap("<c-f>", treeutils.launch_find_files, "Launch Find Files")
                bufmap("<c-g>", treeutils.launch_live_grep, "Launch Live Grep")
                bufmap("<m-r>", function()
                    local path = vim.fn.input("Enter root path:")
                    api.tree.change_root(path)
                end, "Change root to input path")

                local function print_node_path()
                    local node = api.tree.get_node_under_cursor()
                    print(node.absolute_path)
                end
                bufmap("<C-P>", print_node_path, "Print path")

                -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#h-j-k-l-style-navigation-and-editing
                bufmap("l", treeutils.edit_or_open, "Expand folder or go to file")
                bufmap("L", treeutils.vsplit_preview, "VSplit Preview")
                bufmap("h", api.node.navigate.parent_close, "Close parent folder")
                bufmap("H", api.tree.collapse_all, "Collapse All")
                bufmap("gh", api.tree.toggle_hidden_filter, "Toggle hidden files")
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
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "nvimtree")
            require("configs.nvimtree")
            require("nvim-tree").setup(opts)
        end,
    },
    {
        -- Plugin to easily manage multiple terminal windows.
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm", "ToggleTermAll", "TermExec" },
        config = load_config("toggleterm"),
    },

    { "nvchad/volt",          lazy = true },
    {
        "nvchad/menu",
        lazy = true,
        config = function()
            -- mouse users + nvimtree users!
            vim.keymap.set("n", "<RightMouse>", function()
                vim.cmd.exec '"normal! \\<RightMouse>"'

                local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
                require("menu").open(options, { mouse = true })
            end, {})
        end,
    },
}
