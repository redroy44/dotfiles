local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  execute("!git clone https://github.com/wbthomason/packer.nvim " ..
  install_path)
  execute "packadd packer.nvim"
end

vim.cmd "autocmd BufWritePost plugins.lua PackerCompile" -- Auto compile when there are changes in plugins.lua

return require("packer").startup(function(use)
  -- Packer can manage itself as an optional plugin
  use "wbthomason/packer.nvim"

  -- Native LSP
  use "neovim/nvim-lspconfig"
  use "williamboman/nvim-lsp-installer"
  -- use "mattn/efm-langserver"
  use "folke/lsp-colors.nvim"
  -- use "windwp/nvim-ts-autotag"

  -- Spell Checker
  use "lewis6991/spellsitter.nvim"

  -- Auto Completion
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
    }
  })

  -- Telescope
  use "nvim-lua/plenary.nvim"
  use "nvim-telescope/telescope.nvim"
  use "nvim-lua/popup.nvim"
  use "nvim-telescope/telescope-fzy-native.nvim"
  use "nvim-telescope/telescope-dap.nvim"

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  -- Git
  use "tpope/vim-fugitive"
  use "lewis6991/gitsigns.nvim"

  -- Explorer
  use "kyazdani42/nvim-tree.lua"
  use "kevinhwang91/rnvimr"

  -- Scala
  use "derekwyatt/vim-scala"
  use({'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" }})
  use "mfussenegger/nvim-dap"


  -- ColorScheme
  -- use {"ful1e5/onedark.nvim", branch = 'dev'}
  use 'navarasu/onedark.nvim'
  use 'shaunsingh/nord.nvim'

  use "eddyekofo94/gruvbox-flat.nvim"

  -- Color previewers
  use "norcalli/nvim-colorizer.lua"

  -- Status Line
  use {
    'hoob3rt/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- Formatter
  use "mhartington/formatter.nvim"
  use "andrejlevkovitch/vim-lua-format"
  use { "prettier/vim-prettier", run = "yarn install" }
  use "psf/black"

  -- Autosave
  use "Pocco81/AutoSave.nvim"

  -- Utilies Plugins
  use { "tpope/vim-surround" }
  use "terrortylor/nvim-comment"
  use "windwp/nvim-autopairs"
end)
