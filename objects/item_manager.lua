tree_manager = {
	item_groups = { bullets = {}, enemies = {}, towers = {} },
	base_size = 8,
	max_depth = 4,
	max_objects = 16,
}

function tree_manager:clean()
	local _new_item_stack = {}
	for _i, _group in pairs(self.item_groups) do
		local _new_items = {}
		for _i, _item in pairs(_group) do
			if _item ~= "clean" then
				table.insert(_new_items, _item)
			end
		end
		_new_item_stack[_i] = _new_items
	end
	return _new_item_stack
end
function tree_manager:index(_obj)
	local _x_adapted_coord = _obj.position[1] / (love.graphics.getPixelWidth() / self.base_size)
	local _y_adapted_coord = _obj.position[2] / (love.graphics.getPixelHeight() / self.base_size)
end
