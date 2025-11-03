return function(Terminal)
  local term = Terminal:new({
    direction = 'vertical',
    close_on_exit = true,
    hidden = true,
  })

  local toggle = function()
    if term:is_open() and not term:is_focused() then
      term:focus()
    else
      term:toggle()
    end
  end

  return { toggle = toggle }
end