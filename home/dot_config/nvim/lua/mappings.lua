-- See mappings here: https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua
require("nvchad.mappings")

local utils = require("utils.mappings")
local map = utils.map
local map_desc = utils.map_desc
-- map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("i", "jk", "<ESC>")
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- To disable mappings:
local disabled = {
    n = {
        "<C-b>", -- NvChad maps this to beginning of line
        "<leader>fm", -- Duplicate for above
        "<leader>fb", -- NvChad maps this to Find buffers
        "<leader>fh", -- NvChad maps this to Find help pages
        "<leader>n",  -- Use as prefix
        "<leader>b", -- Use as prefix
        "<A-i>", -- NvChad maps this to floating terminal
        "<A-h>", -- NvChad maps this to horizontal terminal
        "<A-v>", -- NvChad maps this to vertical terminal
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

map_desc("n", "<leader>tt", function()
    require("base46").toggle_theme()
end, "NvChad Toggle theme")

map_desc("n", "<leader>tT", function()
    require("base46").toggle_transparency()
end, "NvChad Toggle transparency")

map_desc("n", "gli", function()
    vim.lsp.buf.implementation()
end, "Lsp Go to implementation")

-- tabufline (NVChad plugin)
-- NVChad maps this to <leader>b
-- Use Tab and Shift+Tab to navigate between buffers
map_desc("n", "<leader>bb", "<cmd>enew<CR>", "Buffer New")

--#region ghcup

map_desc("n", "<leader>gg", "<cmd>GHCup <CR>", "ghcup")

--#endregion

--#region Telescope


map_desc("n", "<leader>fb", "<cmd>Telescope file_browser<CR>", "Telescope File browser")
map_desc("n", "<leader>fM", "<cmd>Telescope bookmarks list<CR>", "Telescope Bookmarks ")
map_desc("n", "<leader>fB", function()
    require("telescope.builtin").buffers()
end, "Telescope Find buffers")

map_desc("n", "<leader>fh", "<cmd> Telescope file_browser cwd=$HOME <CR>", "Telescope Search home")

map_desc("n", "<leader>ff", function()
    require("telescope").extensions.togglescope.find_files()
end, "Telescope Find files")

map_desc("n", "<leader>fcc", "<cmd> Telescope find_files cwd=$HOME/.config <CR>", "Telescope Search config 🔍")
map_desc("n", "<leader>fcC", function()
    require("telescope.builtin").commands()
end, "Telescope Commands")
map_desc("n", "<leader>fch", function()
    require("telescope.builtin").command_history()
end, "Telescope Command History")

map_desc("n", "<leader>fcs", function()
    require("telescope.builtin").colorscheme()
end, "Telescope Colorschemes")

map_desc("n", "<leader>fS", function()
    require("telescope.builtin").search_history()
end, "Telescope Search History")

map_desc("n", "<leader>fk", function()
    require("telescope.builtin").keymaps()
end, "Telescope Keymap ⌨")
map_desc("n", "<leader>fm", function()
    require("telescope.builtin").man_pages()
end, "Telescope Man Pages")
map_desc("n", "<leader>fu", "<cmd>Telescope undo<CR>", "Telescope Undo tree ")

map_desc("n", "<leader>fw", function()
    require("telescope").extensions.togglescope.live_grep()
end, "Telescope Live grep")

map_desc("n", "<leader>fy", function()
    require("telescope.builtin").buffers()
end, "Telescope Search buffers")
map_desc("n", "<leader>fY","<cmd>Telescope yaml_schema<CR>", "Telescope YAML schemas")

map_desc("n", "<leader>fls", "<cmd>Telescope lsp_document_symbols<CR>", "Telescope Search Document Symbols")
map_desc("n", "<leader>flw", "<cmd>Telescope lsp_workspace_symbols<CR>", "Telescope Search Workspace Symbols")
map_desc("n", "<leader>fld", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Telescope Search Dynamic Workspace Symbols")

map_desc("n", "<leader>fe", "<cmd>Telescope emoji<CR>", "Telescope Search emojis")
map_desc("n", "<leader>fn", function()
    require("telescope").extensions.notify.notify()
end, "Telescope Notifications")
map_desc("n", "<leader>fN", "<cmd>Noice telescope <CR>", "Telescope Noice")
map_desc("n", "<leader>fj", function()
    require("telescope.builtin").jumplist()
end, "Telescope Jumplist")


map_desc("n", "<leader>fr<CR>", "<cmd>Telescope resume<cr>", "telescope resume previous search" )
map_desc("n", "<leader>fR", function()
    require("telescope.builtin").registers()
end, "Telescope Registers")

map_desc("n", "<leader>fs", function()
    require("telescope").extensions["luasnip"].luasnip()
end, "Telescope LuaSnip")

map_desc("n", "<leader>ftS", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", "Telescope Todo/Fix/Fixme")

map_desc("n", "<leader>ftt", function()
    require("telescope.builtin").tags()
end, "Telescope Tags")

map_desc("n", "<leader>fts", function()
    require("telescope.builtin").treesitter()
end, "Telescope Treesitter")

map_desc("n", "<leader>fF<leader>", function()
    require("telescope").extensions.frecency.frecency({})
end, "Telescope frecency")
map_desc("n", "<leader>fFc", function()
    require("telescope").extensions.frecency.frecency({
        workspace = "CWD",
    })
end, "Telescope frecency (CWD)")

map_desc("n", "<leader>fHl", function()
    require("telescope-helpgrep").live_grep()
end, "Telescope Grep help (live grep)")

map_desc("n", "<leader>fHg", function()
    require("telescope-helpgrep").grep_string()
end, "Telescope Grep help (grep string)")
map_desc("n", "<leader>fHt", function()
    require("telescope.builtin").help_tags()
end, "Telescope Help tags")

-- NVChad provides git status via <leader>gt
map_desc("n", "<leader>ga", function()
    require("telescope.builtin").git_branches()
end, "git Checkout branch")
map_desc("n", "<leader>gc", function()
    require("telescope.builtin").git_commits()
end, "git Checkout commit")
map_desc("n", "<leader>gs", function()
    require("telescope.builtin").git_stash()
end, "git stash")

-- Nvim DAP

map_desc("n", "<leader>fdb", function()
    require("telescope").extensions.dap.list_breakpoints()
end, "DAP List breakpoints")

map_desc("n", "<leader>fdc", function()
    require("telescope").extensions.dap.commands()
end, "DAP List commands")

map_desc("n", "<leader>fdC", function()
    require("telescope").extensions.dap.configuration()
end, "DAP List configuration")

map_desc("n", "<leader>fdf", function()
    require("telescope").extensions.dap.frames()
end, "DAP List frames")

map_desc("n", "<leader>fdv", function()
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

--#region dap

-- Keep same as VS + VS Code
map_desc("n", "<F9>", function()
    require("dap").toggle_breakpoint()
end, "DAP Toggle breakpoint")
map_desc("n", "<F5>", function()
    require("dap").continue()
end, "DAP Launch debugger")
map_desc("n", "<F10>", function()
    require("dap").step_over()
end, "DAP Step over")
map_desc("n", "<F11>", function()
    require("dap").step_into()
end, "DAP Step into")
map_desc("n", "<S-F11>", function()
    require("dap").step_out()
end, "DAP Step out")

map_desc("n", "<leader>rb", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "DAP Set conditional breakpoint")

map_desc("n", "<leader>rl", function()
    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, "DAP Log message")

--#endregion

--region dap_python
map_desc("n", "<leader>rt", function()
    require("dap-python").test_method()
end, "DAP Debug closest method to cursor")

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

map_desc("n", "<leader>sl", show_snippet_list, "Snippets List")

--#endregion

--#region urlview

map_desc("n", "<leader>uu", "<cmd>UrlView<CR>", "UrlView Show URLs")

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

--#region wtf

map_desc({ "n", "x" }, "gw", function()
    require("wtf").ai()
end, "WTF Debug diagnostic with AI")

map_desc("n", "gW", function()
    require("wtf").search()
end, "WTF Search diagnostic with Google")

--#endregion

--#region Flash

local function flash_jump()
    require("flash").jump()
end

map_desc("n", "<leader>ss", flash_jump, "Flash")
map_desc({ "o", "x" }, "ss", flash_jump, "Flash")

local function flash_ts()
    require("flash").treesitter()
end

map_desc("n", "<leader>sT", flash_ts, "Flash Treesitter")
map_desc({ "o", "x" }, "sT", flash_ts, "Flash Treesitter")

local function flash_fwd()
    require("flash").jump({
        search = { forward = true, wrap = false, multi_window = false },
    })
end

map_desc("n", "<leader>sf", flash_fwd, "Flash Forward")
map_desc({ "o", "x" }, "sf", flash_fwd, "Flash Forward")

local function flash_back()
    require("flash").jump({
        search = { forward = false, wrap = false, multi_window = false },
    })
end

map_desc("n", "<leader>sb", flash_back, "Flash Backward")
map_desc({ "o", "x" }, "sb", flash_back, "Flash Backward")

local function flash_cont()
    require("flash").jump({
        search = { continue = true },
    })
end

map_desc("n", "<leader>sc", flash_cont, "Flash Continue search")
map_desc({ "o", "x" }, "sc", flash_cont, "Flash Continue search")

local function flash_diag()
    -- More advanced example that also highlights diagnostics:
    require("flash").jump({
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

map_desc("n", "<leader>sd", flash_diag, "Flash Diagnostics")
map_desc({ "o", "x" }, "sd", flash_diag, "Flash Diagnostics")

map_desc("o", "sr", function()
    require("flash").remote()
end, "Flash Remote")

map_desc({ "o", "x" }, "sR", function()
    require("flash").treesitter_search()
end, "Flash Treesitter search")

map_desc("c", "<leader>st", function()
    require("flash").toggle()
end, "Flash Toggle search")

local flash_word = function()
    local word = vim.fn.expand("<cword>")
    if word ~= nil and #word > 0 then
        require("flash").jump({ pattern = word })
    end
end

map_desc("n", "<leader>sw", flash_word, "Flash current word")

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

--#region ufo

map_desc("n", "]z", function()
    require("ufo").goNextClosedFold()
end, "UFO Go to next closed fold")
map_desc("n", "[z", function()
    require("ufo").goPreviousClosedFold()
end, "UFO Go to previous closed fold")
map_desc("n", "zk", function()
    require("ufo").peekFoldedLinesUnderCursor()
end, "UFO Peek fold")
--#endregion

--#region node_action

map_desc("n", "gA", function()
    require("ts-node-action").node_action()
end, "Node-Action Trigger")

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
end, "Legendary Keymap (current mode)")

--#endregion

--#region outline

map_desc("n", "<leader>go", "<cmd>Outline<cr>", "Outline Toggle")

--#endregion

--#region octo

map_desc("n", "<leader>Oo", "<cmd>Octo<cr>", "Octo")
map_desc("n", "<leader>Oi", "<cmd>Octo issue list<cr>", "Octo Issue List")
map_desc("n", "<leader>Op", "<cmd>Octo pr list<cr>", "Octo PR List")
map_desc("n", "<leader>Or", "<cmd>Octo repo list<cr>", "Octo Repo List")

--#endregion

--#region Noice

map_desc("n", "<leader>nd", function()
    require("noice").cmd("dismiss")
end, "Noice dismiss")

map_desc("n", "<leader>ne", function()
    require("noice").cmd("errors")
end, "Noice errors")

map_desc("n", "<leader>nh", function()
    require("noice").cmd("history")
end, "Noice history")

-- shows the last message in a popup
map_desc("n", "<leader>nl", function()
    require("noice").cmd("last")
end, "Noice last")

map_desc("n", "<leader>nD", function()
    require("noice").cmd("disable")
end, "Noice disable")

map_desc("n", "<leader>nE", function()
    require("noice").cmd("enable")
end, "Noice enable")

map({ "n", "i", "s" }, "<c-f>", function()
    if not require("noice.lsp").scroll(4) then
        return "<c-f>"
    end
end, { silent = true, expr = true, desc = "Noice Scroll forward" })

map({ "n", "i", "s" }, "<c-b>", function()
    if not require("noice.lsp").scroll(-4) then
        return "<c-b>"
    end
end, { silent = true, expr = true, desc = "Noice Scroll backward" })

-- Doesn't seem to work?
map_desc("c", "<S-Enter>", function()
    require("noice").redirect(vim.fn.getcmdline())
end, "Redirect Cmdline")

--#endregion

--#region comment

-- https://github.com/numToStr/Comment.nvim/wiki/Examples#smart-comment

if not vim.g.nvim_comment then
    function _G.__toggle_contextual(vmode)
        local cfg = require("Comment.config"):get()
        local U = require("Comment.utils")
        local Op = require("Comment.opfunc")
        local range = U.get_region(vmode)
        local same_line = range.srow == range.erow

        local ctx = {
            cmode = U.cmode.toggle,
            range = range,
            cmotion = U.cmotion[vmode] or U.cmotion.line,
            ctype = same_line and U.ctype.linewise or U.ctype.blockwise,
        }

        local lcs, rcs = U.parse_cstr(cfg, ctx)
        local lines = U.get_lines(range)

        local params = {
            range = range,
            lines = lines,
            cfg = cfg,
            cmode = ctx.cmode,
            lcs = lcs,
            rcs = rcs,
        }

        if same_line then
            Op.linewise(params)
        else
            Op.blockwise(params)
        end
    end

    map_desc("n", "<Leader>cc", "<cmd>set operatorfunc=v:lua.__toggle_contextual<CR>g@", "Toggle comment")
    map_desc("x", "<Leader>cc", "<cmd>set operatorfunc=v:lua.__toggle_contextual<CR>g@", "Toggle comment")
end
--#endregion
