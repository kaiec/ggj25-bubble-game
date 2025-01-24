extends State

@onready var check_burst: Node = $"../CheckBurst"

func state_process(_delta):
	var cell = engine.area.local_to_map(get_viewport().get_mouse_position())
	engine.set_cursor(cell)
	if Input.is_action_just_pressed("select"):
		if engine.select_bubble(cell):
			engine.state = check_burst
			
func exit_state():
	engine.cursor.hide()
