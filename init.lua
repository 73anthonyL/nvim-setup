-- Load Packer
vim.g.mapleader = ','
local packer = require('packer')
local use = packer.use

-- Start Packer
return packer.startup(function()
    -- Packer can manage itself as a plugin
    use 'wbthomason/packer.nvim'

    -- Add your other plugins here
    use 'shaunsingh/solarized.nvim'
    use { "catppuccin/nvim", as = "catppuccin" }

    use 'andweeb/presence.nvim'

    use {
        'xeluxee/competitest.nvim',
        requires = 'MunifTanjim/nui.nvim',
        config = function() require('competitest').setup() end
    }

    use 'neovim/nvim-lspconfig'

    -- Add more plugins as needed
    -- Example configuration for a plugin
    -- You can configure plugins here using the `config` option
    -- Example:
    -- use {
    --   'author/plugin-name',
    --   config = function()
    --     -- Configuration for the plugin
    --   end
    -- }

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
	vim.cmd("filetype off")
	vim.opt_local.indentkeys:remove(":")
	vim.opt.belloff = "all"
	vim.opt.clipboard:append("unnamedplus")
    vim.cmd.colorscheme "catppuccin-mocha"

	-- Keybindings for { completion, "jk" for escape, ctrl-a to select all
	vim.api.nvim_set_keymap("i", "{<CR>", "{<CR>}<Esc>O", { noremap = true })
	vim.api.nvim_set_keymap("i", "{}", "{}", { noremap = true })
	vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<C-a>", "<esc>ggVG<CR>", { noremap = true })

	-- Plugin-specific configuration
	--require('solarized').set()
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

    require("presence").setup({})
    require('lspconfig').clangd.setup {
        on_attach = on_attach,
        flags = {
            debounce_text_changes = 150,
        }
    }

    vim.api.nvim_set_keymap('n', '<leader>s', ':LspStart clangd<CR>', {noremap = true, silent = true})
    vim.api.nvim_command("set makeprg=g++\\ -Wall\\ -Wextra\\ -Wshadow\\ -Wconversion\\ -Wfloat-equal\\ -Wduplicated-cond\\ -Wlogical-op\\ -std=c++17\\ -o\\ '%:r'\\ '%'")
	vim.api.nvim_set_keymap('n', '<leader>c', ':w <bar> make<CR>', { noremap = true, silent = true })
--	vim.api.nvim_set_keymap('n', '<leader>r', ':rightbelow vertical terminal ./%:r<CR>i', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<leader>r', ":rightbelow vertical terminal ./'%:r'<CR>i", { noremap = true, silent = true })


--  vim.api.nvim_set_keymap('n', '<leader>full', ':term ./%:r<CR>i', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>full', ":term ./'%:r'<CR>i", { noremap = true, silent = true })

	vim.api.nvim_set_keymap('n', '<leader>prob', ':CompetiTest receive problem<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<leader>cont', ':CompetiTest receive contest<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<leader>add', ':CompetiTest add_testcase<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<leader>edit', ':CompetiTest edit_testcase<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<leader>del', ':CompetiTest delete_testcase<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<leader>run', ':CompetiTest run<CR>', { noremap = true, silent = true })
end)
