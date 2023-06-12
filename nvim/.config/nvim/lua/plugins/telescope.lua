local actions = require('telescope.actions')

require('telescope').setup({
  defaults = {
    file_ignore_patterns = { "node_modules/", "__pycache__/" },
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    selection_caret = '❯ ',
    entry_prefix = '  ',
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    selection_strategy = 'reset',
    sorting_strategy = 'descending',
    layout_strategy = 'flex',
    -- layout_config = { horizontal = { mirror = false }, vertical = { mirror = false } },
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

local grep_string = function()
  require('telescope.builtin').grep_string({ search = vim.fn.input('Grep For > ') })
end

local metals = function()
  require('telescope').extensions.metals.commands()
end

local wk = require("which-key")
wk.register({
  ["<C-p>"] = { function() project_files() end, "Search Project Files" }
})

wk.register({
  ["pf"] = { function() grep_string() end , "Grep String"},
  ["mt"] = { function() metals() end , "Metals"},
  ["j"] = { function() return require('telescope.builtin').jumplist() end , "Jumplist"},
  ["man"] = { function() return require('telescope.builtin').man_pages() end , "Man Pages"},
  ["="] = { function() return require('telescope.builtin').spell_suggest() end , "Spell Suggest"},
  ["hi"] = { function() return require('telescope.builtin').highlights() end , "Highlights"},
  ["reg"] = { function() return require('telescope.builtin').registers() end , "Registers"},
  ["gg"] = { function() return require('telescope.builtin').live_grep() end , "Live Grep"},
  ["wc"] = { function() return require('telescope.builtin').lsp_document_symbols() end , "Document Symbols"},
  ["wd"] = { function() return require('telescope.builtin').lsp_dynamic_workspace_symbols() end , "Dynamic Workspace Symbols"},
  ["<Tab>"] = { function() return require('telescope.builtin').buffers() end , "Buffers"},
}, { prefix = "<space>" })

-- Custom key-binding
-- stylua: ignore start
-- map('n', '<space>vrc', function() nvim_dotfiles() end, opts)
-- map('n', '<space>ktty', function() kitty_dotfiles() end, opts)

-- stylua: ignore end
