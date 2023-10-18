local builtin = require('telescope.builtin')
local projects = require('telescope').extensions.projects
local file_browser = require('telescope').extensions.file_browser
local undo = require('telescope').extensions.undo

local map = vim.keymap.set

map('i', 'jj', '<esc>')
map('n', '<Space>', '<nop>')
map('', '<up>', '<nop>')
map('', '<down>', '<nop>')
map('', '<left>', '<nop>')
map('', '<right>', '<nop>')

map('n', '<leader>ff', builtin.find_files, {})
map('n', '<leader>fg', builtin.live_grep, {})
map('n', '<leader>fb', file_browser.file_browser, {})
map('n', '<leader>ud', undo.undo, {})
map('n', '<leader>p', projects.projects, {})
map('n', '<leader>bf', builtin.buffers, {})
map('n', '<leader>fh', builtin.help_tags, {})
map('n', '<leader>os', "<cmd>ObsidianSearch<CR>", {})
map('n', '<leader>obl', "<cmd>ObsidianBacklinks<CR>", {})
map('n', '<leader>z', "<cmd>Goyo<CR>", {})

