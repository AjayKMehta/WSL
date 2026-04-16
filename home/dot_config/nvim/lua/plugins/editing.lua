local utils = require("utils")
local load_config = utils.load_config
local excluded_ftypes = utils.excluded_ftypes

return {
    {
        "kylechui/nvim-surround",
        lazy = false,
        init = function()
            vim.g.nvim_surround_no_normal_mappings = true
        end,
        keys = {
            { "ys", "<Plug>(nvim-surround-normal)", desc = "Add a surrounding pair around a motion (normal mode)" },
            {
                "yr",
                "<Plug>(nvim-surround-normal-cur)",
                desc = "Add a surrounding pair around the current line (normal mode)",
            },
            {
                "yS",
                "<Plug>(nvim-surround-normal-line)",
                desc = "Add a surrounding pair around a motion, on new lines (normal mode)",
            },
            {
                "yR",
                "<Plug>(nvim-surround-normal-cur-line)",
                desc = "Add a surrounding pair around the current line, on new lines (normal mode)",
            },
            { "ds", "<Plug>(nvim-surround-delete)", desc = "Delete a surrounding pair" },
            { "cs", "<Plug>(nvim-surround-change)", desc = "Change a surrounding pair" },
            {
                "cS",
                "<Plug>(nvim-surround-change-line)",
                desc = "Change a surrounding pair, putting replacements on new lines",
            },
        },
        config = load_config("nvim_surround"),
    },
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup()
        end,
    },
    {
        -- Move lines and blocks of code
        "nvim-mini/mini.move",
        version = false,
        opts = {
            mappings = {
                -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
                left = "<A-Left>",
                right = "<A-right>",
                down = "<A-Down>",
                up = "<A-Up>",

                -- Move current line in Normal mode
                line_left = "<A-Left>",
                line_right = "<A-right>",
                line_down = "<A-Down>",
                line_up = "<A-Up>",
            },
            options = { reindent_linewise = true },
        },
        event = "VeryLazy",
    },
    {
        "y3owk1n/undo-glow.nvim",
        event = { "VeryLazy" },
        config = load_config("undo_glow"),
    },
    {
        "smoka7/multicursors.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvimtools/hydra.nvim",
        },
        cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
        keys = {
            {
                mode = { "n" },
                "<Leader>ms",
                "<cmd>MCstart<cr>",
                desc = "Create a selection for selected text or word under the cursor",
            },
            {
                mode = { "v" },
                "ms",
                "<cmd>MCstart<cr>",
                desc = "Create a selection for selected text or word under the cursor",
            },
        },
        config = load_config("multicursors"),
    },
    -- Copy data to system clipboard only when you press 'y'. 'd', 'x' will be filtered out.
    {
        "ibhagwan/smartyank.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            highlight = {
                timeout = 1000,
            },
        },
    },
    -- Respect camelCase and the like in w,e,b motions)
    {
        "chrisgrieser/nvim-spider",
        lazy = true,
        -- Use commands to make them dot-repeatable!
        keys = {
            {
                "<M-w>",
                "<cmd>lua require('spider').motion('w')<CR>",
                desc = "Spider w",
                mode = { "n", "o", "x" },
            },
            { "<M-e>", "<cmd>lua require('spider').motion('e')<CR>", desc = "Spider e", mode = { "n", "o", "x" } },
            { "<M-b>", "<cmd>lua require('spider').motion('b')<CR>", desc = "Spider b", mode = { "n", "o", "x" } },
            { "gE", "<cmd>lua require('spider').motion('ge')<CR>", desc = "Spider ge", mode = { "n", "o", "x" } },
            -- https://github.com/chrisgrieser/nvim-spider?tab=readme-ov-file#operator-pending-mode-the-case-of-cw
            { "cw", "c<cmd>lua require('spider').motion('e')<CR>", mode = "n" },
            {
                "1",
                "<cmd>lua require('spider').motion('w', { customPatterns = {'%d+'}})<CR>",
                desc = "Spider number",
                mode = "n",
            },
        },
        opts = {
            skipInsignificantPunctuation = true,
            subwordMovement = true,
            customPatterns = {},
        },
    },
    {
        "ravibrock/spellwarn.nvim",
        event = "VeryLazy",
        opts = {
            ft_config = { -- spellcheck method: "cursor", "iter", or boolean
                alpha = false,
                help = false,
                lazy = false,
                checkhealth = false,
                cabal = false,
                lspinfo = false,
                mason = false,
                python = "iter",
                markdown = true,
                ["gitsigns-blame"] = false,
            },
            ft_default = false, -- default option for unspecified filetypes
            max_file_size = nil, -- maximum file size to check in lines (nil for no limit)
            severity = { -- severity for each spelling error type (false to disable diagnostics for that type)
                spellbad = "WARN",
                spellcap = "HINT",
                spelllocal = "HINT",
                spellrare = "INFO",
            },
            prefix = "possible misspelling(s): ", -- prefix for each diagnostic message
        },
    },
    -- Assists with discovering motions
    {
        "tris203/precognition.nvim",
        enabled = true,
        dependencies = { "chrisgrieser/nvim-spider" },
        event = { "BufRead", "BufNewFile" },
        cmd = { "Precognition" },
        keys = {
            {
                "<leader>pT",
                function()
                    if require("precognition").toggle() then
                        vim.notify("precognition on")
                    else
                        vim.notify("precognition off")
                    end
                end,
                { desc = "Precognition toggle" },
            },
            {
                "<leader>pp",
                "<cmd>Precognition peek<CR>",
                { desc = "Precognition peek" },
            },
        },
        opts = {
            startVisible = true,
            showBlankVirtLine = true,
            highlightColor = { link = "Comment" },
            hints = {
                Caret = { text = "^", prio = 2 },
                Dollar = { text = "$", prio = 1 },
                MatchingPair = { text = "%", prio = 5 },
                Zero = { text = "0", prio = 1 },
                w = { text = "w", prio = 10 },
                b = { text = "b", prio = 9 },
                e = { text = "e", prio = 8 },
                W = { text = "W", prio = 7 },
                B = { text = "B", prio = 6 },
                E = { text = "E", prio = 5 },
            },
            gutterHints = {
                G = { text = "G", prio = 10 },
                gg = { text = "gg", prio = 9 },
                PrevParagraph = { text = "{", prio = 8 },
                NextParagraph = { text = "}", prio = 8 },
            },
            disabled_fts = excluded_ftypes,
        },
    },
    {
        -- Navigate your code with search labels, enhanced character motions, and Treesitter integration.
        "folke/flash.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = load_config("flash"),
    },
    {
        "chrisgrieser/nvim-various-textobjs",
        event = "VeryLazy",
        opts = {
            keymaps = {
                useDefaults = true,
                disabledDefaults = { "ii", "ai", "aI", "C", "in", "an" },
            },
        },
        config = function(_, opts)
            require("various-textobjs").setup(opts)

            -- Based on this:
            -- https://github.com/chrisgrieser/nvim-various-textobjs?tab=readme-ov-file#smarter-gx
            vim.keymap.set("n", "gX", function()
                -- select URL
                require("various-textobjs").url()

                -- plugin only switches to visual mode when textobj is found
                local foundURL = vim.fn.mode() == "v"
                if not foundURL then
                    return
                end

                local r = require("utils.registers")
                local reg = r.get_first_empty_register()
                if reg == nil then
                    vim.notify("No empty register!")
                    return
                end

                -- retrieve URL with the register as intermediary
                vim.cmd.normal({ '"' .. reg .. "y", bang = true })
                local url = vim.fn.getreg(reg)
                r.clear_register(reg)
                vim.ui.open(url)
            end, { desc = "Open URL (smart)" })

            -- https://github.com/chrisgrieser/nvim-various-textobjs?tab=readme-ov-file#delete-surrounding-indentation
            vim.keymap.set("n", "Dsi", function()
                -- select outer indentation
                require("various-textobjs").indentation("outer", "outer")

                -- plugin only switches to visual mode when a textobj has been found
                local indentationFound = vim.fn.mode():find("V")
                if not indentationFound then
                    return
                end

                -- dedent indentation
                vim.cmd.normal({ "<", bang = true })

                -- delete surrounding lines
                local endBorderLn = vim.api.nvim_buf_get_mark(0, ">")[1]
                local startBorderLn = vim.api.nvim_buf_get_mark(0, "<")[1]
                vim.cmd(tostring(endBorderLn) .. " delete") -- delete end first so line index is not shifted
                vim.cmd(tostring(startBorderLn) .. " delete")
            end, { desc = "Delete Surrounding Indentation" })
        end,
    },
    {
        "windwp/nvim-autopairs",
        -- cond = not vim.g.use_blink,
        event = "InsertEnter",
        opts = {
            fast_wrap = {
                map = "<M-m>",
            },
            check_ts = true,
            disable_filetype = excluded_ftypes,
        },
        config = function(_, opts)
            local npairs = require("nvim-autopairs")

            npairs.setup(opts)

            local Rule = require("nvim-autopairs.rule")
            local cond = require("nvim-autopairs.conds")

            npairs.add_rules({
                Rule("<", ">", { "cs", "java" })
                    :with_pair(cond.not_inside_quote())
                    :with_pair(cond.before_regex("%a+"))
                    :with_pair(cond.not_after_text(">"))
                    -- Move cursor right after inserting pair
                    :with_move(cond.none())
                    -- Allow deletion of both brackets at once
                    :with_del(cond.none())
                    -- Don't add newline when pressing <CR>
                    :with_cr(cond.none()),
            })

            npairs.get_rules("'")[1]:with_pair(cond.not_filetypes({ "ps1" }))
            npairs.get_rules('"')[1]:with_pair(cond.not_filetypes({ "ps1" }))

            npairs.add_rule(Rule("@'", "@'", { "ps1" }))
            npairs.add_rule(Rule('@"', '"@', { "ps1" }))
            npairs.add_rule(
                Rule("'", "'", { "ps1" }):with_pair(cond.not_before_text("@")):with_pair(cond.not_inside_quote)
            )
            npairs.add_rule(
                Rule('"', '"', { "ps1" }):with_pair(cond.not_before_text("@")):with_pair(cond.not_inside_quote)
            )
        end,
    },
    {
        "MagicDuck/grug-far.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("grug-far").setup({
                engine = "ripgrep",
                engines = {
                    -- see https://github.com/BurntSushi/ripgrep
                    ripgrep = {
                        -- ripgrep executable to use, can be a different path if you need to configure
                        path = "rg",

                        -- extra args that you always want to pass
                        -- like for example if you always want context lines around matches
                        extraArgs = "",

                        -- whether to show diff of the match being replaced as opposed to just the
                        -- replaced result. It usually makes it easier to understand the change being made
                        showReplaceDiff = true,
                    },
                },
            })
            local gf = require("grug-far")
            local au_group = vim.api.nvim_create_augroup("grug-far-keybindings", { clear = true })

            vim.api.nvim_create_autocmd("FileType", {
                group = au_group,
                pattern = { "grug-far" },
                callback = function()
                    vim.keymap.set("n", "<localleader>h", function()
                        local state = unpack(gf.get_instance(0):toggle_flags({ "--hidden" }))
                        vim.notify("grug-far: toggled --hidden " .. (state and "ON" or "OFF"))
                    end, { buffer = true })
                end,
            })

            -- open a result location and immediately close grug-far.nvim
            vim.api.nvim_create_autocmd("FileType", {
                group = au_group,
                pattern = { "grug-far" },
                callback = function()
                    vim.api.nvim_buf_set_keymap(0, "n", "<C-enter>", "<localleader>o<localleader>c", {})
                end,
            })

            dofile(vim.g.base46_cache .. "grug_far")
        end,
        keys = {
            {
                "<leader>g*",
                function()
                    require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
                end,
                desc = "Grug Find current word",
            },
            {
                "<leader>gc",
                function()
                    require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
                end,
                desc = "Grug Find in current file",
            },
        },
    },
    {
        "allaman/emoji.nvim",
        cmd = "Emoji",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "folke/snacks.nvim",
            "nvim-telescope/telescope.nvim",
        },
    },
}
