extends Node2D

signal win

@onready var bubble_engine: BubbleEngine = $BubbleEngine
@onready var gui: BubbleGUI = $GUI

@export var max_clicks: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if max_clicks > 0:
		bubble_engine.set_max_clicks(max_clicks)
	bubble_engine.win.connect(func():
		win.emit()
		queue_free()
	)
	gui.reset_clicked.connect(_on_gui_reset_clicked)
	for bubble in $Bubbles.get_children():
		bubble.cell = $Area.local_to_map(bubble.position)



func _on_gui_reset_clicked() -> void:
	print("Pressed Reset")
	Global.game_manager._reload_current_level()
