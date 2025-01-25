extends Node2D

signal win

@onready var bubble_engine: BubbleEngine = $BubbleEngine

@export var max_clicks: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if max_clicks > 0:
		bubble_engine.set_max_clicks(max_clicks)
	bubble_engine.win.connect(func():
		win.emit()
		queue_free()
	)
	for bubble in $Bubbles.get_children():
		
		bubble.cell = $Area.local_to_map(bubble.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
