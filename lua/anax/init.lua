
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
print(563)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false


local lazy = {}
function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  if vim.g.plugins_ready then
    return
  end

  -- You can "comment out" the line below after lazy.nvim is installed
  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)

  require('lazy').setup(plugins, lazy.opts)
  vim.g.plugins_ready = true
end


lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
	{'folke/tokyonight.nvim'},

	{'williamboman/mason.nvim'},
	{'williamboman/mason-lspconfig.nvim'},
	{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
	{'neovim/nvim-lspconfig'},
	{'L3MON4D3/LuaSnip'},

	{'hrsh7th/nvim-cmp'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/cmp-buffer'},
	{'hrsh7th/cmp-path'},
	{'hrsh7th/cmp-cmdline'},
	{'nvim-telescope/telescope.nvim', tag = '0.1.6', dependencies = {'nvim-lua/plenary.nvim'}},
	{'nvim-treesitter/nvim-treesitter'},
	{'akinsho/toggleterm.nvim', version = "*", config = true},
	{'lambdalisue/fern.vim'},
	{ "savq/melange-nvim" },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}},
	{ "m00qek/baleia.nvim", tag = 'v1.4.0' },
})

require("ibl").setup({
		indent = {char = "|"},
		whitespace = { highlight = { "Whitespace", "NonText" }},
});
require("toggleterm").setup{};

local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({buffer = bufnr})
end)

lsp_zero.configure("hls", {
	cmd = {"haskell-language-server-wrapper", "--lsp"},
	filetypes={"haskell", "lhaskell"},
	root_dir = require("lspconfig.util").root_pattern("*.hs", "*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml", ".git")
});

lsp_zero.setup()

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {"pyright", "jdtls"},
	handlers = {
		lsp_zero.default_setup,
	},
})


local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
	{name = 'buffer'},
  },
  mapping = {
    ['<C-y>'] = cmp.mapping.confirm({select = false}),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
    ['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
	['<Tab>'] = cmp.mapping.confirm({select = false}),
    ['<C-p>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({behavior = 'insert'})
      else
        cmp.complete()
      end
    end),
    ['<C-n>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item({behavior = 'insert'})
      else
        cmp.complete()
      end
    end),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  preselect = 'item',
  completion = {
	  completeopt = 'menu,menuone,noinsert'
  },

})


vim.opt.termguicolors = true
vim.cmd.colorscheme('melange')
vim.api.nvim_exec('language en_US.utf8', true)

function setExpandtab()
	if vim.bo.filetype == "haskell" or vim.bo.filetype == "cabal" then
		vim.o.expandtab = true
	else
		vim.o.expandtab = false
	end
end

local function setup_python_highlighting()
	vim.cmd("syntax enable")

    vim.cmd([[highlight PythonMember guifg=#744fc6]])
	vim.cmd([[syntax match pythonMember "\.\w\+" ]])
	vim.cmd([[highlight link pythonMember PythonMember]])

	vim.cmd([[highlight PythonSelf guifg=#379392]])
	vim.cmd([[syntax match pythonSelf /\<self\>/]])
	vim.cmd([[highlight link pythonSelf PythonSelf]])
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = setup_python_highlighting,
})


vim.cmd(
[[
set list
set listchars=tab:>\ 
augroup SetExpandTab
	autocmd!
	autocmd FileType * lua setExpandtab()
augroup END

]])

require("anax.remap")

