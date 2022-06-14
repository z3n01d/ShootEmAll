local state = {}

state.__index = state

function state.new(s)
  local self = {}

  setmetatable(self, state)

  self.state = s

  return self
end

function state:set_state(s)
  self.state = s
end

function state:get_state(s)
  if self.state == s then
    return true
  end

  return false
end

return state
