require("nvchad.options")

local o = vim.o

-- https://nanotipsforvim.prose.sh/change-vims-window-title
o.title = true
o.titlelen = 0

-- o.cursorlineopt ='both' -- to enable cursorline!

-- https://github.com/johanvx/nvim-config/commit/6e117eb10bfd9a109f998ee8cf3f28b559a23e4c#diff-4d7eb50f84b3feefd05e927bd6992f250653dc4f22645fb93d21035f1d17c492R54
o.guifont = "DejaVuSansM Nerd Font"

o.colorcolumn = "80"
o.mouse = "a"

-- https://github.com/carderne/dotfiles/blob/381bc0bdfed96a5ea82b57c89517d2769dc33952/.config/nvim/init.lua#L124-L191

o.hlsearch = true
o.relativenumber = false
o.undodir = vim.fn.stdpath("cache") .. "/undo"
o.autoindent = true

o.updatetime = 100

-- Highlight trailing characters

-- vim.o doesn't work!
vim.opt.listchars = {
    tab = "▸ ",
    trail = "·",
}
o.list = true

o.wrap = true
o.cursorcolumn = true

o.scrolloff = 5

o.termguicolors = true

-- https://www.reddit.com/r/neovim/comments/1c0bemk/using_ripgrep_as_grepprg_to_search_in_the_current/
o.grepprg = "rg --vimgrep"
o.grepformat = "%f:%l:%c:%m"

-- Hanging indent when word-wrap
-- https://www.reddit.com/r/neovim/comments/1d7sugh/comment/l71gilt
o.breakindentopt = "list:-1"
o.breakindent = true

-- https://dev.to/anurag_pramanik/how-to-enable-undercurl-in-neovim-terminal-and-tmux-setup-guide-2ld7
-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Native spelling functionality

vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- https://jdhao.github.io/2019/04/26/words_completion_nvim/
vim.opt.dictionary:append("/usr/share/dict/words")

-- Experimental UI2: floating cmdline and messages
o.cmdheight = 0
require("vim._core.ui2").enable({
    enable = true,
    msg = {
        targets = {
            [""] = "msg",
            empty = "cmd",
            bufwrite = "msg",
            confirm = "cmd",
            emsg = "pager",
            echo = "msg",
            echomsg = "msg",
            echoerr = "pager",
            completion = "cmd",
            list_cmd = "pager",
            lua_error = "pager",
            lua_print = "msg",
            progress = "pager",
            rpc_error = "pager",
            quickfix = "msg",
            search_cmd = "cmd",
            search_count = "cmd",
            shell_cmd = "pager",
            shell_err = "pager",
            shell_out = "pager",
            shell_ret = "msg",
            undo = "msg",
            verbose = "pager",
            wildlist = "cmd",
            wmsg = "msg",
            typed_cmd = "cmd",
        },
        cmd = {
            height = 0.5,
        },
        dialog = {
            height = 0.5,
        },
        msg = {
            height = 0.3,
            timeout = 5000,
        },
        pager = {
            height = 0.5,
        },
    },
})
