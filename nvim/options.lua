local options = {
  number = true,
  relativenumber = false,
  shiftwidth = 2,
  tabstop = 2,
  autoindent = true,
  expandtab = true,
}

for option, value in pairs(options) do 
  vim.opt[option] = value
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "
