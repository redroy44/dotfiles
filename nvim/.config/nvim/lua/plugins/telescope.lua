local actions = require('telescope.actions')

require('telescope').setup({
  defaults = {
    file_ignore_patterns = { "target", "node_modules", "parser.c", "out", "metals", "bloop" },
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    selection_caret = '❯ ',
    entry_prefix = '  ',
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    selection_strategy = 'reset',
    sorting_strategy = 'descending',
    layout_strategy = 'horizontal',
    layout_config = { horizontal = { mirror = false }, vertical = { mirror = false } },
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    mappings = { i = { ['<esc>'] = actions.close, ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist } },
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
    },
  },
})
-- To get fzf loaded and working with telescope
require('telescope').load_extension('fzf')
require('telescope').load_extension('dap')

local dotfile_dir = '$HOME/.dotfiles'

local nvim_dotfiles = function()
  require('telescope.builtin').find_files({ prompt_title = '~ VimRC ~', cwd = dotfile_dir .. '/nvim/.config/nvim' })
end

local kitty_dotfiles = function()
  require('telescope.builtin').find_files({
    prompt_title = '~ Kitty Config ~',
    cwd = dotfile_dir .. '/kitty/.config/kitty',
  })
end

local project_files = function()
  local opt = {} -- define here if you want to define something
  local ok = pcall(require('telescope.builtin').git_files, opt)
  if not ok then
    require('telescope.builtin').find_files(opt)
  end
end

local lsp_code_actions = function()
  require('telescope.builtin').lsp_code_actions(require('telescope.themes').get_cursor())
end

local grep_string = function()
  require('telescope.builtin').grep_string({ search = vim.fn.input('Grep For > ') })
end

local metals = function()
  require('telescope').extensions.metals.commands()
end

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Custom key-binding
-- stylua: ignore start
map('n', '<space>vrc', function() nvim_dotfiles() end, opts)
map('n', '<space>ktty', function() kitty_dotfiles() end, opts)
map('n', '<C-p>', function() project_files() end, opts)

map('n', '<space>ca', function() lsp_code_actions() end, opts)
map('n', '<space>pf', function() grep_string() end, opts)
map('n', '<space>mt', function() metals() end, opts)

-- Builtin key-binding
map('n', '<space>help', function() return require('telescope.builtin').help_tags() end, opts)
map('n', '<space>man', function() return require('telescope.builtin').man_pages() end, opts)
map('n', '<space>=', function() return require('telescope.builtin').spell_suggest() end, opts)
map('n', '<space>hi', function() return require('telescope.builtin').highlights() end, opts)
map('n', '<space>reg', function() return require('telescope.builtin').registers() end, opts)

map('n', '<space>gr', function() return require('telescope.builtin').live_grep() end, opts)
map('n', '<space>wc', function() return require('telescope.builtin').lsp_document_symbols() end, opts)
map('n', '<space>wd', function() return require('telescope.builtin').lsp_dynamic_workspace_symbols() end, opts)

-- stylua: ignore end
