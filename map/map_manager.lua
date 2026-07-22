-- The map is mainly used to know how and where to put everything in place, that involves a lot of drawing and that sort of things
-- The following things are used for that (it will work fine with different sizes, please.)
--
require("objects.item_manager")

map_manager = {
	size = { 8, 8 },
	scale = { 8, 8 },
	tile_size = 70,
	margin = { 0, 0 },
}

function map_manager:init()
	local _screen_size = { love.graphics.getWidth(), love.graphics.getHeight() }

	self.scale[1] = _screen_size[1] / self.tile_size
	self.scale[2] = _screen_size[2] / self.tile_size

	if self.scale[2] > self.scale[1] then
		self.scale[2] = self.scale[2] - self.scale[2] % 1
		self.scale[1] = self.scale[2]
	else
		self.scale[1] = self.scale[1] - self.scale[1] % 1
		self.scale[2] = self.scale[1]
	end
end

function map_manager:draw(_time)
	local _screen_size = { love.graphics.getWidth(), love.graphics.getHeight() }
	love.graphics.rectangle(
		"line",
		self.margin[1],
		self.margin[2],
		_screen_size[1] - self.margin[1],
		_screen_size[2] - self.margin[2],
		10
	)
end
