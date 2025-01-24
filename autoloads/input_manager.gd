extends Node

#region Showing new Screens
signal game_pause
signal game_unpause
signal game_debug_show
signal game_debug_hide
#endregion

#region Game State Management
var _is_in_game: bool = false
var _is_paused: bool = false
var is_debug_label_visible: bool = false
#endregion

enum InputType {MOUSE, JOYPAD}

func _ready():
	set_process_mode(Node.PROCESS_MODE_ALWAYS)

func _input(event: InputEvent) -> void:

	if event.is_action_pressed("pause"):
		if (_is_in_game and not _is_paused):
			game_pause.emit()
		elif (_is_in_game and _is_paused):
			game_unpause.emit()
	elif event.is_action_pressed("toggle_debug_label"):
		if is_debug_label_visible:
			game_debug_hide.emit()
		else:
			game_debug_show.emit()
	elif not _is_in_game: 
		pass

func set_is_in_game(b: bool) -> void:
	_is_in_game = b



func set_is_paused(b: bool) -> void:
	_is_paused = b
