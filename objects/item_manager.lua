tree_manager = {
	bullets = {},
	enemies = {},
	towers = {},
	god = {}, -- This is because it doesn't really exists in the world, just in your imagination
	matrix = {},
	base_size = 8,
	magic_size_x = 0,
	magic_size_y = 0,
}

function tree_manager:update_sizes()
	self.magic_size_x, self.magic_size_y =
		love.graphics.getWidth() / self.base_size, love.graphics.getHeight() / self.base_size
end

function tree_manager:index(_obj)
	local _a = _obj.position[1] / self.magic_size_x
	_a = _a - _a % 1
	local _b_n = (_obj.position[2] / self.magic_size_y)
	_b_n = _b_n - _b_n % 1
	local _index = _a + _b_n * self.base_size
	_obj.matrix_pos = _index
	-- ?? Check in the matrix if everything exists
	if not self.matrix[_obj.type] then
		self.matrix[_obj.type] = {}
	end
	if not self.matrix[_obj.type][_index] then
		self.matrix[_obj.type][_index] = {}
	end
	self.matrix[_obj.type][_index][#self.matrix[_obj.type][_index] + 1] = _i
	self[_obj.type][#self[_obj.type] + 1] = _obj
end

function tree_manager:update_w_matrix()
	-- Fk. - fori
	local _new_matrix = {}
	for _g_name, _group in pairs(self) do
		if type(_group) == "table" then
			local _new_items = {}
			local _ri = 1
			for _i, _obj in ipairs(_group) do
				if _obj ~= "clean" and type(_obj) == "table" and _obj.type then
					-- I don't know for sure, but I guess this is how it detects the objects (is it?)
					-- Get a key number for the matrix, which is 1D, vs a 3D world lmao
					local _a = _obj.position[1] / self.magic_size_x
					_a = _a - _a % 1
					local _b_n = (_obj.position[2] / self.magic_size_y)
					_b_n = _b_n - _b_n % 1
					local _index = _a + _b_n * self.base_size
					_obj.matrix_pos = _index
					-- ?? Check in the matrix if everything exists
					if not _new_matrix[_obj.type] then
						_new_matrix[_obj.type] = {}
					end
					if not _new_matrix[_obj.type][_index] then
						_new_matrix[_obj.type][_index] = {}
					end
					_new_matrix[_obj.type][_index][#_new_matrix[_obj.type][_index] + 1] = _i
					_new_items[_ri] = _obj
					_ri = _ri + 1
				end
			end
			self[_g_name] = _new_items
		end
	end
	self["matrix"] = _new_matrix
end
