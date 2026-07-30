require("objects.bullet_manager")
require("objects.enemies_manager")
require("objects.item_manager")
require("objects.towers_manager")
require("usefull.usefull")
require("player.controller")

FPS = 0
FRAMES = 0
TIME = 0
S05 = 0

-- DEBUG - DEBUG - DEBUG
-- DEBUG - DEBUG - DEBUG

function love.load()
	love.filesystem.setIdentity("Copperwire")

	-- Init data: mainly init for the tree manager and so on. Idk
	tree_manager:update_sizes()

	tree_manager.matrix.bullets = {}
	-- This thing is for the controls. They exist.
	map_manager:optimized_calc()
	map_manager:create_grid()
	controller:loadmap()
end

function love.update(dt)
	TIME = TIME + dt

	local future_FPS = lerp(FPS, 1 / dt, 0.5)
	FPS = future_FPS - future_FPS % 0.1
	FRAMES = FRAMES + 1

	controller:control(TIME)

	-- A few functions that make the game work. I don't know why dont ask. Remember to use DT!

	tree_manager.bullets = bullet_manager:collide(tree_manager.bullets, tree_manager.enemies, tree_manager.towers, dt) -- Collide ??

	tree_manager.enemies = enemies_manager:move(tree_manager.enemies, dt)
	tree_manager.bullets = bullet_manager:move(tree_manager.bullets, dt)

	tree_manager:update_w_matrix()
end

function love.draw()
	map_manager:draw_grid(TIME)

	tower_manager:draw(TIME, tree_manager.towers)
	bullet_manager:draw(TIME, tree_manager.bullets)
	enemies_manager:draw(TIME, tree_manager.enemies)

	-- DEBUG
	love.graphics.print({
		{ 0.8, 0.3, 0.3, 255 },
		FPS
			.. " MEM.kb: "
			.. math.floor(collectgarbage("count"))
			.. " <> Bullets: "
			.. #tree_manager.bullets
			.. " Enemies: "
			.. #tree_manager.enemies
			.. " D. C. : "
			.. love.graphics.getStats().drawcalls
			.. " VMem: "
			.. love.graphics.getStats().texturememory,
	}, 20, 20)
end

function love.resize(w, h)
	tree_manager:update_sizes()
	map_manager:optimized_calc()
end

function love.keypressed(_key, _scancode, _isrepeat)
	controller:check_keys(nil, nil, _key, TIME)
end

function love.mousepressed(_x, _y, _button)
	controller:check_keys(_x, _y, _button, TIME)
end
