-- WARN: VIBE CODED
local M = {}

local function run(args, opts)
  local result = vim.system(args, opts or {}):wait()
  if result.code ~= 0 then
    local message = vim.trim(result.stderr or '')
    return nil, message ~= '' and message or ('command exited with code ' .. result.code)
  end
  return vim.trim(result.stdout or '')
end

local function project_root(file)
  return vim.fs.root(file, '.git') or vim.fn.getcwd()
end

local function pi_pane(root)
  local output, err = run {
    'tmux',
    'list-panes',
    '-s',
    '-F',
    '#{window_id}\t#{pane_id}\t#{pane_current_command}\t#{pane_current_path}',
  }
  if not output then
    return nil, err
  end

  root = vim.fs.normalize(root)
  for line in output:gmatch '[^\n]+' do
    local window, pane, command, path = line:match '^([^\t]+)\t([^\t]+)\t([^\t]+)\t(.*)$'
    if command == 'pi' and vim.fs.normalize(path) == root then
      return { window = window, pane = pane }
    end
  end
end

local function create_pi_pane(root)
  local output, err = run {
    'tmux',
    'split-window',
    '-h',
    '-d',
    '-P',
    '-F',
    '#{window_id}\t#{pane_id}',
    '-c',
    root,
    'pi',
  }
  if not output then
    output, err = run {
      'tmux',
      'split-window',
      '-v',
      '-d',
      '-P',
      '-F',
      '#{window_id}\t#{pane_id}',
      '-c',
      root,
      'pi',
    }
  end
  if not output then
    return nil, err
  end

  local window, pane = output:match '^([^\t]+)\t([^\t]+)$'
  if not pane then
    return nil, 'tmux did not return the new pane id'
  end

  -- Give Pi time to initialize its TUI and enable bracketed paste mode.
  vim.wait(2000, function()
    local command = run { 'tmux', 'display-message', '-p', '-t', pane, '#{pane_current_command}' }
    return command == 'pi'
  end, 50)
  vim.wait(300)

  return { window = window, pane = pane }
end

local function paste_prompt(pane, prompt)
  local buffer_name = ('nvim-pi-%d-%d'):format(vim.fn.getpid(), vim.uv.hrtime())
  local temp = vim.fn.tempname()
  local file, open_err = io.open(temp, 'wb')
  if not file then
    return nil, open_err
  end
  file:write(prompt)
  file:close()

  local _, load_err = run { 'tmux', 'load-buffer', '-b', buffer_name, temp }
  os.remove(temp)
  if load_err then
    return nil, load_err
  end

  local _, paste_err = run { 'tmux', 'paste-buffer', '-d', '-p', '-r', '-b', buffer_name, '-t', pane }
  if paste_err then
    return nil, paste_err
  end
  return true
end

local function code_fence(code)
  local longest = 0
  for ticks in code:gmatch '`+' do
    longest = math.max(longest, #ticks)
  end
  return string.rep('`', math.max(3, longest + 1))
end

function M.send_visual_selection()
  if not vim.env.TMUX then
    vim.notify('Pi selection requires Neovim to be running inside tmux', vim.log.levels.ERROR)
    return
  end

  local file = vim.api.nvim_buf_get_name(0)
  if file == '' then
    vim.notify('Save the buffer before sending it to Pi', vim.log.levels.WARN)
    return
  end

  local start_pos = vim.fn.getpos 'v'
  local end_pos = vim.fn.getpos '.'
  local start_line = math.min(start_pos[2], end_pos[2])
  local end_line = math.max(start_pos[2], end_pos[2])
  local selection = table.concat(vim.fn.getregion(start_pos, end_pos, { type = vim.fn.mode() }), '\n')
  local root = project_root(file)
  local relative_file = vim.fs.relpath(root, file) or file
  local location = start_line == end_line and ('line %d'):format(start_line)
      or ('lines %d-%d'):format(start_line, end_line)
  local fence = code_fence(selection)
  local language = vim.bo.filetype
  local prompt = ('Regarding `%s`, %s:\n\n%s%s\n%s\n%s\n\n'):format(
    relative_file,
    location,
    fence,
    language,
    selection,
    fence
  )

  local target, find_err = pi_pane(root)
  if not target then
    target, find_err = create_pi_pane(root)
  end
  if not target then
    vim.notify('Could not open Pi pane: ' .. (find_err or 'unknown error'), vim.log.levels.ERROR)
    return
  end

  local ok, paste_err = paste_prompt(target.pane, prompt)
  if not ok then
    vim.notify('Could not send selection to Pi: ' .. paste_err, vim.log.levels.ERROR)
    return
  end

  run { 'tmux', 'select-window', '-t', target.window }
  run { 'tmux', 'select-pane', '-t', target.pane }
end

return M
