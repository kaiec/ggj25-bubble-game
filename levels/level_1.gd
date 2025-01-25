extends Node2D

signal win

@onready var bubble_engine: BubbleEngine = $BubbleEngine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubble_engine.win.connect(func():
		win.emit()
		queue_free()
		)
	for bubble in $Bubbles.get_children():
		bubble.cell = $Area.local_to_map(bubble.position)
		bubble.position = $Area.map_to_local(bubble.cell)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
