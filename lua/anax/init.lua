vim.opt.number = true vim.opt.ignorecase = true vim.opt.smartcase = true
print(563)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false


vim.filetype.add({
	extension = {nts = "nts",},
	filename = {
		['.nts'] = {'nts', priority = math.huge},
	},
	pattern = {
		['.*/nts'] = 'nts',
	},
})

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
	{ 'RaafatTurki/hex.nvim' },
	{ "nvim-lualine/lualine.nvim", dependencies = { 'nvim-tree/nvim-web-devicons' }},
	{'romgrk/barbar.nvim',
		dependencies = {'lewis6991/gitsigns.nvim','nvim-tree/nvim-web-devicons'},
		init = function() vim.g.barbat_auto_setup = false end,
		opts = {
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			-- animation = true,
			-- insert_at_start = true,
			-- …etc.
		},
		version = '^1.0.0', -- optional: only update when a new 1.x version is released
	},
	{"nvim-orgmode/orgmode",
	event = "VeryLazy",
	ft = { 'org' },
	config = function()
		require('orgmode').setup({
			org_agenda_files = {"~/orgfiles/**/*"},
			org_default_notes_file = "~/orgfiles/refile.org",
		})
		require("nvim-treesitter.configs").setup({
			ignore_install = {"org"},
		})
	end,
	}
})


require('lualine').setup {
  options = {
	icons_enabled = true,
	theme = 'auto',
	component_separators = { left = '', right = ''},
	section_separators = { left = '', right = ''},
	disabled_filetypes = {
	  statusline = {},
	  winbar = {},
	},
	ignore_focus = {},
	always_divide_middle = true,
	always_show_tabline = true,
	globalstatus = false,
	refresh = {
	  statusline = 100,
	  tabline = 100,
	  winbar = 100,
	}
  },
  sections = {
	lualine_a = {'mode'},
	lualine_b = {'branch', 'diff', 'diagnostics'},
	lualine_c = {'filename'},
	lualine_x = {'encoding', 'fileformat', 'filetype'},
	lualine_y = {'progress'},
	lualine_z = {'location'}
  },
  inactive_sections = {
	lualine_a = {},
	lualine_b = {},
	lualine_c = {'filename'},
	lualine_x = {'location'},
	lualine_y = {},
	lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

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
	root_dir = require("lspconfig.util").root_pattern("*.hs", "*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml", ".git", "shell.nix")
});

lsp_zero.configure("metals", {
	cmd = {"metals", ".--lsp"},
	filetypes = {"scala", "sc"},
	root_dir = require("lspconfig.util").root_pattern(".git", "build.sbt", "metals.json", "shell.nix")
});

lsp_zero.configure("ocamllsp", {
	cmd = {"ocamllsp"},
	filetypes = {"ocaml", "ml"},
	root_dir = require("lspconfig.util").root_pattern(".git", "shell.nix")
});

vim.env.PATH = vim.env.HOME .. "/.opam/default/bin:" .. vim.env.PATH

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
	if vim.bo.filetype == "haskell" or vim.bo.filetype == "cabal" or vim.bo.filetype == "python"then
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

vim.api.nvim_create_autocmd({"FileType", "BufReadPost", "BufWinEnter"}, {
	pattern = "python",
	callback = setup_python_highlighting,
})

vim.api.nvim_create_user_command("PythonSH", function() setup_python_highlighting() end, {desc = "setup custom python syntax highlighting"})

vim.cmd(
[[
set list
set listchars=tab:>\ 
augroup SetExpandTab
	autocmd!
	autocmd FileType * lua setExpandtab()
augroup END

]])

vim.cmd [[
syntax include @python syntax/python.vim
syntax region pythonBlock start="@python" end="@end" contains=@python
]]

require('hex').setup()

vim.g.markdown_fenced_languages = {
	"python",
	"java",
	"haskell",
	"scala",
	"lua",
	"sql",
	"nts",
	"prolog",
	"c",
}

vim.lsp.handlers["window/logMessage"] = function() end
vim.lsp.handlers["window/showMessage"] = function() end

vim.cmd("TSEnable highlight")

require("anax.nts")
require("anax.remap")

