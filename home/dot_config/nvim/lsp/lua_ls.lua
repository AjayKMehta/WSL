local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".luacheckrc",
        ".stylua.toml",
        "stylua.toml",
        "selene.toml",
        "selene.yml",
        ".git",
    },
    on_init = function(client)
        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                version = "LuaJIT",
                path = runtime_path,
            },
        })
    end,
    -- https://luals.github.io/wiki/settings/
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
                globals = { "vim" },
            },
            hint = {
                enable = true,
                setType = true,
                arrayIndex = "Disable",
            },
            codeLens = {
                enable = true,
            },
            format = {

                enable = true,
                -- Put format options here

                defaultConfig = {
                    quote_style = "double",
                    align_function_params = true,
                    never_indent_before_if_condition = false,
                    never_indent_comment_on_if_branch = false,
                },
            },
            workspace = {
                checkThirdParty = "Disable",
                library = {
                    -- vim.api.nvim_get_runtime_file("", true),
                    vim.env.VIMRUNTIME,
                    "${3rd}/luv/library",
                    vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                    vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
