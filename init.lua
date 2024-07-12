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
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'

    use 'hrsh7th/cmp-vsnip'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.8',
    -- or                            , branch = '0.1.x'
      requires = { {'nvim-lua/plenary.nvim'} }
    }

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
    --vim.cmd.colorscheme "solarized"
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
    require'nvim-treesitter.configs'.setup {
      -- A list of parser names, or "all" (the listed parsers MUST always be installed)
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "cpp" },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,

      -- List of parsers to ignore installing (or "all")
      --ignore_install = { "javascript" },

      ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
      -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

      highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        --disable = { "c", "rust" },
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        --disable = function(lang, buf)
            --local max_filesize = 100 * 1024 -- 100 KB
            --local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            --if ok and stats and stats.size > max_filesize then
                --return true
            --end
        --end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
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
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
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
          -- { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          { name = 'buffer' },
        })
    })

    -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
    -- Set configuration for specific filetype.
    --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
    })
    require("cmp_git").setup() ]]-- 

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

    vim.api.nvim_command("set makeprg=g++\\ -Wall\\ -Wextra\\ -Wshadow\\ -Wconversion\\ -Wfloat-equal\\ -Wduplicated-cond\\ -Wlogical-op\\ -std=c++17\\ -o\\ '%:r'\\ '%'")
	vim.api.nvim_set_keymap('n', '<leader>c', ':w <bar> make<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<leader>d', ':w <bar> make<CR>', { noremap = true, silent = true })
-- Map <Leader>d to compile and run with g++ with -fanalyze flag
    vim.api.nvim_set_keymap('n', '<Leader>d', [[:w<bar>exec "!g++ -Wall -Wextra -Wshadow -Wconversion -Wfloat-equal -Wduplicated-cond -Wlogical-op -std=c++17 -o '%:r' '%' -fanalyzer"<CR>]], { noremap = true, silent = true })

	vim.api.nvim_set_keymap('n', '<leader>r', ":rightbelow vertical terminal ./'%:r'<CR>i", { noremap = true, silent = true })


--  vim.api.nvim_set_keymap('n', '<leader>full', ':term ./%:r<CR>i', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>full', ":term ./'%:r'<CR>i", { noremap = true, silent = true })

	vim.api.nvim_set_keymap('n', '<leader>r', ':CompetiTest receive problem<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<leader>t', ':CompetiTest receive contest<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<leader>add', ':CompetiTest add_testcase<CR>i', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<leader>edit', ':CompetiTest edit_testcase<CR>i', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<leader>del', ':CompetiTest delete_testcase<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<leader>run', ':CompetiTest run<CR>', { noremap = true, silent = true })
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    --vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    --vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
end)
