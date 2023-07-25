require('auto-save').setup({
  enabled = true,
  events = { "InsertLeave", "TextChanged", "BufLeave" },
  conditions = {
    exists = true,
    filetype_is_not = {},
    modifiable = true
  },
  debounce_delay = 135
})
