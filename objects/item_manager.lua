tree_manager = {
	bullets = {},
	enemies = {},
	towers = {},
	matrix = {},
	base_size = 4,
}

function tree_manager:convert_to_matrix(_obj, _magic_size)
	-- Get a key number for the matrix, which is 1D, vs a 2.5D world lmao
	return (
		math.floor(_obj.position[1] / _magic_size[1]) + math.floor(_obj.position[2] / _magic_size[2] * self.base_size)
	)
end

function tree_manager:add_to_matrix(_matrix, _thing, _index)
	-- Yes, everything else is per-group. I don't mind doing that. I will do it. Duplicaited code, yes!
	if not _matrix[_index] then
		_matrix[_index] = {}
	end
	_matrix[_index][#_matrix[_index] + 1] = _thing
	return _matrix
end

function tree_manager:update_w_matrix(_everything)
	-- Fk. - fori

	local _magic_size = { love.graphics.getWidth() / self.base_size, love.graphics.getHeight() / self.base_size }
	local _new_items = {}
	_new_items.bullets = {}
	_new_items.enemies = {}
	_new_items.towers = {}
	_new_items.matrix = {}

	for _i, _obj in ipairs(self.bullets) do
		if _obj ~= "clean" then
			local _index = self:convert_to_matrix(_obj, _magic_size)
			local _thing = { _i, "bullets" }
			_obj.matrix_pos = _index
			_new_items.bullets[#_new_items.bullets + 1] = _obj
			_new_items.matrix = self:add_to_matrix(_new_items.matrix, _thing, _index)
		end
	end
	for _i, _obj in ipairs(self.enemies) do
		if _obj ~= "clean" then
			local _index = self:convert_to_matrix(_obj, _magic_size)
			local _thing = { _i, "enemies" }
			_obj.matrix_pos = _index
			_new_items.enemies[#_new_items.enemies + 1] = _obj
			_new_items.matrix = self:add_to_matrix(_new_items.matrix, _thing, _index)
		end
	end
	for _i, _obj in ipairs(self.towers) do
		if _obj ~= "clean" then
			local _index = self:convert_to_matrix(_obj, _magic_size)
			local _thing = { _i, "towers" }
			_obj.matrix_pos = _index
			_new_items.towers[#_new_items.towers + 1] = _obj
			_new_items.matrix = self:add_to_matrix(_new_items.matrix, _thing, _index)
		end
	end
	return _new_items
end

function tree_manager:internal_update(_new_table)
	-- I don't really like to mess wiht internal variables, often causes problems dificult to spot. Is not without drawbacks, anyways.
	for _group, _table in pairs(_new_table) do
		self[_group] = _table
	end
end

function tree_manager:index(_obj)
	local _magic_size =
		{ love.graphics.getWidth() / self.base_size, love.graphics.getHeight() / self.base_size / self.base_size }
	if _obj.type == "enemies" then
		local _index = self:convert_to_matrix(_obj, _magic_size)
		local _thing = { #self.enemies + 1, "bullet" }
		_obj.matrix_pos = _index
		self.enemies[#self.enemies + 1] = _obj
		self.matrix = self:add_to_matrix(self.matrix, _thing, _index)
		print(_obj.position[1] .. " <x y> " .. _obj.position[2])
		print(_index)
	elseif _obj.type == "towers" then
		local _index = self:convert_to_matrix(_obj, _magic_size)
		local _thing = { #self.towers + 1, "bullet" }
		_obj.matrix_pos = _index
		self.towers[#self.towers + 1] = _obj
		self.matrix = self:add_to_matrix(self.matrix, _thing, _index)
	else
		local _index = self:convert_to_matrix(_obj, _magic_size)
		local _thing = { #self.bullets + 1, "bullet" }
		_obj.matrix_pos = _index
		self.bullets[#self.bullets + 1] = _obj
		self.matrix = self:add_to_matrix(self.matrix, _thing, _index)
	end
end
