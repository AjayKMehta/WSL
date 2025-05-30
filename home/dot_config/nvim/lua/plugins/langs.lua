local load_config = require("utils").load_config
local lsp = require("utils.lsp")

return {
    {
        "jalvesaq/Nvim-R",
        lazy = false,
        ft = { "r", "rmd", "quarto" },
        cmd = { "RKill" },
        config = load_config("nvim_r"),
    },
    {
        "seblyng/roslyn.nvim",
        ft = { "cs", "vb", "csproj", "sln", "slnx", "props" },
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

            local config = {
                -- Did this instead;
                -- sudo ln -s /usr/share/dotnet /usr/lib/dotnet

                -- get_sdk_path = get_sdk_path,
                test_runner = {
                    viewmode = "float",
                    enable_buffer_test_execution = true,
                },
                csproj_mappings = true,
                fsproj_mappings = false,
                auto_bootstrap_namespace = {
                    type = "block_scoped", -- TODO: Change
                    enabled = true,
                },
                mappings = {
                    run_test_from_buffer = { lhs = "<leader>ntr", desc = "run test from buffer" },
                    debug_test = { lhs = "<leader>ntd", desc = "debug test" },
                },
                terminal = function(path, action, args)
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
                    }

                    local command = commands[action]() .. "\r"
                    -- TODO: Make this window smaller.
                    require("toggleterm").exec(command, nil, nil, nil, "horizontal")
                end,
                picker = "snacks",
            }

            dotnet.setup(config)

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
