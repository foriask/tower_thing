love.graphics.setDefaultFilter("nearest")
animation_manager = {}

animation_manager = {
	bullet_spr = love.graphics.newImage("assets/bullet_spritesheet.png"),
	enemie_spr = love.graphics.newImage("assets/enemie_spritesheet.png"),
	tower_spr = love.graphics.newImage("assets/tower_spritesheet.png"),
}

function animation_manager:initialize(sheet, frameWidth, frameHeight)
	for _key, _sprite in pairs(self) do
		if type(_sprite) ~= "function" and type(_sprite) == "userdata" then
			local success, sprite_type = pcall(function()
				return _sprite:type()
			end)
			if success and sprite_type == "Image" then
				_key = _key .. "_data"
				self[_key] = {
					hor_n = _sprite:getWidth() / 64,
					ver_n = _sprite:getHeight() / 64,
					_sprite:getWidth(),
					_sprite:getHeight(),
					love.graphics.newSpriteBatch(_sprite),
				}
				local _quads = {}
				-- Initialize quads
				for y = 0, self[_key].ver_n do
					for x = 0, self[_key].hor_n do
						_quads[#_quads + 1] =
							love.graphics.newQuad(x, y, self[_key][1], self[_key][2], _sprite:getDimensions())
					end
				end

				-- Assign quads to the sprite batch
				self[_key][4] = _quads
				self[_key][5] = { unpack(pairs(#_quads)) }
			end
		end
	end
end

function animation_manager:update_pos(_type, _pos, _number)
	return _number
end

function animation_manager:update_frame() end

function animation_manager:draw_basics()
	-- Basics -> No shaders things, basically, the default stuff
	-- Enemies, bullets, towers, by default, go here
	for _key, _batch in pairs(self) do
		if type(_batch) == "table" then
			love.graphics.draw(_batch[3])
		end
	end
end
