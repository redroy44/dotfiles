local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  execute('packadd packer.nvim')
end

-- Auto source when there are changes in plugins.lua
local group = vim.api.nvim_create_augroup('PackerGroup', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = 'plugins.lua',
  command = 'source <afile> | PackerCompile profile=true',
  group = group,
})

local plugins = function(use)
  use({ 'wbthomason/packer.nvim' })
  use({
    'dstein64/vim-startuptime',
    config = function()
      vim.keymap.set('n', '<space>st', ':StartupTime<cr>', { noremap = true })
    end,
  })

  --
  -- Notification
  --
  use({
    'rcarriga/nvim-notify',
    config = function()
      require('plugins.notify')
      vim.notify = require('notify')
    end,
  })

  --
  -- LSP
  --

  use({ 'neovim/nvim-lspconfig' })
  use({ 'hrsh7th/cmp-nvim-lsp' })
  use({
    'williamboman/nvim-lsp-installer',
    config = function()
      require('lsp.setup')
    end,
  })

  --
  -- Auto Completion
  --

  -- Snippets
  use({ 'hrsh7th/cmp-vsnip' })
  use({ 'hrsh7th/vim-vsnip' })
  use({ 'rafamadriz/friendly-snippets', event = 'InsertCharPre' })

  -- Sources
  use({ 'hrsh7th/cmp-buffer' })
  use({ 'hrsh7th/cmp-path' })
  use({ 'hrsh7th/cmp-nvim-lua' })
  use({ 'petertriho/cmp-git', requires = 'nvim-lua/plenary.nvim' })
  use({ 'ray-x/cmp-treesitter' })

  use({
    'hrsh7th/nvim-cmp',
    config = function()
      require('plugins.cmp')
    end,
  })

  use({ 'ray-x/lsp_signature.nvim' })

  --
  -- Treesitter & Spell Checker
  --

  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('plugins.treesitter')
    end,
  })
  use({ 'nvim-treesitter/nvim-treesitter-context' })
  use({ 'nvim-treesitter/playground' })
  use({ 'windwp/nvim-ts-autotag' })
  -- use({
  --   'lewis6991/spellsitter.nvim',
  --   after = 'nvim-treesitter',
  --   commit = 'd2e280a',
  --   config = function()
  --     require('plugins.spellsitter')
  --   end,
  -- })

  --
  -- Auto pair
  --

  use({
    'windwp/nvim-autopairs',
    config = function()
      require('plugins.autopairs')
    end,
  })

  --
  -- Telescope (Fuzzy Finder)
  --

  use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
  use({ 'nvim-telescope/telescope-dap.nvim' })
  use({
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
    event = 'VimEnter',
    config = function()
      require('plugins.telescope')
    end,
  })

  --
  -- Git
  --

  use({
    'tpope/vim-fugitive',
    config = function()
      require('plugins.fugitive')
    end,
  })
  use({
    'lewis6991/gitsigns.nvim',
    event = 'BufRead',
    config = function()
      require('plugins.gitsigns')
    end,
  })

  --
  -- ColorScheme
  --

  use({
    'navarasu/onedark.nvim',
    config = function()
      -- return require('themes.onedark')
    end,
  })
  use({
    'shaunsingh/nord.nvim',
    config = function()
      -- return require('themes.github')
    end,
  })
  use({
    'rebelot/kanagawa.nvim',
    config = function()
      return require('themes.kanagawa')
    end,
  })


  --
  -- Code Formatter
  --

  use({
    'mhartington/formatter.nvim',
    config = function()
      require('plugins.formatter')
    end,
  })

  --
  -- Language syntax highlights
  --

  use({ 'fladson/vim-kitty' })

  --
  -- Explorer
  --

  use({
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('plugins.nvimtree')
    end,
  })

  --
  -- Scala
  --

  use "derekwyatt/vim-scala"
  use({
    'scalameta/nvim-metals',
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require('plugins.metals').setup()
    end
  })
  use "mfussenegger/nvim-dap"

  use({
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "stevanmilic/neotest-scala",
      "antoinemadec/FixCursorHold.nvim"
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-scala")({
            runner = "sbt",
            framework = "scalatest",
          }),
        }
      })
    end
  })

  --
  -- Misc
  --

  use({
    'nvim-lualine/lualine.nvim',
    config = function()
      require('plugins.lualine')
    end,
  })
  use({ 'tpope/vim-surround' })
  use({ 'lilydjwg/colorizer' })
  -- use({
  --   'Pocco81/AutoSave.nvim',
  --   config = function()
  --     require('plugins.autosave')
  --   end,
  -- })
  use({
    'terrortylor/nvim-comment',
    config = function()
      require('plugins.comment')
    end,
  })

  use({ 'mg979/vim-visual-multi' })

  -- https://github.com/sudormrfbin/cheatsheet.nvim
  -- https://github.com/akinsho/bufferline.nvim
  -- https://github.com/folke/which-key.nvim
end

require('packer').startup({
  plugins,
  config = {
    profile = { enable = true },
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'rounded' })
      end,
      prompt_border = 'rounded',
      keybindings = {
        -- Keybindings for the display window
        quit = 'q',
        toggle_info = '<cr>',
        diff = '=',
        prompt_revert = 'r',
      },
    },
  },
})
