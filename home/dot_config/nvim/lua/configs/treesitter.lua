local config = {
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
        "powershell",
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
        enable = vim.g.use_autopairs,
    },
    indent = { enable = true, disable = { "python", "css" } },
    autotag = {
        enable = true,
    },
    highlight = {
        enable = true,
        disable = function(lang, buf)
            local max_filesize = 200 * 1024 -- 200 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        use_languagetree = true,
    },
    tree_setter = {
        enable = true,
    },
    matchup = { enable = true },
    -- https://github.com/nvim-treesitter/nvim-treesitter-refactor
    refactor = {
        highlight_current_scope = { enable = true },
        highlight_definitions = {
            enable = true,
            -- Set to false if you have an `updatetime` of ~100.
            clear_on_cursor_move = true,
        },
        navigation = {
            enable = true,
            -- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
            keymaps = {
                goto_definition = false,
                -- TODO: Test these out.
                list_definitions = false,
                list_definitions_toc = false,
                goto_next_usage = "]U",
                goto_previous_usage = "[U",
            },
        },
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<leader>ti",
            node_incremental = "<leader>tk",
            scope_incremental = "<leader>ts",
            node_decremental = "<leader>tj",
        },
    },
    textobjects = {
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]f"] = { query = "@call.outer", desc = "Next function call start" },
                ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
                ["]c"] = { query = "@class.outer", desc = "Next class start" },
                ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
                ["]l"] = { query = "@loop.outer", desc = "Next loop start" },

                ["]S"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
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
                ["[c"] = { query = "@class.outer", desc = "Prev class start" },
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
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
                ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
                ["=L"] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
                ["=R"] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

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
                ["<leader>pc"] = "@class.outer",
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

dofile(vim.g.base46_cache .. "syntax")
-- dofile(vim.g.base46_cache .. "semantic_tokens")
dofile(vim.g.base46_cache .. "treesitter")

require("nvim-treesitter.configs").setup(config)
require("nvim-treesitter.install").compilers = { "clang" }
