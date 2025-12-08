local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic settings (familiar from vim)
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Leader key (set before loading plugins)
vim.g.mapleader = " "

-- Load plugins
require("lazy").setup("plugins")

-- use cpp highlight for metal shaders
vim.filetype.add({
  extension = {
    metal = "cpp",
  },
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)

-- no mouse
vim.opt.mouse = ""
