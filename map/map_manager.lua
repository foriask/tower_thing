-- The map is mainly used to know how and where to put everything in place, that involves a lot of drawing and that sort of things
love.graphics.setDefaultFilter("nearest")
-- The following things are used for that (it will work fine with different sizes, please.)
--
require("objects.item_manager")

map_manager = {
	grid_size = { 8, 8 }, -- the number of tiles per axis, first horitzontal then vertical
	total_size = { 0, 0 }, -- The size in pixels of the whole grid, first horizontal then vertical
	scale = 1, -- scale of each tile
	tile_size = 64, -- size in pixels of each tile
	margin = { 0, 0 }, -- magin from every size, first horizontal then vertical
	grid = {},
	tile_image = love.graphics.newImage("assets/example.png"),
}

function map_manager:optimized_calc()
	local _screen_size = { love.graphics.getWidth(), love.graphics.getHeight() }

	self.total_size[1] = (self.tile_size * self.grid_size[2])
	self.total_size[2] = (self.tile_size * self.grid_size[2])
	-- First, set total_size to the default value via operations

	local _scale = {}
	_scale[1] = _screen_size[1] / self.total_size[1]
	_scale[2] = _screen_size[2] / self.total_size[2]
	-- After that, get the possibl scale values

	if _scale[1] < _scale[2] then
		_scale[3] = _scale[1] - _scale[1] % 1
	else
		_scale[3] = _scale[2] - _scale[2] % 1
	end

	-- Use the smallest to scale total_size
	self.scale = _scale[3]
	self.total_size[1] = self.total_size[1] * _scale[3]
	self.total_size[2] = self.total_size[2] * _scale[3]

	-- Get the magin, and store it. I would preffer to store 256 bytes than operate every frame
	self.margin[1] = (_screen_size[1] - self.total_size[1]) / 2
	self.margin[2] = (_screen_size[2] - self.total_size[2]) / 2
end

function map_manager:create_grid()
	local _grid = {}
	for _x = 1, self.grid_size[1] do
		_grid[_x] = {}
		for _y = 1, self.grid_size[2] do
			_grid[_x][_y] = nil -- or some initial value you want
		end
	end
	self.grid = _grid
end

function map_manager:change_tile_color(screen_x, screen_y, r, g, b)
	local _screen_size = { love.graphics.getWidth(), love.graphics.getHeight() }

	local grid_x = (screen_x - self.margin[1]) / (self.tile_size * self.scale)
	local grid_y = (screen_y - self.margin[2]) / (self.tile_size * self.scale)

	if grid_x >= 0 and grid_x <= self.grid_size[1] and grid_y >= 0 and grid_y <= self.grid_size[2] then
		local x = math.floor(grid_x) + 1
		local y = math.floor(grid_y) + 1
		self.grid[x][y] = { r = r, g = g, b = b }
	end
end

function map_manager:draw_grid(time)
	love.graphics.push()
	love.graphics.translate(self.margin[1], self.margin[2])
	love.graphics.scale(self.scale)
	-- Oh, that is possible? wow... cool

	for _x = 1, self.grid_size[1] do
		for _y = 1, self.grid_size[2] do
			-- Drawing of each tile here
			-- I dont feel ok using so much every frame... but it will be fine
			local tile_color = self.grid[_x][_y]
			if tile_color then
				love.graphics.setColor(tile_color.r, tile_color.g, tile_color.b)
			else
				love.graphics.setColor(255, 255, 255) -- Default color if no specific color is set
			end

			love.graphics.draw(self.tile_image, (_x - 0.5) * self.tile_size, (_y - 0.5) * self.tile_size, 0, 1, 1)

			--[[ love.graphics.rectangle(
				"fill",
				(_x - 1) * self.tile_size,
				(_y - 1) * self.tile_size,
				self.tile_size,
				self.tile_size
			) ]]
		end
	end

	love.graphics.pop()
end
