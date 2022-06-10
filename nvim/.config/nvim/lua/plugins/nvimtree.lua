require('nvim-tree').setup({
  diagnostics = { enable = true },
  view = {
    width = 30,
    side = 'right',
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },
  renderer = {
    group_empty = true,
    highlight_opened_files = "icon",
    special_files = {},
    root_folder_modifier = ':p:~'
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
})

-- Mappings
vim.keymap.set('n', '<C-b>', function()
  require('nvim-tree').toggle()
end, { noremap = true, silent = true })
