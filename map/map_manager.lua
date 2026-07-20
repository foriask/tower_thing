-- The map is mainly used to know how and where to put everything in place, that involves a lot of drawing and that sort of things
-- The following things are used for that (it will work fine with different sizes, please.)
--
require("objects.item_manager")

map_manager = {
	size = { 8, 8 },
	scale = { 8, 8 },
	tile_size = 64,
	margin = { 0, 0 },
}

function map_manager:init(_screen_size)
	self.scale[1] = _screen_size[1] / (self.tile_size * self.size[1])
	self.scale[2] = _screen_size[2] / (self.tile_size * self.size[2])
	if self.scale[2] > self.scale[1] then
		self.margin = (_screen_size[2] - _screen_size[1]) / 2
	else
		self.margin = (_screen_size[1] - _screen_size[2]) / 2
	end
end
