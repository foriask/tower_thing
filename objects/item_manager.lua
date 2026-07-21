tree_manager = {
	bullets = {},
	enemies = {},
	towers = {},
	god = {}, -- This is because it doesn't really exists in the world, just in your imagination
	matrix = {},
	base_size = 6,
	magic_size = { 0, 0 },
}

function tree_manager:update_sizes()
	return { love.graphics.getWidth() / self.base_size, love.graphics.getHeight() / self.base_size }
end

function tree_manager:convert_to_matrix(_obj)
	-- Get a key number for the matrix, which is 1D, vs a 3D world lmao
	local _a = _obj.position[1] / self.magic_size[1]
	local _b = (_obj.position[2] / self.magic_size[2]) * self.base_size
	return (_a - _a % 1) + (_b - _b % 1)
end

function tree_manager:add_to_matrix(_matrix, _thing, _index)
	-- Yes, everything else is per-group. I don't mind doing that. I will do it. Duplicaited code, yes!
	if not _matrix[_index] then
		_matrix[_index] = {}
	end
	_matrix[_index][#_matrix[_index] + 1] = _thing
	return _matrix
end

function tree_manager:update_w_matrix()
	-- Fk. - fori
	local _new_items = {}
	_new_items.bullets = {}
	_new_items.enemies = {}
	_new_items.towers = {}
	_new_items.matrix = {}
	for _o, _group in pairs(self) do
		if type(_group) == "table" then
			for _i, _obj in ipairs(_group) do
				if _obj ~= "clean" and type(_obj) == "table" and _obj.type then
					-- I don't know for sure, but I guess this is how it detects the objects (is it?)
					local _index = self:convert_to_matrix(_obj)
					local _thing = { _i, _obj.type }
					_obj.matrix_pos = _index
					_new_items[_obj.type][#_new_items[_obj.type] + 1] = _obj
					_new_items.matrix = self:add_to_matrix(_new_items.matrix, _thing, _index)
				end
			end
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
	if _obj.type then
		local _index = self:convert_to_matrix(_obj)
		local _thing = { #self[_obj.type], _obj.type }
		_obj.matrix_pos = _index
		self[_obj.type][#self[_obj.type] + 1] = _obj
		self.matrix = self:add_to_matrix(self.matrix, _thing, _index)
	else
		self.god[#self.god + 1] = _obj
	end
end
