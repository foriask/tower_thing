tree_manager = {
	bullets = {},
	enemies = {},
	towers = {},
	matrix = {},
	base_size = 32,
	base_mult = math.exp(32),
}

function tree_manager:convert_to_matrix(_obj, _screen_size)
	return (
		math.ceil(_obj.position[1] / (_screen_size[1] / self.base_size))
		+ math.ceil(_obj.position[2] / (_screen_size[2] / self.base_size) * self.base_mult)
	)
end

function tree_manager:update_w_matrix(_bullets, _enemies, _towers, _everything)
	local _screen_size = { love.graphics.getWidth(), love.graphics.getHeight() }
	local _new_items = self
	_new_items.bullets = {}
	_new_items.enemies = {}
	_new_items.towers = {}
	_new_items.matrix = {}

	for _i, _obj in ipairs(self.bullets) do
		if _obj ~= "clean" then
			local _index = self:convert_to_matrix(_obj, _screen_size)
			local _thing = { _i, "bullet" }
			_obj.matrix_pos = _index
			table.insert(_new_items.bullets, _obj)
			table.insert(_new_items.matrix, _thing, _index)
		end
	end
	for _i, _obj in ipairs(self.enemies) do
		if _obj ~= "clean" then
			local _index = self:convert_to_matrix(_obj, _screen_size)
			local _thing = { _i, "enemie" }
			_obj.matrix_pos = _index
			table.insert(_new_items.enemies, _obj)
			table.insert(_new_items.matrix, _thing, _index)
		end
	end
	for _i, _obj in ipairs(self.towers) do
		if _obj ~= "clean" then
			local _index = self:convert_to_matrix(_obj, _screen_size)
			local _thing = { _i, "towers" }
			_obj.matrix_pos = _index
			_new_items.towers[#_new_items.towers + 1] = _obj
			_new_items.matrix[_index] = _thing
		end
	end
	return _new_items
end

function tree_manager:index(_obj, _group)
	local _screen_size = { love.graphics.getWidth(), love.graphics.getHeight() }
	if _group then
		if _group == "enemies" then
			local _index = self:convert_to_matrix(_obj, _screen_size)
			local _thing = { #self.enemies + 1, "bullet" }
			_obj.matrix_pos = _index
			self.enemies[#self.enemies + 1] = _obj
			self.matrix[_index] = _thing
		elseif _group == "towers" then
			local _index = self:convert_to_matrix(_obj, _screen_size)
			local _thing = { #self.towers + 1, "bullet" }
			_obj.matrix_pos = _index
			self.towers[#self.towers + 1] = _obj
			self.matrix[_index] = _thing
		else
			local _index = self:convert_to_matrix(_obj, _screen_size)
			local _thing = { #self.bullets + 1, "bullet" }
			_obj.matrix_pos = _index
			self.bullets[#self.bullets + 1] = _obj
			self.matrix[_index] = _thing
		end
	end
end
