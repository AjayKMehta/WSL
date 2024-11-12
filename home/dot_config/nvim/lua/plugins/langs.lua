local lsp = require("utils.lsp")

return {
    {
        "PProvost/vim-ps1",
        ft = "powershell",
    },
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
}
