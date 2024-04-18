local M = {}

M.treesitter = {
    -- ensure_installed = "all",
    ensure_installed = {
        "bash",
        "c_sharp",
        "c",
        "cmake",
        "comment",
        "css",
        "diff",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "haskell",
        "html",
        "javascript",
        "jq",
        "json",
        "json5",
        "jsonc",
        "latex",
        "lua",
        "luadoc",
        "luap",
        "markdown_inline",
        "markdown",
        "mermaid",
        "python",
        "query",
        "r",
        "regex",
        "sql",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "zathurarc",
    },
    auto_install = true,
    autopairs = {
        enable = true,
    },
    indent = { enable = true, disable = { "python", "css" } },
    autotag = {
        enable = true,
    },
    tree_setter = {
        enable = true,
    },
    -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/issues/82#issuecomment-1817659634
    -- context_commentstring = { enable = true },
    matchup = { enable = true },
    -- https://github.com/nvim-treesitter/nvim-treesitter-refactor
    refactor = {
        highlight_current_scope = { enable = true },
        highlight_definitions = {
            enable = true,
            -- Set to false if you have an `updatetime` of ~100.
            clear_on_cursor_move = true,
        },
        smart_rename = {
            enable = true,
            -- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
            keymaps = {
                smart_rename = false, -- "grr"
            },
        },
        navigation = {
            enable = true,
            -- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
            keymaps = {
                goto_definition = "gd",
                list_definitions = "gld",
                list_definitions_toc = "glt",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>",
            },
        },
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gi",
            node_incremental = "gk",
            scope_incremental = "gs",
            node_decremental = "gj",
        },
    },
    textobjects = {
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["=a"] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
                ["=i"] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
                ["=l"] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
                ["=r"] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
                ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
                ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

                ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
                ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

                ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
                ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

                ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
                ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

                ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
                ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

                ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },

                ["aq"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]f"] = { query = "@call.outer", desc = "Next function call start" },
                ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
                -- ["]c"] = { query = "@class.outer", desc = "Next class start" },
                ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
                ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
            },
            goto_next_end = {
                ["]F"] = { query = "@call.outer", desc = "Next function call end" },
                ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
                ["]C"] = { query = "@class.outer", desc = "Next class end" },
                ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
                ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
            },
            goto_previous_start = {
                ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
                ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
                -- ["[c"] = { query = "@class.outer", desc = "Prev class start" },
                ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
                ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
            },
            goto_previous_end = {
                ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
                ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
                ["[C"] = { query = "@class.outer", desc = "Prev class end" },
                ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
                ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
                ["<leader>n:"] = "@property.outer", -- swap object property with next
                ["<leader>nm"] = "@function.outer", -- swap function with next
            },
            swap_previous = {
                ["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
                ["<leader>p:"] = "@property.outer", -- swap object property with prev
                ["<leader>pm"] = "@function.outer", -- swap function with previous
            },
        },
        lsp_interop = {
            enable = true,
            border = "none",
            floating_preview_opts = {},
            peek_definition_code = {
                ["<leader>pf"] = "@function.outer",
                ["<leader>pF"] = "@class.outer",
            },
        },
    },
    playground = {
        enable = true,
    },
    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
    },
}

local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.6 -- You can change this too

M.nvimtree = {
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
            git_placement = "before",
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

        local treeutils = require("configs.treeutils")
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
    end,
    -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#center-a-floating-nvim-tree-window
    view = {
        float = {
            enable = true,
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
        width = function()
            return require("utils").get_width(WIDTH_RATIO, nil, nil)
        end,
    },
}

-- For NvChad-specified settings, see https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/configs/cmp.lua
M.cmp = {
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#disabling-completion-in-certain-contexts-such-as-comments
    enabled = function()
        -- disable completion in comments
        local context = require("cmp.config.context")
        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == "c" then
            return true
        else
            return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
        end
    end,
    experimental = {
        ghost_text = {
            hl_group = "Comment",
        },
    },
    -- https://github.com/Aumnescio/dotfiles/blob/758be23d2f064a480915d1fc8339a6c0d2a71b77/nvim/lua/plugins/autocompletion.lua
    performance = {
        debounce = 25,
        throttle = 50,
        max_view_entries = 30,
        fetching_timeout = 200,
        async_budget = 50,
    },
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    matching = {
        disallow_fuzzy_matching = false,
        disallow_fullfuzzy_matching = true,
        disallow_partial_fuzzy_matching = false,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = false,
    },
    completion = {
        completeopt = "menu,menuone,noinsert,noselect",
        keyword_length = 2,
    },
    mapping = {
        -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#safely-select-entries-with-cr
        ["<CR>"] = require("cmp").mapping({
            i = function(fallback)
                local cmp = require("cmp")
                if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                    fallback()
                end
            end,
            s = require("cmp").mapping.confirm({ select = true }),
            c = require("cmp").mapping.confirm({ behavior = require("cmp").ConfirmBehavior.Replace, select = true }),
        }),
        ["<M-d>"] = require("cmp").mapping({
            i = function()
                local cmp = require("cmp")
                if cmp.visible_docs() then
                    cmp.close_docs()
                else
                    cmp.open_docs()
                end
            end,
        }),
        ["<Down>"] = require("cmp").mapping(require("cmp").mapping.select_next_item({ behavior = require("cmp").SelectBehavior.Insert }), { "i" }), -- Alternative `Select Previous Item`
        ["<Up>"] = require("cmp").mapping(require("cmp").mapping.select_prev_item({ behavior = require("cmp").SelectBehavior.Insert }), { "i" }), -- Alternative `Select Next Item`
    },
    sorting = {
        comparators = {
            require("cmp").config.compare.offset,
            require("cmp").config.compare.exact,
            require("cmp").config.compare.score,
            require("cmp").config.compare.receently_used,
            require("cmp").config.compare.kind,
            require("cmp").config.compare.sort_text,
            require("cmp").config.compare.length,
            require("cmp").config.compare.order,
        },
    },
    window = {
        completion = require("cmp.config.window").bordered({
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
        }),
        -- TODO: Figure out if this can be toggled.
        -- documentation = false,
    },
    -- https://github.com/hrsh7th/nvim-cmp/commit/7aa3f71932c419d716290e132cacbafbaf5bea1c
    view = {
        entries = {
            follow_cursor = true,
        },
    },
}

return M
