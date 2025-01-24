extends State

func state_process(_delta):
	var cell = engine.area.local_to_map(get_viewport().get_mouse_position())
	engine.set_cursor(cell)
	if Input.is_action_just_pressed("select"):
		engine.select_bubble(cell)
