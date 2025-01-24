extends State

func state_process(_delta):
	engine.set_cursor(engine.area.local_to_map(get_viewport().get_mouse_position()))
