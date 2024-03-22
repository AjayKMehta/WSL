local overrides = require("configs.overrides")

local function load_config(plugin)
    return function()
        require("configs." .. plugin)
    end
end

return {
    {
        -- Code outline sidebar powered by LSP.
        -- Differs from aerial as it uses LSP instead of treesitter.
        "hedyhli/outline.nvim",
        cmd = { "Outline", "OutlineOpen" },
        enabled = true, -- Seems more reliablee than aerial.
        opts = {
            outline_window = {
                auto_jump = false,
                wrap = true,
            },
            -- Auto-open preview was annoying. `live = true` allows editing in preview window!
            preview_window = { auto_preview = false, live = true },
            symbol_folding = {
                auto_unfold = {
                    only = 2,
                },
            },
            outline_items = {
                show_symbol_lineno = false,
            },
        },
        config = function(_, opts)
            require("outline").setup(opts)
        end,
    },
    {
        -- A code outline window for skimming and quick navigation.
        "stevearc/aerial.nvim",
        lazy = true,
        cmd = { "AerialToggle", "AerialOpen", "AerialInfo" },
        enabled = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<Leader>ta", "<CMD>AerialToggle<CR>", mode = { "n" }, desc = "Open or close the aerial window" },
        },
        config = load_config("aerial"),
    },
}
