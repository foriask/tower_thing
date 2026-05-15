require("objects.bullet_manager")
require("objects.enemies_manager")
require("objects.item_manager")
require("usefull")
jit.off()
Fps = 0
Bullet_count = 0
how_many_bullets = 1
function love.load()
	tree_manager.item_groups.enemies[1] = {
		position = { 2, 3 },
		s = { 50, 50 },
		collider = { type = "c", [1] = 2, [2] = 3, [3] = 52, [4] = 53, radius = 100 },
		damage = function(_dmg)
			print(_dmg)
		end,
	}
	-- enemies_manager:set_enemie(false, { 300, 300, 0 }, { 30, 30 }, 2, { type = "c", radius = 30 })
end

function love.update(dt)
	Fps = (1 / dt)
	local _player_move = {
		(-(love.keyboard.isDown("a") and 1 or 0) + (love.keyboard.isDown("d") and 1 or 0)) * 200 * dt,
		(-(love.keyboard.isDown("w") and 1 or 0) + (love.keyboard.isDown("s") and 1 or 0)) * 200 * dt,
	}
	how_many_bullets = how_many_bullets
		+ (love.keyboard.isDown("t") and 1 or 0)
		+ (love.keyboard.isDown("y") and -1 or 0)
	if love.keyboard.isDown("e") then
		local _bullets = how_many_bullets
		while _bullets > 0 do
			print("hm?")
			local _bullet = bullet_manager:new(nil, { 400 * math.random(), 1600 * math.random() }, { 5, 0.5 }, 30)
			print(table.concat(_bullet))
			table.insert(tree_manager.item_groups.bullets, _bullet)
			_bullets = _bullets - 1
		end
	end

	-- A few functions that make the game work. I don't know why dont ask. Remember to use DT!
	tree_manager.item_groups.bullets =
		bullet_manager:collide(tree_manager.item_groups.bullets, tree_manager.item_groups.enemies, Obj_list_blocks, dt)
	tree_manager.item_groups.enemies[1].position = sum_table(tree_manager.item_groups.enemies[1].position, _player_move)
	tree_manager.item_groups.enemies[1].collider[1] = tree_manager.item_groups.enemies[1].position[1]
	tree_manager.item_groups.enemies[1].collider[2] = tree_manager.item_groups.enemies[1].position[2]
	tree_manager.item_groups.enemies[1].collider[3] = tree_manager.item_groups.enemies[1].position[1]
		+ tree_manager.item_groups.enemies[1].s[1]
	tree_manager.item_groups.enemies[1].collider[4] = tree_manager.item_groups.enemies[1].position[2]
		+ tree_manager.item_groups.enemies[1].s[2]
	tree_manager.item_groups.bullets = bullet_manager:move_bullets(tree_manager.bullets, dt)
	tree_manager:clean()
end

function love.draw()
	love.graphics.circle(
		"fill",
		tree_manager.item_groups.enemies[1].position[1],
		tree_manager.item_groups.enemies[1].position[2],
		tree_manager.item_groups.enemies[1].collider.radius
	)
	if #tree_manager.item_groups.bullets ~= 0 then
		for _i, _obj in ipairs(tree_manager.item_groups.bullets) do
			print(_i)
			love.graphics.circle("fill", _obj.position[1], _obj.position[2], 4)
		end
	end
	-- enemies_manager:draw()
	love.graphics.print({
		{ 0.8, 0.3, 0.3, 255 },
		Fps
			.. " RAM(kb): "
			.. math.floor(collectgarbage("count"))
			.. "  Bullets: "
			.. #tree_manager.item_groups.bullets
			.. " "
			.. how_many_bullets
			.. "Draw calls: "
			.. love.graphics.getStats().drawcalls
			.. " "
			.. love.graphics.getStats().drawcallsbatched,
	}, 20, 20)
end
