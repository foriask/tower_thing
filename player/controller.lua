controller = {}
controller.keymap = {}
controller.functions = {}

controller.is_checking = false
controller.function_picked = ""
controller.key_picked = {}
controller.multiple_keys = false
controller.key_timer = 0

function controller:loadmap()
	if not love.filesystem.getInfo("controls.lua") then
		self.keymap = dofile("player/defaults.lua")
	else
		local _keys_path = love.filesystem.read("controls.lua")
		local _keys = loadstring(_keys_path)
		if _keys then
			self.keymap = _keys()
		end
	end
	self.functions = dofile("player/functions.lua")
end

function controller:check_keys(_x, _y, _key, _time) -- This is used both for keyboard and mouse (maybe even controller)
	if self.is_checking then
		if self.key_timer == 0 then
			-- Inizialize, picking the first character whatever it is
			self.key_timer = _time
			if _y then
				self.key_picked[#self.key_picked + 1] = "mouse"
			end
			self.key_picked[#self.key_picked + 1] = _key
		elseif (_time - self.key_timer) < 0.2 then
			-- After that, the following operation
			if _y then
				self.key_picked[#self.key_picked + 1] = "mouse"
			end
			local _ignore_rep = true
			for _i, _keyn in ipairs(self.key_picked) do
				if _keyn == _key and _keyn ~= "mouse" or (self.key_picked[_i + 1] == _key) then
					_ignore_rep = false
				end
			end
			-- This ignore keys alredy in the chart
			if _ignore_rep then
				self.key_picked[#self.key_picked + 1] = _key
			end
		else
			self.key_timer = 0
			self.is_checking = false
		end

		self:save()
		return
	end
	if _key == "lshift" and love.keyboard.isDown("f1") then
		self.keymap = dofile("player/defaults.lua")
	end
end

function controller:save_controls(_function, _mlt_keys)
	self.multiple_keys = _mlt_keys or false
	self.function_picked = _function
	self.is_checking = true
end

function controller:save()
	if not self.is_checking and #self.key_picked then
		if self.multiple_keys then
			if type(control_map[self.function_picked][1]) ~= "table" then
				control_map[self.function_picked] = { control_map[self.function_picked][1] } -- Just double it bcs it can be multiple controls ^^
			end
			self.keymap[self.function_picked][self.multiple_keys] = self.key_picked
		end
		self.keymap[self.function_picked] = self.key_picked

		-- Save into a file ^^
		local _string = "local table = {"
		for _function, _key in pairs(self.keymap) do
			_string = _string .. _function .. " = {"
			if type(_key[1]) == "table" then
				_string = _string .. "{"
				for _i, _key2 in ipairs(_key) do
					for _a, _thing in ipairs(_key2) do
						if type(_thing) == "string" then
							_string = _string .. '"' .. _thing .. '",'
						else
							_string = _string .. _key .. ","
						end
					end
					_string = _string .. "}"
				end
			else
				for _a, _thing in ipairs(_key) do
					if type(_thing) == "string" then
						_string = _string .. '"' .. _thing .. '",'
					else
						_string = _string .. _thing .. ","
					end
				end
			end
			_string = _string .. "},"
		end
		_string = _string .. "}\nreturn table"
		-- what the hell was that? Idk
		-- It works though

		-- RESET to stop iterating.
		self.multiple_keys = false
		self.key_picked = {}
		self.function_picked = ""
	end
end

function controller:void_control(_keys)
	local _buttons, _pressed = 0, 0
	local _i = 1
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
		-- Do you spect me to know what the hell is that? Just trust me!
		-- So, to make a control a "mouse" binding, all is needed is to add "mouse" before. The program will do it, truste me
		--
	end

	return _pressed == _buttons, _buttons
end

function controller:control(_time)
	if not self.keymap then
		return
	end
	local _pressed = { false, 0 }
	for _function, _keys in pairs(self.keymap) do
		if type(_keys[1]) == "table" then
			for _i, _keys2 in ipairs(_keys) do
				local _yes = self:void_control(_keys2)
				_pressed = _pressed or _yes
			end
		else
			local _is_pressed, _buttons = self:void_control(_keys)
			if _is_pressed and _buttons > _pressed[2] then
				_pressed = { true, _buttons, _function }
			end
		end
	end
	if _pressed[1] then
		self.functions[_pressed[3]](self, love.mouse:getX(), love.mouse:getY())
	end
end

return controller
