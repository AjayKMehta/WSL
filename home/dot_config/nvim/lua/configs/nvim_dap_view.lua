local config = {
    winbar = {
        sections = {
            "console",
            "watches",
            "scopes",
            "exceptions",
            "breakpoints",
            "threads",
            "repl",
        },
        default_section = "watches",
        controls = {
            enabled = true,
        },
    },
    windows = {
        terminal = {
            position = "left",
            -- List of debug adapters for which the terminal should be ALWAYS hidden
            hide = {},
        },
    },
    auto_toggle = true,
    virtual_text = {
        -- Control with `DapViewVirtualTextToggle`
        enabled = true,
        format = function(variable, _, _)
            -- Strip out excessive whitespace
            return " " .. variable.value:gsub("%s+", " ")
        end,
    },
}

require("dap-view").setup(config)
