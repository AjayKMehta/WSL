-- https://github.com/tinyCatzilla/dots/blob/193cc61951579db692e9cc7f8f278ed33c8b52d4/.config/nvim/lua/custom/configs/vimtex.lua

local g = vim.g

g.tex_flavor = "latex"
-- g.vimtex_view_method = conf.vimtex_view_method
g.vimtex_compiler_progname = 'nvr'

g.vimtex_view_general_viewer = 'zathura'
-- Stopped working! :(
-- g.vimtex_view_method = 'zathura'
-- Do not rely on xodotool: https://github.com/lervag/vimtex/issues/2767
g.vimtex_view_method = 'zathura_simple'

-- https://github.com/Neelfrost/nvim-config/blob/1b1e11bed240987bfe0eae30538394ec210f1aa9/lua/user/plugins/config/vimtex.lua#L34
-- https://medium.com/@Pirmin/a-minimal-latex-setup-on-windows-using-wsl2-and-neovim-51259ff94734
-- Also, seehttps://github.com/lervag/vimtex/issues/2566#issuecomment-1322886643
-- g.vimtex_view_general_viewer = 'SumatraPDF'
-- g.vimtex_view_method = 'SumatraPDF'
-- g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'

g.vimtex_view_skim_sync = 1
g.vimtex_view_skim_activate = 1

vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_latexmk = {
  callback = 1,
  continuous = 1,
  executable = "latexmk",
  options = {
    "-shell-escape",
    "-verbose",
    "-file-line-error",
    "-synctex=1",
    "-interaction=nonstopmode",
  },
}

-- vim.g['vimtex_mappings_enabled'] = 0
g.vimtex_indent_enabled = 0
g.vimtex_quickfix_mode = 0

-- Using Treesitter requires these settings
vim.g.vimtex_syntax_enabled = 0
-- https://github.com/lervag/vimtex/blob/5e6a8ff1405f0f2480c37bb10fa69ddfb1b6713f/doc/vimtex.txt#L4841
g.vimtex_syntax_conceal_disable = 1

-- https://github.com/ofseed/nvim/blob/351ad3c7a8de6e03deab32e0705398169d4f3b8d/lua/plugins/filetype/tex.lua
vim.g.vimtex_toc_config = {
  name = "TOC",
  layers = { "content", "todo", "include" },
  split_width = 25,
  todo_sorted = 0,
  show_help = 1,
  show_numbers = 1,
}

-- Disable imaps (using LuaSnip)
g.vimtex_imaps_enabled = 0

g.vimtex_fold_levelmarker = ''
g.vimtex_fold_enabled = 1
g.vimtex_fold_manual = 1
g.tex_comment_nospell = 1

g.vimtex_format_enabled = 1

g.maplocalleader = ','

-- Latex warnings to ignore
g.vimtex_quickfix_ignore_filters = {
  "Command terminated with space",
  "LaTeX Font Warning: Font shape",
  "Package caption Warning: The option",
  [[Underfull \\hbox (badness [0-9]*) in]],
  "Package enumitem Warning: Negative labelwidth",
  [[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in]],
  [[Package caption Warning: Unused \\captionsetup]],
  "Package typearea Warning: Bad type area settings!",
  [[Package fancyhdr Warning: \\headheight is too small]],
  [[Underfull \\hbox (badness [0-9]*) in paragraph at lines]],
  "Package hyperref Warning: Token not allowed in a PDF string",
  [[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in paragraph at lines]],
}

-- Error suppression:
-- https://github.com/lervag/vimtex/blob/master/doc/vimtex.txt

g.vimtex_log_ignore = ({
  'Underfull',
  'Overfull',
  'specifier changed to',
  'Token not allowed in a PDF string',
  'Package Fontspec Warning',
  'LaTeX Font Warning',
})

-- https://www.ejmastnak.com/tutorials/vim-latex/pdf-reader/#a-pdf-reader-on-linux

vim.cmd [[
        " Get Vim's window ID for switching focus from Zathura to Vim using xdotool.
        " Only set this variable once for the current Vim instance.
        if !exists("g:vim_window_id")
          let g:vim_window_id = system("xdotool getactivewindow")
        endif
      ]]

vim.cmd [[
  function! s:TexFocusVim() abort
  " Give window manager time to recognize focus moved to Zathura;
  " tweak the 200m (200 ms) as needed for your hardware and window manager.
  sleep 200m

  " Refocus Vim and redraw the screen
  silent execute "!xdotool windowfocus " . expand(g:vim_window_id)
  redraw!
endfunction
]]
