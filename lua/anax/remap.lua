
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

vim.api.nvim_create_user_command("Rp", function()
	local pw = vim.fn.inputsecret("gpg passphrase: ")
	if pw == "" then
		vim.notify("passphrase empty", vim.log.levels.WARN)
		return
	end
	vim.b.gpg_passphrase = pw
end, {})

vim.api.nvim_create_user_command("Rw", function(opts)
	if opts.args ~= "" then
		target = vim.fn.fnamemodify(opts.args, ":p")
		vim.cmd("file " .. vim.fn.fnameescape(target))
		vim.b.gpg_file = target
	else
		target = vim.api.nvim_buf_get_name(0)
		if target == "" then
			vim.notify("no usable filename", vim.log.levels.ERROR)
			vim.cmd("mode")
			return
		end
		vim.b.gpg_file = target
	end
	if not vim.b.gpg_passphrase then
		local pw = vim.fn.inputsecret("gpg passphrase: ")
		if pw == "" then
			vim.notify("passphrase empty, write aborted", vim.log.levels.WARN)
			vim.cmd("mode")
			return
		end
		vim.b.gpg_passphrase = pw
	end
	local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
	local cmd = string.format(
		'gpg --symmetric --armor --batch --passphrase-fd 0 > %s',
		vim.fn.shellescape(target)
	)

	local handle = io.popen(cmd, 'w')
	if not handle then
		vin.notify("gpg failed to start", vim.log.levels.ERROR)
		vim.cmd("mode")
		return
	end

	handle:write(vim.b.gpg_passphrase .. "\n")
	handle:write(text)
	if not handle:close()then
		vim.notify("closing handle produced error", vim.log.levels.ERROR)
		vim.cmd("mode")
		return
	end
	vim.cmd("mode")


end, {nargs="?"})

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
vim.keymap.set('n', "<C-c>", "<C-o>")
vim.keymap.set('n', "<C-v>", "<C-i>")
vim.keymap.set('n', "<leader>c", ":SymbolUnderCursorForward<CR>", {silent=true})
vim.keymap.set('n', "<leader>r", ":SymbolUnderCursorReverse<CR>", {silent=true})
vim.keymap.set('n', "<leader><S-c>", ":SymbolsForward<CR>", {silent=true})
vim.keymap.set('n', "<leader><S-r>", ":SymbolsReverse<CR>", {silent=true})


