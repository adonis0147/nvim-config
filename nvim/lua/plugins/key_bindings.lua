--------------------------------------------------------------------------------
--                                  Mappings                                  --
--------------------------------------------------------------------------------

-- telescope.nvim
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true })

-- hop.nvim
vim.api.nvim_set_keymap("n", "s", "<cmd>HopChar2AC<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "S", "<cmd>HopChar2BC<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "s", "<cmd>HopChar2AC<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "S", "<cmd>HopChar2BC<CR>", { noremap = true })

-- vim-easy-align
vim.api.nvim_set_keymap("v", "<enter>", "<plug>(EasyAlign)", {})
vim.api.nvim_set_keymap("n", "ga", "<plug>(EasyAlign)", {})

-- kommentary
vim.api.nvim_set_keymap("n", "<leader>cc", "<plug>kommentary_line_default", {})
vim.api.nvim_set_keymap("x", "<leader>cc", "<plug>kommentary_visual_default", {})

