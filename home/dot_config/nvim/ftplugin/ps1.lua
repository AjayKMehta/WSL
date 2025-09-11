-- https://github.com/PowerShell/PowerShellEditorServices/blob/main/docs/guide/getting_started.md#indentation

vim.opt_local.cindent = true
vim.opt_local.cinoptions:append { 'J1', '(1s', '+0' } -- see :h cino-J, cino-(, cino-+

vim.opt_local.iskeyword:remove { '-' } -- OPTIONALLY consider Verb-Noun as a whole word
