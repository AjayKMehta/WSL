local load_config = require("utils").load_config
local lsp = require("utils.lsp")

return {
    {
        "R-nvim/R.nvim",
        -- Only required if you also set defaults.lazy = true
        lazy = false,
        opts = {
            -- Create a table with the options to be passed to setup()
            R_args = { "--quiet", "--no-save" },
            objbr_auto_start = true,
            objbr_allnames = false, -- Show hidden objects
            objbr_mappings = {
                c = "class",
                g = "dplyr::glimpse",
                l = "length",
                n = "names",
                s = "summary",
                t = "table",
            },
            rmd_environment = "new.env()",
            hook = {
                -- This function will be called at the FileType event
                -- of files supported by R.nvim.
                on_filetype = function()
                    local map_buf = require("utils.mappings").map_buf

                    -- Necessary because `]m`, etc. used by treesitter to move to method start/end
                    map_buf(0, "n", "<Enter>", "<Plug>RDSendLine", "R: Send Line")
                    map_buf(0, "v", "<Enter>", "<Plug>RDSelection", "R: Send Selection")

                    -- Close the last graphics window:
                    map_buf(
                        0,
                        "n",
                        "<LocalLeader>cw",
                        "<Cmd>lua require('r.send').cmd('dev.off()')<CR>",
                        "R: Close graphics window"
                    )

                    -- Send the current file name as argument to `file.info()`:
                    map_buf(0, "n", "<LocalLeader>fi", function()
                        require("r.send").cmd('file.info("' .. vim.api.nvim_buf_get_name(0) .. '")')
                    end, "R: Get file info")

                    -- TODO: Look into this
                    -- if vim.bo.filetype == "rmd" or vim.bo.filetype == "quarto" then
                    --     map_buf(0, "i", "`", "<Plug>RmdInsertChunk", "Insert chunk")
                    -- end

                    if vim.bo.filetype == "quarto" then
                        map_buf(0, "n", "<LocalLeader>qr", "<Plug>RQuartoRender", "Quarto Render")
                        map_buf(0, "n", "<LocalLeader>qp", "<Plug>RQuartoPreview", "Quarto Preview")
                        map_buf(0, "n", "<LocalLeader>qs", "<Plug>RQuartoStop", "Quarto Stop")
                    end

                    local wk = require("which-key")
                    wk.add({
                        buffer = true,
                        mode = { "n", "v" },
                        { "<localleader>a", group = "all" },
                        { "<localleader>b", group = "between marks" },
                        { "<localleader>i", group = "install" },
                        { "<localleader>k", group = "knit" },
                        { "<localleader>k", group = "quarto" },
                    })
                end,
            },
            pdfviewer = "",
        },
        dependencies = {
            "R-nvim/cmp-r",
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            -- https://github.com/R-nvim/R.nvim/wiki/Configuration#using-params-in-r-markdown
            {
                "<LocalLeader>pr",
                "<cmd>lua require('r.send').cmd('params <- lapply(knitr::knit_params(readLines(\"' .. vim.fn.expand(\"%:p\") .. '\")), function(x) x$value); class(params) <- \"knit_param_list\"')<CR>",
                desc = "read params from the YAML header",
            },
            -- https://github.com/R-nvim/R.nvim/wiki/Configuration#using-httpgd-as-the-default-graphics-device
            {
                "<LocalLeader>gd",
                "<cmd>lua require('r.send').cmd('tryCatch(httpgd::hgd_browse(),error=function(e) {httpgd::hgd();httpgd::hgd_browse()})')<CR>",
                desc = "httpgd",
            },
        },
        config = function(_, opts)
            if vim.g.use_radian then
                -- https://github.com/randy3k/radian/blob/master/README.md#nvim-r-support
                vim.g.R_app = "radian"
                vim.g.R_cmd = "R"
                vim.g.R_hl_term = 0
                vim.g.R_bracketed_paste = 1
            end
            require("r").setup(opts)
        end,
    },
    {
        "seblyng/roslyn.nvim",
        cond = vim.g.use_roslyn_nvim,
        ft = { "csproj", "sln", "slnx", "props" },
        opts = {
            -- TODO: Investigate setting this to "roslyn"
            filewatching = "auto",
        },
    },
    {
        "GustavEikaas/easy-dotnet.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
        ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
        lazy = true,
        cmd = "Dotnet",
        keys = {
            {
                "<leader>nbdq",
                function()
                    require("easy-dotnet").build_default_quickfix()
                end,
                desc = ".NET Build Quickfix (default)",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nbq",
                function()
                    require("easy-dotnet").build_quickfix()
                end,
                desc = ".NET Build Quickfix",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nbs",
                function()
                    require("easy-dotnet").build_solution()
                end,
                desc = ".NET Build Solution",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nR",
                function()
                    require("easy-dotnet").restore()
                end,
                desc = ".NET Restore",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nrd",
                function()
                    require("easy-dotnet").run_default()
                end,
                desc = ".NET Run (default)",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nrr",
                function()
                    require("easy-dotnet").run()
                end,
                desc = ".NET Run",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nrp",
                function()
                    require("easy-dotnet").run_profile()
                end,
                desc = ".NET Run Profile",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nx",
                function()
                    require("easy-dotnet").clean()
                end,
                desc = ".NET Clean",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nA",
                "<cmd>Dotnet new<cr>",
                desc = ".NET New item",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nTR",
                function()
                    require("easy-dotnet").testrunner()
                end,
                desc = ".NET Test Runner",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nTD",
                function()
                    require("easy-dotnet").test_default()
                end,
                desc = ".NET Test (default)",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>npv",
                function()
                    require("easy-dotnet").project_view()
                end,
                desc = ".NET Project View",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
        },
        config = function()
            local dotnet = require("easy-dotnet")
            local function get_secret_path(secret_guid)
                return vim.fn.expand("~") .. "/.microsoft/usersecrets/" .. secret_guid .. "/secrets.json"
            end

            local config = {
                -- Did this instead;
                -- sudo ln -s /usr/share/dotnet /usr/lib/dotnet

                -- get_sdk_path = get_sdk_path,
                test_runner = {
                    viewmode = "float",
                    enable_buffer_test_execution = true,
                    mappings = {
                        run_test_from_buffer = { lhs = "<localleader>r", desc = "run test from buffer" },
                        filter_failed_tests = { lhs = "<localleader>fe", desc = "filter failed tests" },
                        debug_test = { lhs = "<localleader>d", desc = "debug test" },
                        go_to_file = { lhs = "g", desc = "go to file" },
                        run_all = { lhs = "<localleader>R", desc = "run all tests" },
                        run = { lhs = "<localleader>r", desc = "run test" },
                        peek_stacktrace = { lhs = "<localleader>p", desc = "peek stacktrace of failed test" },
                        expand = { lhs = "o", desc = "expand" },
                        expand_node = { lhs = "E", desc = "expand node" },
                        expand_all = { lhs = "-", desc = "expand all" },
                        collapse_all = { lhs = "W", desc = "collapse all" },
                        close = { lhs = "q", desc = "close testrunner" },
                        refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
                    },
                },
                csproj_mappings = true,
                fsproj_mappings = false,
                auto_bootstrap_namespace = {
                    type = "file_scoped",
                    enabled = true,
                },
                terminal = function(path, action, args)
                    args = args or ""
                    local commands = {
                        run = function()
                            return string.format("dotnet run --project %s %s", path, args)
                        end,
                        test = function()
                            return string.format("dotnet test %s %s", path, args)
                        end,
                        restore = function()
                            return string.format("dotnet restore %s %s", path, args)
                        end,
                        build = function()
                            return string.format("dotnet build %s %s", path, args)
                        end,
                        watch = function()
                            return string.format("dotnet watch --project %s %s", path, args)
                        end,
                    }
                    local command = commands[action]()
                    if require("easy-dotnet.extensions").isWindows() == true then
                        command = command .. "\r"
                    end
                    vim.cmd("vsplit")
                    vim.cmd("term " .. command)
                end,
                secrets = {
                    path = get_secret_path,
                },
                picker = "snacks",
                debugger = {
                    mappings = {
                        open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
                    },
                    auto_register_dap = true,
                    bin_path = vim.fn.stdpath("data") .. "/mason" .. "/bin/netcoredbg"
                },
                lsp = {
                    enabled = not vim.g.use_roslyn_nvim,
                    analyzer_assemblies = {},
                    roslynator_enabled = true,
                },
                diagnostics = {
                    default_severity = "warning",
                    setqflist = true,
                },
            }

            dotnet.setup(config)
            if not vim.g.use_blink then
                require("cmp").register_source("easy-dotnet", require("easy-dotnet").package_completion_source)
            end

            -- Example command
            vim.api.nvim_create_user_command("Secrets", function()
                dotnet.secrets()
            end, {})
        end,
    },
    {
        "TheLeoP/powershell.nvim",
        ft = { "ps1", "psm1" },
        opts = {
            capabilities = lsp.get_capabilities(),
            bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
            settings = {
                enableProfileLoading = false,
                powershell = {
                    codeFormatting = {
                        Preset = "OTBS",
                        AddWhitespaceAroundPipe = true,
                        IgnoreOneLineBlock = true,
                        PipelineIndentationStyle = "IncreaseIndentationForFirstPipeline",
                        TrimWhitespaceAroundPipe = true,
                        UseConstantStrings = true,
                        UseCorrectCasing = true,
                        WhitespaceBetweenParameters = true,
                    },
                },
            },
            init_options = {
                enableProfileLoading = false,
            },
        },
        config = function(_, opts)
            require("powershell").setup(opts)
        end,
    },
    {
        --- Automatically generate C# boilerplate when you create a file inside a C# project
        "DestopLine/boilersharp.nvim",
        opts = {
            usings = {
                ---@type "never" | "always" | "auto"
                implicit_usings = "never",
                ---@type string[]
                usings = {
                    "System",
                    "System.Collections.Generic",
                    "System.IO",
                    "System.Linq",
                    "System.Net.Http",
                    "System.Threading",
                    "System.Threading.Tasks",
                },
            },

            namespace = {
                ---When to use file scoped namespace syntax.
                ---Set this to "auto" to get this from the C# version inferred from
                ---the csproj file of the project.
                ---@type "never" | "always" | "auto"
                use_file_scoped = "always",
            },

            type_declaration = {
                ---Access modifier to use when writing boilerplate. Set this to
                ---`false` to not use any access modifier (implicitly `internal`).
                default_access_modifier = "public",

                ---C# keyword to use when declaring the type.
                default_type_declaration = "class",

                ---Whether the plugin should use the `interface` keyword for the
                ---type declaration when the name of the type matches the C#
                ---interface naming convention, which would be equivalent to this
                ---regular expression: `^I[A-Z].*$`.
                infer_interfaces = true,
            },

            ---Whether to add autocommands for writing boilerplate when you enter
            ---an empty C# file. Set this to `false` if you wanna be in control
            ---of when boilerplate gets written to the file through user commands
            ---or lua functions.
            add_autocommand = false,

            ---What type of indentation to use for boilerplate generation. This is
            ---only ever used when not using file scoped namespace syntax and
            ---`type_declaration` is enabled. Set this to "auto" to take this from
            ---the buffer's options.
            ---
            ---It is recommended that you set up an "after/ftplugin/cs.lua" file
            ---in your nvim config with options for `expandtab` instead of
            ---changing this option from its default value.
            ---See `:h ftplugin` and `:h after-directory`.
            ---@type "tabs" | "spaces" | "auto"
            indent_type = "auto",
        },
    },
}
