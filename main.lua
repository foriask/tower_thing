require("objects.bullet_manager")
require("objects.enemies_manager")
require("objects.item_manager")
require("usefull")

Fps = 0
Bullet_count = 0
How_many_bullets = 1

function love.load()
	tree_manager:index(enemies_manager:set_enemie(nil, { 20, 20, 0 }, 1, 1, { type = "c", radius = 20 }))
	print(tree_manager.enemies[1])
end

function love.update(dt)
	Fps = lerp(Fps, (1 / dt), 0.5)
	local _player_move = {
		(-(love.keyboard.isDown("a") and 1 or 0) + (love.keyboard.isDown("d") and 1 or 0)) * 200 * dt,
		(-(love.keyboard.isDown("w") and 1 or 0) + (love.keyboard.isDown("s") and 1 or 0)) * 200 * dt,
	}
	tree_manager.enemies[1].acel = _player_move
	How_many_bullets = How_many_bullets
		+ (love.keyboard.isDown("t") and 1 or 0)
		+ (love.keyboard.isDown("y") and -1 or 0)

	if love.mouse.isDown(1) then
		local _pos = { love.mouse.getX(), love.mouse.getY() }
		tree_manager:index(enemies_manager:set_enemie(nil, _pos, 10, 0, { type = "c", radius = 10 }))
	end

	if love.keyboard.isDown("e") then
		local _bullets = How_many_bullets
		while _bullets > 0 do
			local _bullet = bullet_manager:new(nil, { 400 * math.random(), 1600 * math.random(), 0 }, { 100, 40 }, 30)
			tree_manager:index(_bullet)
			_bullets = _bullets - 1
		end
	end

	-- A few functions that make the game work. I don't know why dont ask. Remember to use DT!

	tree_manager.bullets = bullet_manager:collide(tree_manager.bullets, tree_manager.enemies, tree_manager.towers, dt) -- Collide ??

	tree_manager.enemies = enemies_manager:move(tree_manager.enemies, dt)
	tree_manager.bullets = bullet_manager:move(tree_manager.bullets, dt)

	local _new_tree_manager = tree_manager:update_w_matrix(tree_manager)
	tree_manager:internal_update(_new_tree_manager)
end

function love.draw()
	--[[love.graphics.circle(
		"fill",
		tree_manager.item_groups.enemies[1].position[1],
		tree_manager.item_groups.enemies[1].position[2],
		tree_manager.item_groups.enemies[1].collider.radius
	)]]
	enemies_manager:draw(tree_manager.enemies)
	if #tree_manager.bullets ~= 0 then
		for _i, _obj in ipairs(tree_manager.bullets) do
			if _obj ~= "clean" then
				love.graphics.circle("fill", _obj.position[1], _obj.position[2], 4)
			end
		end
	end
	-- enemies_manager:draw()
	love.graphics.print({
		{ 0.8, 0.3, 0.3, 255 },
		Fps
			.. " RAM(kb): "
			.. math.floor(collectgarbage("count"))
			.. "  Bullets: "
			.. #tree_manager.bullets
			.. " "
			.. How_many_bullets
			.. "Draw calls: "
			.. love.graphics.getStats().drawcalls
			.. " "
			.. love.graphics.getStats().texturememory,
	}, 20, 20)
end
