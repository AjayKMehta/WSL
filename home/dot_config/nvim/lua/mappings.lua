-- See mappings here: https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua
require("nvchad.mappings")

local utils = require("utils")
local map = utils.map
local map_desc = utils.map_desc

-- map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("i", "jk", "<ESC>")
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- To disable mappings:
local disabled = {
    n = {
        -- "<C-b>",
        -- "gi", -- Clashes with Treesitter keymap
        -- "<leader>lf", -- Clashes with conform keymap
    },
}

-- https://github.com/NvChad/NvChad/issues/2688#issuecomment-1976174561
for mode, mappings in pairs(disabled) do
    for _, keys in pairs(mappings) do
        vim.keymap.del(mode, keys)
    end
end

map_desc("n", "<leader>tt", function()
    require("base46").toggle_theme()
end, "Toggle theme")

map_desc("n", "<leader>tT", function()
	require("base46").toggle_transparency()
end, "Toggle theme")

map_desc("n", "gli", function()
    vim.lsp.buf.implementation()
end, "LSP implementation")

--#region ghcup

map_desc("n", "<leader>gg", "<cmd>GHCup <CR>", "ghcup")

--#endregion

--#region Telescope

map_desc("n", "<leader>ff", "<cmd> Telescope find_files <CR>", "Telescope: Find files")
map_desc(
    "n",
    "<leader>fa",
    "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
    "Telescope: Find all"
)
map_desc("n", "<leader>fw", "<cmd> Telescope live_grep <CR>", "Telescope: Live grep")
map_desc("n", "<leader>fb", "<cmd> Telescope buffers <CR>", "Telescope: Find buffers")
map_desc("n", "<leader>f?", "<cmd> Telescope help_tags <CR>", "Telescope: Help page")
map_desc("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>", "Telescope: Find oldfiles")
map_desc("n", "<leader>fz", "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Telescope: Find in current buffer")
map_desc("n", "<leader>fh", "<cmd> Telescope file_browser cwd=$HOME <CR>", "Telescope: Search home")
map_desc("n", "<leader>fc", "<cmd> Telescope find_files cwd=$HOME/.config <CR>", "Telescope: 🔍 Search config")
map_desc("n", "<leader>fk", "<cmd> Telescope keymaps <CR>", "Telescope: ⌨ Keymap")
map_desc("n", "<leader>fu", "<cmd>Telescope undo<CR>", "Telescope:  Undo tree")
map_desc("n", "<leader>fy", function()
    require("telescope.builtin").buffers()
end, "Telescope: Search buffers")
map_desc("n", "<leader>fd", "<cmd>Telescope lsp_document_symbols<CR>", "Telescope: Search Document Symbols")
map_desc("n", "leader>sw", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Search Workspace Symbols")
map_desc("n", "<leader>fe", "<cmd>Telescope emoji<CR>", "Telescope: Search emojis")

--#endregion

--#region minimove

local function fn_move(dir)
    return function()
        require("mini.move").move_line(dir)
    end
end

map_desc({ "n", "v" }, "<A-Left>", fn_move("left"), "Move line left")
map_desc({ "n", "v" }, "<A-Right>", fn_move("right"), "Move line right")
map_desc({ "n", "v" }, "<A-Up>", fn_move("up"), "Move line up")
map_desc({ "n", "v" }, "<A-Down>", fn_move("down"), "Move line down")

--#endregion

--#region trouble
map_desc("n", "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics <CR>", "Trouble: Workspace diagnostics")
map_desc("n", "<leader>td", "<cmd>TroubleToggle document_diagnostics <CR>", "Trouble: Document diagnostics")
map_desc("n", "<leader>tL", "<cmd> TroubleToggle loclist <CR>", "Trouble: Location List")
map_desc("n", "<leader>tQ", "<cmd> TroubleToggle quickfix <CR>", "Trouble: Quickfix List")
map_desc("n", "<leader>tS", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", "Trouble: Todo/Fix/Fixme")

--#endregion

--#region bookmarks

map_desc("n", "<leader>mm", "<cmd>Telescope vim_bookmarks all<CR>", " Bookmark Menu")
map_desc("n", "<leader>mt", "<cmd> BookmarkToggle<CR>", "󰃅 Toggle bookmark")
map_desc("n", "<leader>mn", "<cmd> BookmarkNext<CR>", "󰮰 Next bookmark")
map_desc("n", "<leader>mp", "<cmd> BookmarkPrev<CR>", "󰮲 Prev bookmark")
map_desc("n", "<leader>mc", "<cmd> BookmarkClear<CR>", "󰃢 Clear bookmarks")

--#endregion

--#region pretty_hover

map_desc("n", "<leader>ko", function()
    require("pretty_hover").hover()
end, "Hover: Open")
map_desc("n", "<leader>kq", function()
    require("pretty_hover").close()
end, "Hover: Close")

--#endregion

--#region dap

-- Keep same as VS + VS Code
map_desc("n", "<F9>", "<cmd> DapToggleBreakpoint <CR>", "DAP: Toggle breakpoint")
map_desc("n", "<F5>", "<cmd> DapContinue<CR>", "DAP: Launch debugger")
map_desc("n", "<F10>", "<cmd> DapStepOver <CR>", "DAP: Step over")
map_desc("n", "<F11>", "<cmd> DapStepInto <CR>", "DAP: Step into")
map_desc("n", "<S-F11>", "<cmd> DapStepOut <CR>", "DAP: Step out")

map_desc("n", "<leader>rb", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "DAP: Set conditional breakpoint")

map_desc("n", "<leader>rl", function()
    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, "DAP: Log message")

--#endregion

--region dap_python
map_desc("n", "<leader>rt", function()
    require("dap-python").test_method()
end, "DAP: Debug the closest method to cursor")

--#endregion

--region luasnip

local show_snippet_list = function(...)
    local sl = require("luasnip.extras.snippet_list")
    -- keeping the default display behavior but modifying window/buffer
    local modified_default_display = sl.options.display({
        buf_opts = { filetype = "lua" },
        win_opts = { foldmethod = "manual" },
        get_name = function(buf)
            return "Custom Display buf " .. buf
        end,
    })

    sl.open({ display = modified_default_display })
end

map_desc("n", "<leader>sl", show_snippet_list, "Snippets: List")

--#endregion

--#region urlview

map_desc("n", "<leader>uu", "<cmd>UrlView<CR>", "Show local URLs")

--#endregion

--#region code_runner

map("n", "<leader>rc", "<cmd>RunCode<CR>")
map("n", "<leader>rf", "<cmd>RunFile<CR>")
map("n", "<leader>rp", "<cmd>RunProject<CR>")
map("n", "<leader>rx", "<cmd>RunClose<CR>")
map("n", "<leader>crf", "<cmd>CRFiletype<CR>")
map("n", "<leader>crp", "<cmd>CRProjects<CR>")

--#endregion

--#region neogen

local neogen_gen = function(type)
    return function()
        require("neogen").generate({
            type = type,
        })
    end
end

map_desc("n", "<leader>nc", neogen_gen("class"), "neogen: Generate annotation for class")

map_desc("n", "<leader>nf", neogen_gen("func"), "neogen: Generate annotation for function")

--#endregion

--#region wtf

map_desc({ "n", "x" }, "gw", function()
    require("wtf").ai()
end, "Debug diagnostic with AI")

map_desc("n", "gW", function()
    require("wtf").search()
end, "Search diagnostic with Google")

--#endregion

--#region actpreview

map_desc({ "n", "v" }, "ga", function()
    require("actions-preview").code_actions()
end, "Preview code actions.")

--#endregion

--#region Flash

map_desc({ "n", "o", "x" }, "<leader>ss", function()
    require("flash").jump()
end, "Flash")

map_desc({ "n", "o", "x" }, "<leader>sS", function()
    require("flash").treesitter()
end, "Flash Treesitter")
map_desc({ "n", "o", "x" }, "<leader>sf", function()
    require("flash").jump({
        search = { forward = true, wrap = false, multi_window = false },
    })
end, "Flash forward")
map_desc({ "n", "o", "x" }, "<leader>sb", function()
    require("flash").jump({
        search = { forward = false, wrap = false, multi_window = false },
    })
end, "Flash backward")

map_desc({ "n", "o", "x" }, "<leader>sc", function()
    require("flash").jump({
        search = { continue = true },
    })
end, "Flash continue search")
map_desc({ "n", "o", "x" }, "<leader>sd", function()
    -- More advanced example that also highlights diagnostics:
    require("flash").jump({
        matcher = function(win)
            ---@param diag Diagnostic
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
end, "Flash diagnostics")

map_desc("o", "r", function()
    require("flash").remote()
end, "Flash remote")

map_desc({ "o", "x" }, "R", function()
    require("flash").treesitter_search()
end, "Flash treesitter search")

map_desc("c", "<c-s>", function()
    require("flash").toggle()
end, "Flash toggle search")

--#endregion

--#region neotest

map_desc("n", "<leader>tr", function()
    vim.notify_once("Running single test", vim.log.levels.INFO, {
        title = "Neotest",
    })
    require("neotest").run.run()
end, "neotest: Run")
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
end, "neotest: Show output")

map_desc("n", "<leader>ts", function()
    require("neotest").summary.toggle()
end, "neotest: Show summary")

--#endregion

--#region ufo

map_desc("n", "]z", function()
    require("ufo").goNextClosedFold()
end, "UFO: Go to next closed fold")
map_desc("n", "[z", function()
    require("ufo").goPreviousClosedFold()
end, "UFO: Go to previous closed fold")

--#endregion

--#region node_action

map_desc("n", "gA", function()
    require("ts-node-action").node_action()
end, "Trigger Node Action")

--#endregion

--#region legendary

map_desc("n", "<leader>lk", function()
    local filters = require("legendary.filters")
    require("legendary").find({
        filters = {
            filters.current_mode(),
            filters.keymaps(),
        },
    })
end, "Legendary keymap (current mode)")

--#endregion

--#region outline

map_desc("n", "<leader>go", "<cmd>Outline<cr>", "Toggle Outline")

--#endregion

--#region octo

map_desc("n", "<leader>Oo", "<cmd>Octo<cr>", "Octo")
map_desc("n", "<leader>Op", "<cmd>Octo pr list<cr>", "Octo PR List")
--#endregion
