
local builtin = require("telescope.builtin")

local fontSize = 15;
local font = [["JetBrains Mono"]]

vim.cmd("set guifont=" .. font .. ":h" .. fontSize);

function changeFontSize(amount)
	fontSize = fontSize + amount;
	vim.cmd("silent set guifont=" .. font .. ":h" .. fontSize);
end

function fern_buffer_init()
	vim.cmd(
	[[
		nmap <buffer><expr>
			  \ <Plug>(fern-my-expand-or-collapse-or-enter)
			  \ fern#smart#leaf(
			  \   "\<Plug>(fern-action-open)",
			  \   "\<Plug>(fern-action-expand)",
			  \   "\<Plug>(fern-action-collapse)",
			  \ )

		nmap <buffer><nowait> <space> <Plug>(fern-my-expand-or-collapse-or-enter)
		nmap <buffer><nowait> <CR> <Plug>(fern-my-expand-or-collapse-or-enter)
		nmap <buffer><nowait> C <Plug>(fern-action-enter)



	]])
end

vim.cmd(
[[
	augroup fern_customizations
		autocmd!
		autocmd FileType fern lua fern_buffer_init()
	augroup END
]]
)

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<C-w>", ":bd!<CR>", {silent=true})
vim.keymap.set("n", "<C-n>", ":enew<CR>", {silent=true})
vim.keymap.set("n", "<C-Tab>", ":bnext<CR>", {silent=true})

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>b", builtin.buffers, {})
vim.keymap.set("n", "<A-Right>", "<C-w>w", {noremap = true, silent = true})
vim.keymap.set("n", "<A-Left>", "<C-w>W", {noremap = true, silent = true})

vim.keymap.set("n", "<S-Right>", ":bnext<CR>", {noremap = false, silent = true})
vim.keymap.set("n", "<S-Left>", ":bprevious<CR>", {noremap = false, silent = true})

vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>", {silent = true})
vim.keymap.set("t", "<C-e>", "<C-\\><C-n>", {noremap = true, silent = true})
vim.keymap.set("n", "<F5>", ":split<CR>:terminal<CR>arun.bat<CR><C-\\><C-n>", {silent = true})

vim.keymap.set("n", "tf", ":Fern . -drawer<CR>", {silent = true})

vim.keymap.set("n", "<A-CR>", vim.diagnostic.open_float, {silent=true})

vim.cmd([[command! Settings edit $MYVIMRC]])

vim.cmd(
[[
let s:baleia = luaeval("require('baleia').setup({})")
command! ANSI call s:baleia.once(bufnr('%'))
]]
)

vim.keymap.set("n", "<C-,>", function() changeFontSize(1) end, {silent = true})
vim.keymap.set("n", "<C-.>", function() changeFontSize(-1) end, {silent = true})

vim.keymap.set('n', "<C-S-Right>", ":vertical resize -1<CR>")
vim.keymap.set('n', "<C-S-Left>", ":vertical resize +1<CR>")
vim.keymap.set('n', "<C-S-Up>", ":resize -1<CR>")
vim.keymap.set('n', "<C-S-Down>", ":resize +1<CR>")
vim.keymap.set('n', "<leader>n", ":noh<CR>")


