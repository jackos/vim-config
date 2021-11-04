-- plugin: telescope.nvim
-- see: https://github.com/rmagatti/session-lens
-- rafi settings
require("transparent").setup({
  enable = true, -- boolean: enable transparent
  extra_groups = { -- table/string: additional groups that should be clear
    -- In particular, when you set it to 'all', that means all avaliable groups

    -- example of akinsho/nvim-bufferline.lua
    "BufferLineTabClose",
    "BufferlineBufferSelected",
    "BufferLineFill",
    "BufferLineBackground",
    "BufferLineSeparator",
    "BufferLineIndicatorSelected",
  },
  exclude = {}, -- table: groups you don't want to clear
})


require('session-lens').setup({
	path_display = { 'shorten' },
	winblend = 0,
})
require('telescope').load_extension('session-lens')

