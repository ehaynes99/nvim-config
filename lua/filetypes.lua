vim.filetype.add({
  extension = {
    conf = 'conf',
    env = 'conf',
  },
  filename = {
    ['.env'] = 'conf',
  },
  pattern = {
    ['%.env%.[%w_.-]+'] = 'conf',
  },
})
vim.filetype.add({
  filename = {
    ['.swcrc'] = 'json',
  },
})
