vim.g.mapleader = ','
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Start lazy.nvim
require('lazy').setup({
    -- Packer (Not needed with lazy.nvim, just an example of a comment)
    -- use 'wbthomason/packer.nvim'
    
    -- Solarized colorscheme
    { 'shaunsingh/solarized.nvim' },
    
    -- Catpuccin colorschemes
    { "catppuccin/nvim", name = "catppuccin" },
    
    -- Discord Presence 
    { 'andweeb/presence.nvim' },
    
    -- File Explorer
    { 'nvim-tree/nvim-tree.lua', dependencies = 'nvim-tree/nvim-web-devicons' },

    -- CompetiTest for Competitive Programming
    {
        'xeluxee/competitest.nvim',
        dependencies = 'MunifTanjim/nui.nvim',
        config = function() require('competitest').setup() end
    },
    
    -- LSP
    { 'neovim/nvim-lspconfig' },
    
    -- Status bar
    {
        'nvim-lualine/lualine.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
    },
    
    -- Code completion and its dependencies
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'hrsh7th/cmp-vsnip' },
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    -- Fuzzy find and grep
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { {'nvim-lua/plenary.nvim'} }
    },
    
    -- Comments
    { 'tpope/vim-commentary' },
    {
        "nvim-neorg/neorg",
        lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
        version = "*", -- Pin Neorg to the latest stable release
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},
                    ["core.concealer"] = {},
                    ["core.dirman"] = {
                        config = {
                            workspaces = {
                                notes = "~/comp-prog",
                            },
                        },
                    },
                }
            }
	end,
    },
})

-- General editor settings
vim.opt.laststatus = 0
vim.opt.tabstop = 4
vim.opt.compatible = false
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.cinoptions:append("L0")
vim.cmd("syntax on")
vim.cmd("filetype indent on")
vim.cmd("filetype on")
vim.cmd("filetype plugin on")
vim.opt_local.indentkeys:remove(":")
vim.opt.belloff = "all"
vim.opt.clipboard:append("unnamedplus")
vim.o.conceallevel = 2

-- Colorscheme setups
vim.cmd.colorscheme "catppuccin-mocha"
-- require('solarized').set()

-- Keybindings for { completion, "jk" for escape, ctrl-a to select all
vim.api.nvim_set_keymap("i", "{<CR>", "{<CR>}<Esc>O", { noremap = true })
vim.api.nvim_set_keymap("i", "{}", "{}", { noremap = true })
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-a>", "<esc>ggVG<CR>", { noremap = true })

-- CompetiTest setup, with the compile flags and filenames
require('competitest').setup {
    compile_command = {
        cpp = {
            exec = "g++",
            args = {
                "-Wall",
                "-Wextra",
                "-Wshadow",
                "-Wconversion",
                "-Wfloat-equal",
                "-Wduplicated-cond",
                "-Wlogical-op",
                "-std=c++17",
                "$(FNAME)",
                "-o",
                "$(FNOEXT)",
            },
        },
    },

    testcases_use_single_file = true,
    template_file = { cpp = "~/comp-prog/snippets/template.cpp"},
    received_contests_problems_path = "$(JAVA_TASK_CLASS)/$(JAVA_TASK_CLASS).$(FEXT)",
    received_problems_path = "$(CWD)/$(JAVA_TASK_CLASS)/$(JAVA_TASK_CLASS).$(FEXT)",
}

-- Setup Discord Rich Presence
require("presence").setup({})

-- Set up the status bar
require('lualine').setup {
    options = {
        theme = 'ayu'
    }
}

-- File Explorer setup
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup({
    view = {
        width = 45
    },
})

-- Treesitter setup
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "cpp" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, -- For vsnip users.
    }, {
        { name = 'buffer' },
    })
})
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig').clangd.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    }
}

-- Keybinds for compiling, running, 
vim.api.nvim_command("set makeprg=g++\\ -Wall\\ -Wextra\\ -Wshadow\\ -Wconversion\\ -Wfloat-equal\\ -Wduplicated-cond\\ -Wlogical-op\\ -std=c++17\\ -o\\ '%:r'\\ '%'")
vim.api.nvim_set_keymap('n', '<leader>c', ':w <bar> make<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d', ':w <bar> make<CR>', { noremap = true, silent = true })
-- Map <Leader>d to compile and run with g++ with -fanalyze flag
vim.api.nvim_set_keymap('n', '<Leader>d', [[:w<bar>exec "!g++ -Wall -Wextra -Wshadow -Wconversion -Wfloat-equal -Wduplicated-cond -Wlogical-op -std=c++17 -o '%:r' '%' -fanalyzer"<CR>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>r', ":rightbelow vertical terminal ./'%:r'<CR>i", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>full', ":term ./'%:r'<CR>i", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>qr', ':CompetiTest receive problem<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>t', ':CompetiTest receive contest<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>add', ':CompetiTest add_testcase<CR>i', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>edit', ':CompetiTest edit_testcase<CR>i', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>del', ':CompetiTest delete_testcase<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>run', ':CompetiTest run<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>no', ':edit %:t:r.norg<CR>:w<CR>i', { noremap = true, silent = true })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', ':NvimTreeFocus<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':wqa<CR>', { noremap = true, silent = true })
