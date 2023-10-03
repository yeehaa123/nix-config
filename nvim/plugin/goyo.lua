local augroup = vim.api.nvim_create_augroup('goyo_cmds', {clear = true})
local autocmd = vim.api.nvim_create_autocmd
local bind = vim.keymap.set
local unbind = vim.keymap.del

vim.g.goyo_height = '100%'

local enter = function()
  vim.opt.wrap = true
  vim.opt.linebreak =  true
  vim.cmd('Limelight')
end

local leave = function()
  vim.opt.wrap = false
  vim.opt.linebreak =  false
  vim.cmd('Limelight!')
end

autocmd('User', {pattern = 'GoyoEnter', group = augroup, callback = enter})
autocmd('User', {pattern = 'GoyoLeave', group = augroup, callback = leave})
