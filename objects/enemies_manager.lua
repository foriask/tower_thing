enemies_manager = { enemies = {}, enemie_template = {} }
function enemies_manager:set_enemie(_sprite, _pos, _siz, _hp, _colision)
	local _enemie = {
		collider = _colision or { type = "no" },
		sprite = _sprite or false,
		sizes = _siz or { 1, 1 },
		hitpoints = _hp or 1,
		position = _pos or { 0, 0, 0 },
		-- THE LAST DIGIT IN POS (3rd) IS USEFULL. It is used to know what kind of tower can kill it.
	}
	function _enemie:damage(_dmg, _dt)
		print("auch" .. _dmg)
	end
	_enemie.__index = self.enemie_templante
	table.insert(self.enemies, _enemie)
end

function enemies_manager.enemie_template:damage(_dmg, _dt)
	self.hitpoints = self.hitpoints - _dmg
	print("auch")
end

function enemies_manager:draw()
	for _i, _enemie in pairs(self.enemies) do
		if not _enemie.sprite then
			if _enemie.collider.type == "c" then
				love.graphics.circle("fill", _enemie.position[1], _enemie.position[2], _enemie.collider.radius)
			else
				if _enemie.collider.type == "s" then
					love.graphics.rectangle(
						"fill",
						_enemie.position[1],
						_enemie.position[2],
						_enemie.size[1],
						_enemie.size[2]
					)
				end
			end
		else
			love.graphics.draw(
				_enemie.sprite,
				_enemie.position[1],
				_enemie.position[2],
				_enemie.size[1],
				_enemie.size[2]
			)
		end
	end
end
