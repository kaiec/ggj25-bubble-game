extends Node2D

signal win

@onready var bubble_engine: BubbleEngine = $BubbleEngine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubble_engine.win.connect(func():
		win.emit()
		queue_free()
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	win.emit()
	queue_free()
