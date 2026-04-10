vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

if vim.fn.executable("xclip") == 1 or vim.fn.executable("xsel") == 1 or vim.fn.executable("wl-copy") == 1 then
  vim.opt.clipboard = "unnamedplus"
end
