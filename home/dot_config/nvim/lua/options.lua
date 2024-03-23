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
