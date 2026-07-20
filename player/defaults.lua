-- Pretty simple.
-- Anyways, controls work this way:
-- function_name = {one_button, mouse, mouse_button}
-- function_name = {{control_main}, {control_secondary}}

control_map = {
	-- fullscreen = "F11",
	debug_place_enemy = { "e", "mouse", "1" },
	set_setting_debug = { 1 },
	debug_place_bullet = { "mouse", "1" },
	-- debug_two = { "e", "shift" },
}

-- This is easier, just put whatever it says
graphics = {
	fullscreen = true,
	animations = 4, -- Lets do this, 1 to 4, where 1 is just don't animate and 4 is EVERYTHING.
}
return control_map, graphics
