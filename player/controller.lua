require("player.functions")
require("player.settings")

controller = {}
controller.keymap = {}
controller.is_checking = false
controller.key_picked = {}
controller.key_timer = 0
function controller:remap()
	local _keymap = dofile("player/settings.lua")
	return _keymap
end

function controller:check_keys(_x, _y, _key, _time) -- This is used both for keyboard and mouse (maybe even controller)
	if self.is_checking then
		if self.key_timer == 0 then
			self.key_timer = _time
			if _y then
				self.key_picked[#self.key_picked + 1] = "mouse"
			end
			self.key_picked[#self.key_picked + 1] = _y and (_key .. "mb") or _key
		elseif (_time - self.key_timer) < 0.2 then
			if _y then
				self.key_picked[#self.key_picked + 1] = "mouse"
			end
			self.key_picked[#self.key_picked + 1] = _key
		else
			print(table.concat(self.key_picked))
			self.key_timer = 0
			self.is_checking = false
		end
		return
	end
end

function controller:save_settings(_function_name)
	if self.is_checking or not #self.key_picked then
		return
	end
	control_map[_function_name] = self.key_picked
	self.key_picked = {}
	self:remap()
end

function controller:control(_time)
	if not self.keymap then
		return
	end
	for _function, _keys in pairs(self.keymap) do
		local _i = 1
		local _pressed = 0
		local _buttons = 0

		while _i <= #_keys do
			if _keys[_i] == "mouse" then
				_pressed = _pressed + (love.mouse.isDown(_keys[_i + 1]) and 1 or 0)
				_buttons = _buttons + 1
				_i = _i + 2
			else
				_pressed = _pressed + (love.keyboard.isDown(_keys[_i]) and 1 or 0)
				_buttons = _buttons + 1
				_i = _i + 1
			end
		end
		if _buttons == _pressed then
			print(_buttons .. " " .. _pressed)
			functions[_function](love.mouse:getX(), love.mouse:getY())
		end
	end
end

controller.keymap = controller:remap()
return controller
