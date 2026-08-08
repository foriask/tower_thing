love.graphics.setDefaultFilter("nearest")
animation_manager = {}

animation_manager = {
	bullets_spr = love.graphics.newImage("assets/bullet_spritesheet.png"),
	enemies_spr = love.graphics.newImage("assets/enemie_spritesheet.png"),
	towers_spr = love.graphics.newImage("assets/tower_spritesheet.png"),
}

function animation_manager:initialize()
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
					free = {},
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

function animation_manager:update_pos(_type, _pack)
	for _i, _obj in ipairs(_pack) do
		if _obj.sheet_numer then
			a = animation_manager[_type .. "_spr_data"][3]
		end
		return _number
	end
end

function animation_manager:delete(_type, _number) end
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
