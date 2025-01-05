local lsp = require("utils.lsp")

return {
    {
        "jalvesaq/Nvim-R",
        lazy = false,
        ft = { "r", "rmd", "quarto" },
        config = function()
            -- https://github.com/jamespeapen/Nvim-R/wiki/Options
            vim.g.Rout_more_colors = 1

            local languages = { "r", "python" }
            vim.g.markdown_fenced_languages = languages
            vim.g.rmd_fenced_languages = languages
            vim.g.R_non_r_compl = 0 -- use omni completion provided by another plugin

            vim.g.R_auto_start = 1 -- Doesn't seem to work
            vim.g.R_assign_map = "<M-->"
            vim.g.R_rmd_environment = "new.env()" -- compile .Rmd in a fresh environment
            vim.g.R_clear_line = 1 -- Delete existing stuff on command line before sending command to R
            vim.g.R_openhtml = 1
            vim.g.R_start_libs = "base,stats,graphics,grDevices,utils,methods,dplyr,data.table"
            vim.g.R_csv_app = "terminal:vd"

            -- https://github.com/jamespeapen/Nvim-R/wiki/Options#object-browser-options
            vim.g.R_objbr_auto_start = 1
            vim.g.R_objbr_opendf = 1 -- Show data.frame elements
            vim.g.R_objbr_openlist = 1 -- Show list elements
            vim.g.R_objbr_allnames = 1 -- Show hidden objects

            if vim.g.use_radian then
                -- https://github.com/randy3k/radian/blob/master/README.md#nvim-r-support
                vim.g.R_app = "radian"
                vim.g.R_cmd = "R"
                vim.g.R_hl_term = 0
                vim.g.R_bracketed_paste = 1
            end

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
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nB",
                function()
                    require("easy-dotnet").build_quickfix()
                end,
                desc = "build solution",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nr",
                function()
                    require("easy-dotnet").run_default()
                end,
                desc = "run",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nR",
                function()
                    require("easy-dotnet").run_solution()
                end,
                desc = "run solution",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nx",
                function()
                    require("easy-dotnet").clean()
                end,
                desc = "clean solution",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nA",
                "<cmd>Dotnet new<cr>",
                desc = "new item",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
            {
                "<leader>nT",
                "<cmd>Dotnet testrunner<cr>",
                desc = "open test runner",
                ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
            },
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
        ft = { "ps1", "psm1" },
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
        end,
    },
}
