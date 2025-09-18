local map_desc = require("utils.mappings").map_desc
local f = require("flash")

local config = {
    jump = {
        autojump = true,
    },
    highlight = {
        -- show a backdrop with hl FlashBackdrop
        backdrop = true,
        -- Highlight the search matches
        matches = true,
        -- extmark priority
        priority = 5000,
        groups = {
            match = "FlashMatch",
            current = "FlashCurrent",
            backdrop = "FlashBackdrop",
            label = "FlashLabel",
        },
    },
    label = { rainbow = { enabled = true } },
    modes = {
        -- options used when flash is activated through
        -- `f`, `F`, `t`, `T`, `;` and `,` motions
        char = {
            enabled = true,
            multi_line = false,
            autohide = true,
            jump_labels = function(motion)
                return vim.v.count == 0 and vim.fn.reg_executing() == "" and vim.fn.reg_recording() == ""
            end,
            keys = { "f", "F", "t", "T", ";", "," },
            jump = {
                -- Don't add to search register (/)
                register = false,
                autojump = true,
            },
        },
        search = {
            -- when `true`, flash will be activated during regular search by default.
            -- You can always toggle when searching with `require("flash").toggle()`
            enabled = true,
        },
        treesitter = {
            highlight = {
                backdrop = false,
                matches = true,
            },
        },
    },
    prompt = {
        enabled = true,
        prefix = { { " 󰉂 ", "FlashPromptIcon" } },
    },
    search = {
        exclude = {
            "cmp_menu",
            "dropbar_menu",
            "flash_prompt",
            "gitsigns-blame",
            "help",
            "man",
            "noice",
            "notify",
            "NvimTree",
            "oil",
            "Outline",
            "qf",
            "startify",
            "startuptime",
            "TelescopePrompt",
            "toggleterm",
            "Trouble",
            "VoltWindow",
            function(win)
                -- exclude non-focusable windows
                return not vim.api.nvim_win_get_config(win).focusable
            end,
        },
    },
}

map_desc("n", "<leader>fs", function()
    require("flash").jump()
end, "Flash")
map_desc({ "o", "x" }, "fs", function()
    require("flash").jump()
end, "Flash")

map_desc("n", "<leader>fT", function()
    require("flash").treesitter()
end, "Flash Treesitter")
map_desc({ "o", "x" }, "fT", function()
    require("flash").treesitter()
end, "Flash Treesitter")

local function flash_fwd()
    f.jump({
        search = { forward = true, wrap = false, multi_window = false },
    })
end

map_desc("n", "<leader>ff", flash_fwd, "Flash Forward")
map_desc({ "o", "x" }, "ff", flash_fwd, "Flash Forward")

local function flash_back()
    f.jump({
        search = { forward = false, wrap = false, multi_window = false },
    })
end

map_desc("n", "<leader>fb", flash_back, "Flash Backward")
map_desc({ "o", "x" }, "fb", flash_back, "Flash Backward")

local function flash_cont()
    f.jump({
        search = { continue = true },
    })
end

map_desc("n", "<leader>fc", flash_cont, "Flash Continue search")
map_desc({ "o", "x" }, "fc", flash_cont, "Flash Continue search")

local function flash_diag()
    -- More advanced example that also highlights diagnostics:
    f.jump({
        matcher = function(win)
            return vim.tbl_map(function(diag)
                return {
                    pos = { diag.lnum + 1, diag.col },
                    end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
                }
            end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
        end,
        action = function(match, state)
            vim.api.nvim_win_call(match.win, function()
                vim.api.nvim_win_set_cursor(match.win, match.pos)
                vim.diagnostic.open_float()
            end)
            state:restore()
        end,
    })
end

map_desc("n", "<leader>fd", flash_diag, "Flash Diagnostics")
map_desc({ "o", "x" }, "fd", flash_diag, "Flash Diagnostics")

map_desc("o", "fr", function() require("flash").remote() end, "Flash Remote")

map_desc({ "o", "x" }, "fR",  function() require("flash").treesitter_search() end, "Flash Treesitter search")

map_desc({ "n", "v" }, "<leader>ft", function()
    require("flash").toggle()
end, "Flash Toggle search")

local flash_word = function()
    local word = vim.fn.expand("<cword>")
    if word ~= nil and #word > 0 then
        f.jump({ pattern = word })
    end
end

map_desc("n", "<leader>fw", flash_word, "Flash current word")

-- https://github.com/folke/flash.nvim#-examples
map_desc({ "n", "x", "o" }, "<c-space>", function()
    require("flash").treesitter({
        actions = {
            ["<c-space>"] = "next",
            ["<BS>"] = "prev"
        }
    })
end, "Flash TS incremental selection")

dofile(vim.g.base46_cache .. "flash")
