-- https://github.com/PowerShell/PowerShellEditorServices/blob/main/docs/guide/getting_started.md#indentation

-- disable indent from powershell treesitter parser
-- because the parse isn't mature currently
-- you can ignore this step if don't use treesitter
if pcall(require, 'nvim-treesitter') then
  vim.schedule(function() vim.cmd([[TSBufDisable indent]]) end)
end

vim.opt_local.cindent = true
vim.opt_local.cinoptions:append { 'J1', '(1s', '+0' } -- see :h cino-J, cino-(, cino-+

vim.opt_local.iskeyword:remove { '-' } -- OPTIONALLY consider Verb-Noun as a whole word
