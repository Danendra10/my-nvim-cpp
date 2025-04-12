vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
  {
    "tpope/vim-commentary",
    event = "VeryLazy"
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy"  -- Load when required
  },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
vim.opt.shell = "/bin/bash"
require "options"
require "nvchad.autocmds"

vim.g.VM_maps = {
  ["Find Under"] = "<C-m>",  -- Replace <C-m> with your preferred key
}

-- Enable relative line numbers
vim.opt.relativenumber = true
-- Show absolute number on the current line
vim.opt.number = true

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]

vim.schedule(function()
  require "mappings"
end)
