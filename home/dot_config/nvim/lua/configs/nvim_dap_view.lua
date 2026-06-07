local config = {
    winbar = {
        base_sections = {
            -- Labels can be set dynamically with functions
            -- Each function receives the window's width and the current section as arguments
            breakpoints = { label = "Breakpoints", keymap = "B" },
            scopes = { label = "Scopes", keymap = "S" },
            exceptions = { label = "Exceptions", keymap = "E" },
            watches = { label = "Watches", keymap = "W" },
            threads = { label = "Threads", keymap = "T" },
            repl = { label = "REPL", keymap = "R" },
            sessions = { label = "Sessions", keymap = "K" },
            console = { label = "Console", keymap = "C" },
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
