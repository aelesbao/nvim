vim.filetype.add({
  extension = {
    tfvars = 'terraform'
  },
  filename = {
    ['PULLREQ_EDITMSG'] = 'gitcommit',
  },
})
