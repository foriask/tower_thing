control_map = {
	-- fullscreen = "F11",
	debug_place_enemy = { "e", "mouse", "1" },
	set_setting_debug = { 1 },
	-- debug_two = { "e", "shift" },
} -- Ok, lets do this the easy way: key_Action = button or comb. [comb = table]
graphics = {
	fullscreen = true,
	animations = 4, -- Lets do this, 1 to 4, where 1 is just don't animate and 4 is EVERYTHING.
}
return control_map, graphics
