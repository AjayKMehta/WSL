local c = require("utils.nvim_cmp")
local get_buffers_by_size = require("utils").get_buffers_by_size
local cmp = require("cmp")
local src = require("nvim_cmp.sources")
dofile(vim.g.base46_cache .. "cmp")

local opts = {
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#disabling-completion-in-certain-contexts-such-as-comments
    enabled = function()
        local context = require("cmp.config.context")
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        if filetype == "TelescopePrompt" or filetype == "snacks_picker_input" then
            return false
        end

        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == "c" then
            return true
        end

        -- disable completion in comments
        return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
    end,
    experimental = {
        ghost_text = {
            hl_group = "Comment",
        },
    },
    performance = {
        debounce = 25,
        throttle = 50,
        max_view_entries = 30,
        fetching_timeout = 200,
        async_budget = 50,
    },
    -- Enable luasnip to handle snippet expansion for nvim-cmp
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    matching = {
        disallow_fuzzy_matching = false,
        disallow_fullfuzzy_matching = true,
        disallow_partial_fuzzy_matching = false,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = false,
    },
    completion = {
        completeopt = "menu,menuone,noinsert,noselect",
        keyword_length = 2,
        autocomplete = false,
    },
    mapping = require("nvim_cmp.mappings"),
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.receently_used,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    -- https://github.com/hrsh7th/nvim-cmp/commit/7aa3f71932c419d716290e132cacbafbaf5bea1c
    view = {
        entries = {
            follow_cursor = true,
        },
    },
    sources = src.default,
    formatting = { format = c.format },
}

-- Do not use cmp.config.sources():
-- https://github.com/hrsh7th/nvim-cmp/discussions/881
cmp.setup(opts)

cmp.setup.filetype("lua", { sources = src.lua })

cmp.setup.filetype({ "gitcommit", "octo" }, {
    sources = cmp.config.sources(
        {
            { name = "git" },
        },
        -- This has group_index = 2
        {
            { name = "fuzzy_buffer", keyword_length = 4 },
        }
    ),
})

cmp.setup.filetype({ "gitrebase" }, {
    sources = src.gitrebase,
})

-- TODO: Figure out why not working :(
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    enabled = true,
    completion = {
        autocomplete = true,
        keyword_length = 2,
    },
    sources = src.search,
    view = {
        entries = { name = "custom", selection_order = "near_cursor" },
    },
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    completion = {
        keyword_length = 2, -- Otherwise, can't use :q!
    },
    enabled = true,
    sources = src.cmdline,
})

cmp.setup.filetype(
    {
        "help",
        "minifiles",
        "TelescopePrompt",
        "checkhealth",
        "cmp_menu",
        "crunner",
        "dap-view-help",
        "dropbar_menu",
        "flash_prompt",
        "FTerm",
        "grug-far",
        "man",
        "netrw",
        "no-profile",
        "noice",
        "notify",
        "nvcheatsheet",
        "Outline",
        "startify",
        "startuptime",
        "trouble",
    },
    {
        enabled = false,
    }
)

cmp.setup.filetype({ "tex", "plaintex" }, {
    sources = src.tex,
})

cmp.setup.filetype({ "markdown", "rmd", "quarto", "codecompanion" }, {
    sources = src.markdown,
})

local r_sources = vim.deepcopy(default_sources)
local r_source = {
    name = "cmp_r",
    priority = 100,
    keyword_length = 2,
}
table.insert(r_sources, 1, r_source)
table.insert(r_sources, { name = "otter", priority = 90 })
cmp.setup.filetype("r", {
    sources = r_sources,
})

-- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#add-parentheses-after-selecting-function-or-method-item
-- If you want insert `(` after select function or method item
if vim.g.use_autopairs then
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
