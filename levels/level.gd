@tool

extends Node2D

signal win

@onready var bubble_engine: BubbleEngine = $BubbleEngine
@onready var gui: BubbleGUI:
	get():
		if has_node("GUI"):
			return $GUI
		return null

@export var max_clicks: int = -1:
	set(value):
		max_clicks = value
		update_gui(max_clicks)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gui.set_remaining_bubbles(max_clicks)
	if Engine.is_editor_hint(): return
	
	if max_clicks > 0:
		bubble_engine.set_max_clicks(max_clicks)
	bubble_engine.win.connect(func():
		win.emit()
		queue_free()
	)
	gui.reset_clicked.connect(_on_gui_reset_clicked)
	for bubble in $Bubbles.get_children():
		bubble.cell = $Area.local_to_map(bubble.position)
	bubble_engine.click.connect(update_gui)
	bubble_engine.false_click.connect(play_gui_error)
	$Area.modulate = Color.html("#1c071cc9")


func update_gui(clicks_left : int):
	if (gui): gui.set_remaining_bubbles(clicks_left)


func _on_gui_reset_clicked() -> void:
	if Engine.is_editor_hint(): return
	
	print("Pressed Reset")
	Global.game_manager._reload_current_level()


func play_gui_error():
	gui.play_clicks_error()
