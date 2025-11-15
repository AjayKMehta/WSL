-- See mappings here: https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua
-- require("nvchad.mappings")

local utils = require("utils.mappings")
local map = utils.map
local map_desc = utils.map_desc

-- To disable mappings:
local disabled = {
    n = {
        -- "<leader>ch", -- NvChad maps this to Toggle nvcheatsheet
    },
}

-- https://github.com/NvChad/NvChad/issues/2688#issuecomment-1976174561
for mode, mappings in pairs(disabled) do
    for _, keys in ipairs(mappings) do
        if vim.fn.mapcheck(keys, mode) ~= "" then
            vim.keymap.del(mode, keys)
        else
            vim.notify("Keymap " .. keys .. " does not exist for mode " .. mode)
        end
    end
end

map_desc("n", "<Esc>", "<cmd>noh<CR>", "general clear highlights")
map_desc("n", "<C-c>", "<cmd>%y+<CR>", "general copy whole file")

map_desc("n", "<tab>", "<cmd>bnext<CR>", "buffer goto next")
map_desc("n", "<S-tab>", "<cmd>bprevious<CR>", "buffer goto previous")

map_desc("n", "<leader>tt", function()
    require("base46").toggle_theme()
end, "NvChad Toggle theme")

map_desc("n", "<leader>tT", function()
    require("base46").toggle_transparency()
end, "NvChad Toggle transparency")

map_desc("n", "<leader>th", function()
    require("nvchad.themes").open()
end, "telescope nvchad themes")

-- Create a function to handle command mode yanking
local function cmd_yank()
    vim.fn.setreg('"', vim.fn.getcmdline())
    vim.notify("Command line text yanked\n")
end

map_desc("c", "<C-y>", cmd_yank, "Yank command line text")

-- Courtesy of https://www.reddit.com/r/neovim/comments/1ixsk40/comment/mep7kp1/
map_desc("n", "gV", "`[v`]", "Select the previous yanked area")

map_desc("t", "<Esc>", "<C-\\><C-n>", "Exit terminal mode")

--#region Telescope

map_desc("n", "<leader>rs", "<cmd>Telescope resume<cr>", "telescope resume previous search")

-- Nvim DAP

map_desc("n", "<leader>dlb", function()
    require("telescope").extensions.dap.list_breakpoints()
end, "DAP List breakpoints")

map_desc("n", "<leader>dlc", function()
    require("telescope").extensions.dap.commands()
end, "DAP List commands")

map_desc("n", "<leader>dlC", function()
    require("telescope").extensions.dap.configuration()
end, "DAP List configuration")

map_desc("n", "<leader>dlf", function()
    require("telescope").extensions.dap.frames()
end, "DAP List frames")

map_desc("n", "<leader>dlv", function()
    require("telescope").extensions.dap.variables()
end, "DAP List variables")

--#endregion

--#region minimove

local function fn_move(dir)
    return function()
        require("mini.move").move_line(dir)
    end
end

map_desc({ "n", "v" }, "<A-Left>", fn_move("left"), "mini.move line left")
map_desc({ "n", "v" }, "<A-Right>", fn_move("right"), "mini.move line right")
map_desc({ "n", "v" }, "<A-Up>", fn_move("up"), "mini.move line up")
map_desc({ "n", "v" }, "<A-Down>", fn_move("down"), "mini.move line down")

--#endregion

--#region code_runner

map_desc("n", "<leader>rc", "<cmd>RunCode<CR>", "CodeRunner Run code")
map_desc("n", "<leader>rf", "<cmd>RunFile<CR>", "CodeRunner Run file")
map_desc("n", "<leader>rp", "<cmd>RunProject<CR>", "CodeRunner Run project")
map_desc("n", "<leader>rx", "<cmd>RunClose<CR>", "CodeRunner Close runner")

--#endregion

--#region neogen

local neogen_gen = function(type)
    return function()
        require("neogen").generate({
            type = type,
            annotation_convention = {
                cs = "xmldoc",
            },
        })
    end
end

map_desc("n", "<leader>nc", neogen_gen("class"), "Neogen Generate annotation for class")

map_desc("n", "<leader>nf", neogen_gen("func"), "Neogen Generate annotation for function")

--#endregion

--#region neotest

map_desc("n", "<leader>tr", function()
    vim.notify_once("Running single test", vim.log.levels.INFO, {
        title = "Neotest",
    })
    require("neotest").run.run()
end, "Neotest Run")
map_desc("n", "<leader>to", function()
    require("neotest").output.open({
        enter = true,
        open_win = function(settings)
            local height = math.min(settings.height, vim.o.lines - 2)
            local width = math.min(settings.width, vim.o.columns - 2)
            return vim.api.nvim_open_win(0, true, {
                relative = "editor",
                row = 7,
                col = (vim.o.columns - width) / 2,
                width = width,
                height = height,
                style = "minimal",
                border = vim.g.floating_window_border,
                noautocmd = true,
            })
        end,
    })
end, "Neotest Show output")

map_desc("n", "<leader>tS", function()
    require("neotest").summary.toggle()
end, "Neotest Show summary")

--#endregion

--#region octo

map_desc("n", "<leader>Oo", "<cmd>Octo<cr>", "Octo")
map_desc("n", "<leader>Oi", "<cmd>Octo issue list<cr>", "Octo Issue List")
map_desc("n", "<leader>Op", "<cmd>Octo pr list<cr>", "Octo PR List")
map_desc("n", "<leader>Or", "<cmd>Octo repo list<cr>", "Octo Repo List")

--#endregion

--#region Noice

map_desc("n", "<leader>ne", function()
    require("noice").cmd("errors")
end, "Noice errors")

map_desc("n", "<leader>nD", function()
    require("noice").cmd("disable")
end, "Noice disable")

map_desc("n", "<leader>nE", function()
    require("noice").cmd("enable")
end, "Noice enable")

--#endregion
