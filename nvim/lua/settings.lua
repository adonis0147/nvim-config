--------------------------------------------------------------------------------
--                                 Variables                                  --
--------------------------------------------------------------------------------

local text_width = 120
local indent_width = 4

--------------------------------------------------------------------------------
--                                  General                                   --
--------------------------------------------------------------------------------

-- Automatically read a file when it is changed from the outside.
vim.opt.autoread = true

-- No backup files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Use mouse in all mode
vim.opt.mouse = 'a'

-- Encoding
vim.opt.fileencodings = 'utf-8,cp936'

-- File formats
vim.opt.fileformats = 'unix,dos'

-- Timeout
vim.opt.timeoutlen = 500

-- Set the clipboard
vim.opt.clipboard:prepend('unnamed,unnamedplus')

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 7

--------------------------------------------------------------------------------
--                               User Interface                               --
--------------------------------------------------------------------------------

-- Show line number
vim.opt.number = true

-- Show matching brackets
vim.opt.showmatch = true

-- The time of blinking when matching brackets
vim.opt.matchtime = 0

-- Color the column
vim.opt.colorcolumn = tostring(text_width)

-- Colorschema
vim.cmd('colorscheme desert')

-- Termguicolors
vim.opt.termguicolors = true

--------------------------------------------------------------------------------
--                        Text, Tab, Indent, Backspace                        --
--------------------------------------------------------------------------------

-- Text width
vim.opt.textwidth = text_width

-- Don't automatically wrap on load.
vim.opt.wrap = false

-- Don't automatically wrap text when typing.
vim.opt.formatoptions:remove('t')

-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Tab width
vim.opt.tabstop = indent_width

-- Shift
vim.opt.shiftwidth = indent_width
vim.opt.shiftround = true

-- Smart indent
vim.opt.smartindent = true

--------------------------------------------------------------------------------
--                                   Search                                   --
--------------------------------------------------------------------------------

-- Ignore case when searching
vim.opt.ignorecase = true

-- When searching try to be smart about cases.
vim.opt.smartcase = true
