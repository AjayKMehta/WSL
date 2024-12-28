local lsp = require("utils.lsp")

return {
    {
        "jalvesaq/Nvim-R",
        lazy = false,
        ft = { "r", "rmd", "quarto" },
        config = function()
            require("cmp_nvim_r").setup({})
        end,
    },
    {
        "seblj/roslyn.nvim",
        ft = { "cs", "vb", "csproj", "sln", "slnx", "props" },
        config = function(_, opts)
            local config = {
                config = {
                    settings = {
                        ["csharp|background_analysis"] = {
                            dotnet_analyzer_diagnostics_scope = "fullSolution",
                            dotnet_compiler_diagnostics_scope = "fullSolution",
                        },
                        ["csharp|inlay_hints"] = {
                            csharp_enable_inlay_hints_for_implicit_object_creation = false,
                            csharp_enable_inlay_hints_for_implicit_variable_types = true,
                            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                            csharp_enable_inlay_hints_for_types = true,
                            dotnet_enable_inlay_hints_for_indexer_parameters = true,
                            dotnet_enable_inlay_hints_for_literal_parameters = true,
                            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                            dotnet_enable_inlay_hints_for_other_parameters = true,
                            dotnet_enable_inlay_hints_for_parameters = true,
                            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                        },
                        ["csharp|code_lens"] = {
                            dotnet_enable_references_code_lens = true,
                            dotnet_enable_tests_code_lens = true,
                        },
                        ["csharp|completion"] = {
                            dotnet_provide_regex_completions = true,
                            otnet_show_completion_items_from_unimported_namespaces = true,
                            dotnet_show_name_completion_suggestions = true,
                        },
                        ["csharp|symbol_search"] = {
                            dotnet_search_reference_assemblies = true,
                        },
                    },
                },
            }
            require("roslyn").setup(config)
        end,
        exe = {
            "dotnet",
            vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
        },
    },
    {
        "GustavEikaas/easy-dotnet.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
        ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
        lazy = true,
        cmd = "Dotnet",
        keys = {
            {
                "<leader>nb",
                function()
                    require("easy-dotnet").build_default_quickfix()
                end,
                desc = "build",
            },
            {
                "<leader>nB",
                function()
                    require("easy-dotnet").build_quickfix()
                end,
                desc = "build solution",
            },
            {
                "<leader>nr",
                function()
                    require("easy-dotnet").run_default()
                end,
                desc = "run",
            },
            {
                "<leader>nR",
                function()
                    require("easy-dotnet").run_solution()
                end,
                desc = "run solution",
            },
            {
                "<leader>nx",
                function()
                    require("easy-dotnet").clean()
                end,
                desc = "clean solution",
            },
            { "<leader>nA", "<cmd>Dotnet new<cr>", desc = "new item" },
            { "<leader>nT", "<cmd>Dotnet testrunner<cr>", desc = "open test runner" },
        },
        config = function()
            local dotnet = require("easy-dotnet")

            local function get_secret_path(secret_guid)
                local home_dir = vim.fn.expand("~")
                return home_dir .. "/.microsoft/usersecrets/" .. secret_guid .. "/secrets.json"
            end

            local function get_sdk_path()
                local sdk_version =
                    vim.system({ "dotnet", "--version" }):wait().stdout:gsub("\r", ""):gsub("\n", ""):gsub("\\s+.", "")
                return vim.fs.joinpath("/usr/share/dotnet/sdk", sdk_version)
            end

            local config = {
                -- Did this instead;
                -- sudo ln -s /usr/share/dotnet /usr/lib/dotnet

                -- get_sdk_path = get_sdk_path,
                test_runner = {
                    viewmode = "float",
                    enable_buffer_test_execution = true,
                    icons = {
                        project = "󰗀",
                    },
                },
                secrets = {
                    path = get_secret_path,
                },
                csproj_mappings = true,
                fsproj_mappings = false,
                auto_bootstrap_namespace = true,
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
        ft= {"ps1", "psm1"},
        opts = {
            capabilities = lsp.capabilities,
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
        end

    },
}
