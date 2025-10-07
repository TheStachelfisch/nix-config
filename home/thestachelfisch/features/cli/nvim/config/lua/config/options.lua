vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.o

opt.autowrite = true
opt.autoindent = true
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Enable clipboard. Only enable if not SSH session
opt.relativenumber = true -- Show relative line numbers
opt.termguicolors = true
opt.list = true -- Show some invisible characters
opt.confirm = true
opt.cursorline = true
opt.splitright = true
opt.signcolumn = "yes"

opt.tabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.expandtab = true -- Use spaces instaed of tabs
opt.wrap = false
opt.scrolloff = 3
opt.autoread = true
opt.fixeol = true

opt.undofile = true
opt.undolevels = 5000

opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldmethod = "expr"
opt.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
opt.foldlevelstart = 99

-- Keybinds
-- Disable arrow keys in insert mode
vim.keymap.set("i", "<left>", "<nop>")
vim.keymap.set("i", "<right>", "<nop>")
vim.keymap.set("i", "<up>", "<nop>")
vim.keymap.set("i", "<down>", "<nop>")

-- Custom Niceties
-- vim.api.nvim_create_autocmd('BufReadPost', {
--   desc = "Open file at previous edited position",
--   command = 'silent! normal! g`"zz';
-- })

-- Open help view in vsplit
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        vim.cmd("wincmd L")
        vim.api.nvim_set_option_value("cursorcolumn", false, { scope = "local" })
        vim.api.nvim_set_option_value("cursorline", false, { scope = "local" })
    end,
})
