require("objects.bullet_manager")
require("objects.enemies_manager")
require("objects.item_manager")
require("usefull")
require("player.controller")

FPS = 0
FRAMES = 0
TIME = 0
S05 = 0

Bullet_count = 0
How_many_bullets = 1
Enemy_coun = 0
function love.load()
	tree_manager.magic_size = tree_manager:update_sizes()
	tree_manager:index(enemies_manager:set_enemie(nil, { 20, 20, 0 }, 1, 1, { type = "c", radius = 20 }))
	print(tree_manager.enemies[1])
end

function love.update(dt)
	S05 = S05 + dt
	TIME = TIME + dt

	local future_FPS = lerp(FPS, 1 / dt, 0.5)
	FPS = future_FPS - future_FPS % 0.1
	FRAMES = FRAMES + 1

	-- A handful of variables
	-- Automatic timers for routinaty checks, just ignore them if you are not using them, lmao
	if S05 > 0.5 then
		print("hwo")
		tree_manager.magic_size = tree_manager:update_sizes()
		S05 = 0
	end

	controller:control(TIME)

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
		FPS
			.. " MEM.kb: "
			.. math.floor(collectgarbage("count"))
			.. " <> Bullets: "
			.. #tree_manager.bullets
			.. " Qtt: "
			.. How_many_bullets
			.. " Enemies: "
			.. Enemy_coun
			.. " D. C. : "
			.. love.graphics.getStats().drawcalls
			.. " VMem: "
			.. love.graphics.getStats().texturememory,
	}, 20, 20)
end

function love.keypressed(_key, _scancode, _isrepeat)
	controller:check_keys(nil, nil, _key, TIME)
end

function love.mousepressed(_x, _y, _button)
	controller:check_keys(_x, _y, _button, TIME)
end
