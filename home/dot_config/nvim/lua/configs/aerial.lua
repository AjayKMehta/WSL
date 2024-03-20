local aerial = require("aerial")

vim.cmd([[
	hi link AerialClass Type
	hi link AerialClassIcon Special
	hi link AerialFunction Special
	hi AerialFunctionIcon guifg=#cb4b16 guibg=NONE guisp=NONE gui=NONE cterm=NONE
	hi link AerialLine QuickFixLine
	" You can customize the guides (if show_guide=true)
	hi link AerialGuide Comment
	" You can set a different guide color for each level
	hi AerialGuide1 guifg=Red
	hi AerialGuide2 guifg=Blue
	]])

aerial.setup({
    backends = { "treesitter", "lsp", "markdown", "man" },
    layout = {
        default_direction = "prefer_right",
        placement = "edge",
    },
    attach_mode = "window", -- 'window' | 'global'
    nerd_font = "auto",
    show_guides = true,
    filter_kind = {
        "Class",
        "Constant",
        "Constructor",
        "Enum",
        "Event",
        "Field",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Namespace",
        "Property",
        "Struct",
    },
    -- Highlight the symbol in the source buffer when cursor is in the aerial win
    highlight_on_hover = true,
    ignore = {
        -- Ignore unlisted buffers. See :help buflisted
        unlisted_buffers = true,
    },
})
