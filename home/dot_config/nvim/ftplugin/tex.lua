local map_buf = require("utils.mappings").map_buf

-- Necessary because `]m`, etc. used by treesitter to move to method start/end
map_buf(0, { "n", "x", "o" }, "[e", "<plug>(vimtex-[m)", "Go to previous start of environment")
map_buf(0, { "n", "x", "o" }, "]e", "<plug>(vimtex-]m)", "Go to next start of environment")
map_buf(0, { "n", "x", "o" }, "[E", "<plug>(vimtex-[M)", "Go to previous end of environment")
map_buf(0, { "n", "x", "o" }, "]E", "<plug>(vimtex-]M)", "Go to previous start of environment")

map_buf(0, { "x", "o" }, "ic", "<plug>(vimtex-targets-i)c", "Inner command")
map_buf(0, { "x", "o" }, "ac", "<plug>(vimtex-targets-a)c", "Around command")
