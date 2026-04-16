local config = {
    surrounds = {
        -- https://github.com/kylechui/nvim-surround/discussions/53#discussioncomment-8593596
        -- Create generic type: ysiwg on String, enter Foo: Foo<String>
        g = {
            add = function()
                local config = require("nvim-surround.config")
                local result = config.get_input("Enter the generic name: ")
                if result then
                    return { { result .. "<" }, { ">" } }
                end
            end,
            find = function()
                local config = require("nvim-surround.config")
                return config.get_selection({ node = "generic_type" })
            end,
            delete = "^(.-<)().-(>)()$",
            change = {
                target = "^(.-<)().-(>)()$",
                replacement = function()
                    local config = require("nvim-surround.config")
                    local result = config.get_input("Enter the generic name: ")
                    if result then
                        return { { result .. "<" }, { ">" } }
                    end
                end,
            },
        },
    },
}

require("nvim-surround").setup(config)
