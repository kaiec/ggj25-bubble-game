class_name ControlSettings

static func create_action_setting(action: String, label: String) -> void:
	var events = InputMap.action_get_events(action)
	var default_events = []
	for i in range(2):
		if i < events.size():
			default_events.append(events[i])
		else:
			default_events.append(null)

	var setting_key = "action_map_" + action

	
	
static func _register_settings() -> void:
	
	# Insert you remappable actions here
	create_action_setting("move_up", "Move Forward")
	create_action_setting("move_down", "Move Backward")
	create_action_setting("move_left", "Move Left")
	create_action_setting("move_right", "Move Right")


static func set_input_events(events: Array, action: String) -> void:
	InputMap.action_erase_events(action)
	for event in events:
		InputMap.action_add_event(action, event)
