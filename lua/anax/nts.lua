local forward = {
["\\inf"] = "∞",
["\\fr"] = "∀",
["\\ex"] = "∃",
["\\leq"] = "≤",
["\\geq"] = "≥",
["\\land"] = "∧",
["\\lor"] = "∨",
["\\alpha"] = "α",
["\\beta"] = "β",
["\\gamma"] = "γ",
["\\delta"] = "δ",
["\\Delta"] = "Δ",
["\\lambda"] = "λ",
["\\Omega"] = "Ω",
["\\pi"] = "π",
["\\Pi"] = "Π",
["\\theta"] = "θ",
["\\Theta"] = "Θ",
["\\sigma"] = "σ",
["\\Sigma"] = "Σ",
["\\phi"] = "φ",
["\\sum"] = "∑",
["\\neg"] = "¬",
["\\nullset"] = "Ø",
["\\therefore"] = "∴",
["\\in"] = "∈",
["\\notin"] = "∉",
["\\subset"] = "⊆",
["\\cup"] = "∪",
["\\cap"] = "∩",
["\\prod"] = "×",
["\\impl"] = "⇒",
["\\ism"] = "≃",
["\\tbar"] = "≡",
["\\rarrow"] = "→",
}
local reverse = {}
for k, v in pairs(forward) do reverse[v] =  k end

-- Convert word under cursor to unicode
local function convert_word_to_unicode()
  local word = vim.fn.expand("<cWORD>")
  local unicode = forward[word]
  
  if unicode then
    vim.cmd("normal! ciW" .. unicode)
  else
    print("No unicode mapping for: " .. word)
  end
end

-- Convert unicode character under cursor back to keyword
local function convert_unicode_to_word()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  
  -- Get character at cursor (handling multi-byte UTF-8)
  local char_start = col
  while char_start > 0 and vim.fn.strcharpart(line:sub(char_start, char_start), 0, 1) == "" do
    char_start = char_start - 1
  end
  
  local char = vim.fn.strcharpart(line:sub(char_start + 1), 0, 1)
  local keyword = reverse[char]
  
  if keyword then
    local char_len = #char
    vim.api.nvim_buf_set_text(0, vim.fn.line(".") - 1, col, vim.fn.line(".") - 1, col + char_len, {keyword})
  else
    print("No keyword mapping for: " .. char)
  end
end

-- Convert all keywords in buffer to unicode
local function convert_buffer_to_unicode()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local count = 0
  
  for i, line in ipairs(lines) do
    local new_line = line
    for keyword, unicode in pairs(forward) do
      -- Escape special pattern characters
      local escaped_keyword = keyword:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
      local before_count = #new_line
      new_line = new_line:gsub(escaped_keyword, unicode)
      local after_count = #new_line
      -- Count replacements by checking if the line changed
      if before_count ~= after_count or line ~= new_line then
        count = count + 1
      end
    end
    lines[i] = new_line
  end
  
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  print("Converted " .. count .. " keywords to unicode")
end


-- Convert all unicode characters in buffer back to keywords
local function convert_buffer_to_keywords()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local count = 0
  
  for i, line in ipairs(lines) do
    local new_line = line
    for unicode, keyword in pairs(reverse) do
      local replacements = select(2, new_line:gsub(unicode, keyword))
      count = count + replacements
      new_line = new_line:gsub(unicode, keyword)
    end
    lines[i] = new_line
  end
  
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  print("Converted " .. count .. " unicode characters to keywords")
end
-- Expose user commands (buffer-local)



vim.api.nvim_create_user_command("SymbolUnderCursorForward", convert_word_to_unicode, {})
vim.api.nvim_create_user_command("SymbolUnderCursorReverse", convert_unicode_to_word, {})
vim.api.nvim_create_user_command("SymbolsForward", convert_buffer_to_unicode, {})
vim.api.nvim_create_user_command("SymbolsReverse", convert_buffer_to_keywords, {})

-- vim.api.nvim_create_user_command("SymbolsForward", replace_all_forward, { range = false, bang = false })
-- vim.api.nvim_create_user_command("SymbolsReverse", replace_all_reverse, { range = false, bang = false })
-- vim.api.nvim_create_user_command("SymbolUnderCursorForward", replace_word_forward, { range = false, bang = false })
-- vim.api.nvim_create_user_command("SymbolUnderCursorReverse", replace_word_reverse, { range = false, bang = false })


