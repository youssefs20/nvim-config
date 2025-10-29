vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.g.mapleader = " "
vim.opt.autoindent = true
vim.opt.smartindent = true 


-- start lazy nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none", 
    "--branch=stable", 
    lazyrepo,
    lazypath
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n",
        "ErrorMsg"
      },
      { out,
        "WarningMsg"
      },
      { "\nPress any key to exit..."},
    },
      true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- end lazy nvim

local plugins = {
  -- catppuccin
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- telescope  
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  -- treesitter
  {"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"},
  -- neo tree (in normal mode type Neotree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
  }
}
local opts = {}

require("lazy").setup(plugins , opts)

-- press ctrl + p to navigate bewteen files
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
-- press space + f + g to live grep
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

--tree map
vim.keymap.set('n','<C-n>', ':Neotree filesystem reveal left<CR>',{})

-- treesitter configs 
local config = require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua","query", "markdown", "markdown_inline", "javascript"},
  highlight = { enable = true},
  -- gg=G to autoindent (not sure how it works)
  indent = {enable = true},

}

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"
