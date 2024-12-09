local map_buf= require("utils.mappings").map_buf

-- Necessary because `]m`, etc. used by treesitter to move to method start/end
map_buf(0, "n", "[e", "<plug>(vimtex-[m)", "Go to start of current environment")
map_buf(0, "n", "]e", "<plug>(vimtex-]m)", "Go to start of next environment")
map_buf(0, "n", "[E", "<plug>(vimtex-[M)", "Go to end of previous environment")
map_buf(0, "n", "]E", "<plug>(vimtex-]M)", "Go to end of current environment")
