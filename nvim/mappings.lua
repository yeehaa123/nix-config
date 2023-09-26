local builtin = require('telescope.builtin')
local projects = require('telescope').extensions.projects
local file_browser = require('telescope').extensions.file_browser

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>bf', file_browser.file_browser, {})
vim.keymap.set('n', '<leader>p', projects.projects, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
