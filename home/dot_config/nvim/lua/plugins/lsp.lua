local load_config = require("utils").load_config

return {
    {
        -- Performant LSP progress status.
        "linrongbin16/lsp-progress.nvim",
        config = load_config("lsp_progress"),
    },
    {
        -- Garbage collector that stops inactive LSP clients to free RAM.
        "zeioth/garbage-day.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        event = "VeryLazy",
    },
    {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("lsp_lines").setup()
            require("lsp_lines").toggle()
        end,
        keys = {
            {
                "<leader>lt",
                function()
                    require("lsp_lines").toggle()
                end,
                desc = "Lsp Toggle inline diagnostics",
            },
        },
    },
    {
        "adoyle-h/lsp-toggle.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        cmd = { "ToggleLSP" },
        opts = {
            create_cmds = true, -- Whether to create user commands
            telescope = true, -- Whether to load telescope extensions
        },
    },
    {
        -- Show function signature as you type.
        "ray-x/lsp_signature.nvim",
        -- Displays overload info!
        ft = { "cs", "python" },
        -- Disabling this and setting lsp.signature.enabled for Noice to true doesn't work :(
        enabled = true,
        opts = {
            debug = false, -- set to true to enable debug logging
            log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
            -- default is  ~/.cache/nvim/lsp_signature.log
            verbose = false, -- show debug line number

            bind = true, -- This is mandatory, otherwise border config won't get registered.
            -- If you want to hook lspsaga or other signature handler, pls set to false
            doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
            -- set to 0 if you DO NOT want any API comments be shown
            -- This setting only take effect in insert mode, it does not affect signature help in normal
            -- mode, 10 by default

            max_height = 12, -- max height of signature floating_window
            max_width = 80, -- max_width of signature floating_window
            noice = true, -- set to true if you using noice to render markdown
            wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long

            floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

            floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
            -- will set to true when fully tested, set to false will use whichever side has more space
            -- this setting will be helpful if you do not want the PUM and floating win overlap

            floating_window_off_x = 1, -- adjust float windows x position.
            -- can be either a number or function
            floating_window_off_y = function() -- adjust float windows y position. e.g. set to -2 can make floating window move up 2 lines
                local linenr = vim.api.nvim_win_get_cursor(0)[1] -- buf line number
                local pumheight = vim.o.pumheight
                local winline = vim.fn.winline() -- line number in the window
                local winheight = vim.fn.winheight(0)

                -- window top
                if winline - 1 < pumheight then
                    return pumheight
                end

                -- window bottom
                if winheight - winline < pumheight then
                    return -pumheight
                end
                return 0
            end,

            close_timeout = 4000, -- close floating window after ms when last parameter is entered
            fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
            hint_enable = true, -- virtual hint enable
            hint_prefix = "󰏚 ", -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
            hint_scheme = "String",
            hint_inline = function()
                if vim.fn.has("nvim-0.10") == 1 then
                    return "inline"
                else
                    return false
                end
            end, -- should the hint be inline(nvim 0.10 only)?  default false
            hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
            handler_opts = {
                border = "rounded", -- double, rounded, single, shadow, none, or a table of borders
            },

            always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

            auto_close_after = 5000, -- autoclose signature float win after x sec, disabled if nil.
            extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
            zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

            padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc

            transparency = nil, -- disabled by default, allow floating win transparent value 1~100
            shadow_blend = 36, -- if you using shadow as border use this set the opacity
            shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
            timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
            toggle_key = "<M-t>", -- toggle floating window key (must set below to true)
            toggle_key_flip_floatwin_setting = true,

            -- DOESN'T WORK?
            select_signature_key = "<M-n>", -- cycle to next signature, e.g. '<M-n>' function overloading
            move_cursor_key = "<M-w>", -- imap, use nvim_set_current_win to move cursor between current win and floating
        },
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        config = function(_, opts)
            require("lsp_signature").setup(opts)
        end,
    },
}
